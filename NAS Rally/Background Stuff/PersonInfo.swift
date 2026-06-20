//
//  PersonInfo.swift
//  NAS Rally
//
//  Created by Peyton Ward on 5/31/26.
//

import SwiftUI

struct PersonInfo {
    var id: UUID
    var name: String
    var theme: String
    var bio: String
    var ralliesJoined: Int
    var rallieNames: [String]
    var privligeLevel: String
}

func getPersonInfo() -> PersonInfo {
    let placeholderID = UUID(uuidString: "00000000-0000-0000-0000-000000000000") ?? UUID()
    let joinedRallies = ["NAS Rally"]

    return PersonInfo(
        id: placeholderID,
        name: "Peyton Ward",
        theme: "Space",
        bio: "I'm a programmer",
        ralliesJoined: joinedRallies.count,
        rallieNames: joinedRallies,
        privligeLevel: "Admin"
    )
}
