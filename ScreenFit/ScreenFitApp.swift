//
//  ScreenFitApp.swift
//  ScreenFit
//
//  Created by Anh Nguyen on 14/3/2025.
//

import SwiftData
import SwiftUI
import FamilyControls

@main
struct ScreenFitApp: App {
    @State var permissionsService = PermissionsService()
    @State var poseEstimator: PoseEstimator
    @State var screenTimeBlocker = ScreenTimeBlocker()
    @State var meshGradientModel = MeshGradientModel()
    @State var exerciseManager: ExerciseManager
    
    let container: ModelContainer
    
    init() {
        #if DEBUG
        let configuration = ModelConfiguration(
            for: OnboardingVersion.self,
            isStoredInMemoryOnly: false
        )
        #else
        let configuration = ModelConfiguration(
            for: OnboardingVersion.self,
            isStoredInMemoryOnly: false
        )
        #endif
        container = try! ModelContainer(
            for: OnboardingVersion.self,
            configurations: configuration
        )
        
        let exerciseManager = ExerciseManager()
        _exerciseManager = State(initialValue: exerciseManager)
        _poseEstimator = State(initialValue: PoseEstimator(exerciseManager: exerciseManager))
        exerciseManager.resetScreenTime = screenTimeBlocker.resetScreenTimeLimit
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(permissionsService)
                .environment(poseEstimator)
                .environment(screenTimeBlocker)
                .environment(meshGradientModel)
                .environment(exerciseManager)
                .modelContainer(container)
                .preferredColorScheme(.dark)
        }
    }
}
