//
//  ChallengesView.swift
//  ChallengeAI
//
//  Created by Ethan Hunt on 11/15/24.
//

import SwiftUI

struct ChallengesView: View {
    let userPreferences: UserPreferences
    @State private var challenge: Challenge? = nil

    var body: some View {
        VStack {
            if let challenge = challenge {
                Text(challenge.question) // Or challenge.description if added
                    .padding()
                
                if let options = challenge.options {
                    ForEach(options, id: \.self) { option in
                        Button(option) {
                            print("Selected: \(option)")
                        }
                        .padding()
                    }
                }
            } else {
                Text("Loading challenge...")
                    .padding()
                    .onAppear {
                        generateChallenge(preferences: userPreferences) { newChallenge in
                            self.challenge = newChallenge
                        }
                    }
            }
        }
    }
}

#Preview {
    ChallengesView(userPreferences: UserPreferences(
        difficulty: "Medium",
        topics: ["Math", "Science"],
        challengeType: "Multiple Choice", frequency: "Daily"
    ))
}

