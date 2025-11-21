//
//  ProcessingOptionsView.swift
//  X-Scan 3D
//
//  Created by KOTIREDDY SYAMALA on 12/11/25.
//

import SwiftUI

struct ProcessingOptionsView: View {
    @Environment(\.dismiss) private var dismiss

    let project: ProjectModel
    let onSelect: (ProcessingMode) -> Void

    @State private var selectedMode: ProcessingMode = .localQuick

    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("Project")) {
                    HStack {
                        if let thumb = project.thumbnail {
                            Image(uiImage: thumb)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 56, height: 56)
                                .clipped()
                                .cornerRadius(8)
                        } else {
                            ZStack {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.gray.opacity(0.2))
                                Image(systemName: "cube")
                                    .foregroundColor(.gray)
                            }
                            .frame(width: 56, height: 56)
                        }
                        VStack(alignment: .leading) {
                            Text(project.title).bold()
                            Text(project.date, style: .date)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }

                Section(header: Text("Processing Mode")) {
                    ModeRow(title: "Local Quick", subtitle: "Fast preview using available data", mode: .localQuick)
                    ModeRow(title: "Local LiDAR Only", subtitle: "Generate mesh from LiDAR frames only", mode: .localLidarOnly)
                    ModeRow(title: "Cloud Premium", subtitle: "High-quality reconstruction in the cloud", mode: .cloudPremium)
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Process Options")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Start") {
                        onSelect(selectedMode)
                        dismiss()
                    }
                    .bold()
                }
            }
        }
    }

    @ViewBuilder
    private func ModeRow(title: String, subtitle: String, mode: ProcessingMode) -> some View {
        Button {
            selectedMode = mode
        } label: {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(title).foregroundColor(.primary)
                    Text(subtitle).font(.caption).foregroundColor(.secondary)
                }
                Spacer()
                if selectedMode == mode {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.accentColor)
                } else {
                    Image(systemName: "circle")
                        .foregroundColor(.secondary)
                }
            }
            .contentShape(Rectangle())
        }
    }
}

