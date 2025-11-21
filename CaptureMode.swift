//
//  CaptureMode.swift
//  X-Scan 3D
//
//  Created by KOTIREDDY SYAMALA on 12/11/25.
//

import Foundation

enum CaptureMode: String, CaseIterable, Equatable {
    case lidar = "LiDAR"
    case photo = "Photo"
    case pano  = "360°"
}
