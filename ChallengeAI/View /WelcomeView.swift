//
//  WelcomeView.swift
//  ChallengeAI
//
//  Created by Ethan Hunt on 11/10/24.
//

import SwiftUI

// Simple WelcomeView
struct WelcomeView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        ZStack {
            VStack {
                Spacer() // Pushes content towards the top

                // Title at the top, centered horizontally
                Text("Welcome to the Dashboard")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 40) // Adjust top padding as needed
                    .frame(maxWidth: .infinity, alignment: .center)

                Spacer() // Adds space between the title and the button

                // Button centered in the middle, just below the title
                Button(action: {
                    // Navigate to another view or the actual dashboard
                }) {
                    Text("Go to Dashboard")
                        .font(.title2)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()

                Spacer() // Pushes the button upwards to stay centered
            }

            // Logout button in the top-right corner
            VStack {
                HStack {
                    Spacer() // Pushes the logout button to the right
                    Button(action: {
                        // Log the user out
                        appState.isLoggedIn = false
                    }) {
                        Text("Logout")
                            .foregroundColor(.red)
                            .padding()
                    }
                }
                Spacer() // Ensures that the logout button is at the top
            }
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
