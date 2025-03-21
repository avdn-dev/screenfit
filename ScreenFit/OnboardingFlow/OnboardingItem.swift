//
//  OnboardingItem.swift
//  ScreenFit
//
//  Created by Anh Nguyen on 15/3/2025.
//

import Foundation
import SwiftUI

struct OnboardingItem: Identifiable {
    let id = UUID()
    let tag: Int
    let image: Image
    let title: String
    let body: String
    let buttonLabel: String
}

