//
//  ShutterHUD.swift
//  X-Scan 3D
//
//  Created by KOTIREDDY SYAMALA on 12/11/25.
//

import SwiftUI

struct ShutterHUD: View {
    var onShutter: () -> Void

    var body: some View {
        HStack {
            // Left spacer or placeholder for future controls
            Spacer()

            // Shutter button
            Button(action: onShutter) {
                ZStack {
                    Circle()
                        .fill(Color.white)
                        .frame(width: 78, height: 78)
                    Circle()
                        .stroke(Color.white.opacity(0.6), lineWidth: 4)
                        .frame(width: 90, height: 90)
                }
                .shadow(radius: 8)
            }
            .accessibilityLabel("Shutter")

            // Right spacer or placeholder for future controls
            Spacer()
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 12)
        .background(
            LinearGradient(
                colors: [Color.black.opacity(0.6), Color.black.opacity(0.0)],
                startPoint: .bottom,
                endPoint: .top
            )
            .ignoresSafeArea(edges: .bottom)
        )
    }
}
