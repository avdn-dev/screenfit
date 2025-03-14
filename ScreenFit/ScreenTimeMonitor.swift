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

struct ScreenTimeMonitor {
    let dailySchedule = DeviceActivitySchedule(intervalStart: DateComponents(hour: 0, minute: 0), intervalEnd: DateComponents(hour: 23, minute: 59, second: 59), repeats: true)
    let center = DeviceActivityCenter()
    let activity = DeviceActivityName("ScreenTime")
    let eventName = DeviceActivityEvent.Name("Limit")
    
    func stopDailyMonitoring() {
        center.stopMonitoring()
    }
    
    func startDailyMonitoring(of selection: FamilyActivitySelection, timeLimit: DateComponents) throws {
        let event = DeviceActivityEvent(
            applications: selection.applicationTokens,
            categories: selection.categoryTokens,
            webDomains: selection.webDomainTokens,
            threshold: timeLimit
        )
        try center.startMonitoring(activity, during: dailySchedule, events: [eventName: event])
    }
}
