//
//  ProfileView.swift
//  ChallengeAI
//
//  Created by Ethan Hunt on 11/15/24.
//

import SwiftUI
import PhotosUI

struct ProfileView: View {
    @Binding var userPreferences: UserPreferences
    @State private var showSuccessMessage = false
    @State private var isPickerPresented = false
    @State private var profileImage: UIImage? = loadSavedImage() // Load saved image on startup

    var body: some View {
        NavigationView {
            ZStack {
                // Background gradient
                LinearGradient(gradient: Gradient(colors: [.blue.opacity(0.7), .purple.opacity(0.7)]), startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()

                VStack(spacing: 20) {
                    // Profile header with tappable photo
                    HStack {
                        ZStack {
                            if let profileImage = profileImage {
                                Image(uiImage: profileImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 80, height: 80)
                                    .clipShape(Circle())
                                    .shadow(radius: 10)
                                    .onTapGesture {
                                        isPickerPresented = true
                                    }
                            } else {
                                Image(systemName: "person.circle.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 80, height: 80)
                                    .foregroundColor(.white)
                                    .onTapGesture {
                                        isPickerPresented = true
                                    }
                            }
                        }

                        Text("Profile Page")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                    .padding()

                    // Navigation button with animation
                    NavigationLink(destination: PreferencesView(userPreferences: $userPreferences)) {
                        Text("Edit Preferences")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                LinearGradient(gradient: Gradient(colors: [.purple, .blue]), startPoint: .leading, endPoint: .trailing)
                            )
                            .foregroundColor(.white)
                            .cornerRadius(12)
                            .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 5)
                            .scaleEffect(showSuccessMessage ? 1.1 : 1.0)
                            .animation(.easeInOut(duration: 0.3), value: showSuccessMessage)
                    }
                    .padding(.horizontal)

                    // Display updated preferences with sleek styling
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Your Preferences")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)

                        ProfilePreferenceRow(title: "Difficulty", value: userPreferences.difficulty)
                        ProfilePreferenceRow(title: "Topics", value: userPreferences.topics.joined(separator: ", "))
                        ProfilePreferenceRow(title: "Challenge Type", value: userPreferences.challengeType)
                    }
                    .padding()
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(12)
                    .padding(.horizontal)

                    // Success message feedback
                    if showSuccessMessage {
                        Text("Preferences updated successfully!")
                            .font(.callout)
                            .foregroundColor(.green)
                            .transition(.opacity)
                            .padding()
                    }
                }
                .navigationTitle("Profile")
            }
            .sheet(isPresented: $isPickerPresented) {
                PhotoPicker(profileImage: $profileImage)
            }
        }
        .onAppear {
            // Trigger a subtle animation on load
            withAnimation(.spring()) {
                showSuccessMessage = true
            }
        }
        .onChange(of: profileImage) { newImage in
            if let newImage = newImage {
                saveImage(newImage)
            }
        }
    }
}

// MARK: - Photo Picker
struct PhotoPicker: UIViewControllerRepresentable {
    @Binding var profileImage: UIImage?

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 1
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: PhotoPicker

        init(_ parent: PhotoPicker) {
            self.parent = parent
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)
            guard let provider = results.first?.itemProvider, provider.canLoadObject(ofClass: UIImage.self) else { return }

            provider.loadObject(ofClass: UIImage.self) { image, _ in
                DispatchQueue.main.async {
                    self.parent.profileImage = image as? UIImage
                }
            }
        }
    }
}

// MARK: - File Management
func saveImage(_ image: UIImage) {
    guard let data = image.jpegData(compressionQuality: 0.8),
          let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
        return
    }

    let fileURL = directory.appendingPathComponent("profile_image.jpg")
    do {
        try data.write(to: fileURL)
        print("Image saved successfully!")
    } catch {
        print("Error saving image: \(error)")
    }
}

func loadSavedImage() -> UIImage? {
    guard let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
        return nil
    }

    let fileURL = directory.appendingPathComponent("profile_image.jpg")
    if FileManager.default.fileExists(atPath: fileURL.path) {
        return UIImage(contentsOfFile: fileURL.path)
    }
    return nil
}

// MARK: - Profile Preference Row
struct ProfilePreferenceRow: View {
    var title: String
    var value: String

    var body: some View {
        HStack {
            Text("\(title):")
                .font(.subheadline)
                .fontWeight(.bold)
                .foregroundColor(.white)
            Spacer()
            Text(value)
                .font(.subheadline)
                .foregroundColor(.white)
        }
        .padding(.horizontal)
    }
}

#Preview {
    ProfileView(userPreferences: .constant(UserPreferences(
        difficulty: "Easy",
        topics: ["General Knowledge", "Science"],
        challengeType: "Text",
        frequency: "Daily"
    )))
}





