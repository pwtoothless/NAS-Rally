//
//  Sensitive Info.swift
//  NAS Rally
//
//  Created by Peyton Ward on 6/24/26.
//

import SwiftUI

struct CardView: View {
    @Binding var person: PersonInfo
    
    var body: some View {
        Text("Credit Card")
    }
}

struct IDView: View {
    @Binding var person: PersonInfo
    
    var body: some View {
        Text("ID")
    }
}
