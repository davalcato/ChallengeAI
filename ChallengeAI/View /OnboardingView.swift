//
//  OnboardingView.swift
//  ChallengeAI
//
//  Created by Ethan Hunt on 10/1/24.
//

import SwiftUI

struct OnboardingView: View {
    @State private var currentTab = 0
    @State private var isOnboardingComplete = false // State to track onboarding completion
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            VStack {
                // TabView for swiping through onboarding screens
                TabView(selection: $currentTab) {
                    OnboardingPage(
                        title: "Welcome to ChallengeAI",
                        description: "Discover AI-generated challenges designed just for you!",
                        imageName: "onboarding1",
                        currentTab: $currentTab
                    )
                    .tag(0)

                    OnboardingPage(
                        title: "Game-Like Experience",
                        description: "Earn points, level up, and compete with friends in real-time challenges.",
                        imageName: "onboarding2",
                        currentTab: $currentTab
                    )
                    .tag(1)

                    OnboardingPage(
                        title: "AI Personalized",
                        description: "AI tailors challenges based on your interests and performance.",
                        imageName: "onboarding3",
                        currentTab: $currentTab
                    )
                    .tag(2)

                    OnboardingPage(
                        title: "Get Started!",
                        description: "Ready to jump in? Let's begin your journey.",
                        imageName: "onboarding4",
                        currentTab: $currentTab
                    )
                    .tag(3)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))

                // Skip and Continue Button
                VStack {
                    if currentTab < 3 {
                        Button(action: {
                            currentTab = 3 // Skip to the last screen
                        }) {
                            Text("Skip")
                                .font(.headline)
                                .foregroundColor(.gray)
                                .padding()
                        }
                    }

                    if currentTab == 3 {
                        Button(action: {
                            // Mark onboarding as complete and navigate to LoginView
                            isOnboardingComplete = true
                        }) {
                            Text("Get Started")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.bottom, 20)

                // NavigationLink to LoginView
                NavigationLink(destination: LoginView(), isActive: $isOnboardingComplete) {
                    EmptyView()
                }
            }
            .background(Color.white)
            .edgesIgnoringSafeArea(.all)
            .navigationTitle("") // Optional: Set title or remove
            .navigationBarHidden(true) // Hide navigation bar
        }
    }
}

// Onboarding Page with Animations
struct OnboardingPage: View {
    var title: String
    var description: String
    var imageName: String
    @Binding var currentTab: Int
    
    @State private var imageOpacity: Double = 0
    @State private var textOpacity: Double = 0
    
    var body: some View {
        VStack {
            // Animate the image sliding in
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(height: 300)
                .padding(.top, 50)
                .opacity(imageOpacity)
                .onAppear {
                    withAnimation(.easeIn(duration: 1)) {
                        imageOpacity = 1
                    }
                }
            
            // Animate the title and description fading in
            Text(title)
                .font(.largeTitle)
                .bold()
                .padding(.top, 20)
                .opacity(textOpacity)
                .onAppear {
                    withAnimation(.easeIn(duration: 1.5).delay(0.5)) {
                        textOpacity = 1
                    }
                }
            
            Text(description)
                .font(.body)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 30)
                .padding(.top, 10)
                .opacity(textOpacity)
            
            Spacer()
        }
        .padding()
        .onDisappear {
            // Reset animations when leaving the screen
            imageOpacity = 0
            textOpacity = 0
        }
    }
}



#Preview {
    OnboardingView()
}
