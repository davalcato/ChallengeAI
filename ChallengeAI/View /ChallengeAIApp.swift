//
//  ChallengeAIApp.swift
//  ChallengeAI
//
//  Created by Ethan Hunt on 10/1/24.
//

import SwiftUI

@available(iOS 14.0, *)
@main
struct ChallengeAIApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            OnboardingView() // Start with the OnboardingView
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
