//
//  LiDARCaptureBridge.swift
//  X-Scan 3D
//
//  Created by KOTIREDDY SYAMALA on 11/11/25.
//

import Foundation
import SwiftUI
import RealityKit
import CoreLocation
import Combine

final class LiDARCaptureBridge: ObservableObject {
    // Underlying manager
    let captureManager = LiDARCaptureManager()

    // Published values observed by ScanView
    @Published var frameCounter: Int = 0
    @Published var currentGPS: CLLocationCoordinate2D?

    // Retain callbacks for exports and mesh availability
    private var meshAvailabilityHandler: ((Bool) -> Void)?
    private var meshExportCompletion: ((URL?) -> Void)?
    private var pointCloudExportCompletion: ((URL?) -> Void)?

    init() {
        captureManager.delegate = self
    }

    func start(project: ProjectModel, folder: URL, vm: ProjectViewModel, availabilityHandler: @escaping (Bool) -> Void) {
        meshAvailabilityHandler = availabilityHandler
        captureManager.start(projectFolder: folder)
    }

    func stop() {
        captureManager.stop()
    }

    func exportMesh(completion: @escaping (URL?) -> Void) {
        meshExportCompletion = completion
        captureManager.exportCurrentMeshOBJ()
    }

    func exportPointCloud(completion: @escaping (URL?) -> Void) {
        pointCloudExportCompletion = completion
        captureManager.exportLatestPointCloudPLY()
    }
}

extension LiDARCaptureBridge: LiDARCaptureManagerDelegate {
    func didCaptureFrame(_ frame: CaptureFrame, rawRGBURL: URL, rawDepthURL: URL) {
        // Increment a simple counter; ScanView only shows count
        DispatchQueue.main.async {
            self.frameCounter += 1
        }
        // If you want to store frames into a project/view model, wire that here later.
    }

    func didUpdateMeshAvailable(_ available: Bool) {
        DispatchQueue.main.async {
            self.meshAvailabilityHandler?(available)
        }
    }

    func didFinishMeshExport(url: URL) {
        DispatchQueue.main.async {
            self.meshExportCompletion?(url)
            self.meshExportCompletion = nil
        }
    }

    func didFinishPointCloudExport(url: URL) {
        DispatchQueue.main.async {
            self.pointCloudExportCompletion?(url)
            self.pointCloudExportCompletion = nil
        }
    }

    func didFail(with error: Error) {
        // You could surface errors via another @Published or callback
        // For now, we complete with nil for export requests if pending
        DispatchQueue.main.async {
            if self.meshExportCompletion != nil {
                self.meshExportCompletion?(nil)
                self.meshExportCompletion = nil
            }
            if self.pointCloudExportCompletion != nil {
                self.pointCloudExportCompletion?(nil)
                self.pointCloudExportCompletion = nil
            }
        }
    }
}

