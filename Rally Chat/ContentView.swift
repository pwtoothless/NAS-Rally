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
/// It provides access to the application's primary features:
/// - **Home**: The main landing view and dashboard.
/// - **Rallies**: An overview of upcoming and active rally events.
/// - **Chat**: Real-time messaging and discussion channels.
/// - **Profile**: User account details and personalization options.
/// - **Settings**: App preferences and configuration controls.

struct ContentView: View {
    var body: some View {
        TabView() {
            Tab("Home", systemImage: "house") {
                //HomeView()
            }
            Tab("Rallies", systemImage: "car.2.fill") {
                //RalliesView()
            }
            Tab("Chat", systemImage: "bubble.left.and.bubble.right") {
                //ChatView()
            }
            Tab("Profile", systemImage: "person.circle") {
                //ProfileView()
            }
            Tab("Settings", systemImage: "gearshape") {
                //SettingsView()
            }
        }
        .tabViewStyle(.sidebarAdaptable)
    }
}

#Preview {
    ContentView()
}
