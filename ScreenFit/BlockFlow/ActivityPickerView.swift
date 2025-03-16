//
//  ActivityPickerView.swift
//  ScreenFit
//
//  Created by Anh Nguyen on 16/3/2025.
//

import SwiftUI
import FamilyControls

struct ActivityPickerView: View {
    var body: some View {
        NavigationStackWithMeshGradientBackground(navigationTitle: "Add limit") {
            Form {
                ActivityEditView()
            }
            .navigationBarTitleDisplayMode(.inline)
            .scrollContentBackground(.hidden)
        }
    }
}

#Preview {
    let model = ScreenTimeSelectAppsModel()
    
    ActivityPickerView()
        .environment(MeshGradientModel())
        .preferredColorScheme(.dark)
}
