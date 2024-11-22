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
                    // Top Section with Title and Profile Image
                    HStack {
                        Spacer()
                        
                        Text("Welcome to the Dashboard")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity, alignment: .center)
                        
                        // Profile Image Button
                        Button(action: {
                            showProfileView = true
                        }) {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .foregroundColor(.blue)
                                .padding(.trailing, 16)
                        }
                    }
                    .padding(.top, 16)
                    
                    Spacer()
                    
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





