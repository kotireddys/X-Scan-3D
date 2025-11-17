//
//  ProjectViewModel.swift
//  X-Scan 3D
//
//  Created by KOTIREDDY SYAMALA on 11/11/25.
//

import Foundation
import SwiftUI
import Combine

@MainActor
class ProjectViewModel: ObservableObject {
    @Published var projects: [ProjectModel] = []

    func addProject(_ project: ProjectModel) {
        projects.append(project)
    }

    func toggleFrameSelection(projectID: UUID, frameID: UUID) {
        guard let pIndex = projects.firstIndex(where: { $0.id == projectID }),
              let fIndex = projects[pIndex].frames.firstIndex(where: { $0.id == frameID }) else { return }
        projects[pIndex].frames[fIndex].includeInReconstruction.toggle()
    }
}

