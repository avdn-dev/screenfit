//
//  CGPoint+Distance.swift
//  ScreenFit
//
//  Created by Anh Nguyen on 15/3/2025.
//

import UIKit

extension CGPoint {
    func distance(to point: CGPoint) -> CGFloat {
        return sqrt(pow(x - point.x, 2) + pow(y - point.y, 2))
    }
}
