//
//  PointCloudBuilder.swift
//  X-Scan 3D
//
//  Created by KOTIREDDY SYAMALA on 11/11/25.
//

import Foundation
import ARKit
import simd
import UIKit

enum PointCloudError: Error { case intrinsicsMissing }

struct PointCloudBuilder {
    // Returns positions + colors for each valid depth pixel
    static func pointCloud(from frame: ARFrame, depth: ARDepthData) throws -> ([SIMD3<Float>], [SIMD3<UInt8>]) {
        let camera = frame.camera
        let intrinsics = camera.intrinsics
        let resolution = camera.imageResolution

        // Depth buffer (Float32 meters)
        let depthBuffer = depth.depthMap
        CVPixelBufferLockBaseAddress(depthBuffer, .readOnly)
        defer { CVPixelBufferUnlockBaseAddress(depthBuffer, .readOnly) }

        let dw = CVPixelBufferGetWidth(depthBuffer)
        let dh = CVPixelBufferGetHeight(depthBuffer)
        let dptr = CVPixelBufferGetBaseAddress(depthBuffer)!.assumingMemoryBound(to: Float32.self)

        // RGB (for color sampling)
        let rgbBuffer = frame.capturedImage
        let rgbImage = CIImage(cvPixelBuffer: rgbBuffer).oriented(forExifOrientation: 6) // portrait fix
        let ctx = CIContext()
        guard let rgbCG = ctx.createCGImage(rgbImage, from: rgbImage.extent) else {
            return ([], [])
        }
        let rgbProvider = rgbCG.dataProvider!.data! as Data
        let rgbBytes = [UInt8](rgbProvider)
        let bytesPerPixel = 4 // BGRA

        var positions: [SIMD3<Float>] = []
        positions.reserveCapacity(dw * dh / 2)
        var colors: [SIMD3<UInt8>] = []
        colors.reserveCapacity(dw * dh / 2)

        // Simple intrinsics unprojection
        let fx = intrinsics.columns.0.x
        let fy = intrinsics.columns.1.y
        let cx = intrinsics.columns.2.x
        let cy = intrinsics.columns.2.y

        // Scale from depth map resolution to RGB resolution
        let sx = Float(resolution.width) / Float(dw)
        let sy = Float(resolution.height) / Float(dh)

        for y in 0..<dh {
            for x in 0..<dw {
                let z = dptr[y * dw + x]
                if !z.isFinite || z <= 0.0 { continue }

                // camera-space coordinates
                let X = (Float(x) - cx) / fx * z
                let Y = (Float(y) - cy) / fy * z
                let pos = SIMD3<Float>(X, Y, z)
                positions.append(pos)

                // nearest neighbor color sample in BGRA
                let rx = min(max(Int(Float(x) * sx), 0), Int(resolution.width) - 1)
                let ry = min(max(Int(Float(y) * sy), 0), Int(resolution.height) - 1)
                let idx = (ry * Int(resolution.width) + rx) * bytesPerPixel
                let b = rgbBytes[idx + 0]
                let g = rgbBytes[idx + 1]
                let r = rgbBytes[idx + 2]
                colors.append(SIMD3<UInt8>(r, g, b))
            }
        }
        return (positions, colors)
    }
}
