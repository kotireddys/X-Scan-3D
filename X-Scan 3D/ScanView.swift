//
//  ScanView.swift
//  X-Scan 3D
//
//  Created by KOTIREDDY SYAMALA on 11/11/25.
//

import SwiftUI
import ARKit
import RealityKit

struct ScanView: View {
    /// Toggle the default LiDAR header (used only in standalone mode)
    var showHeader: Bool = true

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .top) {
                // Your ARKit / LiDAR feed
                // Provide an ARView instance to ARContainerView as required by its API.
                ARContainerView(arView: ARView(frame: .zero))
                    .ignoresSafeArea()

                // Optional header (only if showHeader is true)
                if showHeader {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("X-Scan 3D")
                            .font(.headline)
                            .foregroundColor(.white)
                        Text("No Mesh")
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                    .padding(.top, geo.safeAreaInsets.top + 8)
                    .padding(.horizontal)
                    .background(.ultraThinMaterial)
                    .cornerRadius(12)
                    .padding()
                }
            }
            .background(Color.black)
            .ignoresSafeArea() // Keep AR full-bleed; GeometryReader gives us the insets
        }
    }
}
