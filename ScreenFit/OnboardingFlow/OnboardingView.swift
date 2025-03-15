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
        GeometryReader { geometry in
            ZStack {
                LinearGradient(
                    stops: [
                        Gradient.Stop(color: .pink, location: 0.00),
                        Gradient.Stop(color: .purple, location: 1.00),
                    ],
                    startPoint: UnitPoint(x: 0.5, y: 0),
                    endPoint: UnitPoint(x: 0.5, y: 1)
                )
                .frame(maxHeight: geometry.size.height / 2)
                .offset(y: -geometry.size.height / 4)
                
                VStack(alignment: .center, spacing: 20) {
                    Image(decorative: item.image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxHeight: 400)
                        .padding(.top, 80)
                    
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
        .ignoresSafeArea()
    }
}
