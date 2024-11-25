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
    @StateObject private var appState = AppState(isLoggedIn: UserDefaults.standard.bool(forKey: "isLoggedIn")) // Sync with UserDefaults
    @State private var userPreferences: UserPreferences

    init() {
        _userPreferences = State(initialValue: UserPreferencesService.loadUserPreferences())
    }

    var body: some View {
        Group {
            if appState.isLoggedIn {
                MainAppView(
                    userPreferences: $userPreferences,
                    onLogout: {
                        // Log out the user by updating AppState and UserDefaults
                        withAnimation {
                            appState.isLoggedIn = false
                        }
                        UserDefaults.standard.set(false, forKey: "isLoggedIn") // Sync logout state
                        print("User logged out")
                    }
                )
                .environmentObject(appState)
            } else {
                LoginView() // Login interface
                    .environmentObject(appState)
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





