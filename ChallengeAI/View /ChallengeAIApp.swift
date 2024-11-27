//
//  ChallengeAIApp.swift
//  ChallengeAI
//
//  Created by Ethan Hunt on 10/1/24.
//

import SwiftUI
import Firebase

@available(iOS 14.0, *)
@main
struct ChallengeAIApp: App {
    @StateObject private var appState = AppState(isLoggedIn: UserDefaults.standard.bool(forKey: "isLoggedIn"))

    init() {
        // Initialize Firebase when the app starts
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            if appState.isLoggedIn {
                WelcomeView() // Navigate to WelcomeView after login
                    .environmentObject(appState)
            } else {
                OnboardingView() // Show LoginView for unauthenticated users
                    .environmentObject(appState)
            }
        }
    }
}
