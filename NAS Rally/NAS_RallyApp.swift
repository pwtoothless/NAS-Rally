//
//  NAS_RallyApp.swift
//  NAS Rally
//
//  Created by Peyton Ward on 5/31/26.
//

import SwiftUI

@main
struct NAS_RallyApp: App {
     @State private var personInfo = getPersonInfo()
    
    var body: some Scene {
        WindowGroup {
            if !(checkFirstLaunch()) {
                LoginView(person: $personInfo)
            }
            else {
                ContentView(person: $personInfo)
            }
        }
    }
}

func checkFirstLaunch() -> Bool {
    let defaults = UserDefaults.standard
    let hasLaunchedBefore = defaults.bool(forKey: "hasLaunchedBefore")
    
    if !hasLaunchedBefore {
        print("This is the first time the app is launched since installation!")
        defaults.set(true, forKey: "hasLaunchedBefore")
        return true
    } else {
        print("The app has been launched before.")
        return false
    }
}
