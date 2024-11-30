//
//  DashboardView.swift
//  ChallengeAI
//
//  Created by Ethan Hunt on 11/11/24.
//

import SwiftUI
import AVKit

struct DashboardView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var challenges: [String] = []
    @State private var showChallengeDetails = false
    @State private var selectedChallenge: String? = nil
    @State private var userPreferences = ["Fitness", "Mental Health", "Creativity"]
    @State private var completedChallenges = 0
    @State private var isFetchingChallenges = false

    @State private var showVideoPlayer = false
    @State private var videoURL: URL?
    @State private var player: AVPlayer? = nil
    @State private var videoTransition: AnyTransition = .identity // To manage animations

    @State private var scaleEffect: CGFloat = 1.0 // For scale effect during transition

    @State private var showSearch = false // Boolean to control search feature visibility

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color.blue.opacity(0.6), Color.purple.opacity(0.6)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack {
                HStack {
                    Spacer() // Pushes the search icon to the right
                    Button(action: {
                        showSearch.toggle() // Toggle the search feature
                    }) {
                        Image(systemName: "magnifyingglass") // Search icon
                            .resizable()
                            .frame(width: 14, height: 14) // Smaller size for the icon
                            .foregroundColor(.white)
                            .padding(10) // Adjusted padding to place it higher
                            .background(Color.black.opacity(0.5))
                            .clipShape(Circle())
                    }
                    .padding(.top, 2) // Adjusted to make it higher
                    .padding(.trailing, 9)
                }

                Text("AI Tasks and Challenges")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    .padding(.top, 40)

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

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 20) {
                        ForEach(["Tanaya", "amelaomor", "Draya", "Indiana", "Simerk"], id: \.self) { name in
                            VStack {
                                Button(action: {
                                    playVideo(for: name)
                                }) {
                                    Image(name)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 50, height: 50)
                                        .clipShape(Circle())
                                        .shadow(radius: 5)
                                }
                                Text(name)
                                    .font(.caption)
                                    .foregroundColor(.white)
                            }
                        }
                    }
                    .padding(.horizontal)
                }

                Spacer()

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
                    .padding(.bottom, 20)
                }
            }
        }
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
        .sheet(isPresented: $showVideoPlayer) {
            if let player = player {
                ZStack {
                    VideoPlayer(player: player)
                        .scaleEffect(scaleEffect) // Apply scaling effect during the transition
                        .opacity(Double(scaleEffect)) // Apply opacity fade effect
                        .transition(.asymmetric(insertion: .scale, removal: .opacity)) // Combine scale and opacity for smooth transition
                        .gesture(
                            DragGesture()
                                .onEnded { value in
                                    if value.translation.width < -50 {
                                        goToNextVideo()
                                    } else if value.translation.width > 50 {
                                        goToPreviousVideo()
                                    } else if value.translation.height > 50 {
                                        dismissVideo() // Swipe Down to Dismiss
                                    }
                                }
                        )
                        .onDisappear {
                            player.pause()
                        }

                    VStack {
                        HStack {
                            Button(action: {
                                showVideoPlayer = false
                            }) {
                                Image(systemName: "xmark")
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(Color.black.opacity(0.5))
                                    .clipShape(Circle())
                            }
                            Spacer()
                        }
                        .padding()
                        Spacer()
                    }
                }
            }
        }
    }

    func fetchPersonalizedChallenges() {
        userPreferences = userPreferences.shuffled().map { $0 + " AI" }
        let simulatedAIResponse = generateChallengesBasedOnPreferences(userPreferences)
        self.challenges = simulatedAIResponse
    }

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

    func playVideo(for name: String) {
        if let url = Bundle.main.url(forResource: name, withExtension: "mov") {
            player = AVPlayer(url: url)
            player?.play()
            videoURL = url
            showVideoPlayer = true
        } else {
            print("Video \(name).mov not found in the bundle.")
        }
    }

    func goToNextVideo() {
        // Stop the previous video audio if it's playing
        player?.pause()
        
        guard let currentName = videoURL?.lastPathComponent.split(separator: ".").first,
              let currentIndex = ["Tanaya", "amelaomor", "Draya", "Indiana", "Simerk"].firstIndex(of: String(currentName)),
              currentIndex + 1 < 5 else {
            return
        }

        scaleEffect = 0.9 // Shrink video during transition
        withAnimation(.easeInOut(duration: 0.5)) {
            scaleEffect = 1.0 // Scale back to normal after transition
        }

        let nextName = ["Tanaya", "amelaomor", "Draya", "Indiana", "Simerk"][currentIndex + 1]
        if let url = Bundle.main.url(forResource: nextName, withExtension: "mov") {
            player = AVPlayer(url: url)
            player?.play()
            videoURL = url
        } else {
            print("Next video \(nextName).mov not found in the bundle.")
        }
    }

    func goToPreviousVideo() {
        // Stop the previous video audio if it's playing
        player?.pause()

        guard let currentName = videoURL?.lastPathComponent.split(separator: ".").first,
              let currentIndex = ["Tanaya", "amelaomor", "Draya", "Indiana", "Simerk"].firstIndex(of: String(currentName)),
              currentIndex - 1 >= 0 else {
            return
        }

        scaleEffect = 0.9 // Shrink video during transition
        withAnimation(.easeInOut(duration: 0.5)) {
            scaleEffect = 1.0 // Scale back to normal after transition
        }

        let prevName = ["Tanaya", "amelaomor", "Draya", "Indiana", "Simerk"][currentIndex - 1]
        if let url = Bundle.main.url(forResource: prevName, withExtension: "mov") {
            player = AVPlayer(url: url)
            player?.play()
            videoURL = url
        } else {
            print("Previous video \(prevName).mov not found in the bundle.")
        }
    }

    func dismissVideo() {
        // Stop the video and dismiss the player
        player?.pause()
        showVideoPlayer = false
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






