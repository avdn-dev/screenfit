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
    @State var model = ScreenTimeSelectAppsModel()
    @State var familyActivityPickerIsPresented: Bool = false
    @AppStorage("isShowingScreenTimeResetSheet", store: UserDefaults(suiteName: "group.CGC-Studio.ScreenFit.shared-data")) var isShowingScreenTimeResetSheet: Bool = false
    @State var poseEstimator = PoseEstimator()
    
    let store = ManagedSettingsStore()
    let screenTimeMonitor = ScreenTimeMonitor()
    
    init() {
        poseEstimator.resetScreenTime = resetScreenTimeLimit
    }
    
    var body: some View {
        
        VStack {
            Button("Select apps") {
                familyActivityPickerIsPresented = true
            }
            .familyActivityPicker(isPresented: $familyActivityPickerIsPresented, selection: $model.activitySelection)
            Button("Start monitoring") {
                do {
                    try screenTimeMonitor.startDailyMonitoring(of: model.activitySelection, timeLimit: DateComponents(second: 2))
                } catch {
                    print("Failed to start daily device activity monitoring: \(error)")
                }
            }
            Button("Stop monitoring", action: screenTimeMonitor.stopDailyMonitoring)
            Button("Reset screen time limit") {
                isShowingScreenTimeResetSheet = true
            }
            Button("Reset screen time limit easy") {
                resetScreenTimeLimit()
            }
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
