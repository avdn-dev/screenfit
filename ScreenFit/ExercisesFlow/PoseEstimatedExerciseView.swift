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
            
            ZStack {
                GeometryReader { geo in
                    CameraViewWrapper(poseEstimator: poseEstimator)
                    SkeletonView(poseEstimator: poseEstimator, size: geo.size)
                        .opacity(iShowingSkeleton ? 1 : 0)
                }
            }
            HStack {
                Text("Squat counter:")
                    .font(.title)
                Text(String(exerciseManager.exerciseReps[exercise] ?? 0))
                    .font(.title)
            }
        }
        .navigationTitle(exercise.rawValue)
        .onAppear {
            exerciseManager.selectedExercise = exercise
        }
    }
}

#Preview {
    PoseEstimatedExerciseView(exercise: .squat)
        .preferredColorScheme(.dark)
}
