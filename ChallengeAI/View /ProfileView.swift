//
//  ProfileView.swift
//  ChallengeAI
//
//  Created by Ethan Hunt on 11/15/24.
//

import SwiftUI

struct ProfileView: View {
    @Binding var userPreferences: UserPreferences
    @State private var showSuccessMessage = false

    var body: some View {
        NavigationView {
            ZStack {
                // Background gradient
                LinearGradient(gradient: Gradient(colors: [.blue.opacity(0.7), .purple.opacity(0.7)]), startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()

                VStack(spacing: 20) {
                    // Profile header with icon
                    HStack {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                            .foregroundColor(.white)
                        Text("Profile Page")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                    .padding()

                    // Navigation button with animation
                    NavigationLink(destination: PreferencesView(userPreferences: $userPreferences)) {
                        Text("Edit Preferences")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                LinearGradient(gradient: Gradient(colors: [.purple, .blue]), startPoint: .leading, endPoint: .trailing)
                            )
                            .foregroundColor(.white)
                            .cornerRadius(12)
                            .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 5)
                            .scaleEffect(showSuccessMessage ? 1.1 : 1.0)
                            .animation(.easeInOut(duration: 0.3), value: showSuccessMessage)
                    }
                    .padding(.horizontal)

                    // Display updated preferences with sleek styling
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Your Preferences")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)

                        ProfilePreferenceRow(title: "Difficulty", value: userPreferences.difficulty)
                        ProfilePreferenceRow(title: "Topics", value: userPreferences.topics.joined(separator: ", "))
                        ProfilePreferenceRow(title: "Challenge Type", value: userPreferences.challengeType)
                    }
                    .padding()
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(12)
                    .padding(.horizontal)

                    // Success message feedback
                    if showSuccessMessage {
                        Text("Preferences updated successfully!")
                            .font(.callout)
                            .foregroundColor(.green)
                            .transition(.opacity)
                            .padding()
                    }
                }
                .navigationTitle("Profile")
            }
        }
        .onAppear {
            // Trigger a subtle animation on load
            withAnimation(.spring()) {
                showSuccessMessage = true
            }
        }
    }
}

struct ProfilePreferenceRow: View {
    var title: String
    var value: String

    var body: some View {
        HStack {
            Text("\(title):")
                .font(.subheadline)
                .fontWeight(.bold)
                .foregroundColor(.white)
            Spacer()
            Text(value)
                .font(.subheadline)
                .foregroundColor(.white)
        }
        .padding(.horizontal)
    }
}

#Preview {
    ProfileView(userPreferences: .constant(UserPreferences(
        difficulty: "Easy",
        topics: ["General Knowledge", "Science"],
        challengeType: "Text",
        frequency: "Daily"
    )))
}



