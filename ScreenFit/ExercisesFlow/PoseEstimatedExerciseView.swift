//
//  PoseEstimatedExerciseView.swift
//  ScreenFit
//
//  Created by Anh Nguyen on 15/3/2025.
//

import SwiftUI

struct PoseEstimatedExerciseView: View {
    @Environment(PoseEstimator.self) var poseEstimator
    let exercise: Exercise
    
    var body: some View {
        VStack {
            ZStack {
                GeometryReader { geo in
                    CameraViewWrapper(poseEstimator: poseEstimator)
                    SkeletonView(poseEstimator: poseEstimator, size: geo.size)
                }
            }
            .frame(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.width * 1920 / 1080, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            HStack {
                Text("Squat counter:")
                    .font(.title)
                Text(String(poseEstimator.squatCount))
                    .font(.title)
            }
        }
        .navigationTitle(exercise.rawValue)
    }
}

#Preview {
    PoseEstimatedExerciseView(exercise: .squat)
}
