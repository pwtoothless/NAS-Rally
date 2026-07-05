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
