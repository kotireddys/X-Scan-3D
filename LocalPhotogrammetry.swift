//
//  LocalPhotogrammetry.swift
//  X-Scan 3D
//
//  Created by KOTIREDDY SYAMALA on 11/11/25.
//

#if os(macOS)
import Foundation
import RealityKit

@available(macOS 12.0, *)
func runLocalPhotogrammetry(_ project: ProjectModel, projectFolder: URL) async {
    do {
        // Align with your capture code which writes into "raw"
        let input = projectFolder.appendingPathComponent("raw", isDirectory: true)
        let output = projectFolder.appendingPathComponent("mesh.usdz", isDirectory: false)

        let session = try PhotogrammetrySession(input: input)
        let request = PhotogrammetrySession.Request.modelFile(url: output, detail: .medium)
        try await session.process(requests: [request])
        print("✅ Local model ready at \(output)")
    } catch {
        print("❌ Local photogrammetry failed:", error.localizedDescription)
    }
}
#else
// Stub for non-macOS platforms so the project compiles.
import Foundation

func runLocalPhotogrammetry(_ project: ProjectModel, projectFolder: URL) async {
    print("ℹ️ Local photogrammetry is only available on macOS 12.0+.")
}
#endif
