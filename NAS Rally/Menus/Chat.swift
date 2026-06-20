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
            NavigationLink(destination: MessageView()) {
                Text("Open Messages")
            }
        }
    }
}

struct MessageView: View {
    var body: some View {
        Text("Messages")
    }
}
