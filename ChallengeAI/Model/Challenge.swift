//
//  Challenge.swift
//  ChallengeAI
//
//  Created by Ethan Hunt on 11/15/24.
//

import Foundation


struct Challenge: Codable {
    let id: String
    let difficulty: String
    let topic: String
    let type: String
    let question: String
    let options: [String]?
    let answer: String

    // Add a description property
    var description: String {
        return "Challenge: \(question)"
    }
}

