//
//  ExerciseProgressViewStyle.swift
//  ScreenFit
//
//  Created by Anh Nguyen on 16/3/2025.
//

import Foundation
import SwiftUI

struct ExerciseProgressViewStyle: ViewModifier {
    let value: Double
    let maxValue: Double
    let caption: String
    let lineHeight: CGFloat
    let trackColor: Color
    let progressColor: Color
    let symbol: Image
    
    func body(content: Content) -> some View {
        VStack(alignment: .leading) {
            Text(caption)
                .font(.title)
                .bold()
                .monospacedDigit()
            
            content
                .hidden() // Hide the original progress view
                .overlay(
                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            // Background track
                            RoundedRectangle(cornerRadius: lineHeight / 2)
                                .fill(trackColor)
                                .frame(height: lineHeight)
                            
                            // Progress indicator
                            RoundedRectangle(cornerRadius: lineHeight / 2)
                                .fill(progressColor)
                                .frame(width: geometry.size.width * CGFloat(value / maxValue), height: lineHeight)
                            
                            // SF Symbol at current progress position
                            symbol
                                .font(.title)
                                .frame(width: lineHeight * 2.5, height: lineHeight * 2.5)
                                .shadow(radius: 4)
                                .offset(x: geometry.size.width * CGFloat(value / maxValue) - (lineHeight * 1.25))
                                .animation(.easeInOut(duration: 0.3), value: value)
                        }
                    }
                    
                )
        }
    }
}

extension ProgressView {
    func exerciseStyle(
        value: Double,
        maxValue: Double = 1.0,
        caption: String,
        lineHeight: CGFloat = 10,
        trackColor: Color = .gray.opacity(0.3),
        progressColor: Color = .accent,
        symbol: Image
    ) -> some View {
        self.modifier(
            ExerciseProgressViewStyle(
                value: min(max(value, 0), maxValue),
                maxValue: maxValue,
                caption: caption,
                lineHeight: lineHeight,
                trackColor: trackColor,
                progressColor: progressColor,
                symbol: symbol
            )
        )
    }
}
