//
//  ContentView.swift
//  ScreenFit
//
//  Created by Anh Nguyen on 14/3/2025.
//

import FamilyControls
import SwiftUI

struct ContentView: View {
    @State var model = ScreenTimeSelectAppsModel()
    @State var familyActivityPickerIsPresented: Bool = false
    
    var body: some View {
        VStack {
            Button("Select apps") {
                familyActivityPickerIsPresented = true
            }
            .familyActivityPicker(isPresented: $familyActivityPickerIsPresented, selection: $model.activitySelection)
        }
    }
}

#Preview {
    ContentView()
}
