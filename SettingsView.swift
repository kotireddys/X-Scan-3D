//
//  SettingsView.swift
//  X-Scan 3D
//
//  Created by KOTIREDDY SYAMALA on 11/11/25.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("captureEveryNFrames") private var captureEveryNFrames: Int = 6
    @AppStorage("saveDepthData") private var saveDepthData: Bool = true
    @AppStorage("enableMeshReconstruction") private var enableMeshReconstruction: Bool = true

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Capture")) {
                    Stepper(value: $captureEveryNFrames, in: 1...30) {
                        HStack {
                            Text("Capture every N frames")
                            Spacer()
                            Text("\(captureEveryNFrames)")
                                .foregroundStyle(.secondary)
                        }
                    }
                    Toggle("Save Depth Data", isOn: $saveDepthData)
                }

                Section(header: Text("Reconstruction")) {
                    Toggle("Enable Mesh Reconstruction", isOn: $enableMeshReconstruction)
                }

                Section(header: Text("About")) {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "—")
                            .foregroundStyle(.secondary)
                    }
                    HStack {
                        Text("Build")
                        Spacer()
                        Text(Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "—")
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
}
