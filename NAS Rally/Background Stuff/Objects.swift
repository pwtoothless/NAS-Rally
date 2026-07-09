//
//  PersonInfo.swift
//  NAS Rally
//
//  Created by Peyton Ward on 5/31/26.
//

import Foundation // Needed for UUID Variable

struct PersonInfo {
    var id: UUID
    var name: String
    var theme: String
    var bio: String
    var ralliesJoined: Int
    var rallieNames: [String]
    var privligeLevel: String
    var tos: Bool
}

struct SensitiveInfoRow: Codable {
    var id: UUID
    var ccn: Int
    var cvv: Int
    var exp: String
    var name: String
}

struct CalendarEvent {
    var eventName: String
    var eventDate: String
    var eventTime: String
    var eventLocation: String
    var eventDescription: String
    var eventImage: String
    var peopleGoing: Int
}

func saveCalendarEvent(_ event: CalendarEvent) {
    // Will take in event with info, then format to an event making call
}


struct Message: Codable, Identifiable, Equatable {
    let id: UUID
    let groupId: UUID
    let senderId: UUID
    let content: String
    let createdAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id, content
        case groupId = "group_id"
        case senderId = "sender_id"
        case createdAt = "created_at"
    }
}

struct ReadReceipt: Codable {
    let messageId: UUID
    let userId: UUID
    let readAt: Date
    
    enum CodingKeys: String, CodingKey {
        case messageId = "message_id"
        case userId = "user_id"
        case readAt = "read_at"
    }
}

struct RallyRow: Codable, Identifiable {
    let id: UUID
    let name: String
}
