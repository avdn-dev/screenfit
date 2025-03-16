//
//  BlockView.swift
//  ScreenFit
//
//  Created by Anh Nguyen on 15/3/2025.
//

import SwiftUI

struct BlockView: View {
    @Environment(ScreenTimeMonitor.self) var monitor
    @AppStorage("isShowingScreenTimeResetSheet", store: UserDefaults(suiteName: "group.CGC-Studio.ScreenFit.shared-data")) var isShowingScreenTimeResetSheet: Bool = false
    
    var body: some View {
        NavigationStackWithMeshGradientBackground(navigationTitle: "Limit") {
            VStack {
                if monitor.limitName == nil {
                    EmptyBlockView()
                } else {
                    Button("Reset screen time limit") {
                        isShowingScreenTimeResetSheet = true
                    }
                }
            }
        }
    }
}

#Preview {
    BlockView()
        .environment(MeshGradientModel())
        .preferredColorScheme(.dark)
}
