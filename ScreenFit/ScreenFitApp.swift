//
//  ScreenFitApp.swift
//  ScreenFit
//
//  Created by Anh Nguyen on 14/3/2025.
//

import SwiftUI
import FamilyControls

@main
struct ScreenFitApp: App {
    @State var permissionsService = PermissionsService()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(permissionsService)
        }
    }
}
