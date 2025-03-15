//
//  BlockView.swift
//  ScreenFit
//
//  Created by Anh Nguyen on 15/3/2025.
//

import SwiftUI

struct BlockView: View {
    @Environment(ScreenTimeBlocker.self) var screenTimeBlocker
    
    @State var model = ScreenTimeSelectAppsModel()
    @State var familyActivityPickerIsPresented: Bool = false
    @AppStorage("isShowingScreenTimeResetSheet", store: UserDefaults(suiteName: "group.CGC-Studio.ScreenFit.shared-data")) var isShowingScreenTimeResetSheet: Bool = false
    
    let screenTimeMonitor = ScreenTimeMonitor()
    
    var body: some View {
        NavigationStackWithMeshGradientBackground(navigationTitle: "Block") {
            VStack {
                EmptyBlockView()
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
            }
        }
    }
}

#Preview {
    BlockView()
        .environment(ScreenTimeBlocker())
        .preferredColorScheme(.dark)
}
