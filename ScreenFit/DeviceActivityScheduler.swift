//
//  DeviceActivityScheduler.swift
//  ScreenFit
//
//  Created by Anh Nguyen on 14/3/2025.
//

import DeviceActivity
import Foundation

extension DeviceActivityName {
    static let daily = Self ("daily")
}

struct DeviceActivityScheduler {
    let dailySchedule = DeviceActivitySchedule(intervalStart: DateComponents(hour: 0, minute: 0), intervalEnd: DateComponents(hour: 23, minute: 59, second: 59), repeats: true)
    let center = DeviceActivityCenter()
    
    func startDailyMonitoring() throws {
        try center.startMonitoring(.daily, during: dailySchedule)
    }
}
