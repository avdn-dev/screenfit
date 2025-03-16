//
//  BlockView.swift
//  ScreenFit
//
//  Created by Anh Nguyen on 15/3/2025.
//

import SwiftUI
import FamilyControls

struct BlockView: View {
    @Environment(ScreenTimeSelectAppsModel.self) var model
    @Environment(ScreenTimeMonitor.self) var monitor
    @AppStorage("isShowingScreenTimeResetSheet", store: UserDefaults(suiteName: "group.CGC-Studio.ScreenFit.shared-data")) var isShowingScreenTimeResetSheet: Bool = false
    @AppStorage("isScreentimeBlocked", store: UserDefaults(suiteName: "group.CGC-Studio.ScreenFit.shared-data")) var isScreentimeBlocked: Bool = false
    
    @State private var timeLimitHours = 12
    @State private var timeLimitMinutes = 30
    @State private var timeLimitSeconds = 30
    
    var body: some View {
        NavigationStackWithMeshGradientBackground(navigationTitle: "Limit") {
            if monitor.limitName == nil {
                EmptyBlockView()
            } else {
                List {
                    Section("Limits") {
                        NavigationLink {
                            ActivityDetailsView()
                        } label: {
                            Text(monitor.limitName!)
                                .bold()
                        }
                    }
                    HStack {
                        Spacer()
                        
                        Button("Unblock apps") {
                            isShowingScreenTimeResetSheet = true
                        }
                        .buttonStyle(.borderedProminent)
                        .buttonBorderShape(.roundedRectangle)
                        .controlSize(.extraLarge)
                        .disabled(isScreentimeBlocked)
                        
                        Spacer()
                    }
                    .listRowBackground(Color.clear)
                    .opacity(isScreentimeBlocked ? 1 : 0)
                }
                .headerProminence(.increased)
                .scrollContentBackground(.hidden)
            }
        }
    }
}

#Preview {
    let model = ScreenTimeSelectAppsModel()
    
    BlockView()
        .environment(model)
        .environment(ScreenTimeMonitor(model: model))
        .environment(MeshGradientModel())
        .preferredColorScheme(.dark)
}
