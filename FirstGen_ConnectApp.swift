//
//  FirstGen_ConnectApp.swift
//  FirstGen Connect
//
//  Created by 6 GO Participant on 7/2/24.
//

import SwiftUI

@main
struct FirstGen_ConnectApp: App {
    @StateObject private var userProfile = UserProfile()
    var body: some Scene {
        WindowGroup {
            LoginView().environmentObject(userProfile)
        }
    }
}
