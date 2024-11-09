//
//  LoginView.swift
//  ChallengeAI
//
//  Created by Ethan Hunt on 10/1/24.
//

import SwiftUI

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

// LoginView Component
struct LoginView: View {
    @StateObject private var loginData = LoginData() // Use StateObject for LoginData
    @State private var showErrorAlert = false
    @State private var showSuccessMessage = false
    @State private var showFailureMessage = false
    @State private var appState = AppState() // Initialize the AppState

    var body: some View {
        NavigationView {
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

                Button(action: {
                    // Handle registration or login action
                    if loginData.registerUser {
                        if loginData.registerUserValid() {
                            loginData.register { success in
                                DispatchQueue.main.async {
                                    if success {
                                        print("Registration successful")
                                        showSuccessMessage = true
                                        showFailureMessage = false
                                        appState.isLoggedIn = true
                                    } else {
                                        print("Registration failed")
                                        showFailureMessage = true
                                        showSuccessMessage = false
                                    }
                                }
                            }
                        } else {
                            loginData.errorMessage = "Please make sure all fields are filled and passwords match."
                            showErrorAlert = true
                        }
                    } else {
                        if loginData.loginUserValid() {
                            loginData.login { success in
                                DispatchQueue.main.async {
                                    if success {
                                        appState.isLoggedIn = true
                                    } else {
                                        loginData.errorMessage = "Incorrect email or password."
                                        showErrorAlert = true
                                    }
                                }
                            }
                        } else {
                            loginData.errorMessage = "Email and password cannot be empty."
                            showErrorAlert = true
                        }
                    }
                }) {
                    Text(loginData.registerUser ? "Register" : "Login")
                        .font(.title3)
                        .fontWeight(.bold)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal, 50)
                }
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

                // Google Sign-In Button (no functionality implemented)
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
                .padding(.top)

                // Facebook Login Button (no functionality implemented)
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
                .padding(.top, 10)

                // Toggle between login and registration
                Button(action: {
                    withAnimation {
                        loginData.registerUser.toggle()
                        // Clear password fields when switching to login
                        if !loginData.registerUser {
                            loginData.password = ""
                            loginData.reEnterPassword = ""
                        }
                    }
                }) {
                    Text(loginData.registerUser ? "Already have an account? Login" : "Don't have an account? Register")
                        .foregroundColor(.blue)
                        .padding(.top, 10)
                        .cornerRadius(8)
                }

                Spacer()
            }
            .navigationBarHidden(true)
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
    }
}

// Assuming you have a LoginData model
class LoginData: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var reEnterPassword: String = ""
    @Published var registerUser: Bool = false
    @Published var showPassword: Bool = false
    @Published var showReEnterPassword: Bool = false
    @Published var errorMessage: String = ""

    func registerUserValid() -> Bool {
        // Implement validation logic
        return !email.isEmpty && !password.isEmpty && (password == reEnterPassword)
    }

    func loginUserValid() -> Bool {
        // Implement validation logic
        return !email.isEmpty && !password.isEmpty
    }

    func register(completion: (Bool) -> Void) {
        // Implement registration logic
        completion(true)
    }

    func login(completion: (Bool) -> Void) {
        // Implement login logic
        completion(true)
    }
}

// Assuming you have an AppState model
class AppState: ObservableObject {
    @Published var isLoggedIn: Bool = false
}

// Preview for the LoginView
struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}







