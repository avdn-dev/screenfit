//
//  OnboardingItem.swift
//  ScreenFit
//
//  Created by Anh Nguyen on 15/3/2025.
//

import Foundation

struct OnboardingItem: Identifiable {
    let id = UUID()
    let tag: Int
    let image: String
    let title: String
    let body: String
    let buttonLabel: String
}

