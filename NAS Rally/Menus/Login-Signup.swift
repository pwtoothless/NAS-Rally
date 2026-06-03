//
//  Login-Signup.swift
//  NAS Rally
//
//  Created by Peyton Ward on 6/2/26.
//

import SwiftUI

// Login Screen Code below

struct LoginView: View {
    @Binding var person: PersonInfo
    @State private var EmailInput = ""
    @State private var PassInput = ""
    
    var body: some View {
        VStack {
            Text("Login")
                .font(.largeTitle)
            
            VStack {
                Image(.nasLogo)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 100)
                
                TextField("Email", text: $EmailInput)
                    .textFieldStyle(.roundedBorder)
                TextField("Password", text: $PassInput)
                    .textFieldStyle(.roundedBorder)
            }
            .padding(.leading, 25)
            .padding(.trailing, 25)
            
            Button("Login") {
                if (login(userEmail: EmailInput, userPassword: PassInput)) {
                    ContentView(person: $person)
                }
                else {
                    // Show Login Fail popup Here
                }
            }
            .frame(width: 50, height: 75)
            
            Spacer()
        }
    }
}

// Signup Screen Code below

struct SignupView: View {
    var body: some View {
        Text("Signup")
    }
}


func login(userEmail : String, userPassword : String) -> Bool {
    // Use SupaBase Auth Here
    // If Succesfull then save data and return true
    // Else false
    return false
}

func signup(userEmail : String, userPassword : String, userName : String) -> Bool {
    return true
}
