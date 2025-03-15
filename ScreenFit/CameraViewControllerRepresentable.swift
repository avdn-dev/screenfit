//
//  CameraViewControllerRepresentable.swift
//  ScreenFit
//
//  Created by Anh Nguyen on 15/3/2025.
//

import SwiftUI

struct CameraViewWrapper: UIViewControllerRepresentable {
    var poseEstimator: PoseEstimator
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let cameraViewController = CameraViewController()
        cameraViewController.delegate = poseEstimator
        return cameraViewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) { }
}
