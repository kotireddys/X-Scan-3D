//
//  CameraEngine.swift
//  X-Scan 3D
//
//  Created by KOTIREDDY SYAMALA on 14/11/25.
//

import Foundation
import AVFoundation
import UIKit
import Combine

@MainActor
final class CameraEngine: NSObject, ObservableObject {
    var objectWillChange: ObservableObjectPublisher

    // Current scan mode (drives UI + behavior)
    @Published var mode: CaptureMode = .lidar

    // Photo camera session
    let photoSession = AVCaptureSession()
    private let photoOutput = AVCapturePhotoOutput()
    private var photoDeviceInput: AVCaptureDeviceInput?

    // Latest captured photo (you can hook this into your project logic later)
    @Published var lastCapturedImage: UIImage?

    // Torch state
    @Published var torchOn: Bool = false

    override init() {
        self.objectWillChange = ObservableObjectPublisher()
        super.init()
        configurePhotoSession()
    }

    private func configurePhotoSession() {
        photoSession.beginConfiguration()
        photoSession.sessionPreset = .photo

        guard let camera = AVCaptureDevice.default(.builtInWideAngleCamera,
                                                   for: .video,
                                                   position: .back),
              let input = try? AVCaptureDeviceInput(device: camera)
        else {
            photoSession.commitConfiguration()
            return
        }

        if photoSession.canAddInput(input) {
            photoSession.addInput(input)
            self.photoDeviceInput = input
        }

        if photoSession.canAddOutput(photoOutput) {
            photoSession.addOutput(photoOutput)
        }

        photoSession.commitConfiguration()
    }

    // MARK: - Mode switching

    func setMode(_ newMode: CaptureMode) {
        // Stop photo session when leaving photo mode
        if mode == .photo && newMode != .photo {
            stopPhotoSession()
        }
        // Start photo session when entering photo mode
        if newMode == .photo && mode != .photo {
            startPhotoSession()
        }
        mode = newMode
    }

    func startPhotoSession() {
        guard !photoSession.isRunning else { return }
        DispatchQueue.main.async {
            self.photoSession.startRunning()
        }
    }

    func stopPhotoSession() {
        guard photoSession.isRunning else { return }
        DispatchQueue.main.async {
            self.photoSession.stopRunning()
        }
    }

    // MARK: - Capture

    func capturePhoto() {
        guard mode == .photo else { return }

        let settings = AVCapturePhotoSettings()
        if let device = (photoDeviceInput?.device), device.hasFlash {
            settings.flashMode = torchOn ? .on : .off
        }

        photoOutput.capturePhoto(with: settings, delegate: self)
    }

    // MARK: - Torch / Flash

    func toggleTorch() {
        guard let device = photoDeviceInput?.device, device.hasTorch else { return }

        do {
            try device.lockForConfiguration()
            if torchOn {
                device.torchMode = .off
                torchOn = false
            } else {
                try device.setTorchModeOn(level: 0.7)
                torchOn = true
            }
            device.unlockForConfiguration()
        } catch {
            print("Torch error:", error.localizedDescription)
        }
    }
}

extension CameraEngine: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput,
                     didFinishProcessingPhoto photo: AVCapturePhoto,
                     error: Error?) {
        guard error == nil,
              let data = photo.fileDataRepresentation(),
              let img = UIImage(data: data) else { return }
        lastCapturedImage = img
        // TODO: push into your ProjectModel / gallery later
    }
}
