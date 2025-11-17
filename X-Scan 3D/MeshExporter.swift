//
//  MeshExporter.swift
//  X-Scan 3D
//
//  Created by KOTIREDDY SYAMALA on 11/11/25.
//

import Foundation
import ARKit
import simd

enum MeshExportError: Error { case writeFailed }

struct MeshExporter {
    // Exports all ARMeshAnchors to a single OBJ with vertex normals
    static func exportOBJ(from anchors: [ARMeshAnchor], to folder: URL) throws -> URL {
        let url = folder.appendingPathComponent("mesh_\(Int(Date().timeIntervalSince1970)).obj")
        var obj = "# ARKit Mesh Export\n"

        var vertexOffset = 1 // OBJ indices start at 1

        for (idx, anchor) in anchors.enumerated() {
            let geom = anchor.geometry
            let transform = anchor.transform

            // Vertices
            for v in 0..<geom.vertices.count {
                let vertex = geom.vertices.vertex(at: v)
                let world = (transform * SIMD4<Float>(vertex, 1.0)).xyz
                obj += "v \(world.x) \(world.y) \(world.z)\n"
            }

            // Normals (already in world space orientation relative to anchor; no transform applied)
            for n in 0..<geom.normals.count {
                let normal = geom.normals.normal(at: n)
                obj += "vn \(normal.x) \(normal.y) \(normal.z)\n"
            }

            // Faces (single geometry element in ARKit)
            let faces = geom.faces
            obj += "g anchor\(idx)\n"

            // Ensure we are dealing with triangles
            guard faces.primitiveType == .triangle else {
                // If not triangles, skip (or triangulate if desired)
                continue
            }

            let count = faces.indexCount
            guard count % 3 == 0 else {
                // If not multiple of 3, skip to avoid malformed OBJ
                continue
            }

            for t in stride(from: 0, to: count, by: 3) {
                let i0 = Int(faces.index(at: t)) + vertexOffset
                let i1 = Int(faces.index(at: t + 1)) + vertexOffset
                let i2 = Int(faces.index(at: t + 2)) + vertexOffset
                obj += "f \(i0)//\(i0) \(i1)//\(i1) \(i2)//\(i2)\n"
            }

            vertexOffset += geom.vertices.count
        }

        do {
            try obj.write(to: url, atomically: true, encoding: .utf8)
        } catch {
            throw MeshExportError.writeFailed
        }
        return url
    }
}

// MARK: - ARKit Geometry helpers
private extension ARGeometrySource {
    func vertex(at index: Int) -> SIMD3<Float> {
        let stride = self.stride
        let offset = self.offset
        let stridePtr = UnsafeRawPointer(buffer.contents() + offset + index * stride)
        let f = stridePtr.assumingMemoryBound(to: SIMD3<Float>.self).pointee
        return f
    }
    func normal(at index: Int) -> SIMD3<Float> {
        let stride = self.stride
        let offset = self.offset
        let stridePtr = UnsafeRawPointer(buffer.contents() + offset + index * stride)
        let f = stridePtr.assumingMemoryBound(to: SIMD3<Float>.self).pointee
        return f
    }
}

private extension ARGeometryElement {
    // Compute number of indices in this element
    var indexCount: Int {
        // Entire buffer is the index data for this element
        return buffer.length / self.bytesPerIndex
    }

    func index(at elementIndex: Int) -> UInt32 {
        // Handles 2- or 4-byte indices
        let bytesPer = self.bytesPerIndex
        let base = buffer.contents() + elementIndex * bytesPer
        switch bytesPer {
        case 2:
            return UInt32(base.assumingMemoryBound(to: UInt16.self).pointee)
        case 4:
            return base.assumingMemoryBound(to: UInt32.self).pointee
        default:
            // Fallback: treat as 4-byte
            return base.assumingMemoryBound(to: UInt32.self).pointee
        }
    }
}

private extension SIMD4 where Scalar == Float {
    var xyz: SIMD3<Float> { .init(x, y, z) }
}
