//
//  CameraPreview.swift
//  X-Scan 3D
//
//  Created by KOTIREDDY SYAMALA on 14/11/25.
//

import SwiftUI
import AVFoundation
import UIKit

struct CameraPreview: UIViewRepresentable {
    let session: AVCaptureSession
    var videoGravity: AVLayerVideoGravity = .resizeAspectFill

    func makeUIView(context: Context) -> PreviewView {
        let view = PreviewView()
        view.videoPreviewLayer.session = session
        view.videoPreviewLayer.videoGravity = videoGravity
        return view
    }

    func updateUIView(_ uiView: PreviewView, context: Context) {
        if uiView.videoPreviewLayer.session !== session {
            uiView.videoPreviewLayer.session = session
        }
        uiView.videoPreviewLayer.videoGravity = videoGravity
    }
}

// A UIView subclass whose backing layer is AVCaptureVideoPreviewLayer
final class PreviewView: UIView {
    override class var layerClass: AnyClass {
        AVCaptureVideoPreviewLayer.self
    }

    var videoPreviewLayer: AVCaptureVideoPreviewLayer {
        return layer as! AVCaptureVideoPreviewLayer
    }
}
