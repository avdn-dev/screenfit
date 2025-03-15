//
//  PermissionsService.swift
//  ScreenFit
//
//  Created by Anh Nguyen on 15/3/2025.
//

import FamilyControls
import Foundation
import UIKit

@Observable
class PermissionsService {
    let familyControlsCenter = AuthorizationCenter.shared
    let notificationsCenter = UNUserNotificationCenter.current()
    
    func requestScreenTimePermission(openedSettingsCompletionHandler: @Sendable @escaping (Bool) -> Void = { _ in }) {
        switch familyControlsCenter.authorizationStatus {
        case .notDetermined:
            Task {
                do {
                    try await familyControlsCenter.requestAuthorization(for: .individual)
                } catch {
                    print("Failed to request Screen Time authorisation: \(error)")
                }
            }
        case .denied:
            Task {
                // Open app settings to enable permissions
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    if await UIApplication.shared.canOpenURL(url) {
                        await UIApplication.shared.open(url, options: [:], completionHandler: openedSettingsCompletionHandler)
                    }
                }
            }
        case .approved:
            print("Screen Time authorisation granted.")
        @unknown default: break
        }
    }
    
    func requestNotificationPermission(openedSettingsCompletionHandler: @Sendable @escaping (Bool) -> Void = { _ in }) {
        Task {
            do {
                if try await notificationsCenter.requestAuthorization(options: [.alert, .sound, .badge]) == true {
                    print("Notification authorisation granted.")
                } else {
                    // Open app settings to enable permissions
                    if let url = URL(string: UIApplication.openSettingsURLString) {
                        if await UIApplication.shared.canOpenURL(url) {
                            await UIApplication.shared.open(url, options: [:], completionHandler: openedSettingsCompletionHandler)
                        }
                    }
                }
            } catch {
                // Handle any errors.
                print("Notification authorisation denied: \(error)")
            }
        }
    }
}
