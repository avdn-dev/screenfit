//
//  ScreenTimeMonitor.swift
//  ScreenFit
//
//  Created by Anh Nguyen on 14/3/2025.
//

import DeviceActivity
import Foundation
import FamilyControls

extension DeviceActivityName {
    static let daily = Self ("daily")
}

@Observable
class ScreenTimeMonitor {
    let dailySchedule = DeviceActivitySchedule(intervalStart: DateComponents(hour: 0, minute: 0), intervalEnd: DateComponents(hour: 23, minute: 59, second: 59), repeats: true)
    let center = DeviceActivityCenter()
    let activity = DeviceActivityName("ScreenTime")
    let eventName = DeviceActivityEvent.Name("Limit")
    let model: ScreenTimeSelectAppsModel
    // Fix to get state from persistent store
    var timeLimit: DateComponents = .init(hour: 23)
    var limitName: String? {
        didSet {
            saveLimitName(limitName)
        }
    }
    
    private let userDefaultsKey = "LimitName"
    
    private func saveLimitName(_ name: String?) {
        guard let name else { return }
        let defaults = UserDefaults(suiteName: "group.CGC-Studio.ScreenFit.shared-data")

        defaults?.set(name, forKey: userDefaultsKey)
    }
    
    private func getSavedLimitName() -> String? {
        let defaults = UserDefaults(suiteName: "group.CGC-Studio.ScreenFit.shared-data")

        return defaults?.string(forKey: userDefaultsKey)
    }
    
    init(model: ScreenTimeSelectAppsModel) {
        self.model = model
        
        limitName = getSavedLimitName()
    }
    
    func startDailyMonitoring() {
        center.stopMonitoring()
        
        let event = DeviceActivityEvent(
            applications: model.activitySelection.applicationTokens,
            categories: model.activitySelection.categoryTokens,
            webDomains: model.activitySelection.webDomainTokens,
            threshold: timeLimit
        )
        do {
            try center.startMonitoring(activity, during: dailySchedule, events: [eventName: event])
        } catch {
            print("Failed to start monitoring: \(error)")
        }
    }
    
    func setTimeLimit(to timeLimit: DateComponents) {
        self.timeLimit = timeLimit
    }
}
