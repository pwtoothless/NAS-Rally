//
//  Home.swift
//  NAS Rally
//
//  Created by Peyton Ward on 5/31/26.
//

import SwiftUI

struct HomeView: View {
    @Binding var person: PersonInfo

    var body: some View {
        VStack {
            Text("Home")
            
            // Main Page
            HStack {
                Image(.personPic)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 200)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 2))
                    .shadow(radius: 5)
                
                Text("Hi, " + person.name)
                    .padding()
                    .font(.headline)
            }
            .foregroundColor(.primary)
            .frame(width: .infinity, height: 150)
            .padding(.leading, 15)
            .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
        }
        Text("Updates for user go here")
        Spacer() // Top Aligns the Page
    }
}
