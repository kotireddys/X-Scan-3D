//
//  CaptureTopBar.swift
//  X-Scan 3D
//
//  Created by KOTIREDDY SYAMALA on 12/11/25.
//

import SwiftUI

struct CaptureTopBar: View {
    @Binding var mode: CaptureMode

    var body: some View {
        GeometryReader { geo in
            HStack {
                ModeChips(mode: $mode)
                Spacer()
                HStack(spacing: 8) {
                    GlassIcon(system: "bolt.fill")
                    GlassIcon(system: "questionmark.circle")
                    GlassIcon(system: "gearshape")
                }
            }
            .padding(.horizontal, 12)
            .padding(.top, geo.safeAreaInsets.top + 8)
            .padding(.bottom, 8)
            .background(
                LinearGradient(colors: [Color.black.opacity(0.5), Color.black.opacity(0.0)],
                               startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea(edges: .top)
            )
        }
        .frame(height: 64) // Provide a reasonable height; GeometryReader needs a frame
    }
}

// Minimal chip selector for CaptureMode
private struct ModeChips: View {
    @Binding var mode: CaptureMode

    var body: some View {
        HStack(spacing: 8) {
            Chip(title: "LiDAR", isSelected: mode == .lidar) { mode = .lidar }
            Chip(title: "Photo", isSelected: mode == .photo) { mode = .photo }
        }
    }

    @ViewBuilder
    private func Chip(title: String, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline.weight(.semibold))
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(isSelected ? Color.white.opacity(0.2) : Color.black.opacity(0.3))
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(isSelected ? Color.white.opacity(0.9) : Color.white.opacity(0.4), lineWidth: 1)
                )
                .foregroundColor(.white)
                .cornerRadius(14)
        }
        .buttonStyle(.plain)
        .accessibilityLabel(title)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}

// Minimal frosted circular icon button
private struct GlassIcon: View {
    let system: String
    var action: (() -> Void)? = nil

    var body: some View {
        Button(action: { action?() }) {
            Image(systemName: system)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white)
                .frame(width: 32, height: 32)
                .background(.ultraThinMaterial)
                .clipShape(Circle())
                .overlay(
                    Circle().stroke(Color.white.opacity(0.3), lineWidth: 1)
                )
        }
        .buttonStyle(.plain)
    }
}
