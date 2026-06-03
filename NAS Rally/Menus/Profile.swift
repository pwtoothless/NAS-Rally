//
//  Profile.swift
//  NAS Rally
//
//  Created by Peyton Ward on 5/31/26.
//

import SwiftUI
import PhotosUI

struct ProfileView: View {
    @Binding var person: PersonInfo
    @State private var editMode: Bool = false
    @State private var textInput = ""
    @FocusState private var isBioFeildFocused: Bool
    @FocusState private var isNameFeildFocused: Bool
    @State private var imageSelection: PhotosPickerItem? = nil
    
    var body: some View {
        VStack {
            HStack {
                Text("Profile")
                Button("Edit Mode") {
                    editMode.toggle()
                    if !editMode {
                        person.bio = textInput
                    }
                    else {
                        textInput = person.bio
                    }
                }
            }
            VStack {
                HStack {
                    VStack {
                        Image(.personPic)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 200)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.white, lineWidth: 2))
                            .shadow(radius: 5)
                            .overlay(alignment: .trailing) {
                                Button(action: {
                                }) {
                                    PhotosPicker(selection: $imageSelection, matching: .images, photoLibrary: .shared()) {
                                        EmptyView()
                                    }
                                    if (editMode) {
                                        Image(systemName: "pencil.circle.fill")
                                            .symbolRenderingMode(.multicolor)
                                            .font(.system(size: 30))
                                            .foregroundColor(.accentColor)
                                            .offset(y: 35)
                                    }
                                }
                                .buttonStyle(.borderless)
                            }
                    }
                    .padding(.trailing, 30)
                    
                    VStack {
                        if (editMode) {
                            TextField("Enter Name", text: $textInput)
                                .textFieldStyle(.roundedBorder)
                                .focused($isNameFeildFocused)
                            
                            Button("Edit Name") {
                                isNameFeildFocused = true
                            }
                            .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
                        }
                        else {
                            Text(person.name)
                        }
                    }
                }
                
                VStack {
                    HStack {
                        if (editMode) {
                            Text("Bio")
                                .padding(.leading, 15)
                            Spacer()
                            Button("Edit Bio") {
                                isBioFeildFocused = true
                            }
                            .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
                            .padding(.trailing, 15)
                        }
                        else {
                            Text("Bio")
                        }
                    }
                    if(!editMode) {
                        Text(person.bio)
                    }
                    else {
                        TextField("Enter bio", text: $textInput)
                            .textFieldStyle(.roundedBorder)
                            .focused($isBioFeildFocused)
                    }
                }
            }
            .foregroundColor(.primary)
            .padding(.leading, 25)
            .padding(.trailing, 25)
            .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
            
            Spacer()
        }
    }
}

// Add a preview for ProfileView for easier testing and development
#Preview {
    // Create a sample PersonInfo for the preview
    ProfileView(person: .constant(PersonInfo(name: "Sample Name", theme: "Default", bio: "Sample Text", ralliesJoined: 1, rallieNames: ["temp"], privligeLevel: "User")))
}
