//
//  CameraViewController.swift
//  ScreenFit
//
//  Created by Anh Nguyen on 15/3/2025.
//

import UIKit
import AVFoundation

final class CameraViewController: UIViewController {
    // MARK: Stored properties
    
    private let cameraQueue = DispatchQueue(
        label: "CameraOutput",
        qos: .userInteractive
    )
    
    private let userQueue = DispatchQueue(label: "UserInitiated", qos: .userInitiated)
    
    private var cameraSession: AVCaptureSession!
    
    var delegate: AVCaptureVideoDataOutputSampleBufferDelegate?
    
    // MARK: Computed properties
    
    private var cameraView: CameraView { view as! CameraView }
    
    // MARK: Overrides
    
    override func loadView() {
        view = CameraView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        do {
            if cameraSession == nil {
                try prepareAVSession()
                cameraView.setSession(cameraSession)
                cameraView.previewLayer.videoGravity = .resizeAspectFill
            }
            
            userQueue.async { [weak self] in
                self?.cameraSession.startRunning()
            }
        } catch {
            print(error.localizedDescription)
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        cameraSession?.stopRunning()
        super.viewWillDisappear(animated)
    }
    
    // MARK: Internal functions
    
    func prepareAVSession() throws {
        cameraSession = AVCaptureSession()
        cameraSession.beginConfiguration()
        cameraSession.sessionPreset = AVCaptureSession.Preset.high
        guard let videoDevice = AVCaptureDevice.default(
                .builtInWideAngleCamera,
                for: .video,
                position: .front)
        else { return }
        
        guard let deviceInput = try? AVCaptureDeviceInput(device: videoDevice) else {
            return
        }
        
        guard cameraSession.canAddInput(deviceInput) else {
            return
        }
        cameraSession.addInput(deviceInput)
        
        let dataOutput = AVCaptureVideoDataOutput()
        if cameraSession.canAddOutput(dataOutput) {
            cameraSession.addOutput(dataOutput)
            dataOutput.setSampleBufferDelegate(delegate, queue: cameraQueue)
        } else {
            return
        }
        
        cameraSession.commitConfiguration()
    }
}
