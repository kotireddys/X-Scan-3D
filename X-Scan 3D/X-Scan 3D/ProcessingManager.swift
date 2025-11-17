//
//  ProcessingManager.swift
//  X-Scan 3D
//
//  Created by KOTIREDDY SYAMALA on 11/11/25.
//

import Foundation

enum ProcessingMode {
    case localQuick
    case localLidarOnly
    case cloudPremium
}

class ProcessingManager {
    func processProject(_ project: ProjectModel, mode: ProcessingMode) async {
        switch mode {
        case .localQuick:
            let projectFolder = ensureProjectFolder(for: project)
            await runLocalPhotogrammetry(project, projectFolder: projectFolder)
        case .localLidarOnly:
            await generateLidarMeshPreview(project)
        case .cloudPremium:
            await uploadToCloud(project)
        }
    }

    // MARK: - Private helpers

    private func ensureProjectFolder(for project: ProjectModel) -> URL {
        let docs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let folder = docs.appendingPathComponent(project.id.uuidString, isDirectory: true)
        try? FileManager.default.createDirectory(at: folder, withIntermediateDirectories: true)
        try? FileManager.default.createDirectory(at: folder.appendingPathComponent("raw"), withIntermediateDirectories: true)
        return folder
    }

    // MARK: - Stubs to satisfy calls; implement real logic later

    /// Generates a quick LiDAR-only mesh preview for the given project.
    /// Replace with real implementation that consumes saved ARMesh/point cloud if desired.
    private func generateLidarMeshPreview(_ project: ProjectModel) async {
        // TODO: Implement LiDAR-only local meshing pipeline if applicable.
        // For now, this is a no-op stub to satisfy the compiler.
        await Task.yield()
    }

    /// Uploads the project's data to a cloud service for premium processing.
    /// Replace with your networking implementation.
    private func uploadToCloud(_ project: ProjectModel) async {
        // TODO: Implement upload to your backend (e.g., zip raw folder, POST to API).
        await Task.yield()
    }
}

