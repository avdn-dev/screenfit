//
//  OnboardingOverlay.swift
//  ScreenFit
//
//  Created by Anh Nguyen on 15/3/2025.
//

import SwiftUI

struct OnboardingOverlay: View {
    @Environment(PermissionsService.self) var permissionsService
    
    @State private var selectedView = UserDefaults.standard.integer(forKey: "selectedOnboardingView")
    @State private var lastOnboardingScreen = 3
    @State private var openedSettings = false
    let points: [SIMD2<Float>] = MeshGradientGenerator.generatePoints()
    @State var colors = MeshGradientGenerator.generateColors()
    
    let dismissOnboardingView: () -> Void
    @State var timer: Timer?
    
    init(dismissOnboardingView: @escaping () -> Void) {
        self.dismissOnboardingView = dismissOnboardingView
        UIPageControl.appearance().currentPageIndicatorTintColor = .systemPurple
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                MeshGradient(width: 3,
                             height: 3,
                             points: points,
                             colors: colors)
                .ignoresSafeArea()
                .frame(maxHeight: geometry.size.height / 2)
                .offset(y: -geometry.size.height / 4)
                
                TabView(selection: $selectedView) {
                    OnboardingView(item: OnboardingItem(tag: 0, image: "", title: "ScreenFit", body: "ScreenFit allows you to set screen time limits, and forces you to exercise to unblock apps that have reached their limits.", buttonLabel: "Get started"), onboardingButtonPressed: { withAnimation { selectedView += 1} }).tag(0)
                    
                    OnboardingView(item: OnboardingItem(tag: 1, image: "", title: "Screen Time", body: "ScreenFit requires the Screen Time API to set and monitor screen time limits.", buttonLabel: "Grant permissions"), onboardingButtonPressed: requestScreenTimePermission).tag(1)
                    
                    OnboardingView(item: OnboardingItem(tag: 2, image: "", title: "Notifications", body: "ScreenFit uses a notification for quick access unblocking an app that has reached its screen time limit.", buttonLabel: "Grant permissions"), onboardingButtonPressed: requestNotificationPermission).tag(2)
                    
                    OnboardingView(item: OnboardingItem(tag: 3, image: "", title: "Ready to Go!", body: "ScreenFit has defaults for screen time limits and exercise tracking that you can configure further if you'd like.", buttonLabel: "Begin"), onboardingButtonPressed: dismissOnboarding).tag(3)
                }
            }
        }
        .tabViewStyle(.page)
        .indexViewStyle(.page(backgroundDisplayMode: .always))
        .onChange(of: selectedView) { _, newValue in
            if openedSettings {
                UserDefaults.standard.set(newValue, forKey: "selectedOnboardingView")
                openedSettings = false
            }
        }
        .background()
        .onAppear(perform: startMeshGradientAnimation)
    }
    
    private func startMeshGradientAnimation() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            withAnimation(.easeInOut(duration: 2.0)) {
                colors = MeshGradientGenerator.generateColors()
            }
        }
    }
    
    func requestScreenTimePermission() {
        permissionsService.requestScreenTimePermission() { openedSettingsSuccessfully in
            openedSettings = true
        }
        
        withAnimation { selectedView += 1 }
    }
    
    func requestNotificationPermission() {
        permissionsService.requestNotificationPermission { openedSettingsSuccessfully in
            openedSettings = true
        }
        
        withAnimation { selectedView += 1 }
    }
    
    func dismissOnboarding() {
        timer?.invalidate()
        dismissOnboardingView()
        
        // Reset selectedView for the next time onboarding screen is opened after slight delay to hide change
        Task {
            try? await Task.sleep(nanoseconds: 500_000_000)
            UserDefaults.standard.set(0, forKey: "selectedOnboardingView")
        }
    }
}

#Preview {
    OnboardingOverlay(dismissOnboardingView: {})
        .environment(PermissionsService())
        .preferredColorScheme(.dark)
}
