//
//  ScreenTimeSelectedAppsModel.swift
//  ScreenFit
//
//  Created by Anh Nguyen on 14/3/2025.
//

import FamilyControls
import Foundation

@Observable
class ScreenTimeSelectAppsModel {
    private let encoder = PropertyListEncoder()
    private let decoder = PropertyListDecoder()
    private let userDefaultsKey = "ScreenTimeSelection"
    
    var activitySelection: FamilyActivitySelection {
        didSet {
            saveSelection(activitySelection)
        }
    }
    
    init() {
        activitySelection = FamilyActivitySelection()
        if let savedSelection = getSavedSelection() {
            activitySelection = savedSelection
        }
    }
    
    private func saveSelection(_ selection: FamilyActivitySelection) {
        let defaults = UserDefaults(suiteName: "group.CGC-Studio.ScreenFit.shared-data")

        defaults?.set(
            try? encoder.encode(selection),
            forKey: userDefaultsKey
        )
    }
    
    private func getSavedSelection() -> FamilyActivitySelection? {
        let defaults = UserDefaults(suiteName: "group.CGC-Studio.ScreenFit.shared-data")

        guard let data = defaults?.data(forKey: userDefaultsKey) else {
            return nil
        }
        
        return try? decoder.decode(
            FamilyActivitySelection.self, from:
            data
        )
    }
}
