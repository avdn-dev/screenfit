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
    @State var poseEstimator = PoseEstimator()
    @State var screenTimeBlocker = ScreenTimeBlocker()
    
    let container: ModelContainer
    
    init() {
        #if DEBUG
        let configuration = ModelConfiguration(
            for: OnboardingVersion.self,
            isStoredInMemoryOnly: true
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
        
        poseEstimator.resetScreenTime = screenTimeBlocker.resetScreenTimeLimit
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(permissionsService)
                .environment(poseEstimator)
                .environment(screenTimeBlocker)
                .modelContainer(container)
        }
    }
}
