//
//  LoginView.swift
//  ChallengeAI
//
//  Created by Ethan Hunt on 10/1/24.
//

import SwiftUI
import KeychainSwift
import FirebaseAuth

// CustomTextField Component
struct CustomTextField: View {
    var icon: String
    var title: String
    var hint: String
    @Binding var value: String
    var isSecure: Bool
    @Binding var showPassword: Bool

    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 15) {
                Image(systemName: icon)
                    .foregroundColor(.gray)

                if isSecure && !showPassword {
                    SecureField(hint, text: $value)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                } else {
                    TextField(hint, text: $value)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                }

                // Password visibility toggle for secure fields
                if isSecure {
                    Button(action: {
                        showPassword.toggle()
                    }) {
                        Image(systemName: showPassword ? "eye.slash.fill" : "eye.fill")
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 10).strokeBorder(Color.gray, lineWidth: 1))
        }
    }
}


struct LoginView: View {
    @StateObject private var loginData = LoginData()
    @State private var showErrorAlert = false
    @State private var showSuccessMessage = false
    @State private var showFailureMessage = false
    @State private var navigateToWelcome = false
    @State private var showForgotPassword = false

    var body: some View {
        VStack {
            Spacer()

            Image(systemName: "person.circle")
                .font(.system(size: 100))
                .foregroundColor(.blue)

            Text(loginData.registerUser ? "Register" : "Login")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.bottom, 20)

            CustomTextField(
                icon: "envelope",
                title: "Email",
                hint: "example@example.com",
                value: $loginData.email,
                isSecure: false,
                showPassword: .constant(false)
            )
            .padding(.horizontal, 50)

            CustomTextField(
                icon: "lock",
                title: "Password",
                hint: "Enter your password",
                value: $loginData.password,
                isSecure: true,
                showPassword: $loginData.showPassword
            )
            .padding(.horizontal, 50)
            .padding(.bottom, 20)

            if loginData.registerUser {
                CustomTextField(
                    icon: "lock",
                    title: "Re-enter Password",
                    hint: "Re-enter your password",
                    value: $loginData.reEnterPassword,
                    isSecure: true,
                    showPassword: $loginData.showReEnterPassword
                )
                .padding(.horizontal, 50)
                .padding(.bottom, 20)
            }

            Button(action: handleLoginOrRegister) {
                Text(loginData.registerUser ? "Register" : "Login")
                    .font(.title3)
                    .fontWeight(.bold)
                    .padding(.vertical, 15)
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.horizontal, 50)
            .contentShape(Rectangle())
            .alert(isPresented: $showErrorAlert) {
                Alert(title: Text("Error"), message: Text(loginData.errorMessage), dismissButton: .default(Text("OK")))
            }

            if showSuccessMessage {
                Text("Registration successful!")
                    .foregroundColor(.green)
                    .padding(.top, 10)
            }

            if showFailureMessage {
                Text("Registration failed. Please try again.")
                    .foregroundColor(.red)
                    .padding(.top, 10)
            }

            NavigationLink(destination: WelcomeView(), isActive: $navigateToWelcome) {
                EmptyView()
            }

            SocialLoginButtons()
                .padding(.top, 10)

            Button(action: toggleRegisterLoginMode) {
                Text(loginData.registerUser ? "Already have an account? Login" : "Don't have an account? Register")
                    .foregroundColor(.blue)
                    .padding(.top, 10)
            }

            Button(action: { showForgotPassword.toggle() }) {
                Text("Forgot Password?")
                    .foregroundColor(.blue)
                    .padding(.top, 10)
            }
            .sheet(isPresented: $showForgotPassword) {
                ForgotPasswordView(showForgotPassword: $showForgotPassword)
            }

            Spacer()
        }
        .navigationBarHidden(true) // Ensure the navigation bar is hidden
        .background(
            GeometryReader { _ in
                Color.clear
                    .contentShape(Rectangle())
                    .onTapGesture {
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    }
            }
        )
    }

    private func handleLoginOrRegister() {
        if loginData.registerUser {
            if loginData.registerUserValid() {
                loginData.register { success in
                    if success {
                        navigateToWelcome = true
                    } else {
                        showFailureMessage = true
                    }
                }
            } else {
                showErrorAlert = true
            }
        } else {
            if loginData.loginUserValid() {
                loginData.login { success in
                    if success {
                        navigateToWelcome = true
                    } else {
                        showErrorAlert = true
                    }
                }
            } else {
                showErrorAlert = true
            }
        }
    }

    private func toggleRegisterLoginMode() {
        withAnimation {
            loginData.registerUser.toggle()
            if !loginData.registerUser {
                loginData.password = ""
                loginData.reEnterPassword = ""
            }
        }
    }
}


struct SocialLoginButtons: View {
    var body: some View {
        VStack {
            Button(action: {
                // Implement Google sign-in functionality
            }) {
                HStack {
                    Image(systemName: "globe")
                    Text("Sign in with Google")
                }
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .frame(width: 300, height: 50)
                .background(Color.red)
                .cornerRadius(8)
            }

            Button(action: {
                // Implement Facebook sign-in functionality
            }) {
                HStack {
                    Image(systemName: "f.circle")
                    Text("Sign in with Facebook")
                }
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .frame(width: 300, height: 50)
                .background(Color.blue)
                .cornerRadius(8)
            }
        }
    }
}




// Assuming you have an AppState model
//class AppState: ObservableObject {
//    @Published var isLoggedIn: Bool = false
//}
//
//// Preview for the LoginView
//struct LoginView_Previews: PreviewProvider {
//    static var previews: some View {
//        LoginView()
//    }
//}







