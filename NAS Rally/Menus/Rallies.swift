//
//  Rallies.swift
//  NAS Rally
//
//  Created by Peyton Ward on 5/31/26.
//

import SwiftUI
import Supabase

struct DatabaseRally: Codable, Identifiable {
    let id: UUID
    let name: String
    let description: String?
}

struct RalliesView: View {
    @Binding var person: PersonInfo
    @State private var allRallies: [DatabaseRally] = []
    @State private var isLoading = false
    @State private var selectedRally: DatabaseRally? = nil
    
    var body: some View {
        NavigationStack {
            ZStack {
                if isLoading && allRallies.isEmpty {
                    VStack(spacing: 12) {
                        ProgressView()
                        Text("Loading rallies...")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxHeight: .infinity)
                } else {
                    List(allRallies) { rally in
                        Button(action: {
                            selectedRally = rally
                        }) {
                            HStack(spacing: 14) {
                                // Dynamic logo loading from public Supabase bucket
                                AsyncImage(url: try? getRallyImageURL(for: rally.name)) { phase in
                                    switch phase {
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 50, height: 50)
                                            .clipShape(Circle())
                                            .overlay(Circle().stroke(Color.white.opacity(0.2), lineWidth: 1))
                                    case .failure(_):
                                        Image(systemName: "car.circle.fill")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 50, height: 50)
                                            .foregroundColor(.gray)
                                            .opacity(0.5)
                                            .clipShape(Circle())
                                    case .empty:
                                        ProgressView()
                                            .frame(width: 50, height: 50)
                                    @unknown default:
                                        ProgressView()
                                            .frame(width: 50, height: 50)
                                    }
                                }
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(rally.name)
                                        .font(.headline)
                                        .foregroundColor(.primary)
                                    
                                    // Join Status representation
                                    let isJoined = person.rallieNames.contains(rally.name)
                                    HStack(spacing: 4) {
                                        Text("Join Status:")
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                        Text(isJoined ? "Joined" : "Not Joined")
                                            .font(.subheadline)
                                            .bold()
                                            .foregroundColor(isJoined ? .green : .red)
                                    }
                                }
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            .padding(.vertical, 4)
                        }
                    }
                    .listStyle(.plain)
                    .refreshable {
                        await fetchAllRallies()
                    }
                }
            }
            .navigationTitle("Rallies")
            .task {
                await fetchAllRallies()
            }
            .sheet(item: $selectedRally) { rally in
                RallyUserDetailSheet(rally: rally, person: $person)
            }
        }
    }
    
    private func fetchAllRallies() async {
        isLoading = true
        do {
            let rows: [DatabaseRally] = try await supabase.from("rallies")
                .select()
                .execute()
                .value
            self.allRallies = rows
        } catch {
            print("Error loading rallies: \(error)")
        }
        isLoading = false
    }
}

// MARK: - Rally User Details Sheet
struct RallyUserDetailSheet: View {
    @Environment(\.dismiss) private var dismiss
    let rally: DatabaseRally
    @Binding var person: PersonInfo
    
    @State private var attendeeCount = 0
    @State private var isLoadingCount = false
    @State private var isSendingRequest = false
    @State private var showToast = false
    @State private var toastMessage = ""
    
    var isJoined: Bool {
        person.rallieNames.contains(rally.name)
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Top area with logo on left, name centered, attendee counter on right
                HStack(alignment: .top) {
                    // Rally logo big in the top left
                    AsyncImage(url: try? getRallyImageURL(for: rally.name)) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(width: 90, height: 90)
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                                .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.white.opacity(0.2), lineWidth: 1))
                                .shadow(radius: 4)
                        case .failure(_):
                            Image(systemName: "car.fill")
                                .font(.system(size: 40))
                                .foregroundColor(.gray)
                                .opacity(0.3)
                                .frame(width: 90, height: 90)
                                .background(RoundedRectangle(cornerRadius: 16).fill(Color.gray.opacity(0.1)))
                        case .empty:
                            Image(systemName: "car.fill")
                                .font(.system(size: 40))
                                .foregroundColor(.gray)
                                .opacity(0.3)
                                .frame(width: 90, height: 90)
                                .background(RoundedRectangle(cornerRadius: 16).fill(Color.gray.opacity(0.1)))
                        @unknown default:
                            Image(systemName: "car.fill")
                                .font(.system(size: 40))
                                .foregroundColor(.gray)
                                .opacity(0.3)
                                .frame(width: 90, height: 90)
                                .background(RoundedRectangle(cornerRadius: 16).fill(Color.gray.opacity(0.1)))
                        }
                    }
                    
                    Spacer()
                    
                    // Name centered along the top
                    Text(rally.name)
                        .font(.title2)
                        .bold()
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                        .padding(.top, 10)
                    
                    Spacer()
                    
                    // Attendees Count in top right (padded from edge)
                    VStack(alignment: .center, spacing: 4) {
                        if isLoadingCount {
                            ProgressView()
                                .scaleEffect(0.8)
                        } else {
                            Text("\(attendeeCount)")
                                .font(.title3)
                                .bold()
                                .foregroundColor(.blue)
                            
                            Text("Attending")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.top, 8)
                    .frame(width: 70)
                }
                .padding(.horizontal)
                .padding(.vertical, 20)
                .background(Color.primary.opacity(0.02))
                
                Divider()
                
                // Description of the rally
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("About the Rally")
                            .font(.headline)
                            .padding(.top, 16)
                        
                        Text(rally.description ?? "Welcome to the \(rally.name) rally! Join us for a thrilling experience filled with automotive adventure, scenic routes, and camaraderie with fellow car enthusiasts. Detailed maps and schedules will be provided upon approval.")
                            .font(.body)
                            .foregroundColor(.secondary)
                            .lineSpacing(4)
                    }
                    .padding(.horizontal)
                }
                
                Spacer()
                
                // Join Event button at the bottom
                Button(action: {
                    sendJoinRequest()
                }) {
                    HStack {
                        if isSendingRequest {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .padding(.trailing, 8)
                        }
                        Text(isJoined ? "Already Joined" : (isSendingRequest ? "Sending Request..." : "Join Event"))
                            .bold()
                            .foregroundColor(.white)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(isJoined ? Color.gray : Color.blue)
                    .cornerRadius(12)
                    .shadow(color: isJoined ? Color.clear : Color.blue.opacity(0.3), radius: 8, x: 0, y: 4)
                }
                .disabled(isJoined || isSendingRequest)
                .padding(.horizontal)
                .padding(.bottom, 24)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Close") {
                        dismiss()
                    }
                }
            }
            .overlay {
                if showToast {
                    VStack {
                        HStack {
                            Image(systemName: "paperplane.fill")
                                .foregroundColor(.blue)
                            Text(toastMessage)
                                .font(.subheadline)
                                .bold()
                            Spacer()
                        }
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 12).fill(.ultraThinMaterial))
                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.blue.opacity(0.3), lineWidth: 1))
                        .padding()
                        .transition(.move(edge: .top).combined(with: .opacity))
                        
                        Spacer()
                    }
                    .animation(.spring(), value: showToast)
                }
            }
            .task {
                await fetchAttendeeCount()
            }
        }
    }
    
    private func fetchAttendeeCount() async {
        isLoadingCount = true
        do {
            struct GroupRow: Decodable {
                let id: UUID
            }
            
            // 1. Fetch group_id by matching name
            let groups: [GroupRow] = try await supabase.from("groups")
                .select("id")
                .eq("name", value: rally.name)
                .execute()
                .value
            
            if let groupId = groups.first?.id {
                // 2. Fetch member count from group_members
                struct GroupMemberRow: Decodable {
                    let user_id: UUID
                }
                let members: [GroupMemberRow] = try await supabase.from("group_members")
                    .select("user_id")
                    .eq("group_id", value: groupId)
                    .execute()
                    .value
                self.attendeeCount = members.count
            }
        } catch {
            print("Error loading attendee count: \(error)")
        }
        isLoadingCount = false
    }
    
    private func sendJoinRequest() {
        isSendingRequest = true
        
        Task {
            // --- MOCK JOIN REQUEST UPLOAD LOGIC ---
            // In a production environment:
            // Since the request function hasn't been implemented yet,
            // we will simulate the delay of sending an invitation/request row
            // to a 'rally_requests' table in database for Admin approval.
            
            try? await Task.sleep(nanoseconds: 1_200_000_000)
            
            toastMessage = "Join request sent to Admin!"
            showToast = true
            
            try? await Task.sleep(nanoseconds: 2_000_000_000)
            showToast = false
            dismiss()
            isSendingRequest = false
        }
    }
}
