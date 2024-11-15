//
//  DashboardView.swift
//  ChallengeAI
//
//  Created by Ethan Hunt on 11/11/24.
//

import SwiftUI

struct DashboardView: View {
    @State private var challenges: [String] = [] // Store AI-generated challenges
    @State private var showChallengeDetails = false
    @State private var userPreferences = ["Fitness", "Mental Health", "Creativity"] // Example preferences
    
    var body: some View {
        VStack {
            Text("AI Tasks and Challenges")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()

            // Display the generated challenges from AI
            List {
                Section(header: Text("Personalized Challenges")) {
                    ForEach(challenges, id: \.self) { challenge in
                        Text(challenge)
                    }
                }

                // Example AI tasks
                Section(header: Text("AI Tasks")) {
                    Text("Task 1: AI Text Analysis")
                    Text("Task 2: Image Recognition Challenge")
                }
            }
            .listStyle(GroupedListStyle())
            .frame(height: 300)

            Spacer()

            // Button to refresh challenges
            Button(action: {
                fetchPersonalizedChallenges()
            }) {
                Text("Get New Challenges")
                    .font(.title2)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.horizontal, 50)

            Spacer()
        }
        .padding()
        .onAppear {
            // Fetch challenges when the view first loads
            fetchPersonalizedChallenges()
        }
    }

    // Fetch AI-generated personalized challenges
    func fetchPersonalizedChallenges() {
        // Call your AI service here. For now, simulate AI response.
        let simulatedAIResponse = generateChallengesBasedOnPreferences(userPreferences)
        
        // Update the challenges state
        self.challenges = simulatedAIResponse
    }

    // Mock function to simulate AI response based on preferences
    func generateChallengesBasedOnPreferences(_ preferences: [String]) -> [String] {
        var challenges: [String] = []
        
        for preference in preferences {
            if preference == "Fitness" {
                challenges.append("Complete a 5km run this week.")
            } else if preference == "Mental Health" {
                challenges.append("Practice meditation for 10 minutes daily.")
            } else if preference == "Creativity" {
                challenges.append("Create a new art piece over the weekend.")
            }
        }
        
        return challenges
    }
}




#Preview {
    DashboardView()
}
