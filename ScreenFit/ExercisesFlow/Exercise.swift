//
//  Exercise.swift
//  ScreenFit
//
//  Created by Anh Nguyen on 15/3/2025.
//

import SwiftUI

enum Exercise: String, CaseIterable {
    case squat = "Squats"
    case pushup = "Pushups"
    case lunge = "Lunges"
    case jumpingJack = "Jumping Jacks"
    case pullup = "Pullups"
    case crunch = "Crunches"
    case walking = "Steps"
    
    var image: Image {
        switch self {
        case .squat: Image(.figureSquat)
        case .pushup: Image(.figurePushup)
        case .lunge: Image(systemName: "figure.strengthtraining.functional")
        case .jumpingJack: Image(systemName: "figure.mixed.cardio")
        case .pullup: Image(.figurePullup)
        case .crunch: Image(.figureCrunch)
        case .walking: Image(systemName: "figure.walk")
        }
    }
}
