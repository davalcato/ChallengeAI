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

    var body: some View {
        if #available(iOS 16.0, *) {
            NavigationStack {
                VStack {
                    // Top Section with Profile Image and Title
                    HStack {
                        // Title "ChallengeAI" in bold and italic
                        Text("ChallengeAI")
                            .font(.system(size: 17, weight: .bold, design: .default)) // Custom font with bold weight
                            .italic() // Ensures italic style is applied
                            .foregroundColor(.primary)
                            .padding(.leading, 16) // Adjust left spacing
                            .padding(.top, -16) // Align with profile image height


                        Spacer()

                        // Profile Image Button in the top-right corner
                        Button(action: {
                            showProfileView = true
                        }) {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor(.blue)
                        }
                        .padding(.trailing, 16) // Adjust right spacing
                        .padding(.top, -16) // Align with title
                    }

                    Spacer()

                    // Welcome Text pushed down near the Dashboard button
                    Text("Welcome to the Dashboard")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 50) // Adjust spacing to move closer to the button

                    // NavigationLink to DashboardView
                    NavigationLink(destination: DashboardView()) {
                        Text("Go to Dashboard")
                            .font(.title2)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }

                    Spacer()

                    // Logout Button at Bottom
                    Button(action: {
                        appState.isLoggedIn = false
                    }) {
                        Text("Logout")
                            .foregroundColor(.red)
                            .padding(.bottom, 16)
                    }
                }
                .sheet(isPresented: $showProfileView) {
                    ProfileView(userPreferences: $userPreferences) // ProfileView presented as a sheet
                }
                .padding()
            }
        } else {
            // Fallback on earlier versions
        }
    }
}

#Preview {
    WelcomeView()
        .environmentObject(AppState(isLoggedIn: true))
}







