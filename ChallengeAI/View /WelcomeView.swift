//
//  WelcomeView.swift
//  ChallengeAI
//
//  Created by Ethan Hunt on 11/10/24.
//

import SwiftUI

struct WelcomeView: View {
    @EnvironmentObject var appState: AppState
    @State private var navigateToDashboard = false // State to trigger navigation

    var body: some View {
        NavigationView {
            VStack {
                // Title at the top
                Spacer()

                Text("Welcome to the Dashboard")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .padding()

                // Go to Dashboard Button centered
                NavigationLink(destination: DashboardView(), isActive: $navigateToDashboard) {
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
                    .padding(.horizontal, 50)
                }

                Spacer()

                // Logout button in the top-right corner
                HStack {
                    Spacer()
                    Button(action: {
                        appState.isLoggedIn = false
                    }) {
                        Text("Logout")
                            .foregroundColor(.red)
                            .padding()
                    }
                }
            }
            .padding()
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
}
