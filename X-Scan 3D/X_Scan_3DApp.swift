//
//  X_Scan_3DApp.swift
//  X-Scan 3D
//
//  Created by KOTIREDDY SYAMALA on 11/11/25.
//
import SwiftUI

@main
struct X_Scan_3DApp: App {
    @StateObject private var vm = ProjectViewModel()
    @StateObject private var cameraEngine = CameraEngine()

    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environmentObject(vm)
                .environmentObject(cameraEngine)
        }
    }
}
