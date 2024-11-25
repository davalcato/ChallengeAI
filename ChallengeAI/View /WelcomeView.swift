//
//  WelcomeView.swift
//  ChallengeAI
//
//  Created by Ethan Hunt on 11/10/24.
//

import SwiftUI

struct WelcomeView: View {
    @EnvironmentObject var appState: AppState
    @State private var showProfileView = false // State to control ProfileView sheet
    @State private var userPreferences = UserPreferences(
        difficulty: "Easy",
        topics: ["General Knowledge"],
        challengeType: "Text",
        frequency: "Daily"
    )
    @State private var navigateToDashboard = false // State for controlling navigation

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
                        EmptyView() // Empty view for manual navigation
                    }

                    // Button to navigate to Dashboard
                    Button(action: {
                        // Set state to navigate to DashboardView
                        navigateToDashboard = true
                        UserDefaults.standard.set(true, forKey: "isLoggedIn")
                        appState.isLoggedIn = true
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

                    Spacer()

                    // Logout Button at Bottom
                    Button(action: {
                        UserDefaults.standard.set(false, forKey: "isLoggedIn")
                        appState.isLoggedIn = false
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
            }
        } else {
            // Fallback for earlier iOS versions
            Text("Your device does not support this feature.")
        }
    }
}

#Preview {
    WelcomeView()
        .environmentObject(AppState(isLoggedIn: UserDefaults.standard.bool(forKey: "isLoggedIn")))
}











