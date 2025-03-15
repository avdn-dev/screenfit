//
//  EmptyBlockView.swift
//  ScreenFit
//
//  Created by Anh Nguyen on 15/3/2025.
//

import SwiftUI

struct EmptyBlockView: View {
    var body: some View {
        ContentUnavailableView {
            Label {
                Text("No screen time limits set")
            } icon: {
                Image(.lockIphoneBadgePlus)
            }
        } description: {
            // Insert copy here
            Text("Add a new screen time limit to turn screen time into exercise.")
        } actions: {
            Button("Add new block") {
                
            }
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.roundedRectangle)
        }
    }
}

#Preview {
    EmptyBlockView()
}
