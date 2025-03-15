//
//  MeshGradientModel.swift
//  ScreenFit
//
//  Created by Anh Nguyen on 16/3/2025.
//

import Foundation

@Observable
public class MeshGradientModel {
    var colors = MeshGradientGenerator.generateColors()
    let points: [SIMD2<Float>] = MeshGradientGenerator.generatePoints()
}
