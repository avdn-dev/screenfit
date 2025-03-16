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

// TODO: Handle state much better...
@Observable
class ScreenTimeMonitor {
    let dailySchedule = DeviceActivitySchedule(intervalStart: DateComponents(hour: 0, minute: 0), intervalEnd: DateComponents(hour: 23, minute: 59, second: 59), repeats: true)
    let center = DeviceActivityCenter()
    let activity = DeviceActivityName("ScreenTime")
    let eventName = DeviceActivityEvent.Name("Limit")
    let model: ScreenTimeSelectAppsModel
    var timeLimit: DateComponents = .init(second: 1) {
        didSet {
            saveTimeLimit(timeLimit)
        }
    }
    var limitName: String? {
        didSet {
            saveLimitName(limitName)
        }
    }
    
    private let userDefaultsNameKey = "LimitName"
    private let userDefaultsTimeHourKey = "TimeLimitHour"
    private let userDefaultsTimeMinuteKey = "TimeLimitMinute"
    private let userDefaultsTimeSecondKey = "TimeLimitSecond"
    
    init(model: ScreenTimeSelectAppsModel) {
        self.model = model
        
        limitName = getSavedLimitName()
        timeLimit = getSavedTimeLimit()
    }
    
    private func saveLimitName(_ name: String?) {
        guard let name else { return }
        let defaults = UserDefaults(suiteName: "group.CGC-Studio.ScreenFit.shared-data")

        defaults?.set(name, forKey: userDefaultsNameKey)
    }
    
    private func getSavedLimitName() -> String? {
        let defaults = UserDefaults(suiteName: "group.CGC-Studio.ScreenFit.shared-data")

        return defaults?.string(forKey: userDefaultsNameKey)
    }
    
    private func saveTimeLimit(_ timeLimit: DateComponents) {
        let defaults = UserDefaults(suiteName: "group.CGC-Studio.ScreenFit.shared-data")

        defaults?.set(timeLimit.hour ?? 0, forKey: userDefaultsTimeHourKey)
        defaults?.set(timeLimit.minute ?? 0, forKey: userDefaultsTimeMinuteKey)
        defaults?.set(timeLimit.second ?? 0, forKey: userDefaultsTimeSecondKey)
    }
    
    private func getSavedTimeLimit() -> DateComponents {
        let defaults = UserDefaults(suiteName: "group.CGC-Studio.ScreenFit.shared-data")
        
        return DateComponents(
            hour: defaults?.integer(forKey: userDefaultsTimeHourKey),
            minute: defaults?.integer(forKey: userDefaultsTimeMinuteKey),
            second: defaults?.integer(forKey: userDefaultsTimeSecondKey)
        )
    }
    
    func startDailyMonitoring() {
        guard let limitName else {
            return
        }
        
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
