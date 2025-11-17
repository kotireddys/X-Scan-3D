//
//  ProjectModel.swift
//  X-Scan 3D
//
//  Created by KOTIREDDY SYAMALA on 11/11/25.
//

import Foundation
import SwiftUI

struct ProjectModel: Identifiable, Hashable {
    let id = UUID()
    var title: String
    var date: Date
    var thumbnail: UIImage?
    var frames: [CaptureFrame]
    var modelPath: URL?
}
