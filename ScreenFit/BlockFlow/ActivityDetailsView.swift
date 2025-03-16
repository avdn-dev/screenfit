//
//  ActivityDetailsView.swift
//  ScreenFit
//
//  Created by Anh Nguyen on 16/3/2025.
//

import SwiftUI

struct ActivityDetailsView: View {
    @Environment(ScreenTimeMonitor.self) var monitor
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStackWithMeshGradientBackground(navigationTitle: monitor.limitName ?? "") {
            Form {
                ActivityEditView()
            }
            .navigationBarTitleDisplayMode(.inline)
            .scrollContentBackground(.hidden)
            .toolbar {
                ToolbarItem(placement: .destructiveAction) {
                    Button {
                        dismiss()
                        monitor.limitName = nil
                        monitor.startDailyMonitoring()
                    } label: {
                        Image(systemName: "trash")
                    }
                }
            }
        }
    }
}

#Preview {
    ActivityDetailsView()
        .environment(ScreenTimeMonitor(model: ScreenTimeSelectAppsModel()))
        .preferredColorScheme(.dark)
}
