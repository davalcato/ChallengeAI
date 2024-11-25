//
//  AppState.swift
//  ChallengeAI
//
//  Created by Ethan Hunt on 11/10/24.
//

import SwiftUI
import Combine

// AppState model to manage global state
class AppState: ObservableObject {
    @Published var isLoggedIn: Bool = true

    init(isLoggedIn: Bool) {
        self.isLoggedIn = isLoggedIn
    }
}

// UserPreferencesService: Handles loading and saving preferences
struct UserPreferencesService {
    static func loadUserPreferences() -> UserPreferences {
        // Replace with actual data source (e.g., JSON file, UserDefaults)
        let json = """
        {
            "difficulty": "Medium",
            "topics": ["Math", "Science"],
            "challengeType": "Multiple Choice",
            "frequency": "Weekly"
        }
        """.data(using: .utf8)!

        let decoder = JSONDecoder()
        return (try? decoder.decode(UserPreferences.self, from: json))
            ?? UserPreferences(difficulty: "Easy", topics: ["General Knowledge"], challengeType: "Text", frequency: "Daily")
    }
}

// AppRootView: Main entry point for the app
struct AppRootView: View {
    @StateObject private var appState = AppState(isLoggedIn: false) // Initialize AppState
    @State private var userPreferences: UserPreferences

    init() {
        // Load preferences during initialization
        _userPreferences = State(initialValue: UserPreferencesService.loadUserPreferences())
    }

    var body: some View {
        Group {
            if appState.isLoggedIn {
                MainAppView(
                    userPreferences: $userPreferences,
                    onLogout: {
                        // Log out the user by updating AppState
                        withAnimation {
                            appState.isLoggedIn = false
                        }
                        print("User logged out")
                    }
                )
                .environmentObject(appState) // Pass AppState to MainAppView
            } else {
                LoginView() // Login interface
                    .environmentObject(appState) // Pass AppState to LoginView
            }
        }
        .onAppear {
            print("AppRootView loaded. Current login state: \(appState.isLoggedIn)")
        }
    }
}

#Preview {
    AppRootView()
}





