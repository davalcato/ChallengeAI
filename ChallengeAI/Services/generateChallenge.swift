//
//  generateChallenge.swift
//  ChallengeAI
//
//  Created by Ethan Hunt on 11/15/24.
//

import Foundation

func generateChallenge(preferences: UserPreferences, completion: @escaping (Challenge) -> Void) {
    let difficulty = preferences.difficulty
    let topics = preferences.topics.randomElement() ?? "General Knowledge"
    let type = preferences.challengeType

    // Hypothetical API service or internal logic
    AIChallengeService.createChallenge(difficulty: difficulty, topic: topics, type: type) { challenge in
        completion(challenge)
    }
}

