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
    @State private var buttonScale: CGFloat = 1.0 // For animation

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
                            withAnimation {
                                showProfileView = true
                            }
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
                        .foregroundColor(.blue)
                        .padding(.bottom, 50)
                        .scaleEffect(buttonScale)
                        .animation(.easeInOut(duration: 0.5), value: buttonScale)

                    // NavigationLink triggered by state
                    NavigationLink(
                        destination: DashboardView(),
                        isActive: $navigateToDashboard
                    ) {
                        EmptyView()
                    }

                    // Button to navigate to Dashboard with animation
                    Button(action: {
                        withAnimation(.spring()) {
                            navigateToDashboard = true
                        }
                    }) {
                        Text("Go to Dashboard")
                            .font(.title2)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(
                                LinearGradient(gradient: Gradient(colors: [.blue, .purple]), startPoint: .leading, endPoint: .trailing)
                            )
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal, 40)

                    // Toggle interactive stats with fun animation
                    Button(action: {
                        withAnimation {
                            showInteractiveStats.toggle()
                        }
                    }) {
                        Text(showInteractiveStats ? "Hide Stats" : "Show Stats")
                            .font(.title3)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(showInteractiveStats ? Color.red : Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .shadow(radius: 10)
                    }
                    .padding(.horizontal, 40)

                    if showInteractiveStats {
                        InteractiveStatsView()
                            .transition(.slide)
                            .padding(.top, 20)
                    }

                    Spacer()

                    // Logout Button with animation
                    Button(action: {
                        showLogoutConfirmation = true
                    }) {
                        Text("Logout")
                            .foregroundColor(.red)
                            .fontWeight(.bold)
                            .padding(.bottom, 16)
                            .scaleEffect(buttonScale)
                            .animation(.easeInOut(duration: 0.5), value: buttonScale)
                    }
                }
                .sheet(isPresented: $showProfileView) {
                    ProfileView(userPreferences: $userPreferences)
                        .transition(.move(edge: .bottom))
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
            .background(
                LinearGradient(gradient: Gradient(colors: [.purple, .blue]), startPoint: .topLeading, endPoint: .bottomTrailing)
                    .edgesIgnoringSafeArea(.all)
            )
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
                .foregroundColor(.purple)

            // Sample charts or stats with exciting visuals
            HStack {
                VStack {
                    Text("Tasks Completed")
                        .font(.headline)
                        .foregroundColor(.blue)

                    ProgressView(value: 75, total: 100)
                        .progressViewStyle(LinearProgressViewStyle(tint: .green))
                        .frame(width: 150)
                        .padding(.top, 10)
                }

                VStack {
                    Text("Daily Challenges")
                        .font(.headline)
                        .foregroundColor(.purple)

                    ProgressView(value: 40, total: 100)
                        .progressViewStyle(LinearProgressViewStyle(tint: .orange))
                        .frame(width: 150)
                        .padding(.top, 10)
                }
            }
            .padding()

            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white)
                .shadow(radius: 10)
        )
        .padding()
    }
}

#Preview {
    WelcomeView()
        .environmentObject(AppState(isLoggedIn: UserDefaults.standard.bool(forKey: "isLoggedIn")))
}

















