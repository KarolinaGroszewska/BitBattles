//
//  ContentView.swift
//  BitBattles
//
//  Created by Kari Groszewska on 12/6/24.
//

import SwiftUI


struct LaunchView: View {
    
    @EnvironmentObject var authManager: AuthManager
    
    var body: some View {
        VStack {
            if authManager.authState != .signedOut {
                ProfileView()
            } else {
                LoginView()
            }
        }
        .padding()
    }
}

#Preview {
    LaunchView()
        .environmentObject(AuthManager())
}
