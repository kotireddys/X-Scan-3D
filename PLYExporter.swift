//
//  PLYExporter.swift
//  X-Scan 3D
//
//  Created by KOTIREDDY SYAMALA on 11/11/25.
//

import Foundation
import simd

enum PLYExporterError: Error { case writeFailed }

struct PLYExporter {
    static func export(positions: [SIMD3<Float>], colors: [SIMD3<UInt8>], to folder: URL) throws -> URL {
        let url = folder.appendingPathComponent("pointcloud_\(Int(Date().timeIntervalSince1970)).ply")
        let header = """
        ply
        format ascii 1.0
        element vertex \(positions.count)
        property float x
        property float y
        property float z
        property uchar red
        property uchar green
        property uchar blue
        end_header
        """

        var body = String()
        body.reserveCapacity(positions.count * 30)
        for i in 0..<positions.count {
            let p = positions[i]
            let c = colors.indices.contains(i) ? colors[i] : SIMD3<UInt8>(255,255,255)
            body += "\n\(p.x) \(p.y) \(p.z) \(c.x) \(c.y) \(c.z)"
        }

        let text = header + body + "\n"
        do {
            try text.write(to: url, atomically: true, encoding: .utf8)
        } catch {
            throw PLYExporterError.writeFailed
        }
        return url
    }
}
