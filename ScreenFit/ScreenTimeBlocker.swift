//
//  ScreenTimeBlocker.swift
//  ScreenFit
//
//  Created by Anh Nguyen on 15/3/2025.
//

import Foundation
import ManagedSettings

@Observable
class ScreenTimeBlocker {
    let store = ManagedSettingsStore()
    
    func resetScreenTimeLimit() {
        store.shield.applications = nil
        store.shield.webDomains = nil
        store.shield.applicationCategories = nil
        store.shield.webDomainCategories = nil
    }
}
