//
//  ContentView.swift
//  Rally Chat
//
//  Created by Peyton Ward on 5/31/26.
//

import SwiftUI

/// The content and behavior of the main interface.
///
/// This property defines a tab-based navigation structure that adapts between
/// a standard tab bar and a sidebar depending on the platform and screen size.
/// It provides access to the primary features of the application:
/// - **Home**: The main landing view and dashboard.
/// - **Rallies**: An overview of upcoming and active rally events.
/// - **Chat**: Real-time messaging and discussion channels.
/// - **Profile**: User account details and personalization options.
/// - **Settings**: App preferences and configuration controls.

struct ContentView: View {
    // Example: Create a sample PersonInfo instance
    // In a real app, this data would likely come from a ViewModel,
    // User Defaults, or an API.
    @State private var samplePerson = PersonInfo(name: "Ivy Lucca-McCoy", id: 1, theme: "Default", bio: "This would be the bio", ralliesJoined: 1, rallieNames: ["temp"])

    var body: some View {
        TabView() {
            Tab("Home", systemImage: "house") {
                // Pass the samplePerson instance to HomeView
                HomeView(person: $samplePerson)
            }
            Tab("Rallies", systemImage: "car.2.fill") {
                RalliesView(person: $samplePerson)
            }
            Tab("Chat", systemImage: "bubble.left.and.bubble.right") {
                ChatView(person: $samplePerson)
            }
            Tab("Profile", systemImage: "person.circle") {
                ProfileView(person: $samplePerson)
            }
            Tab("Settings", systemImage: "gearshape") {
                SettingsView(person: $samplePerson)
            }
        }
        .tabViewStyle(.sidebarAdaptable)
    }
}

#Preview {
    ContentView()
}
