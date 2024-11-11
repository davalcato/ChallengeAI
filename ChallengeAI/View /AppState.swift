//
//  AppState.swift
//  ChallengeAI
//
//  Created by Ethan Hunt on 11/10/24.
//

import SwiftUI
import Combine

// AppState model to manage global state
class AppState: ObservableObject {
    @Published var isLoggedIn: Bool
    
    init(isLoggedIn: Bool) {
        self.isLoggedIn = isLoggedIn
    }
}


//#Preview {
//    AppState(isLoggedIn: true)as! any View
//}
