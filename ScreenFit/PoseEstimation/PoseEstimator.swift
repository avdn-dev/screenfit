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
    
    var wasInBottomPosition = false
    var bodyParts = [VNHumanBodyPoseObservation.JointName : VNRecognizedPoint]() {
        didSet {
            countSquats(bodyParts: bodyParts)
        }
    }
    var squatCount = 0 {
        didSet {
            if squatCount == squatsRequired {
                // TODO: Add visual confirmation
                resetScreenTime()
                squatCount = 0
                onFinishedExercise()
            }
        }
    }
    var resetScreenTime: (() -> Void)!
    var squatsRequired = 1
    var onFinishedExercise: (() -> Void)!
    
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
    
    func countSquats(bodyParts: [VNHumanBodyPoseObservation.JointName : VNRecognizedPoint]) {
        // TODO: Add logic to include left side later
        guard let rightKnee = bodyParts[.rightKnee]?.location,
              let rightHip = bodyParts[.rightHip]?.location,
              let rightAnkle = bodyParts[.rightAnkle]?.location else {
            return
        }
        
        let firstAngle = atan2(rightHip.y - rightKnee.y, rightHip.x - rightKnee.x)
        let secondAngle = atan2(rightAnkle.y - rightKnee.y, rightAnkle.x - rightKnee.x)
        var angleDiffRadians = firstAngle - secondAngle
        while angleDiffRadians < 0 {
                    angleDiffRadians += CGFloat(2 * Double.pi)
                }
        let angleDiffDegrees = Int(angleDiffRadians * 180 / .pi)
        if angleDiffDegrees > 150 && self.wasInBottomPosition {
            self.squatCount += 1
            self.wasInBottomPosition = false
        }
        
        let hipHeight = rightHip.y
        let kneeHeight = rightKnee.y
        if hipHeight < kneeHeight {
            self.wasInBottomPosition = true
        }
    }
}
