//
//  MainTabView.swift
//  X-Scan 3D
//
//  Created by KOTIREDDY SYAMALA on 11/11/25.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            CaptureContainerView()
                .tabItem { Label("Capture", systemImage: "camera.viewfinder") }

            ModelLibraryView()
                .tabItem { Label("Library", systemImage: "square.grid.2x2.fill") }

            ExploreMapView()
                .tabItem { Label("Explore", systemImage: "map.fill") }

            SettingsView()
                .tabItem { Label("Profile", systemImage: "person.crop.circle") }
        }
        .tint(.blue)
    }
}
