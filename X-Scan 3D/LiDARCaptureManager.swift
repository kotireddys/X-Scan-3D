//
//  LiDARCaptureManager.swift
//  X-Scan 3D
//
//  Created by KOTIREDDY SYAMALA on 11/11/25.
//

import Foundation
import ARKit
import RealityKit
import CoreLocation
import UIKit
import Combine

protocol LiDARCaptureManagerDelegate: AnyObject {
    func didCaptureFrame(_ frame: CaptureFrame, rawRGBURL: URL, rawDepthURL: URL)
    func didUpdateMeshAvailable(_ available: Bool)
    func didFinishMeshExport(url: URL)
    func didFinishPointCloudExport(url: URL)
    func didFail(with error: Error)
}

final class LiDARCaptureManager: NSObject, ObservableObject {
    let objectWillChange = ObservableObjectPublisher()
    
    weak var delegate: LiDARCaptureManagerDelegate?

    // AR
    private let arView = ARView(frame: .zero)
    private let session = ARSession()
    private var frameThrottle = 0
    var arContainerView: ARView { arView }

    // Location
    private let locationManager = CLLocationManager()
    private var lastLocation: CLLocationCoordinate2D?

    // Storage
    private let fileMgr = FileManager.default
    private var projectFolder: URL?

    // Config
    private let captureEveryNFrames = 6

    // MARK: - Public API
    func start(projectFolder: URL) {
        self.projectFolder = projectFolder
        setupLocation()
        setupARSession()
    }

    func stop() {
        session.pause()
        arView.session.pause()
    }

    // Export current world mesh → OBJ
    func exportCurrentMeshOBJ() {
        guard let anchors = session.currentFrame?.anchors.compactMap({ $0 as? ARMeshAnchor }),
              !anchors.isEmpty
        else {
            delegate?.didFail(with: NSError(domain: "Mesh", code: -1, userInfo: [NSLocalizedDescriptionKey: "No mesh anchors available"]))
            return
        }
        do {
            let url = try MeshExporter.exportOBJ(from: anchors, to: projectFolder ?? tempFolder())
            delegate?.didFinishMeshExport(url: url)
        } catch {
            delegate?.didFail(with: error)
        }
    }

    // Export point cloud from the latest frame’s depth
    func exportLatestPointCloudPLY() {
        guard let frame = session.currentFrame,
              let sceneDepth = frame.sceneDepth
        else {
            delegate?.didFail(with: NSError(domain: "PointCloud", code: -1, userInfo: [NSLocalizedDescriptionKey: "No scene depth available"]))
            return
        }

        do {
            let (positions, colors) = try PointCloudBuilder.pointCloud(from: frame, depth: sceneDepth)
            let url = try PLYExporter.export(positions: positions, colors: colors, to: projectFolder ?? tempFolder())
            delegate?.didFinishPointCloudExport(url: url)
        } catch {
            delegate?.didFail(with: error)
        }
    }

    // MARK: - Private
    private func setupARSession() {
        arView.session = session
        session.delegate = self

        let config = ARWorldTrackingConfiguration()
        guard ARWorldTrackingConfiguration.supportsSceneReconstruction(.meshWithClassification) else {
            delegate?.didUpdateMeshAvailable(false)
            return
        }
        config.sceneReconstruction = .meshWithClassification
        config.environmentTexturing = .automatic

        if ARWorldTrackingConfiguration.supportsFrameSemantics(.sceneDepth) {
            config.frameSemantics.insert(.sceneDepth)
        }

        config.worldAlignment = .gravity
        config.planeDetection = [.horizontal, .vertical]
        session.run(config, options: [.removeExistingAnchors, .resetTracking])
        delegate?.didUpdateMeshAvailable(true)
    }

    private func setupLocation() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    private func tempFolder() -> URL {
        fileMgr.temporaryDirectory
    }

    // Save frame (RGB + Depth + metadata) to disk
    private func saveFrame(_ arFrame: ARFrame) {
        guard let projectFolder else { return }

        // RGB
        let rgbBuffer = arFrame.capturedImage
        let rgbUIImage = rgbBuffer.toUIImage()
        let ts = Int(Date().timeIntervalSince1970 * 1000)
        let rawFolder = projectFolder.appendingPathComponent("raw", isDirectory: true)
        try? fileMgr.createDirectory(at: rawFolder, withIntermediateDirectories: true)

        let rgbURL = rawFolder.appendingPathComponent("img_\(ts).jpg")
        let depthURL = rawFolder.appendingPathComponent("depth_\(ts).bin")
        let metaURL = rawFolder.appendingPathComponent("meta_\(ts).json")

        if let data = rgbUIImage.jpegData(compressionQuality: 0.9) {
            try? data.write(to: rgbURL)
        }

        // Depth
        if let depth = arFrame.sceneDepth?.depthMap {
            let depthData = depth.serializeFloat32()
            try? depthData.write(to: depthURL)
        }

        // Metadata
        let meta: [String: Any] = [
            "timestamp": ts,
            "latitude": lastLocation?.latitude as Any,
            "longitude": lastLocation?.longitude as Any,
            "hasDepth": arFrame.sceneDepth != nil
        ]
        if let json = try? JSONSerialization.data(withJSONObject: meta, options: [.prettyPrinted]) {
            try? json.write(to: metaURL)
        }

        // Build CaptureFrame for Gallery
        let frameThumb = rgbUIImage.thumbnail(maxDimension: 320)
        let capture = CaptureFrame(
            imageName: rgbURL.lastPathComponent,
            thumbnail: frameThumb,
            timestamp: Date(),
            includeInReconstruction: true,
            gpsLocation: lastLocation,
            depthAvailable: arFrame.sceneDepth != nil
        )
        delegate?.didCaptureFrame(capture, rawRGBURL: rgbURL, rawDepthURL: depthURL)
    }
}

// MARK: - ARSessionDelegate
extension LiDARCaptureManager: ARSessionDelegate {
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        frameThrottle &+= 1
        if frameThrottle % captureEveryNFrames == 0 {
            saveFrame(frame)
        }
    }

    func session(_ session: ARSession, didFailWithError error: Error) {
        delegate?.didFail(with: error)
    }
}

// MARK: - CLLocationManagerDelegate
extension LiDARCaptureManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        lastLocation = locations.last?.coordinate
    }
}

// MARK: - Helpers
private extension CVPixelBuffer {
    func toUIImage() -> UIImage {
        let ci = CIImage(cvPixelBuffer: self)
        let ctx = CIContext(options: nil)
        guard let cg = ctx.createCGImage(ci, from: ci.extent) else { return UIImage() }
        return UIImage(cgImage: cg, scale: 1.0, orientation: .right) // camera orientation
    }

    // Serialize depth (Float32) row-major
    func serializeFloat32() -> Data {
        CVPixelBufferLockBaseAddress(self, .readOnly)
        defer { CVPixelBufferUnlockBaseAddress(self, .readOnly) }

        let width = CVPixelBufferGetWidth(self)
        let height = CVPixelBufferGetHeight(self)
        let count = width * height
        let base = CVPixelBufferGetBaseAddress(self)!
        let length = count * MemoryLayout<Float32>.size
        let data = Data(bytes: base, count: length)
        return data
    }
}

private extension UIImage {
    func thumbnail(maxDimension: CGFloat) -> UIImage {
        let longestSide = Swift.max(size.width, size.height)
        let scale = maxDimension / longestSide
        let new = CGSize(width: size.width * scale, height: size.height * scale)
        let renderer = UIGraphicsImageRenderer(size: new)
        return renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: new))
        }
    }
}

