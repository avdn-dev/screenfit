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
    let store = ManagedSettingsStore()
    let screenTimeMonitor = ScreenTimeMonitor()
    
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
                store.shield.applications = nil
            }
        }
        
    }
}

#Preview {
    ContentView()
}
