//
//  Supabase.swift
//  NAS Rally
//
//  Created by Peyton Ward on 6/2/26.
//

import Foundation
import Supabase

let supabase = SupabaseClient(
    supabaseURL: URL(string: "http://24.19.76.199:8000")!,
    supabaseKey: "sb_publishable_xflKOJnjZKIKm7f_Ri4Bn4_7-zhLiVC"
)

// Helper struct for encoding dynamic values
struct AnyEncodable: Encodable {
    private let encode: (Encoder) throws -> Void

    init<T: Encodable>(_ value: T) {
        self.encode = { encoder in try value.encode(to: encoder) }
    }

    func encode(to encoder: Encoder) throws {
        try encode(encoder)
    }
}


// MARK: - Helper Function for Logout (can be moved to Supabase.swift)
func logout() async {
    try? await supabase.auth.signOut()
}

nonisolated private struct SupabasePersonRow: Codable {
    var id: UUID
    var name: String
    var theme: String
    var bio: String
    var ralliesJoined: Int
    var rallieNames: [String]
    var privligeLevel: String
    var tos: Bool
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case theme
        case bio
        case ralliesJoined = "rallies_joined"
        case rallieNames = "rallie_names"
        case privligeLevel = "privilege_level"
        case tos
    }
    
    var personInfo: PersonInfo {
        PersonInfo(
            id: id,
            name: name,
            theme: theme,
            bio: bio,
            ralliesJoined: ralliesJoined,
            rallieNames: rallieNames,
            privligeLevel: privligeLevel,
            tos: tos
        )
    }
}

// MARK: - App Helper Functions
func fetchCurrentProfile() async throws -> PersonInfo? {
    let session = try await supabase.auth.session
    let profile: SupabasePersonRow = try await supabase.from("profiles")
        .select()
        .eq("id", value: session.user.id.uuidString)
        .single()
        .execute()
        .value
    return profile.personInfo
}

nonisolated private struct NewSupabasePersonRow: Encodable {
    var id: UUID
    var name: String
    var theme: String
    var bio: String
    var ralliesJoined: Int
    var rallieNames: [String]
    var privligeLevel: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case theme
        case bio
        case ralliesJoined = "rallies_joined"
        case rallieNames = "rallie_names"
        case privligeLevel = "privilege_level"
    }
}

enum AuthResult {
    case success(PersonInfo)
    case failure(String)
}

func login(Email: String, Password: String) async -> AuthResult {
    do {
        let session = try await supabase.auth.signIn(email: Email, password: Password)
        let personInfo = try await loadPersonInfoOrCreateDefault(
            userID: session.user.id,
            name: session.user.userMetadata["name"]?.stringValue ?? Email
        )
        return .success(personInfo)
    } catch {
        print("Login failed: \(error)")
        return .failure(authErrorMessage(for: error, fallback: "Login failed. Please try again."))
    }
}

func signup(Name: String, Email: String, Password: String) async -> AuthResult {
    do {
        let authResponse = try await supabase.auth.signUp(
            email: Email,
            password: Password,
            data: ["name": .string(Name)]
        )
        
        let newPerson = NewSupabasePersonRow(
            id: authResponse.user.id,
            name: Name,
            theme: "Dark",
            bio: "",
            ralliesJoined: 0,
            rallieNames: [],
            privligeLevel: "User"
        )
        
        try await supabase.from("profiles")
            .upsert(newPerson, onConflict: "id")
            .execute()
        
        let personInfo = try await loadPersonInfo(for: authResponse.user.id)
        return .success(personInfo)
    } catch {
        print("Signup failed: \(error)")
        return .failure(authErrorMessage(for: error, fallback: "Signup failed. Please try again."))
    }
}

private func loadPersonInfo(for userID: UUID) async throws -> PersonInfo {
    let personRow: SupabasePersonRow = try await supabase.from("profiles")
        .select()
        .eq("id", value: userID.uuidString)
        .single()
        .execute()
        .value
    
    return personRow.personInfo
}

private func loadPersonInfoOrCreateDefault(userID: UUID, name: String) async throws -> PersonInfo {
    do {
        return try await loadPersonInfo(for: userID)
    } catch let error as PostgrestError where error.code == "PGRST116" {
        let newPerson = NewSupabasePersonRow(
            id: userID,
            name: name,
            theme: "Default",
            bio: "",
            ralliesJoined: 0,
            rallieNames: [],
            privligeLevel: "User"
        )
        
        let insertedPerson: SupabasePersonRow = try await supabase.from("profiles")
            .upsert(newPerson, onConflict: "id")
            .select()
            .single()
            .execute()
            .value
        
        return insertedPerson.personInfo
    }
}

private func authErrorMessage(for error: any Error, fallback: String) -> String {
    if let urlError = error as? URLError {
        switch urlError.code {
        case .cannotConnectToHost, .cannotFindHost, .networkConnectionLost, .notConnectedToInternet, .timedOut:
            return "Could not connect to the server. Check the network or Supabase server."
        default:
            return urlError.localizedDescription
        }
    }
    
    if let authError = error as? AuthError {
        switch authError {
        case let .api(message, errorCode, _, _):
            if errorCode == .unexpectedFailure && message.localizedCaseInsensitiveContains("confirmation email") {
                return "The server could not send the confirmation email. Check Supabase email settings."
            }
            return message
        case let .weakPassword(message, reasons):
            return ([message] + reasons).joined(separator: " ")
        default:
            return authError.message
        }
    }
    
    return "Signup failed. Please try again."
}

func updateProfile(person: PersonInfo) async throws {
    let updateData: [String: AnyEncodable] = [
        "name": AnyEncodable(person.name),
        "bio": AnyEncodable(person.bio)
    ]
    
    try await supabase.from("profiles")
        .update(updateData)
        .eq("id", value: person.id.uuidString)
        .execute()
}

func getProfileImageURL(for userID: UUID) throws -> URL {
    return try supabase.storage
        .from("Profile Pictures")
        .getPublicURL(path: userID.uuidString + "/images/profile.jpg")
}
