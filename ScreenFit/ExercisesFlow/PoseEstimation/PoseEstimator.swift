//
//  PoseEstimator.swift
//  ScreenFit
//
//  Created by Anh Nguyen on 15/3/2025.
//

import AVFoundation
import Vision

@Observable
class PoseEstimator: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    let sequenceHandler = VNSequenceRequestHandler()
    
    var bodyParts = [VNHumanBodyPoseObservation.JointName : VNRecognizedPoint]() {
        didSet {
            exerciseManager.checkForRepetition(bodyParts: bodyParts)
        }
    }

    var exerciseManager: ExerciseManager
    
    init(exerciseManager: ExerciseManager) {
        self.exerciseManager = exerciseManager
    }
    
    func captureOutput(_ output: AVCaptureOutput,
                       didOutput sampleBuffer: CMSampleBuffer,
                       from connection: AVCaptureConnection) {
        let humanBodyRequest = VNDetectHumanBodyPoseRequest(completionHandler: detectedBodyPose)
        
        do {
            try sequenceHandler.perform(
                [humanBodyRequest],
                on: sampleBuffer,
                orientation: .right) // TODO: Check this for edge cases later
        } catch {
            print("Failed to handle VNRequest: \(error)")
        }
    }
    
    func detectedBodyPose(request: VNRequest, error: Error?) {
        guard let bodyPoseResults = request.results as? [VNHumanBodyPoseObservation] else {
            return
        }
        
        guard var bodyParts = try? bodyPoseResults.first?.recognizedPoints(.all) else {
            return
        }
        
        bodyParts = bodyParts.filter{ _, bodyPart in
            // //TODO: Investigate if both coordinates are necessary, benchmarking performance
//            bodyPart.location.y != 1
            bodyPart.location.x != 0 && bodyPart.confidence > 0.1 // TODO: Tune the confidence required
        }
        
        DispatchQueue.main.async {
            self.bodyParts = bodyParts
        }
    }
}
