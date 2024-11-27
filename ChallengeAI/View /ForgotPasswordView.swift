//
//  ForgotPasswordView.swift
//  ChallengeAI
//
//  Created by Ethan Hunt on 11/15/24.
//

import SwiftUI
import FirebaseAuth

struct ForgotPasswordView: View {
    @Binding var showForgotPassword: Bool
    @State private var email: String = ""
    @State private var successMessage: String = ""
    @State private var errorMessage: String = ""

    var body: some View {
        VStack {
            Text("Reset Your Password")
                .font(.title)
                .fontWeight(.bold)
                .padding()

            TextField("Enter your email", text: $email)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .disableAutocorrection(true)

            Button(action: resetPassword) {
                Text("Send Reset Link")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.top)

            if !successMessage.isEmpty {
                Text(successMessage)
                    .foregroundColor(.green)
                    .padding()
            }

            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }

            Spacer()

            Button(action: { showForgotPassword = false }) {
                Text("Cancel")
                    .foregroundColor(.blue)
                    .padding()
            }
        }
        .padding()
    }

    func resetPassword() {
        guard !email.isEmpty else {
            errorMessage = "Please enter an email address."
            successMessage = ""
            return
        }

        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                errorMessage = error.localizedDescription
                successMessage = ""
            } else {
                successMessage = "Password reset email sent successfully."
                errorMessage = ""
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    showForgotPassword = false
                }
            }
        }
    }
}


