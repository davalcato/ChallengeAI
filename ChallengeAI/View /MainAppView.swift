//
//  MainAppView.swift
//  ChallengeAI
//
//  Created by Ethan Hunt on 11/15/24.
//

import SwiftUI

struct MainAppView: View {
    @Binding var userPreferences: UserPreferences

    var body: some View {
        NavigationView {
            VStack {
                Text("Welcome to the Main App!")
                    .font(.largeTitle)
                    .padding()

                // Example of showing preferences-based content
                if !userPreferences.topics.isEmpty {
                    Text("Your favorite topics:")
                        .font(.headline)
                    ForEach(userPreferences.topics, id: \.self) { topic in
                        Text("• \(topic)")
                    }
                } else {
                    Text("No topics selected.")
                        .foregroundColor(.gray)
                }

                Spacer()

                // Example of navigation or action buttons
                NavigationLink("View Challenges", destination: ChallengesView(userPreferences: userPreferences))
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding()
            .navigationTitle("Main App")
        }
    }
}

#Preview {
    MainAppView(userPreferences: .constant(UserPreferences(difficulty: "Easy", topics: ["Math", "Science"], challengeType: "Text", frequency: "Daily")))
}

