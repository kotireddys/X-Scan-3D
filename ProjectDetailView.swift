//
//  ProjectDetailView.swift
//  X-Scan 3D
//
//  Created by KOTIREDDY SYAMALA on 11/11/25.
//

import SwiftUI

struct ProjectDetailView: View {
    var project: ProjectModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if let image = project.thumbnail {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(12)
                }

                NavigationLink(destination: CaptureGalleryView(project: project)) {
                    Label("View Captured Images", systemImage: "photo.on.rectangle")
                        .font(.headline)
                }
                .buttonStyle(.borderedProminent)

                Divider()
                Text("3D Model Preview (coming soon)")
                    .foregroundColor(.secondary)
                    .padding(.top)
            }
            .padding()
        }
        .navigationTitle(project.title)
    }
}
