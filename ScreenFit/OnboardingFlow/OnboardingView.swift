//
//  OnboardingView.swift
//  ScreenFit
//
//  Created by Anh Nguyen on 15/3/2025.
//

import SwiftUI

struct OnboardingView: View {
    let item: OnboardingItem
    let onboardingButtonPressed: () -> Void
    
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            item.image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxHeight: 400)
            
            Text(item.title)
                .bold()
                .font(.largeTitle)
                .padding(.vertical)
            
            Text(item.body)
                .padding(.horizontal, 20)
                .frame(maxWidth: 400)
                .multilineTextAlignment(.center)
            
            Spacer()
            
            Button(item.buttonLabel, action: onboardingButtonPressed)
                .buttonStyle(.borderedProminent)
                .padding(.vertical)
                .controlSize(.extraLarge)
                .font(.headline)
                .buttonBorderShape(.roundedRectangle)
                .offset(y: -100)
        }
    }
}
