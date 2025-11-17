//
//  HomeView.swift
//  X-Scan 3D
//
//  Created by KOTIREDDY SYAMALA on 11/11/25.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var vm: ProjectViewModel

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                NavigationLink("📷 New Scan", destination: ScanView())
                    .buttonStyle(.borderedProminent)

                NavigationLink("🧭 My Projects", destination: ProjectListView())
                    .buttonStyle(.bordered)
            }
            .navigationTitle("X-Scan 3D")
        }
    }
}
