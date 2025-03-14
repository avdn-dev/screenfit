//
//  DeviceActivityMonitorExtension.swift
//  ScreenTimeMonitor
//
//  Created by Anh Nguyen on 14/3/2025.
//

import DeviceActivity
import ManagedSettings

// Optionally override any of the functions below.
// Make sure that your class name matches the NSExtensionPrincipalClass in your Info.plist.
class DeviceActivityMonitorExtension: DeviceActivityMonitor {
    let store = ManagedSettingsStore()
    
    override func eventDidReachThreshold(_ event: DeviceActivityEvent.Name, activity: DeviceActivityName) {
        super.eventDidReachThreshold(event, activity: activity)
        
        let model = ScreenTimeSelectAppsModel()
        let applications = model.activitySelection.applicationTokens
        
        store.shield.applications = applications.isEmpty ? nil : applications
    }
}
