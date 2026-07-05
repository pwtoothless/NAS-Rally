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
    @State private var bioInput: String
    @State private var nameInput: String
    @State private var imageSelection: PhotosPickerItem? = nil
    @State private var isSaving: Bool = false
    @State private var profileImageURL: URL? = nil
    
    init(person: Binding<PersonInfo>) {
        self._person = person
        self._bioInput = State(initialValue: person.wrappedValue.bio)
        self._nameInput = State(initialValue: person.wrappedValue.name)
    }
    
    var body: some View {
        VStack {
            HStack {
                Text("Profile")
                Spacer()
                Button(editMode ? (isSaving ? "Saving..." : "Save") : "Edit") {
                    if editMode {
                        isSaving = true
                        person.name = nameInput
                        person.bio = bioInput
                        
                        Task {
                            do {
                                try await updateProfile(person: person)
                                editMode = false
                            } catch {
                                print("Failed to update profile: \(error)")
                            }
                            isSaving = false
                        }
                    } else {
                        editMode = true
                    }
                }
                .disabled(isSaving)
            }
            .padding()
            
            VStack(spacing: 20) {
                AsyncImage(url: profileImageURL) { phase in
                    switch phase {
                    case .empty:
                        ProgressView().frame(width: 100, height: 100)
                    case .success(let image):
                        image.resizable().scaledToFill().frame(width: 100, height: 100).clipShape(Circle())
                    case .failure:
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .foregroundStyle(.gray)
                            .frame(width: 100, height: 100)
                    @unknown default:
                        EmptyView()
                    }
                }
                
                if editMode {
                    TextField("Name", text: $nameInput)
                        .textFieldStyle(.roundedBorder)
                    TextField("Bio", text: $bioInput)
                        .textFieldStyle(.roundedBorder)
                } else {
                    Text(person.name).font(.title)
                    Text(person.bio)
                }
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 24).fill(.ultraThinMaterial))
            
            Spacer()
        }
        .task {
            do {
                self.profileImageURL = try await getProfileImageURL(for: person.id)
            } catch {
                print("Failed to load image URL: \(error)")
            }
        }
    }
}
