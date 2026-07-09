//
//  Admin.swift
//  NAS Rally
//
//  Created by Peyton Ward on 6/22/26.
//

import SwiftUI
import Foundation
import Supabase

struct AdminProfile: Codable, Identifiable {
    var id: UUID
    var name: String
    var bio: String
    var ralliesJoined: Int
    var rallieNames: [String]
    var privligeLevel: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case bio
        case ralliesJoined = "rallies_joined"
        case rallieNames = "rallie_names"
        case privligeLevel = "privilege_level"
    }
}

struct AdminView: View {
    @Binding var person: PersonInfo
    @State private var selectedTab = 0 // 0 = Users, 1 = Rallies, 2 = Permissions
    
    // Loaded data states
    @State private var users: [AdminProfile] = []
    @State private var rallies: [RallyRow] = []
    @State private var isLoading = false
    
    // Modal Presentation States
    @State private var selectedRally: RallyRow? = nil
    @State private var selectedUserForPermissions: AdminProfile? = nil
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            Text("Admin Dashboard")
                .font(.title2)
                .bold()
                .padding(.top, 16)
                .padding(.bottom, 12)
            
            // Custom Top Tab Bar
            HStack(spacing: 0) {
                tabButton(title: "Users", index: 0)
                tabButton(title: "Rallies", index: 1)
                tabButton(title: "Permissions", index: 2)
            }
            .background(Color.primary.opacity(0.05))
            .cornerRadius(12)
            .padding(.horizontal)
            .padding(.bottom, 16)
            
            // Tab Contents
            ZStack {
                if isLoading {
                    VStack(spacing: 12) {
                        ProgressView()
                        Text("Loading dashboard...")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxHeight: .infinity)
                } else {
                    switch selectedTab {
                    case 0:
                        UsersTabView(users: users)
                    case 1:
                        RalliesTabView(rallies: rallies, users: users, selectedRally: $selectedRally)
                    case 2:
                        PermissionsTabView(users: users, selectedUser: $selectedUserForPermissions)
                    default:
                        EmptyView()
                    }
                }
            }
        }
        .task {
            await loadAdminData()
        }
        .sheet(item: $selectedRally) { rally in
            RallyDetailSheet(rally: rally, allUsers: users)
        }
        .sheet(item: $selectedUserForPermissions) { user in
            PermissionDetailSheet(user: user, onSave: { updatedLevel in
                // Refresh local data to reflect database modifications
                Task {
                    await loadAdminData()
                }
            })
        }
    }
    
    private func tabButton(title: String, index: Int) -> some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                selectedTab = index
            }
        }) {
            Text(title)
                .font(.subheadline)
                .bold()
                .padding(.vertical, 10)
                .frame(maxWidth: .infinity)
                .foregroundColor(selectedTab == index ? .white : .primary)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(selectedTab == index ? Color.blue : Color.clear)
                )
                .padding(2)
        }
    }
    
    private func loadAdminData() async {
        isLoading = true
        do {
            // Fetch Profiles
            let fetchedProfiles: [AdminProfile] = try await supabase.from("profiles")
                .select()
                .execute()
                .value
            self.users = fetchedProfiles
            
            // Fetch Rallies
            let fetchedRallies: [RallyRow] = try await supabase.from("rallies")
                .select()
                .execute()
                .value
            self.rallies = fetchedRallies
        } catch {
            print("Error loading admin data: \(error)")
        }
        isLoading = false
    }
}

// MARK: - Users Tab View
struct UsersTabView: View {
    let users: [AdminProfile]
    
    var body: some View {
        List(users) { user in
            HStack(spacing: 12) {
                Image(systemName: "person.crop.circle.fill")
                    .font(.title2)
                    .foregroundColor(.secondary)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(user.name)
                        .font(.headline)
                    if !user.bio.isEmpty {
                        Text(user.bio)
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .lineLimit(1)
                    }
                }
                
                Spacer()
                
                Text(user.privligeLevel)
                    .font(.caption2)
                    .bold()
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(user.privligeLevel == "Admin" ? Color.red.opacity(0.1) : Color.blue.opacity(0.1))
                    .foregroundColor(user.privligeLevel == "Admin" ? .red : .blue)
                    .cornerRadius(8)
            }
            .padding(.vertical, 4)
        }
        .listStyle(.insetGrouped)
    }
}

// MARK: - Rallies Tab View
struct RalliesTabView: View {
    let rallies: [RallyRow]
    let users: [AdminProfile]
    @Binding var selectedRally: RallyRow?
    
    var body: some View {
        List(rallies) { rally in
            Button(action: {
                selectedRally = rally
            }) {
                HStack {
                    Image(systemName: "car.2.fill")
                        .foregroundColor(.blue)
                        .font(.title3)
                        .padding(.trailing, 4)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(rally.name)
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        let attendees = users.filter { $0.rallieNames.contains(rally.name) }.count
                        Text("\(attendees) participant\(attendees == 1 ? "" : "s")")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.vertical, 4)
            }
        }
        .listStyle(.insetGrouped)
    }
}

// MARK: - Rally Details Sheet
struct RallyDetailSheet: View {
    @Environment(\.dismiss) private var dismiss
    let rally: RallyRow
    let allUsers: [AdminProfile]
    
    var attendees: [AdminProfile] {
        allUsers.filter { $0.rallieNames.contains(rally.name) }
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Rally Header Logo Preview
                VStack(spacing: 12) {
                    AsyncImage(url: try? getRallyImageURL(for: rally.name)) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: 80, height: 80)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.white, lineWidth: 2))
                                .shadow(radius: 4)
                        case .failure:
                            Image(systemName: "car.fill")
                                .font(.title)
                                .foregroundColor(.gray)
                                .opacity(0.3)
                                .frame(width: 80, height: 80)
                                .background(Circle().fill(Color.gray.opacity(0.1)))
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.white, lineWidth: 2))
                                .shadow(radius: 4)
                        case .empty: // Corrected: Separated .empty case
                            ProgressView()
                                .frame(width: 55, height: 44)
                        @unknown default: // Corrected: Separated @unknown default and placed last
                            ProgressView()
                                .frame(width: 55, height: 44)
                                .frame(width: 80, height: 80)
                                .background(Circle().fill(Color.gray.opacity(0.1)))
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.white, lineWidth: 2))
                                .shadow(radius: 4)
                        }
                    }
                    
                    Text(rally.name)
                        .font(.title2)
                        .bold()
                }
                .padding(.vertical, 24)
                .frame(maxWidth: .infinity)
                .background(Color.primary.opacity(0.02))
                
                HStack {
                    Text("Attendees (\(attendees.count))")
                        .font(.headline)
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 16)
                .padding(.bottom, 8)
                
                if attendees.isEmpty {
                    VStack(spacing: 8) {
                        Image(systemName: "person.3.fill")
                            .font(.largeTitle)
                            .foregroundColor(.secondary.opacity(0.5))
                        Text("No participants registered yet.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxHeight: .infinity)
                } else {
                    List(attendees) { attendee in
                        HStack {
                            Image(systemName: "person.circle.fill")
                                .foregroundColor(.secondary)
                            Text(attendee.name)
                                .font(.body)
                            Spacer()
                            if attendee.privligeLevel == "Admin" {
                                Text("Admin")
                                    .font(.caption2)
                                    .bold()
                                    .padding(.horizontal, 6)
                                    .padding(.vertical, 2)
                                    .background(Color.red.opacity(0.1))
                                    .foregroundColor(.red)
                                    .cornerRadius(4)
                            }
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Rally Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Close") {
                        dismiss()
                    }
                }
            }
        }
    }
}

// MARK: - Permissions Tab View
struct PermissionsTabView: View {
    let users: [AdminProfile]
    @Binding var selectedUser: AdminProfile?
    
    var body: some View {
        List(users) { user in
            Button(action: {
                selectedUser = user
            }) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(user.name)
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        Text("Role: \(user.privligeLevel)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "slider.horizontal.3")
                        .foregroundColor(.blue)
                }
                .padding(.vertical, 4)
            }
        }
        .listStyle(.insetGrouped)
    }
}

// MARK: - Permission Details Sheet
struct PermissionDetailSheet: View {
    @Environment(\.dismiss) private var dismiss
    let user: AdminProfile
    let onSave: (String) -> Void
    
    // Database privilege level
    @State private var privilegeLevel: String
    
    // Hypothetical Permissions
    @State private var joinRallies = true
    @State private var sendMessages = true
    @State private var viewProfiles = true
    
    @State private var isSaving = false
    @State private var showSuccess = false
    @State private var errorMessage = ""
    
    init(user: AdminProfile, onSave: @escaping (String) -> Void) {
        self.user = user
        self.onSave = onSave
        self._privilegeLevel = State(initialValue: user.privligeLevel)
        
        // Set hypothetical defaults based on user privilege
        let isUserAdmin = user.privligeLevel == "Admin"
        self._joinRallies = State(initialValue: true)
        self._sendMessages = State(initialValue: true)
        self._viewProfiles = State(initialValue: true)
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("User Info")) {
                    HStack {
                        Text("Name")
                            .bold()
                        Spacer()
                        Text(user.name)
                            .foregroundColor(.secondary)
                    }
                }
                
                Section(header: Text("Database Permissions")) {
                    Picker("Role Level", selection: $privilegeLevel) {
                        Text("User").tag("User")
                        Text("Admin").tag("Admin")
                    }
                    .pickerStyle(.segmented)
                    .onChange(of: privilegeLevel) { newValue in
                        if newValue == "Admin" {
                            joinRallies = true
                            sendMessages = true
                            viewProfiles = true
                        }
                    }
                }
                
                Section(header: Text("Hypothetical Permissions (Simulated)")) {
                    Toggle("Can Join Rallies", isOn: $joinRallies)
                    Toggle("Can Send Messages", isOn: $sendMessages)
                    Toggle("Can View Other Profiles", isOn: $viewProfiles)
                }
                
                if !errorMessage.isEmpty {
                    Section {
                        Text(errorMessage)
                            .foregroundColor(.red)
                    }
                }
            }
            .navigationTitle("Edit Permissions")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        savePermissions()
                    }) {
                        if isSaving {
                            ProgressView()
                        } else {
                            Text("Save")
                                .bold()
                        }
                    }
                    .disabled(isSaving)
                }
            }
            .alert("Permissions Saved", isPresented: $showSuccess) {
                Button("OK") {
                    dismiss()
                }
            } message: {
                Text("Role updated in database to '\(privilegeLevel)'. Simulated options updated successfully.")
            }
        }
    }
    
    private func savePermissions() {
        isSaving = true
        errorMessage = ""
        
        Task {
            do {
                // Update the privilege_level column in public profiles table
                let updateData: [String: AnyEncodable] = [
                    "privilege_level": AnyEncodable(privilegeLevel)
                ]
                
                try await supabase.from("profiles")
                    .update(updateData)
                    .eq("id", value: user.id.uuidString)
                    .execute()
                
                onSave(privilegeLevel)
                showSuccess = true
            } catch {
                errorMessage = "Failed to update role: \(error.localizedDescription)"
            }
            isSaving = false
        }
    }
}
