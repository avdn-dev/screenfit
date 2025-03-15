//
//  OnboardingVersion.swift
//  ScreenFit
//
//  Created by Anh Nguyen on 15/3/2025.
//

import SwiftData

@Model
class OnboardingVersion {
    @Attribute(.unique) var id: String
    var versionNumber: String
    
    init(id: String = "OnboardingVersion", versionNumber: String) {
        self.id = id
        self.versionNumber = versionNumber
    }
}
