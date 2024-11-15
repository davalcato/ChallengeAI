//
//  AIChallengeService.swift
//  ChallengeAI
//
//  Created by Ethan Hunt on 11/15/24.
//

import Foundation

class AIChallengeService {
    static func createChallenge(difficulty: String, topic: String, type: String, completion: @escaping (Challenge) -> Void) {
        // Simulate API response
        let simulatedChallenge = Challenge(
            id: UUID().uuidString,
            difficulty: difficulty,
            topic: topic,
            type: type,
            question: "What is 2 + 2?",
            options: ["2", "3", "4", "5"],
            answer: "4"
        )
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { // Simulate network delay
            completion(simulatedChallenge)
        }
    }
}

