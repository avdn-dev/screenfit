//
//  ExercisesView.swift
//  ScreenFit
//
//  Created by Anh Nguyen on 15/3/2025.
//

import SwiftUI

struct ExercisesView: View {
    @Environment(PoseEstimator.self) var poseEstimator
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            List {
                Section("Select exercise to unlock") {
                    ForEach(Exercise.allCases, id: \.self) { exercise in
                        NavigationLink {
                            switch exercise {
                            case .walking: PoseEstimatedExerciseView(exercise: exercise)
                            default : PoseEstimatedExerciseView(exercise: exercise)
                            }
                        } label: {
                            HStack {
                                exercise.image
                                
                                Text(exercise.rawValue)
                            }
                        }
                    }
                }
                .headerProminence(.increased)
            }
            .navigationTitle("Unlock apps")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                    }
                }
            }
        }
    }
}

#Preview {
    ExercisesView()
        .environment(PoseEstimator())
        .preferredColorScheme(.dark)
}
