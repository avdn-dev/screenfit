//
//  NavigationStackWithMeshGradientBackground.swift
//  ScreenFit
//
//  Created by Anh Nguyen on 15/3/2025.
//

import SwiftUI

struct NavigationStackWithMeshGradientBackground<Content: View>: View {
    @Environment(MeshGradientModel.self) var meshGradientModel
    
    let navigationTitle: String
    let content: Content
    
    init(navigationTitle: String, @ViewBuilder content: () -> Content) {
        self.navigationTitle = navigationTitle
        self.content = content()
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                MeshGradient(width: 3,
                             height: 3,
                             points: meshGradientModel.points,
                             colors: meshGradientModel.colors)
                .ignoresSafeArea()
                
                content
                .navigationTitle(navigationTitle)
                .toolbarBackground(.regularMaterial, for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
            }
        }
    }
}

#Preview {
    NavigationStackWithMeshGradientBackground(navigationTitle: "Preview") {
        Text("Preview")
    }
    .environment(MeshGradientModel())
    .preferredColorScheme(.dark)
}
