//
//  ImageDetailView.swift
//  X-Scan 3D
//
//  Created by KOTIREDDY SYAMALA on 11/11/25.
//

import SwiftUI
import _LocationEssentials

struct ImageDetailView: View {
    var frame: CaptureFrame
    var project: ProjectModel
    @EnvironmentObject var vm: ProjectViewModel

    var body: some View {
        VStack {
            Image(uiImage: frame.thumbnail)
                .resizable()
                .scaledToFit()
                .padding()

            Text("Captured at: \(frame.timestamp.formatted())")
            if let gps = frame.gpsLocation {
                Text("Lat: \(gps.latitude), Lon: \(gps.longitude)")
            }
            Toggle("Include in Reconstruction", isOn: .constant(frame.includeInReconstruction))
                .padding()

            Spacer()
        }
        .presentationDetents([.medium, .large])
    }
}

