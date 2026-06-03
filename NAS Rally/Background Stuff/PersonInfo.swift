//
//  PersonInfo.swift
//  NAS Rally
//
//  Created by Peyton Ward on 5/31/26.
//

import SwiftUI

struct PersonInfo {
    var name: String
    var theme: String
    var bio: String
    var ralliesJoined: Int
    var rallieNames: [String]
    var privligeLevel: String
}

func getPersonInfo() -> PersonInfo {
    return PersonInfo(name: "Peyton Ward", theme: "Space", bio: "I'm a programmer", ralliesJoined: 1, rallieNames: ["NAS Rally"], privligeLevel: "Admin")
}
