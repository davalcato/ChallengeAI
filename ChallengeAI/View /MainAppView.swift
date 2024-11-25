//
//  MainAppView.swift
//  ChallengeAI
//
//  Created by Ethan Hunt on 11/15/24.
//

import SwiftUI

struct MainAppView: View {
    @Binding var userPreferences: UserPreferences
    var onLogout: () -> Void // Logout callback

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

                // Logout button
                Button(action: {
                    onLogout() // Call the logout closure
                    print("Logout button pressed")
                }) {
                    Text("Logout")
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding()
            }
            .padding()
            .navigationTitle("Main App")
        }
        .onAppear {
            print("MainAppView loaded")
        }
    }
}

#Preview {
    MainAppView(
        userPreferences: .constant(UserPreferences(
            difficulty: "Easy",
            topics: ["Math", "Science"],
            challengeType: "Text",
            frequency: "Daily"
        )),
        onLogout: {}
    )
}




