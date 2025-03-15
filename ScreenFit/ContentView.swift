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
    @Environment(\.modelContext) var modelContext
    @Environment(PoseEstimator.self) var poseEstimator
    @AppStorage("isShowingScreenTimeResetSheet", store: UserDefaults(suiteName: "group.CGC-Studio.ScreenFit.shared-data")) var isShowingScreenTimeResetSheet: Bool = false
    @Query var onboardingVersion: [OnboardingVersion]
    @State private var isShowingOnboarding = false
    @State private var selectedTab: Int = 0
    
    let currentOnboardingVersionNumer = "1.0.0"
    
    var body: some View {
        TabView(selection: $selectedTab) {
            Group {
                BlockView()
                .tag(0)
                .tabItem {
                    Label("Block", systemImage: selectedTab == 0 ? "lock.fill" : "lock")
                }
                StatsView()
                .tag(1)
                .tabItem {
                    Label("Stats", systemImage: selectedTab == 1 ? "chart.bar.fill" : "chart.bar")
                }
            }
            .toolbarBackground(.white, for: .tabBar)
            .toolbarBackground(.visible, for: .tabBar)
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
            poseEstimator.onFinishedExercise = hideScreenTimeResetSheet
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
}

#Preview {
    ContentView()
}
