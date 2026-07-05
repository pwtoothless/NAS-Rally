//
//  Chat.swift
//  NAS Rally
//	
//  Created by Peyton Ward on 5/31/26.
//

import SwiftUI

struct ChatView: View {
    @Binding var person: PersonInfo
    
    var body: some View {
        NavigationStack {
            Text("Chat")
                .padding(.top, 10)
                .padding(.bottom, 10)
                .bold()
            
            ForEach(0..<person.ralliesJoined, id: \.self) { idx in
                NavigationLink(destination: MessageView()) {
                    // Logo
                    
                    if person.rallieNames.indices.contains(idx) {
                        Image("RallyLogos/Logo" + person.rallieNames[idx])
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 125)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.white, lineWidth: 2))
                            .shadow(radius: 5)
                            .padding(.leading, 10)
                    }
                    else {
                        Image("RallyLogos/LogoUnknown")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 200)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.white, lineWidth: 2))
                            .shadow(radius: 5)
                            .padding(.leading, 10)
                    }
                    // Rally Name
                    
                    if person.rallieNames.indices.contains(idx) {
                        Text(person.rallieNames[idx])
                            .padding(.horizontal, 10)
                    }
                    else {
                        Text("")
                            .padding(.horizontal, 10)
                    }
                }
                .glassEffectCompat(.regular, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
            }
            Spacer()
        }
    }
}

struct MessageView: View {
    @State private var messageInput: String = ""
    
    var body: some View {
        GroupBox {
            VStack {
                VStack { // Top Section
                    Image("RallyLogos/Logo" + "NAS Rally")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 65, height: 70)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.white, lineWidth: 2))
                        .shadow(radius: 5)
                        .backgroundStyle(FillShapeStyle())
                        .glassEffectCompat(.regular)
                    
                    Text("NAS Rally")
                        .padding(.horizontal, 5)
                        .padding(.vertical, 3)
                        .glassEffectCompat(.regular, in: .capsule)
                }
                .frame(maxHeight: 90, alignment: .center)
                .padding(.vertical, 10)
                .padding(.horizontal, 8)
                .glassEffectCompat(.regular, in: RoundedRectangle(cornerRadius: 10, style: .continuous))
            
                Spacer() // Pushes content to fill the remaining area
                
                // Display a square of messages w/ names of people and profile pics to the left of peoples messages
                
                HStack { // Bottom Textbox Section
                    TextField("  Message", text: $messageInput)
                        .frame(minHeight: 30, alignment: .center)
                        .glassEffectCompat(.regular, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
                        .padding(.horizontal, 18)
                        .padding(.bottom, 8)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}
