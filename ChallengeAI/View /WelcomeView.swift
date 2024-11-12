//
//  WelcomeView.swift
//  ChallengeAI
//
//  Created by Ethan Hunt on 11/10/24.
//

import SwiftUI

struct WelcomeView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
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
        .navigationBarHidden(true) // Ensure there's no extra navigation bar
        .padding()
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
}
