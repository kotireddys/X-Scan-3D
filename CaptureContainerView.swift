//
//  CaptureContainerView.swift
//  X-Scan 3D
//
//  Created by KOTIREDDY SYAMALA on 12/11/25.
//

import SwiftUI
import UIKit

struct CaptureContainerView: View {
    @EnvironmentObject var cameraEngine: CameraEngine
    @EnvironmentObject var vm: ProjectViewModel

    @State private var showLibrarySheet = false
    @State private var showProcessingSheet = false

    var body: some View {
        ZStack {
            // BACKGROUND: camera / LiDAR feed
            Group {
                switch cameraEngine.mode {
                case .photo:
                    PhotoCaptureView()
                        .environmentObject(cameraEngine)
                case .lidar:
                    ScanView(showHeader: false)
                case .pano:
                    PanoStubView()
                }
            }
            .ignoresSafeArea()

            // FOREGROUND: HUD
            VStack(spacing: 0) {
                // Use the standalone top bar that binds to mode
                CaptureTopBar(mode: $cameraEngine.mode)

                Spacer()

                // Bottom HUD: left library button, shutter, right settings
                bottomBar
            }
        }
        .preferredColorScheme(.dark)
        .sheet(isPresented: $showLibrarySheet) {
            ModelLibraryView()
                .environmentObject(vm)
        }
        .sheet(isPresented: $showProcessingSheet) {
            // You already have ProcessingOptionsView – reuse later
            Text("Processing sheet goes here")
                .padding()
        }
    }

    private var bottomBar: some View {
        HStack(spacing: 56) {
            // Quick Library shortcut
            Button {
                showLibrarySheet = true
            } label: {
                Image(systemName: "photo.on.rectangle")
                    .font(.title2)
                    .foregroundColor(.white)
                    .padding(10)
                    .background(.ultraThinMaterial)
                    .clipShape(Circle())
            }

            // Shutter using your standalone component
            ShutterHUD {
                if cameraEngine.mode == .photo {
                    cameraEngine.capturePhoto()
                } else if cameraEngine.mode == .lidar {
                    // later: trigger LiDAR snapshot / mark scan
                }
                showProcessingSheet = true
            }

            // Right button reserved for future capture settings
            Button {
                // open capture settings
            } label: {
                Image(systemName: "slider.horizontal.3")
                    .font(.title2)
                    .foregroundColor(.white)
                    .padding(10)
                    .background(.ultraThinMaterial)
                    .clipShape(Circle())
            }
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 10)
        .background(.ultraThinMaterial)
        .clipShape(Capsule())
        .padding(.horizontal, 18)
    }
}

// Placeholder panel for 360° mode
struct PanoStubView: View {
    var body: some View {
        ZStack {
            Color.black
            Text("360° Capture Coming Soon")
                .foregroundColor(.white)
                .font(.headline)
        }
        .ignoresSafeArea()
    }
}
