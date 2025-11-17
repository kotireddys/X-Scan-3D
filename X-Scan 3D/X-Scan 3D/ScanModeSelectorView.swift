//
//  ScanModeSelectorView.swift
//  X-Scan 3D
//
//  Created by KOTIREDDY SYAMALA on 11/11/25.
//

import SwiftUI

struct ScanModeSelectorView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                NavigationLink(destination: ScanView()) {
                    Label("LiDAR Scan", systemImage: "cube.transparent.fill")
                        .font(.title2.bold())
                }
                .buttonStyle(.borderedProminent)
                .tint(.green)

                NavigationLink(destination: PhotoCaptureView()) {
                    Label("Photogrammetry Capture", systemImage: "camera.circle.fill")
                        .font(.title2.bold())
                }
                .buttonStyle(.borderedProminent)
                .tint(.blue)
            }
            .navigationTitle("Choose Scan Mode")
            .padding()
        }
    }
}
