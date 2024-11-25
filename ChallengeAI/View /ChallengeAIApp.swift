//
//  ChallengeAIApp.swift
//  ChallengeAI
//
//  Created by Ethan Hunt on 10/1/24.
//

import SwiftUI

@available(iOS 14.0, *)
@main
struct ChallengeAIApp: App {
    @StateObject private var appState = AppState(isLoggedIn: UserDefaults.standard.bool(forKey: "isLoggedIn"))

    var body: some Scene {
        WindowGroup {
            if appState.isLoggedIn {
                WelcomeView()
                    .environmentObject(appState)
            } else {
                OnboardingView()
                    .environmentObject(appState)
            }
        }
    }
}

