//
//  Admin.swift
//  NAS Rally
//
//  Created by Peyton Ward on 6/22/26.
//

//  This will contain all of the code for adding new rallies and other admin abilities
import SwiftUI
import Foundation
import Auth

struct AdminView: View {
    @Binding var person: PersonInfo
    
    var body: some View {
        Text("Admin")
            .padding(.top, 10)
            .padding(.bottom, 10)
            .bold()
    }
}
