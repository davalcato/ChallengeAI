//
//  ProfileView.swift
//  ChallengeAI
//
//  Created by Ethan Hunt on 11/15/24.
//

import SwiftUI

struct ProfileView: View {
    @Binding var userPreferences: UserPreferences

    var body: some View {
        NavigationView {
            VStack {
                Text("Profile Page")
                    .font(.largeTitle)
                    .padding()

                NavigationLink(destination: PreferencesView(userPreferences: $userPreferences)) {
                    Text("Edit Preferences")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding()

                // Display updated preferences for testing purposes
                Text("Selected Difficulty: \(userPreferences.difficulty)")
                Text("Selected Topics: \(userPreferences.topics.joined(separator: ", "))")
                Text("Challenge Type: \(userPreferences.challengeType)")
            }
            .navigationTitle("Profile")
        }
    }
}

#Preview {
    ProfileView(userPreferences: .constant(
        UserPreferences(
            difficulty: "Easy",
            topics: ["General Knowledge"],
            challengeType: "Text",
            frequency: "Daily"
        )
    ))
}

