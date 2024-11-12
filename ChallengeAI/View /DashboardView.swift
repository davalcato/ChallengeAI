//
//  DashboardView.swift
//  ChallengeAI
//
//  Created by Ethan Hunt on 11/11/24.
//

import SwiftUI

struct DashboardView: View {
    var body: some View {
        VStack {
            Text("AI Tasks and Challenges")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()

            List {
                // Example AI tasks and challenges
                Section(header: Text("Tasks")) {
                    Text("Task 1: AI Text Analysis")
                    Text("Task 2: Image Recognition Challenge")
                }
                Section(header: Text("Challenges")) {
                    Text("Challenge 1: Beat the AI at Chess")
                    Text("Challenge 2: Generate AI Art")
                }
            }
            .listStyle(GroupedListStyle())

            Spacer()
        }
        .padding()
        // Remove the .navigationTitle from here
    }
}



#Preview {
    DashboardView()
}
