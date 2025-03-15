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
    @State var isShowingScreenTimeResetSheet: Bool = false
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
            VStack {
                ZStack {
                    GeometryReader { geo in
                        CameraViewWrapper(poseEstimator: poseEstimator)
                        SkeletonView(poseEstimator: poseEstimator, size: geo.size)
                    }
                }.frame(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.width * 1920 / 1080, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                HStack {
                    Text("Squat counter:")
                        .font(.title)
                    Text(String(poseEstimator.squatCount))
                        .font(.title)
                }
            }
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
