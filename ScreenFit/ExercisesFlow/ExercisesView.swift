//
//  ExercisesView.swift
//  ScreenFit
//
//  Created by Anh Nguyen on 15/3/2025.
//

import SwiftUI

struct ExercisesView: View {
    @Environment(PoseEstimator.self) var poseEstimator
    @Environment(ExerciseManager.self) var exerciseManager
    @Environment(ScreenTimeBlocker.self) var screenTimeBlocker
    @Environment(\.dismiss) var dismiss
    
    @State var isShowingFinalConfirmationAlert: Bool = false
    
    let alertMessages = [
        "Your future self called. They're not mad, just disappointed.",
        "Fun fact: the average person can do at least ONE more rep than they think they can. But you'll never know...",
        "Breaking news: local user opts for thumb exercise instead of promised workout. Fitness influencers hate this one trick!",
        "Achievement unlocked: Master of Excuses. +5 Screen Time, -10 Personal Growth",
        "If you do this, big Screen Time wins."
    ]
    
    var body: some View {
        NavigationStack {
            List {
                Section("Select an exercise and complete the required number of repetitions to unlock apps") {
                    ForEach(Exercise.allCases, id: \.self) { exercise in
                        NavigationLink {
                            switch exercise {
                            case .walking: PoseEstimatedExerciseView(exercise: exercise)
                            default : PoseEstimatedExerciseView(exercise: exercise)
                            }
                        } label: {
                            VStack(alignment: .leading) {
                                HStack(spacing: 0) {
                                    exercise.image
                                        .frame(width: 10)
                                    
                                    
                                    HStack {
                                        Group {
                                            Text(getPaddingSpaces(for: exercise))
                                                .monospaced()
                                            Text("\(exerciseManager.exerciseTargets[exercise]!)")
                                                .monospacedDigit()
                                        }
                                        
                                        Text(exercise.rawValue)
                                    }
                                }
                                
                                ProgressView(value: Double(exerciseManager.exerciseReps[exercise]!) / Double(exerciseManager.exerciseTargets[exercise]!))
                            }
                        }
                    }
                }
                .headerProminence(.increased)
                Section("The easy way out") {
                    Text("Warning: taking shortcuts may lead to excessive screen time, diminished gains, and disappointed personal trainers everywhere.")
                    
                    VStack(alignment: .center) {
                        Button("I'm a quitter (everyone is judging you)") {
                            isShowingFinalConfirmationAlert = true
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.bottom)
                }
                .listRowSeparator(.hidden)
            }
            .alert("Do you quit everything in life", isPresented: $isShowingFinalConfirmationAlert) {
                Button(role: .destructive) {
                    screenTimeBlocker.resetScreenTimeLimit()
                    dismiss()
                } label: {
                    Text("Quit")
                }
            } message: {
                Text(alertMessages.randomElement()!)
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
        .presentationCornerRadius(15)
    }
    
    func getPaddingSpaces(for exercise: Exercise) -> String {
        let maxDigitLength = "\(exerciseManager.highestTarget)".count
        
        let currentDigitLength = "\(exerciseManager.exerciseTargets[exercise]!)".count
        
        let spacesToAdd = maxDigitLength - currentDigitLength
        
        return String(repeating: " ", count: spacesToAdd)
    }
}

#Preview {
    ExercisesView()
        .environment(ScreenTimeBlocker())
        .environment(ExerciseManager())
        .environment(MeshGradientModel())
        .environment(PoseEstimator(exerciseManager: ExerciseManager()))
        .preferredColorScheme(.dark)
}
