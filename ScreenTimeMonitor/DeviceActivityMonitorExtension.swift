//
//  DeviceActivityMonitorExtension.swift
//  ScreenTimeMonitor
//
//  Created by Anh Nguyen on 14/3/2025.
//

import DeviceActivity
import ManagedSettings
import UserNotifications

// Optionally override any of the functions below.
// Make sure that your class name matches the NSExtensionPrincipalClass in your Info.plist.
class DeviceActivityMonitorExtension: DeviceActivityMonitor {
    let store = ManagedSettingsStore()
    
    override func eventDidReachThreshold(_ event: DeviceActivityEvent.Name, activity: DeviceActivityName) {
        super.eventDidReachThreshold(event, activity: activity)
        
        let model = ScreenTimeSelectAppsModel()
        let applications = model.activitySelection.applicationTokens
        let webDomains = model.activitySelection.webDomainTokens
        let categories = model.activitySelection.categoryTokens
        
        store.shield.applications = applications.isEmpty ? nil : applications
        store.shield.webDomains = webDomains.isEmpty ? nil : webDomains
        store.shield.applicationCategories = categories.isEmpty ? nil : .specific(categories)
        store.shield.webDomainCategories = categories.isEmpty ? nil : .specific(categories)
        
        triggerNotification()
        UserDefaults(suiteName: "group.CGC-Studio.ScreenFit.shared-data")?.set(true, forKey: "isShowingScreenTimeResetSheet")
    }
    
    private func triggerNotification() {
        let content = UNMutableNotificationContent()
        content.title = "App locked"
        content.body = "Screen time limit reached. Press or open ScreenFit to unlock app."
        content.sound = UNNotificationSound.default
        
        // Trigger with small delay
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: "Notification", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error {
                print("Failed to schedule notification: \(error)")
            }
        }
    }
}
