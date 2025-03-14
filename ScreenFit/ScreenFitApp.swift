//
//  ScreenFitApp.swift
//  ScreenFit
//
//  Created by Anh Nguyen on 14/3/2025.
//

import SwiftUI
import FamilyControls

@main
struct ScreenFitApp: App {
    let center = AuthorizationCenter.shared
    let scheduler = DeviceActivityScheduler()
    
    init() {
        do {
            try scheduler.startDailyMonitoring()
        } catch {
            print("Failed to start daily device activity schedule: \(error)")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear(perform: requestFamilyControlsAuthorisation)
        }
    }
    
    private func requestFamilyControlsAuthorisation() {
        Task {
            do {
                try await center.requestAuthorization(for: .individual)
            } catch {
                print("Failed to request Screen Time authorization: \(error)")
            }
        }
    }
}
