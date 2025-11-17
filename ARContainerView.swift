//
//  ARContainerView.swift
//  X-Scan 3D
//
//  Created by KOTIREDDY SYAMALA on 11/11/25.
//

import SwiftUI
import RealityKit

struct ARContainerView: UIViewRepresentable {
    let arView: ARView

    func makeUIView(context: Context) -> ARView {
        arView
    }

    func updateUIView(_ uiView: ARView, context: Context) {
        // Nothing to update; ARView is managed by LiDARCaptureManager
    }
}

