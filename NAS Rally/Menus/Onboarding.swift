//
//  Onboarding.swift
//  NAS Rally
//
//  Created by Peyton Ward on 6/23/26.
//

import SwiftUI

struct OnboardingView: View {
    @Binding var person: PersonInfo
    
    var body: some View {
        VStack {
            Text("Onboarding")
                .padding(.top, 10)
                .padding(.bottom, 10)
                .bold()
            Text("Here you will fill out some information about yourself and car. After you provide this information you will be granted access to NAS Rally")
                .padding()
            Spacer()
        }
    }
}

struct TOSView: View {
    @Binding var person: PersonInfo
    
    var body: some View {
        VStack {
            Text("Terms of Service")
                .font(.largeTitle)
            Text("Please read and agree to the terms of service")
            // PDF pulled from storage bucket in Supabase
            
            Spacer()
            
            Button("Decline") {
                // Handle decline
            }
            .buttonStyle(.bordered)
            
            Button("Accept") {
                person.tos = true
                // Update Supabase or local state here
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}
