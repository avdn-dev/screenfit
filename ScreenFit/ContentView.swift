//
//  ContentView.swift
//  ScreenFit
//
//  Created by Anh Nguyen on 14/3/2025.
//

import FamilyControls
import SwiftUI
import ManagedSettings
import SwiftData

struct ContentView: View {
    @Environment(MeshGradientModel.self) var meshGradientModel
    @Environment(\.modelContext) var modelContext
    @Environment(PoseEstimator.self) var poseEstimator
    @Environment(ExerciseManager.self) var exerciseManager
    @AppStorage("isShowingScreenTimeResetSheet", store: UserDefaults(suiteName: "group.CGC-Studio.ScreenFit.shared-data")) var isShowingScreenTimeResetSheet: Bool = false
    @Query var onboardingVersion: [OnboardingVersion]
    @State private var isShowingOnboarding = false
    
    let currentOnboardingVersionNumer = "1.0.0"
    
    var body: some View {
        TabView {
            Group {
                // TODO: Adopt UIKit to allow the label icons to change with state
                BlockView()
                    .tabItem {
                        Label("Block", systemImage: "lock.iphone")
                    }
                StatsView()
                    .tabItem {
                        Label("Stats", systemImage: "chart.bar.fill")
                    }
                SettingsView()
                    .tabItem {
                        Label("Settings", systemImage: "gearshape.fill")
                    }
            }
            .toolbarBackground(.regularMaterial, for: .tabBar)
            .toolbarBackground(.visible, for: .tabBar)
            .toolbarColorScheme(.dark, for: .tabBar)
        }
        .sheet(isPresented: $isShowingScreenTimeResetSheet) {
            ExercisesView()
        }
        .fullScreenCover(isPresented: $isShowingOnboarding) {
            OnboardingOverlay {
                // Store new onboarding version to disk
                modelContext.insert(OnboardingVersion(versionNumber: currentOnboardingVersionNumer))
                
                // Dismiss the onboarding view
                isShowingOnboarding.toggle()
            }
            .ignoresSafeArea()
        }
        .onAppear {
            isShowingOnboarding = shouldShowOnboarding()
            exerciseManager.onFinishedExercise = hideScreenTimeResetSheet
            startMeshGradientAnimation()
        }
    }
    
    private func shouldShowOnboarding() -> Bool {
        // Onboarding versions stored in descending order
        if let onboarding = onboardingVersion.first,
           currentOnboardingVersionNumer == onboarding.versionNumber {
            // User has already seen the current onboarding flow
            return false
        } else {
            return true
        }
    }
    
    private func hideScreenTimeResetSheet() {
        isShowingScreenTimeResetSheet = false
    }
    
    private func startMeshGradientAnimation() {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            withAnimation(.easeInOut(duration: 2.0)) {
                meshGradientModel.colors = MeshGradientGenerator.generateColors(withDarkening: 0.4)
            }
        }
    }
}

#Preview {
    let configuration = ModelConfiguration(
        for: OnboardingVersion.self,
        isStoredInMemoryOnly: true
    )
    
    let container = try! ModelContainer(
        for: OnboardingVersion.self,
        configurations: configuration
    )
    
    let exerciseManager = ExerciseManager()
    
    ContentView()
        .environment(PoseEstimator(exerciseManager: exerciseManager))
        .environment(ScreenTimeBlocker())
        .environment(PermissionsService())
        .environment(MeshGradientModel())
        .environment(exerciseManager)
        .modelContainer(container)
        .preferredColorScheme(.dark)
}
