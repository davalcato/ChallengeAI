//
//  WelcomeView.swift
//  ChallengeAI
//
//  Created by Ethan Hunt on 11/10/24.
//

import SwiftUI

struct WelcomeView: View {
    @EnvironmentObject var appState: AppState
    @State private var showProfileView = false
    @State private var userPreferences = UserPreferences(
        difficulty: "Easy",
        topics: ["General Knowledge"],
        challengeType: "Text",
        frequency: "Daily"
    )
    @State private var navigateToDashboard = false
    @State private var showLogoutConfirmation = false
    @State private var showInteractiveStats = false // State to toggle interactive stats

    var body: some View {
        if #available(iOS 16.0, *) {
            NavigationStack {
                VStack {
                    // Top Section with Profile Image and Title
                    HStack {
                        Text("ChallengeAI")
                            .font(.system(size: 17, weight: .bold, design: .default))
                            .italic()
                            .foregroundColor(.primary)
                            .padding(.leading, 16)
                            .padding(.top, -16)

                        Spacer()

                        Button(action: {
                            showProfileView = true
                        }) {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor(.blue)
                        }
                        .padding(.trailing, 16)
                        .padding(.top, -16)
                    }

                    Spacer()

                    Text("Welcome to the Dashboard")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 50)

                    // NavigationLink triggered by state
                    NavigationLink(
                        destination: DashboardView(),
                        isActive: $navigateToDashboard
                    ) {
                        EmptyView()
                    }

                    // Button to navigate to Dashboard
                    Button(action: {
                        navigateToDashboard = true
                    }) {
                        Text("Go to Dashboard")
                            .font(.title2)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal, 40)

                    // Toggle interactive stats
                    Button(action: {
                        showInteractiveStats.toggle()
                    }) {
                        Text(showInteractiveStats ? "Hide Stats" : "Show Stats")
                            .font(.title3)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(showInteractiveStats ? Color.red : Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal, 40)

                    if showInteractiveStats {
                        InteractiveStatsView()
                            .transition(.opacity)
                            .padding(.top, 20)
                    }

                    Spacer()

                    // Logout Button
                    Button(action: {
                        showLogoutConfirmation = true
                    }) {
                        Text("Logout")
                            .foregroundColor(.red)
                            .padding(.bottom, 16)
                    }
                }
                .sheet(isPresented: $showProfileView) {
                    ProfileView(userPreferences: $userPreferences)
                }
                .padding()
                .confirmationDialog(
                    "Are you sure you want to Logout?",
                    isPresented: $showLogoutConfirmation,
                    titleVisibility: .visible
                ) {
                    Button("Logout", role: .destructive) {
                        handleLogout()
                    }
                    Button("Cancel", role: .cancel) { }
                }
            }
        } else {
            Text("Your device does not support this feature.")
        }
    }

    private func handleLogout() {
        UserDefaults.standard.set(false, forKey: "isLoggedIn")
        appState.isLoggedIn = false
    }
}

struct InteractiveStatsView: View {
    var body: some View {
        VStack {
            Text("User Insights")
                .font(.title)
                .fontWeight(.bold)
                .padding()

            // Sample charts or stats
            HStack {
                VStack {
                    Text("Tasks Completed")
                        .font(.headline)
                        .foregroundColor(.blue)

                    ProgressView(value: 75, total: 100)
                        .progressViewStyle(LinearProgressViewStyle(tint: .green))
                        .frame(width: 150)
                }

                VStack {
                    Text("Daily Challenges")
                        .font(.headline)
                        .foregroundColor(.purple)

                    ProgressView(value: 40, total: 100)
                        .progressViewStyle(LinearProgressViewStyle(tint: .orange))
                        .frame(width: 150)
                }
            }
            .padding()

            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white)
                .shadow(radius: 5)
        )
        .padding()
    }
}

#Preview {
    WelcomeView()
        .environmentObject(AppState(isLoggedIn: UserDefaults.standard.bool(forKey: "isLoggedIn")))
}
















