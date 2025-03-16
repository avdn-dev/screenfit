//
//  EmptyBlockView.swift
//  ScreenFit
//
//  Created by Anh Nguyen on 15/3/2025.
//

import SwiftUI

struct EmptyBlockView: View {
    var body: some View {
        ZStack {
            ContentUnavailableView {
                Label {
                    Text("No screen time limits set")
                } icon: {
                    Image(.lockIphoneBadgePlus)
                }
            } description: {
                Text("Add a new screen time limit to turn screen time into exercise.")
            }
            
            NavigationLink {
                ActivityPickerView()
            } label: {
                Text("Add limit")
                    .bold()
            }
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.roundedRectangle)
            .controlSize(.extraLarge)
            .offset(y: 100)
        }
    }
}

#Preview {
    EmptyBlockView()
        .preferredColorScheme(.dark)
}
