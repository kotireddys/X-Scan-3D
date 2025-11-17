//
//  CaptureFrame.swift
//  X-Scan 3D
//
//  Created by KOTIREDDY SYAMALA on 11/11/25.
//

import Foundation
import SwiftUI
import CoreLocation

struct CaptureFrame: Identifiable, Hashable {
    static func == (lhs: CaptureFrame, rhs: CaptureFrame) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    let id = UUID()
    var imageName: String
    var thumbnail: UIImage
    var timestamp: Date
    var includeInReconstruction: Bool = true
    var gpsLocation: CLLocationCoordinate2D?
    var depthAvailable: Bool
}
