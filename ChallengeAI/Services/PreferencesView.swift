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
    @State private var selectedTopics = Set<String>() // Use Set for selection management
    @State private var challengeType = "Text"

    let difficulties = ["Easy", "Medium", "Hard"]
    let topics = ["Math", "Science", "History", "General Knowledge"]
    let challengeTypes = ["Text", "Image", "Audio", "Mixed"]

    var body: some View {
        Form {
            Section(header: Text("Difficulty")) {
                Picker("Difficulty", selection: $selectedDifficulty) {
                    ForEach(difficulties, id: \.self) { difficulty in
                        Text(difficulty).tag(difficulty)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
            }

            Section(header: Text("Topics")) {
                List(topics, id: \.self) { topic in
                    HStack {
                        Text(topic)
                        Spacer()
                        if selectedTopics.contains(topic) {
                            Image(systemName: "checkmark")
                        }
                    }
                    .contentShape(Rectangle()) // Make the entire row tappable
                    .onTapGesture {
                        if selectedTopics.contains(topic) {
                            selectedTopics.remove(topic)
                        } else {
                            selectedTopics.insert(topic)
                        }
                    }
                }
            }

            Section(header: Text("Challenge Type")) {
                Picker("Type", selection: $challengeType) {
                    ForEach(challengeTypes, id: \.self) { type in
                        Text(type).tag(type)
                    }
                }
                .pickerStyle(MenuPickerStyle())
            }

            Button(action: savePreferences) {
                Text("Save Preferences")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .onDisappear {
            userPreferences.difficulty = selectedDifficulty
            userPreferences.topics = Array(selectedTopics) // Convert Set to Array
            userPreferences.challengeType = challengeType
        }
        .navigationTitle("Preferences")
    }

    private func savePreferences() {
        userPreferences.difficulty = selectedDifficulty
        userPreferences.topics = Array(selectedTopics) // Convert Set to Array
        userPreferences.challengeType = challengeType
    }
}




