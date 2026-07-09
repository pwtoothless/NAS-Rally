//
//  Settings.swift
//  NAS Rally
//
//  Created by Peyton Ward on 5/31/26.
//

import SwiftUI
import Auth
import Supabase

struct SettingsView: View {
    @Binding var person: PersonInfo
    let themes = ["Auto", "Blue", "Red"]
    
    var body: some View {
        VStack {
            Text("Settings")
                .padding(.horizontal, 15)
                .padding(.top, 10)
                .padding(.bottom, 10)
                .bold()
            
            List {
                // Profile Menu
                NavigationLink(destination: ProfileView(person: $person)) {
                    HStack {
                        Image(systemName: "person.crop.circle.fill")
                            .padding(.leading, 10)
                        Text("Profile")
                            .padding(.leading, 8)
                    }
                }
                
                // Theme Picker
                HStack {
                    Image(systemName: "photo.artframe")
                        .padding(.leading, 10)
                    
                    Picker("Select a Theme", selection: $person.theme) {
                        ForEach(themes, id: \.self) { themeName in
                            Text(themeName)
                        }
                    }
                    .padding(.leading, 8)
                    .pickerStyle(.menu)
                }
                
                // Payment Info
                NavigationLink(destination: CardView(person: $person)) {
                    HStack {
                        Image(systemName: "creditcard")
                            .padding(.leading, 10)
                        Text("Payment Info")
                            .padding(.leading, 8)
                    }
                }
                
                // ID View
                NavigationLink(destination: IDView(person: $person)) {
                    HStack {
                        Image(systemName: "person.text.rectangle")
                            .padding(.leading, 10)
                        Text("ID")
                            .padding(.leading, 8)
                    }
                }
                
                // Logout Option - IMPLEMENTED BELOW
                HStack {
                    Spacer()
                    Button("Logout") {
                        logout()
                    }
                    .buttonStyle(.bordered)
                    .foregroundColor(.primary)
                    Spacer()
                }
            }
            .glassEffectCompat(.regular, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
        }
    }
}

// MARK: - Logout Implementation

private func logout() {
    Task {
        do {
            // Sign out from Supabase authentication
            try await supabase.auth.signOut()
            
            // Clear the person binding (set to nil)
            // _ = $person
            
            // Navigate back to LoginView
            // This will be handled by the parent view's navigation stack
            
        } catch {
            print("Logout failed: \(error)")
        }
    }
}
