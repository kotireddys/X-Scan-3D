//
//  ShareSheet.swift
//  X-Scan 3D
//
//  Created by KOTIREDDY SYAMALA on 11/11/25.
//

import SwiftUI
import UIKit

struct ShareSheet: UIViewControllerRepresentable {
    var activityItems: [Any]
    var applicationActivities: [UIActivity]? = nil
    var excludedActivityTypes: [UIActivity.ActivityType]? = nil
    var completion: UIActivityViewController.CompletionWithItemsHandler? = nil

    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: activityItems,
                                                  applicationActivities: applicationActivities)
        controller.excludedActivityTypes = excludedActivityTypes
        controller.completionWithItemsHandler = completion
        return controller
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        // No dynamic updates needed
    }
}
