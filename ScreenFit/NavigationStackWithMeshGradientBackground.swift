//
//  NavigationStackWithMeshGradientBackground.swift
//  ScreenFit
//
//  Created by Anh Nguyen on 15/3/2025.
//

import SwiftUI

struct NavigationStackWithMeshGradientBackground<Content: View>: View {
    @State var colors = MeshGradientGenerator.generateColors(withDarkening: 0.2)
    let points: [SIMD2<Float>] = MeshGradientGenerator.generatePoints()
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
                             points: points,
                             colors: colors)
                .ignoresSafeArea()
                .overlay(Color.black.opacity(0.3))
                .onAppear(perform: startMeshGradientAnimation)
                
                content
                .navigationTitle(navigationTitle)
                .toolbarTitleDisplayMode(.inlineLarge)
                .toolbarBackground(.regularMaterial, for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
            }
        }
    }
    
    private func startMeshGradientAnimation() {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            withAnimation(.easeInOut(duration: 2.0)) {
                colors = MeshGradientGenerator.generateColors(withDarkening: 0.2)
            }
        }
    }
}

#Preview {
    NavigationStackWithMeshGradientBackground(navigationTitle: "Preview") {
        Text("Preview")
    }
    .preferredColorScheme(.dark)
}
