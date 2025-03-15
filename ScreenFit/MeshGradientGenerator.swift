//
//  MeshGradientGenerator.swift
//  ScreenFit
//
//  Created by Anh Nguyen on 15/3/2025.
//

import SwiftUI

struct MeshGradientGenerator {
    static func generatePoints() -> [SIMD2<Float>] {
        var points = [SIMD2<Float>]()
    
        // 0th index: Top-left
        points.append([0.0, 0.0])
        
        // 1st index: Top-middle
        points.append([Float.random(in: 0.3...0.7), 0.0])
        
        // 2nd index: Top-right
        points.append([1.0, 0.0])
        
        // 3rd index: Middle-left
        points.append([0.0, Float.random(in: 0.3...0.7)])
        
        // 4th index: Middle
        points.append([Float.random(in: 0.2...0.8), Float.random(in: 0.2...0.8)])
        
        // 5th index: Middle-right
        points.append([1.0, Float.random(in: 0.3...0.7)])
        
        // 6th index: Bottom-left
        points.append([0.0, 1.0])
        
        // 7th index: Bottom-middle
        points.append([Float.random(in: 0.3...0.7), 1.0])
        
        // 8th index: Bottom-right
        points.append([1.0, 1.0])
        
        return points
    }
    
    static func generateColors(withDarkening darkeningFactor: Double = 0) -> [Color] {
        // Distribute the three colors across the 9 points with 3 points for each
        var colors: [Color] = []
        
        for _ in 0..<3 {
            colors.append(.purple.mix(with: .black, by: darkeningFactor))
        }
        
        for _ in 0..<3 {
            colors.append(.pink.mix(with: .black, by: darkeningFactor))
        }
        
        for _ in 0..<3 {
            colors.append(.orange.mix(with: .black, by: darkeningFactor))
        }
        
        return colors.shuffled()
    }
}
