//
//  ContentView.swift
//  ChallengeAI
//
//  Created by Ethan Hunt on 10/1/24.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    // Fetch items from Core Data
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>

    @EnvironmentObject var appState: AppState // Use shared AppState from the parent
    @State private var userPreferences: UserPreferences // User preferences
    @State private var showPreferencesView = false // Control navigation to PreferencesView

    // Initialize userPreferences in the initializer to handle decoding errors
    init() {
        do {
            let jsonData = """
            {
                "difficulty": "Easy",
                "topics": ["General Knowledge"],
                "challengeType": "Text",
                "frequency": "Daily"
            }
            """.data(using: .utf8)!
            let decoder = JSONDecoder()
            _userPreferences = State(initialValue: try decoder.decode(UserPreferences.self, from: jsonData))
        } catch {
            // Provide fallback values if decoding fails
            _userPreferences = State(initialValue: UserPreferences(
                difficulty: "Easy",
                topics: ["General Knowledge"],
                challengeType: "Text",
                frequency: "Daily"
            ))
        }
    }

    var body: some View {
        Group {
            if appState.isLoggedIn {
                if #available(iOS 16.0, *) {
                    NavigationStack {
                        if showPreferencesView {
                            PreferencesView(userPreferences: $userPreferences)
                                .onDisappear {
                                    // Once preferences are set, stop showing PreferencesView
                                    showPreferencesView = false
                                }
                        } else {
                            MainAppView(userPreferences: $userPreferences, onLogout: logout)
                                .onAppear {
                                    // Check if preferences are set, otherwise show PreferencesView
                                    if userPreferences.topics.isEmpty || userPreferences.difficulty.isEmpty {
                                        showPreferencesView = true
                                    }
                                }
                        }
                    }
                } else {
                    // Fallback on earlier versions
                    Text("Unsupported iOS version.")
                }
            } else {
                // Show OnboardingView when the user is not logged in
                OnboardingView()
            }
        }
    }

    // Logout function to update AppState and UserDefaults
    private func logout() {
        withAnimation {
            appState.isLoggedIn = false
            UserDefaults.standard.set(false, forKey: "isLoggedIn")
        }
    }

    // Add a new item to Core Data
    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()

            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    // Delete selected items from Core Data
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

#Preview {
    ContentView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        .environmentObject(AppState(isLoggedIn: UserDefaults.standard.bool(forKey: "isLoggedIn")))
}




