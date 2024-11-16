//
//  LoginData.swift
//  ChallengeAI
//
//  Created by Ethan Hunt on 11/15/24.
//

import Foundation
import KeychainSwift
import Combine


class LoginData: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var reEnterPassword: String = ""
    @Published var showPassword: Bool = false
    @Published var showReEnterPassword: Bool = false
    @Published var errorMessage: String = ""
    @Published var isLoggedIn: Bool = false
    @Published var registerUser: Bool = false

    private let keychain = KeychainSwift()

    // Helper method to validate email format using regex
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }

    // Helper method to check password length
    func isPasswordLengthValid(_ password: String) -> Bool {
        return password.count >= 6
    }

    // Method to validate registration credentials
    func registerUserValid() -> Bool {
        if email.isEmpty || password.isEmpty || reEnterPassword.isEmpty {
            errorMessage = "Please fill out all fields."
            return false
        } else if !isValidEmail(email) {
            errorMessage = "Invalid email format."
            return false
        } else if !isPasswordLengthValid(password) {
            errorMessage = "Password must be at least 6 characters long."
            return false
        } else if password != reEnterPassword {
            errorMessage = "Passwords do not match."
            return false
        }
        return true
    }

    // Method to validate login credentials
    func loginUserValid() -> Bool {
        if email.isEmpty || password.isEmpty {
            errorMessage = "Email and password cannot be empty."
            return false
        } else if !isValidEmail(email) {
            errorMessage = "Invalid email format."
            return false
        } else if !isPasswordLengthValid(password) {
            errorMessage = "Password must be at least 6 characters long."
            return false
        }
        return true
    }

    // Register user with Keychain storage
    func register(completion: @escaping (Bool) -> Void) {
        if registerUserValid() {
            // Storing credentials securely using Keychain
            keychain.set(email, forKey: "email")
            keychain.set(password, forKey: "password")
            print("Registration successful: \(email)")
            completion(true)
        } else {
            completion(false)
        }
    }

    // Login user by checking credentials against stored Keychain values
    func login(completion: @escaping (Bool) -> Void) {
        // Retrieve stored credentials from Keychain
        guard let storedEmail = keychain.get("email"), let storedPassword = keychain.get("password") else {
            errorMessage = "No stored credentials found. Please register first."
            completion(false)
            return
        }

        // Validate entered email and password
        if loginUserValid() {
            // Check if the entered credentials match the stored credentials
            if email == storedEmail && password == storedPassword {
                isLoggedIn = true
                print("Login successful!")
                completion(true)
            } else {
                errorMessage = "Incorrect email or password. Please try again."
                print("Login failed: \(email)")
                completion(false)
            }
        } else {
            completion(false)
        }
    }

    // Method to clear stored credentials (for logout or account deletion)
    func clearCredentials() {
        keychain.delete("email")
        keychain.delete("password")
        isLoggedIn = false
        print("Credentials cleared from Keychain.")
    }
}
