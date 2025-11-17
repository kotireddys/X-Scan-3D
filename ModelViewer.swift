//
//  ModelViewer.swift
//  X-Scan 3D
//
//  Created by KOTIREDDY SYAMALA on 12/11/25.
//

import SwiftUI
import SceneKit

struct ModelViewer: View {
    let project: ProjectModel

    var body: some View {
        SceneView(
            scene: loadScene(for: project),
            options: [.allowsCameraControl, .autoenablesDefaultLighting]
        )
        .background(Color.black)
        .ignoresSafeArea()
        .navigationTitle(project.title)
        .navigationBarTitleDisplayMode(.inline)
    }

    private func loadScene(for p: ProjectModel) -> SCNScene {
        // pick cloud → local → lidar preview
        let base = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            .appendingPathComponent(p.id.uuidString, isDirectory: true)
        let candidates = ["mesh_cloud.glb", "mesh_local.usdz", "lidar_preview.obj"]

        for name in candidates {
            let url = base.appendingPathComponent(name)
            if FileManager.default.fileExists(atPath: url.path),
               let scn = try? SCNScene(url: url, options: nil) { return scn }
        }
        return SCNScene()
    }
}
