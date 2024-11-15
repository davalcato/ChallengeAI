//
//  fetchAIChallenge.swift
//  ChallengeAI
//
//  Created by Ethan Hunt on 11/15/24.
//

import Foundation

func fetchAIChallenge(preferences: UserPreferences, completion: @escaping (Challenge?) -> Void) {
    guard let url = URL(string: "https://api.openai.com/v1/your_endpoint") else {
        print("Invalid URL")
        completion(nil)
        return
    }

    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.addValue("Bearer YOUR_API_KEY", forHTTPHeaderField: "Authorization")
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")

    let payload: [String: Any] = [
        "difficulty": preferences.difficulty,
        "topics": preferences.topics,
        "challengeType": preferences.challengeType
    ]

    guard let jsonData = try? JSONSerialization.data(withJSONObject: payload) else {
        print("Failed to serialize payload")
        completion(nil)
        return
    }

    request.httpBody = jsonData

    URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            print("Error fetching AI challenge: \(error.localizedDescription)")
            completion(nil)
            return
        }

        guard let data = data else {
            print("No data received")
            completion(nil)
            return
        }

        do {
            let challenge = try JSONDecoder().decode(Challenge.self, from: data)
            completion(challenge)
        } catch {
            print("Failed to decode response: \(error.localizedDescription)")
            completion(nil)
        }
    }.resume()
}

