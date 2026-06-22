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
    @Binding var person: PersonInfo
    
    var body: some View {
        TabView() {
            Tab("Home", systemImage: "house") {
                HomeView(person: $person)
            }
            Tab("Rallies", systemImage: "car.2.fill") {
                RalliesView(person: $person)
            }
            Tab("Chat", systemImage: "bubble.left.and.bubble.right") {
                ChatView(person: $person)
            }
            Tab("Wavers", systemImage: "long.text.page.and.pencil") {
                WaversView(person: $person)
            }
            Tab("Settings", systemImage: "gearshape") {
                SettingsView(person: $person)
            }
            if (person.privligeLevel == "Admin") {
                Tab("Admin", systemImage: "person.badge.checkmark.seal.fill") {
                    AdminView(person: $person)
                }
            }
        }
        .tabViewStyle(.sidebarAdaptable)
    }
}
