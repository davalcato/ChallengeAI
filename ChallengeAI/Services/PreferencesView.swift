//
//  PreferencesView.swift
//  ChallengeAI
//
//  Created by Ethan Hunt on 11/15/24.
//

import SwiftUI

struct PreferencesView: View {
    @Binding var userPreferences: UserPreferences
    @State private var selectedDifficulty = "Easy"
    @State private var selectedTopics = Set<String>()
    @State private var challengeType = "Text"
    @State private var showSavedToast = false // State for toast animation

    let difficulties = ["Easy", "Medium", "Hard"]
    let topics = ["Math", "Science", "History", "General Knowledge"]
    let challengeTypes = ["Text", "Image", "Audio", "Mixed"]

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.blue.opacity(0.4), .purple.opacity(0.6)]),
                           startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()

            VStack(spacing: 20) {
                // Difficulty Section
                VStack(alignment: .leading) {
                    Text("Difficulty")
                        .font(.headline)
                        .padding(.bottom, 5)
                    Picker("Difficulty", selection: $selectedDifficulty) {
                        ForEach(difficulties, id: \.self) { difficulty in
                            Text(difficulty)
                                .fontWeight(selectedDifficulty == difficulty ? .bold : .regular)
                                .tag(difficulty)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(10)
                }
                .padding(.horizontal)

                // Topics Section
                VStack(alignment: .leading) {
                    Text("Topics")
                        .font(.headline)
                        .padding(.bottom, 5)
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 2), spacing: 10) {
                        ForEach(topics, id: \.self) { topic in
                            Text(topic)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(selectedTopics.contains(topic) ? Color.blue : Color.gray.opacity(0.4))
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .onTapGesture {
                                    withAnimation {
                                        toggleTopicSelection(topic)
                                    }
                                }
                        }
                    }
                }
                .padding(.horizontal)

                // Challenge Type Section
                VStack(alignment: .leading) {
                    Text("Challenge Type")
                        .font(.headline)
                        .padding(.bottom, 5)
                    Picker("Type", selection: $challengeType) {
                        ForEach(challengeTypes, id: \.self) { type in
                            Text(type)
                                .tag(type)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .padding()
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(10)
                }
                .padding(.horizontal)

                // Save Button
                Button(action: {
                    savePreferences()
                    showSavedToast.toggle()
                }) {
                    Text("Save Preferences")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                }
                .padding(.horizontal)
            }
            .padding(.vertical)

            // Toast Notification
            if showSavedToast {
                VStack {
                    Spacer()
                    HStack {
                        Text("Preferences Saved!")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.green)
                            .cornerRadius(8)
                        Spacer()
                    }
                    .padding()
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        withAnimation {
                            showSavedToast.toggle()
                        }
                    }
                }
            }
        }
        .onAppear {
            // Initialize local states with user preferences
            selectedDifficulty = userPreferences.difficulty
            selectedTopics = Set(userPreferences.topics)
            challengeType = userPreferences.challengeType
        }
        .navigationTitle("Preferences")
        .foregroundColor(.white)
    }

    private func toggleTopicSelection(_ topic: String) {
        if selectedTopics.contains(topic) {
            selectedTopics.remove(topic)
        } else {
            selectedTopics.insert(topic)
        }
    }

    private func savePreferences() {
        userPreferences.difficulty = selectedDifficulty
        userPreferences.topics = Array(selectedTopics)
        userPreferences.challengeType = challengeType
    }
}






