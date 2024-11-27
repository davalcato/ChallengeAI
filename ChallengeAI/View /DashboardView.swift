//
//  DashboardView.swift
//  ChallengeAI
//
//  Created by Ethan Hunt on 11/11/24.
//

import SwiftUI
import AVFoundation

struct DashboardView: View {
    @Environment(\.presentationMode) var presentationMode // To dismiss the view
    @State private var challenges: [String] = [] // Store AI-generated challenges
    @State private var showChallengeDetails = false
    @State private var selectedChallenge: String? = nil // Track selected challenge
    @State private var userPreferences = ["Fitness", "Mental Health", "Creativity"] // Example preferences
    @State private var completedChallenges = 0 // Number of completed challenges
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

                // Animated progress bar
                ProgressView(value: Double(completedChallenges), total: Double(challenges.count))
                    .progressViewStyle(LinearProgressViewStyle(tint: .green))
                    .padding(.horizontal, 40)
                    .frame(height: 10)
                    .scaleEffect(y: 2)
                    .animation(.easeInOut, value: completedChallenges)

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
                                isSelected: challenge == selectedChallenge,
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
        .gesture(
            DragGesture()
                .onEnded { value in
                    if value.translation.width > 100 { // Detect right swipe
                        presentationMode.wrappedValue.dismiss() // Navigate back
                    }
                }
        )
        .onAppear {
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
    let isSelected: Bool
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
            colors: isSelected ? [Color.orange, Color.red] : [Color.purple, Color.blue],
            startPoint: .top,
            endPoint: .bottom
        ))
        .cornerRadius(15)
        .shadow(radius: isSelected ? 10 : 5)
        .scaleEffect(isSelected ? 1.1 : 1.0)
        .animation(.easeInOut, value: isSelected)
    }
}

struct ChallengeDetailView: View {
    let challenge: String
    let onComplete: () -> Void
    @State private var isCompleted = false

    var body: some View {
        ZStack {
            VStack {
                Text(challenge)
                    .font(.title)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .padding()

                Spacer()

                // Complete button with pulse animation
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
                        .scaleEffect(isCompleted ? 1.2 : 1.0)
                        .animation(.easeInOut, value: isCompleted)
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 20)

                if isCompleted {
                    StarburstEffect()
                        .frame(width: 200, height: 200)
                        .offset(y: -150)
                        .animation(.easeOut(duration: 2.0), value: isCompleted)
                }
            }
        }
        .padding()
    }
}

struct StarburstEffect: View {
    var body: some View {
        Canvas { context, size in
            for _ in 0..<30 {
                let randomPosition = CGPoint(
                    x: CGFloat.random(in: 0..<size.width),
                    y: CGFloat.random(in: 0..<size.height)
                )
                context.fill(
                    Circle().path(in: CGRect(origin: randomPosition, size: CGSize(width: 5, height: 5))),
                    with: .color(.yellow.opacity(0.8))
                )
            }
        }
    }
}

#Preview {
    DashboardView()
}






