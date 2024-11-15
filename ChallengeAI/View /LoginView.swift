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
    @StateObject private var loginData = LoginData() // Use StateObject for LoginData
    @State private var showErrorAlert = false
    @State private var showSuccessMessage = false
    @State private var showFailureMessage = false
    @State private var navigateToWelcome = false // State to trigger navigation
    @State private var showForgotPassword = false // State to show Forgot Password view

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

                // Login/Register Button with adjusted hit area
                Button(action: {
                    // Handle registration or login action
                    if loginData.registerUser {
                        if loginData.registerUserValid() {
                            loginData.register { success in
                                DispatchQueue.main.async {
                                    if success {
                                        navigateToWelcome = true // Trigger navigation on success
                                    } else {
                                        showFailureMessage = true
                                        showSuccessMessage = false
                                    }
                                }
                            }
                        } else {
                            showErrorAlert = true
                        }
                    } else {
                        if loginData.loginUserValid() {
                            loginData.login { success in
                                DispatchQueue.main.async {
                                    if success {
                                        navigateToWelcome = true // Trigger navigation on success
                                    } else {
                                        loginData.errorMessage = "Incorrect email or password."
                                        showErrorAlert = true
                                    }
                                }
                            }
                        } else {
                            showErrorAlert = true
                        }
                    }
                }) {
                    Text(loginData.registerUser ? "Register" : "Login")
                        .font(.title3)
                        .fontWeight(.bold)
                        .padding(.vertical, 15)  // Only vertical padding inside the button
                        .frame(maxWidth: .infinity)  // Let the button take full width
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal, 50)  // Padding outside the button does not affect hit area
                .contentShape(Rectangle()) // Ensures only the button is tappable

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

                // NavigationLink to WelcomeView
                NavigationLink(
                    destination: WelcomeView(),
                    isActive: $navigateToWelcome,
                    label: {
                        EmptyView() // Hidden NavigationLink
                    }
                )

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

                // Forgot Password Button
                Button(action: {
                    // Show the Forgot Password view
                    showForgotPassword.toggle()
                }) {
                    Text("Forgot Password?")
                        .foregroundColor(.blue)
                        .padding(.top, 10)
                }
                .sheet(isPresented: $showForgotPassword) {
                    ForgotPasswordView(showForgotPassword: $showForgotPassword)
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







