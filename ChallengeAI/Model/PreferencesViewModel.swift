//
//  PreferencesViewModel.swift
//  ChallengeAI
//
//  Created by Ethan Hunt on 11/15/24.
//

import Foundation
import Combine

class PreferencesViewModel: ObservableObject {
    @Published var preferences: UserPreferences = UserPreferences(
        difficulty: "Easy",
        topics: ["General Knowledge"],
        challengeType: "Text",
        frequency: "Daily"
    )

    private let preferencesKey = "UserPreferences"

    init() {
        loadPreferences()
    }

    func savePreferences() {
        if let encoded = try? JSONEncoder().encode(preferences) {
            UserDefaults.standard.set(encoded, forKey: preferencesKey)
        }
    }

    func loadPreferences() {
        if let savedData = UserDefaults.standard.data(forKey: preferencesKey),
           let decoded = try? JSONDecoder().decode(UserPreferences.self, from: savedData) {
            preferences = decoded
        }
    }
}

