//
//  BitBattlesApp.swift
//  BitBattles
//
//  Created by Kari Groszewska on 12/6/24.
//

import SwiftUI
import FirebaseCore
import GoogleSignIn

@main
struct BitBattlesApp: App {
    init() {
        FirebaseApp.configure()
        let authManager = AuthManager()
              _authManager = StateObject(wrappedValue: authManager)
    }
        
    @StateObject var authManager: AuthManager

    var body: some Scene {
        WindowGroup {
            LaunchView()
                .environmentObject(authManager)
        }
    }
}
