//
//  CameraView.swift
//  ScreenFit
//
//  Created by Anh Nguyen on 15/3/2025.
//

import UIKit
import AVFoundation

final class CameraView: UIView {
    // Use the preview layer as the view's backing layer
    override class var layerClass: AnyClass {
        AVCaptureVideoPreviewLayer.self
    }
    
    var previewLayer: AVCaptureVideoPreviewLayer {
        layer as! AVCaptureVideoPreviewLayer
    }
    
    func setSession(_ session: AVCaptureSession) {
        // Connects the session with the preview layer so that the layer provides live view of camera
        previewLayer.session = session
    }
}
