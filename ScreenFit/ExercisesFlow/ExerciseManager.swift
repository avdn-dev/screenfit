//
//  ExerciseManager.swift
//  ScreenFit
//
//  Created by Anh Nguyen on 16/3/2025.
//

import Foundation
import Vision

@Observable
public class ExerciseManager {
    var exerciseTargets: [Exercise: Int] = [
        .squat: 10,
        .pushup: 8,
        .lunge: 12, // 6 per leg
        .jumpingJack: 20,
        .pullup: 4,
        .crunch: 15,
        .walking: 250
    ]
    var selectedExercise: Exercise = .squat
    var exerciseReps = generateEmptyExerciseRepsDictionary()
    var wasInBottomPosition = false
    var resetScreenTime: (() -> Void)!
    var onFinishedExercise: (() -> Void)!
    var resetMonitor: (() -> Void)!
    var highestTarget = 250
    
    var selectedExerciseTarget: Int {
        exerciseTargets[selectedExercise]!
    }
    var selectedExerciseReps: Int {
        exerciseReps[selectedExercise]!
    }
    
    var currentProgress: Double {
        Double(selectedExerciseReps) / Double(selectedExerciseTarget)
    }
    
    static func generateEmptyExerciseRepsDictionary() -> [Exercise: Int] {
        return Exercise.allCases.reduce(into: [Exercise: Int]()) { partialResult, exercise in
            partialResult[exercise] = 0
        }
    }
    
    func checkForRepetition(bodyParts: [VNHumanBodyPoseObservation.JointName : VNRecognizedPoint]) {
        switch selectedExercise {
        case .squat:
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
                exerciseReps[.squat, default: 0] += 1
                if exerciseReps[.squat] == exerciseTargets[.squat] {
                    // TODO: Add visual confirmation
                    resetScreenTime()
                    exerciseReps[.squat] = 0
                    onFinishedExercise()
                    resetMonitor()
                }
                
                self.wasInBottomPosition = false
            }
            
            let hipHeight = rightHip.y
            let kneeHeight = rightKnee.y
            if hipHeight < kneeHeight {
                self.wasInBottomPosition = true
            }
        default: break
        }
    }
}
