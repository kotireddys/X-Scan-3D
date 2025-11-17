//
//  PhotoCaptureView.swift
//  X-Scan 3D
//
//  Created by KOTIREDDY SYAMALA on 11/11/25.
//

import SwiftUI
import AVFoundation
import CoreLocation
import Combine

struct PhotoCaptureView: View {
    @EnvironmentObject var cameraEngine: CameraEngine

    var body: some View {
        ZStack {
            CameraPreview(session: cameraEngine.photoSession)
                .ignoresSafeArea()
        }
        .background(Color.black)
        .ignoresSafeArea()
        .navigationBarHidden(true)
        .toolbar(.hidden)
    }
}

// … the rest of the file remains unchanged …
