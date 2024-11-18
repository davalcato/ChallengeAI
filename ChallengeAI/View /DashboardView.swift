//
//  DashboardView.swift
//  ChallengeAI
//
//  Created by Ethan Hunt on 11/11/24.
//

import SwiftUI
import AVKit // For video playback

struct DashboardView: View {
    @State private var challenges: [String] = [] // Store AI-generated challenges
    @State private var showChallengeDetails = false
    @State private var selectedChallenge: String? = nil // Track selected challenge
    @State private var userPreferences = ["Fitness", "Mental Health", "Creativity"] // Example preferences
    
    var body: some View {
        NavigationView {
            VStack {
                // Title at the very top center of the screen
                Text("AI Tasks and Challenges")
                    .font(.title) // Reduced the font size
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .padding(.top, 0) // Push the title to the very top

                // Display the generated challenges from AI
                List {
                    Section(header: Text("Personalized Challenges")) {
                        ForEach(challenges, id: \.self) { challenge in
                            Button(action: {
                                selectedChallenge = challenge
                                showChallengeDetails = true
                            }) {
                                Text(challenge)
                                    .font(.headline)
                                    .foregroundColor(.blue)
                            }
                        }
                    }

                    // Example AI tasks
                    Section(header: Text("AI Tasks")) {
                        Text("Task 1: AI Text Analysis")
                        Text("Task 2: Image Recognition Challenge")
                    }
                }
                .listStyle(GroupedListStyle())
                .frame(height: 396)

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
            .sheet(isPresented: $showChallengeDetails) {
                // Show details for the selected challenge
                if let challenge = selectedChallenge {
                    ChallengeDetailView(challenge: challenge)
                }
            }
        }
        .navigationBarBackButtonHidden(false) // Show the back button to navigate to the WelcomeView
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

struct ChallengeDetailView: View {
    let challenge: String
    
    var body: some View {
        VStack {
            Text(challenge)
                .font(.title)
                .fontWeight(.bold)
                .padding()

            // Example: Show video or additional content based on the challenge
            if challenge.contains("5km run") {
                Text("Motivational Video")
                    .font(.headline)
                    .padding(.bottom, 20)
                
                VideoPlayer(player: AVPlayer(url: URL(string: "https://www.example.com/running-video.mp4")!))
                    .frame(height: 300)
                    .cornerRadius(10)
            } else if challenge.contains("meditation") {
                Text("Meditation Guide")
                    .font(.headline)
                    .padding(.bottom, 20)
                
                Text("Follow this 10-minute guided meditation to relax and unwind.")
                    .padding()
            } else if challenge.contains("art piece") {
                Text("Creativity Tips")
                    .font(.headline)
                    .padding(.bottom, 20)
                
                Text("Discover ways to spark your creativity and create a unique art piece.")
                    .padding()
            } else {
                Text("More details coming soon!")
                    .padding()
            }

            Spacer()
        }
        .padding()
    }
}

#Preview {
    DashboardView()
}



