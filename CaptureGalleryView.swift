//
//  CaptureGalleryView.swift
//  X-Scan 3D
//
//  Created by KOTIREDDY SYAMALA on 11/11/25.
//

import SwiftUI

struct CaptureGalleryView: View {
    @EnvironmentObject var vm: ProjectViewModel
    var project: ProjectModel
    @State private var selectedFrame: CaptureFrame?

    let grid = [GridItem(.adaptive(minimum: 100), spacing: 8)]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: grid, spacing: 10) {
                ForEach(project.frames) { frame in
                    VStack {
                        Image(uiImage: frame.thumbnail)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                            .clipped()
                            .overlay(
                                RoundedRectangle(cornerRadius: 6)
                                    .stroke(frame.includeInReconstruction ? Color.green : Color.red, lineWidth: 2)
                            )
                            .onTapGesture {
                                selectedFrame = frame
                            }
                        Text(frame.timestamp, style: .time)
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Source Images")
        .sheet(item: $selectedFrame) { frame in
            ImageDetailView(frame: frame, project: project)
        }
    }
}

