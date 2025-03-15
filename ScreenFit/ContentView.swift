//
//  ContentView.swift
//  ScreenFit
//
//  Created by Anh Nguyen on 14/3/2025.
//

import FamilyControls
import SwiftUI
import ManagedSettings

struct ContentView: View {
    @AppStorage("isShowingScreenTimeResetSheet", store: UserDefaults(suiteName: "group.CGC-Studio.ScreenFit.shared-data")) var isShowingScreenTimeResetSheet: Bool = false
    @State var poseEstimator = PoseEstimator()
    @State private var selectedTab: Int = 0
    
    let store = ManagedSettingsStore()
    
    init() {
        poseEstimator.resetScreenTime = resetScreenTimeLimit
    }
    
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
                .environment(poseEstimator)
        }
    }
    
    private func resetScreenTimeLimit() {
        store.shield.applications = nil
        store.shield.webDomains = nil
        store.shield.applicationCategories = nil
        store.shield.webDomainCategories = nil
        isShowingScreenTimeResetSheet = false
    }
}

#Preview {
    ContentView()
}
