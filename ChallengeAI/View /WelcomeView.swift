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
    @State private var showInteractiveStats = false
    @State private var buttonScale: CGFloat = 1.0
    @State private var images = [
        ImageItem(id: UUID(), name: "amelaomor"),
        ImageItem(id: UUID(), name: "Tanaya"),
        ImageItem(id: UUID(), name: "Draya"),
        ImageItem(id: UUID(), name: "Indiana"),
        ImageItem(id: UUID(), name: "Simerk")
    ]
    @State private var selectedImage: ImageItem?

    var body: some View {
        if #available(iOS 16.0, *) {
            NavigationStack {
                ZStack(alignment: .topTrailing) {
                    VStack {
                        // Top Section: Title and Buttons
                        Text("ChallengeAI")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .italic()
                            .foregroundColor(.blue)
                            .multilineTextAlignment(.center)
                            .padding(.top, 20)

                        HStack {
                            // "Go to Dashboard" Button
                            Button(action: {
                                withAnimation(.spring()) {
                                    navigateToDashboard = true
                                }
                            }) {
                                Text("Go to Dashboard")
                                    .font(.subheadline)
                                    .padding(8)
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                            }
                            .padding(.leading, 16)

                            Spacer()

                            // "Show Stats" Button
                            Button(action: {
                                withAnimation {
                                    showInteractiveStats.toggle()
                                }
                            }) {
                                Text(showInteractiveStats ? "Hide Stats" : "Show Stats")
                                    .font(.subheadline)
                                    .padding(8)
                                    .background(showInteractiveStats ? Color.red : Color.green)
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                            }
                            .padding(.trailing, 16)
                        }
                        .padding(.top, 10)

                        // NavigationLink to Dashboard
                        NavigationLink(
                            destination: DashboardView(),
                            isActive: $navigateToDashboard
                        ) {
                            EmptyView()
                        }

                        // Stats Section
                        if showInteractiveStats {
                            InteractiveStatsView()
                                .transition(.slide)
                                .padding(.vertical, 10)
                        }

                        // Scrollable Images Section
                        ScrollView(.vertical, showsIndicators: false) {
                            VStack(spacing: 20) {
                                ForEach(images) { imageItem in
                                    Image(imageItem.name)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(height: 200)
                                        .cornerRadius(10)
                                        .clipped()
                                        .onTapGesture {
                                            withAnimation {
                                                selectedImage = imageItem // Set the tapped image
                                            }
                                        }
                                }
                            }
                            .padding(.horizontal, 16)
                        }
                        .padding(.top, 20)

                        Spacer()

                        // Logout Button
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

                    // Profile Button
                    Button(action: {
                        withAnimation {
                            showProfileView = true
                        }
                    }) {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.blue)
                            .padding()
                    }
                }
            }
            .background(
                LinearGradient(gradient: Gradient(colors: [.purple, .blue]), startPoint: .topLeading, endPoint: .bottomTrailing)
                    .edgesIgnoringSafeArea(.all)
            )
            .fullScreenCover(item: $selectedImage) { imageItem in
                FullScreenImageView(imageName: imageItem.name)
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

struct FullScreenImageView: View {
    let imageName: String
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)

            Image(imageName)
                .resizable()
                .scaledToFit()
                .onTapGesture {
                    dismiss() // Dismiss the full-screen view on tap
                }
        }
        .gesture(
            DragGesture().onEnded { value in
                if value.translation.height > 100 {
                    dismiss() // Dismiss when swiped down
                }
            }
        )
    }
}

struct ImageItem: Identifiable {
    let id: UUID
    let name: String
}

struct InteractiveStatsView: View {
    var body: some View {
        VStack {
            Text("User Insights")
                .font(.title)
                .fontWeight(.bold)
                .padding()
                .foregroundColor(.purple)

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

















