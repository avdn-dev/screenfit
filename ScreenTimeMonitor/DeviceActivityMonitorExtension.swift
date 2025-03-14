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
    }
    
    private func triggerNotification() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                let content = UNMutableNotificationContent()
                content.title = "App locked"
                content.body = "Screen time limit reached. Press or open ScreenFit to unlock app."
                content.sound = UNNotificationSound.default
                
                // Trigger immediately
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.1, repeats: false)
                let request = UNNotificationRequest(identifier: "Notification", content: content, trigger: trigger)
                
                center.add(request) { error in
                    if let error {
                        print("Failed to schedule notification: \(error)")
                    }
                }
            } else {
                print("Failed to schedule notification: notification permissions denied")
            }
        }
    }
}
