//
//  ExploreMapView.swift
//  X-Scan 3D
//
//  Created by KOTIREDDY SYAMALA on 11/11/25.
//

import SwiftUI
import MapKit

struct ExploreMapView: View {
    // iOS 17+: use MapCameraPosition
    @State private var position: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 41.89, longitude: 12.51),
            span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        )
    )

    // iOS 16 fallback state (unused on iOS 17+)
    @State private var legacyRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 41.89, longitude: 12.51),
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    )

    var body: some View {
        Group {
            if #available(iOS 17.0, *) {
                Map(position: $position, interactionModes: .all) {
                    // Add map content here if desired (e.g., UserAnnotation(), MapCompass(), etc.)
                }
            } else {
                Map(coordinateRegion: $legacyRegion, interactionModes: [.all])
            }
        }
        .ignoresSafeArea()
        .overlay(alignment: .topLeading) {
            VStack(alignment: .leading) {
                Text("Explore Nearby Scans")
                    .font(.headline)
                    .padding(10)
                    .background(.ultraThinMaterial)
                    .cornerRadius(10)
                    .padding()
            }
        }
    }
}
