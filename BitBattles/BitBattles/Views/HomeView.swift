//
//  HomeView.swift
//  BitBattles
//
//  Created by Kari Groszewska on 12/8/24.
//

import SwiftUI
import AuthenticationServices

struct HomeView: View {
    @EnvironmentObject var authManager: AuthManager

    var body: some View {
        Button {
            Task {
                await signOut()
            }
        } label: {
            HStack {
                Text("Sign Out")
                    .font(.system(size: 20))
                    .fontWeight(.medium)
                    .foregroundStyle(.black)
            }
            .frame(width: 220.5, height: 38.5)
            .background(.white)
            .overlay(
                RoundedRectangle(cornerRadius: 5).stroke(Color(red: 43/255, green: 43/255, blue: 43/255), lineWidth: 0.75))
            .padding(.bottom, 30)
        }
    }
    
    func signOut() async{
        do {
            try await authManager.signOut()
        } catch {
            print("Sign out failed: \(error)")

        }
    }
}

#Preview {
    HomeView()
}
