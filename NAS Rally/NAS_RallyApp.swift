//
//  NAS_RallyApp.swift
//  NAS Rally
//
//  Created by Peyton Ward on 5/31/26.
//

import SwiftUI

@main
struct NAS_RallyApp: App {
    @State private var personInfo: PersonInfo? = nil
    @State private var isLoading = true
    
    var body: some Scene {
        WindowGroup {
            Group {
                if isLoading {
                    ProgressView("Loading Profile...")
                } else if let person = personInfo {
                    ContentView(person: Binding(
                        get: { person },
                        set: { personInfo = $0 }
                    ))
                } else {
                    LoginView(person: Binding(
                        get: { personInfo ?? PersonInfo(id: UUID(), name: "", theme: "", bio: "", ralliesJoined: 0, rallieNames: [], privligeLevel: "", tos: false) },
                        set: { personInfo = $0 }
                    ))
                }
            }
            .task {
                await loadSession()
            }
        }
    }
    
    private func loadSession() async {
        do {
            self.personInfo = try await fetchCurrentProfile()
        } catch {
            print("No active session or error fetching profile: \(error)")
        }
        self.isLoading = false
    }
}
