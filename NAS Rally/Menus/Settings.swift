//
//  Settings.swift
//  NAS Rally
//
//  Created by Peyton Ward on 5/31/26.
//

import SwiftUI

struct SettingsView: View {
    @Binding var person: PersonInfo
    let themes = ["Dark", "Light", "Blue", "Red"]
    
    var body: some View {
        NavigationStack {
            Text("Settings")
            VStack {
                // Profile Men
                HStack {
                    NavigationLink (destination: ProfileView(person: $person)) {
                        Image(systemName: "person.crop.circle.fill")
                            .padding(.leading, 10)
                        Text("Profile")
                            .padding(.leading, 8)
                        
                    }
                }
                .frame(width: 350, height: 55, alignment: .leading)
                .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
                
                HStack {
                    Text("Theme")
                        .padding(.leading, 10)
                    Picker("Select a Theme", selection: $person.theme) { // Corrected binding to person.theme
                        ForEach(themes, id: \.self) { themeName in // Corrected closure parameter name
                            Text(themeName) // Corrected to display individual themeName
                        }
                    }
                    .pickerStyle(.menu)
                    .padding(.leading, 8)
                }
                .frame(width: 350, height: 55, alignment: .leading)
                .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
            }
            .padding(.horizontal, 15)
        }
        Spacer()
    }
}
