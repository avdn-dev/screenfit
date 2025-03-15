//
//  PoseEstimatedExerciseView.swift
//  ScreenFit
//
//  Created by Anh Nguyen on 15/3/2025.
//

import SwiftUI

struct PoseEstimatedExerciseView: View {
    @Environment(PoseEstimator.self) var poseEstimator
    @Environment(ExerciseManager.self) var exerciseManager
    @State var iShowingSkeleton: Bool = false
    
    let exercise: Exercise
    
    var body: some View {
        VStack {
            Toggle(isOn: $iShowingSkeleton) {
                Text("Display body skeleton")
            }
            
            HStack {
                ProgressView("\(exerciseManager.selectedExercise.rawValue) progress: \(exerciseManager.selectedExerciseReps)/\(exerciseManager.selectedExerciseTarget)", value: exerciseManager.currentProgress)
                    .exerciseStyle(value: exerciseManager.currentProgress, caption: "\(exerciseManager.selectedExercise.rawValue) progress: \(exerciseManager.selectedExerciseReps)/\(exerciseManager.selectedExerciseTarget)", symbol: exercise.image)
            }
            .padding(.bottom)
            
            ZStack {
                GeometryReader { geo in
                    CameraViewWrapper(poseEstimator: poseEstimator)
                    SkeletonView(poseEstimator: poseEstimator, size: geo.size)
                        .opacity(iShowingSkeleton ? 1 : 0)
                }
            }
            .clipShape(
                RoundedRectangle(
                    cornerRadius: 15,
                    style: .continuous
                )
            )
        }
        .navigationTitle(exercise.rawValue)
        .onAppear {
            exerciseManager.selectedExercise = exercise
        }
        .padding(.horizontal)
    }
}

#Preview {
    PoseEstimatedExerciseView(exercise: .squat)
        .preferredColorScheme(.dark)
}
