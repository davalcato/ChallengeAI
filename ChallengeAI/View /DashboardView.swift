//
//  DashboardView.swift
//  ChallengeAI
//
//  Created by Ethan Hunt on 11/11/24.
//

import SwiftUI
import AVFoundation
import _AVKit_SwiftUI

struct DashboardView: View {
    @State private var challenges: [String] = [] // Store AI-generated challenges
    @State private var showChallengeDetails = false
    @State private var selectedChallenge: String? = nil // Track selected challenge
    @State private var userPreferences = ["Fitness", "Mental Health", "Creativity"] // Example preferences
    @State private var completedChallenges = 2 // Example: Number of completed challenges
    @State private var isFetchingChallenges = false // State to show/hide spinner

    var body: some View {
        ZStack {
            // Dynamic gradient background
            LinearGradient(
                colors: [Color.blue.opacity(0.6), Color.purple.opacity(0.6)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack {
                // Title and progress tracking
                Text("AI Tasks and Challenges")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    .padding(.top, 40)
                
                Text("\(completedChallenges)/\(challenges.count) Challenges Completed")
                    .font(.headline)
                    .foregroundColor(.white.opacity(0.8))
                    .padding(.bottom, 20)

                // Display challenges as swipeable cards
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 20) {
                        ForEach(challenges, id: \.self) { challenge in
                            ChallengeCard(
                                challenge: challenge,
                                onCardTapped: {
                                    selectedChallenge = challenge
                                    showChallengeDetails = true
                                }
                            )
                        }
                    }
                    .padding(.horizontal)
                }
                .frame(height: 250)

                Spacer()

                // Button to refresh challenges
                if isFetchingChallenges {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(1.5)
                        .padding()
                } else {
                    Button(action: {
                        isFetchingChallenges = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                            isFetchingChallenges = false
                            fetchPersonalizedChallenges()
                        }
                    }) {
                        Text("Get New Challenges")
                            .font(.title2)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.white)
                            .foregroundColor(Color.blue)
                            .cornerRadius(15)
                    }
                    .padding(.horizontal, 40)
                }

                Spacer()
            }
        }
        .onAppear {
            // Fetch challenges when the view first loads
            fetchPersonalizedChallenges()
        }
        .sheet(isPresented: $showChallengeDetails) {
            if let challenge = selectedChallenge {
                ChallengeDetailView(challenge: challenge, onComplete: {
                    completedChallenges += 1
                })
            }
        }
    }

    // Fetch AI-generated personalized challenges
    func fetchPersonalizedChallenges() {
        // Randomize preferences for fun
        userPreferences = userPreferences.shuffled().map { $0 + " AI" }
        
        // Simulate AI response
        let simulatedAIResponse = generateChallengesBasedOnPreferences(userPreferences)
        
        // Update the challenges state
        self.challenges = simulatedAIResponse
    }

    // Mock function to simulate AI response based on preferences
    func generateChallengesBasedOnPreferences(_ preferences: [String]) -> [String] {
        var challenges: [String] = []
        
        for preference in preferences {
            if preference.contains("Fitness") {
                challenges.append("Complete a 5km run this week.")
            } else if preference.contains("Mental Health") {
                challenges.append("Practice meditation for 10 minutes daily.")
            } else if preference.contains("Creativity") {
                challenges.append("Create a new art piece over the weekend.")
            } else {
                challenges.append("Explore a new challenge based on \(preference).")
            }
        }
        
        return challenges
    }
}



struct ChallengeCard: View {
    let challenge: String
    let onCardTapped: () -> Void

    var body: some View {
        VStack {
            Text(challenge)
                .font(.headline)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding()

            Spacer()

            Button(action: onCardTapped) {
                Text("View Details")
                    .font(.subheadline)
                    .padding()
                    .background(Color.white.opacity(0.9))
                    .foregroundColor(.blue)
                    .cornerRadius(8)
            }
        }
        .frame(width: 200, height: 200)
        .background(LinearGradient(
            colors: [Color.purple, Color.blue],
            startPoint: .top,
            endPoint: .bottom
        ))
        .cornerRadius(15)
        .shadow(radius: 5)
    }
}

struct ChallengeDetailView: View {
    let challenge: String
    let onComplete: () -> Void
    @State private var isCompleted = false

    var body: some View {
        VStack {
            Text(challenge)
                .font(.title)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding()

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

            // Complete button with confetti
            Button(action: {
                isCompleted = true
                onComplete()
            }) {
                Text(isCompleted ? "Challenge Completed!" : "Mark as Complete")
                    .font(.title3)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(isCompleted ? Color.green : Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(15)
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 20)
            .animation(.easeInOut, value: isCompleted)
        }
        .padding()
    }
}

#Preview {
    DashboardView()
}





