//
//  WelcomeView.swift
//  ChallengeAI
//
//  Created by Ethan Hunt on 11/10/24.
//

import SwiftUI

struct WelcomeView: View {
    @EnvironmentObject var appState: AppState
    @State private var showProfileView = false // Control navigation to ProfileView
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
                    Text("Welcome to the Dashboard")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding()
                    
                    // Button to navigate to DashboardView
                    Button(action: {
                        // Navigate to DashboardView
                    }) {
                        NavigationLink(destination: DashboardView()) {
                            Text("Go to Dashboard")
                                .font(.title2)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }
                    .padding()
                    
                    Button(action: {
                        // Log the user out
                        appState.isLoggedIn = false
                    }) {
                        Text("Logout")
                            .foregroundColor(.red)
                            .padding()
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            showProfileView = true
                        }) {
                            Image(systemName: "person.crop.circle")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .clipShape(Circle())
                                .foregroundColor(.blue)
                        }
                    }
                }
                .sheet(isPresented: $showProfileView) {
                    ProfileView(userPreferences: $userPreferences)
                }
                .navigationBarHidden(false) // Ensure the toolbar is visible
                .padding()
            }
        } else {
            // Fallback on earlier versions
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

#Preview {
    WelcomeView()
        .environmentObject(AppState(isLoggedIn: true))
}

