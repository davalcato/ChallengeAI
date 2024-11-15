//
//  UserPreferences.swift
//  ChallengeAI
//
//  Created by Ethan Hunt on 11/15/24.
//

import Foundation

struct UserPreferences: Codable {
    var difficulty: String // "Easy", "Medium", "Hard"
    var topics: [String] // ["Math", "Science"]
    var challengeType: String // "Text", "Image", "Audio", "Mixed"
    var frequency: String // "Daily", "Weekly", "On-Demand"
}


