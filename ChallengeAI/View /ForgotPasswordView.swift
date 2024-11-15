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
            Text("Reset your password")
                .font(.title)
                .padding()
            
            TextField("Enter your email", text: $email)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.emailAddress)
            
            Button(action: {
                resetPassword()
            }) {
                Text("Reset Password")
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
        }
        .padding()
    }
    
    func resetPassword() {
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


#Preview {
    ForgotPasswordView(showForgotPassword: .constant(true))
}

