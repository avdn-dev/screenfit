//
//  Skeleton.swift
//  ScreenFit
//
//  Created by Anh Nguyen on 15/3/2025.
//

import SwiftUICore

struct Skeleton: Shape {
    var points: [CGPoint]
    var size: CGSize
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        guard !points.isEmpty else {
            return path
        }
        
        path.move(to: points[0])
        
        for point in points {
            path.addLine(to: point)
        }
        
        // Points must be scaled and translated to match camera view since they are normalised when returned from Vision
        return path.applying(CGAffineTransform.identity.scaledBy(x: size.width, y: size.height))
            .applying(CGAffineTransform(scaleX: -1, y: -1).translatedBy(x: -size.width, y: -size.height))
    }
}
