//
//  HomeView.swift
//  BitBattles
//
//  Created by Kari Groszewska on 12/8/24.
//

import SwiftUI
import AuthenticationServices
import FirebaseCore
import FirebaseFirestore

struct ProfileView: View {
    @EnvironmentObject var authManager: AuthManager

    var body: some View {
        ZStack {
            Color(red: 217/255, green: 244/255, blue: 241/255)
                .ignoresSafeArea()
            VStack {
                Text("User Profile")
                    .monospaced()
                    .fontWeight(.semibold)
                    .font(.system(size: 24))
                    .padding(.top, 25)
                    .foregroundStyle(Color.black)
                
                Button {
                    Task {
                        await getUserData()
                    }
                } label: {
                    HStack {
                        Text("Get User Data")
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
                //Name
                //Email Address
                //Classes Started (Icons)
                //Hours Spent (Daily, Weekly, All-time)
                

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
        }
    }
    
    func signOut() async{
        do {
            try await authManager.signOut()
        } catch {
            print("Sign out failed: \(error)")

        }
    }
    
    func getUserData() async {
        let uid = authManager.user?.uid ?? ""
        let docRef = Firestore.firestore().collection("users").document("\(uid)")
        do {
          let document = try await docRef.getDocument()
          if document.exists {
            let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
            print("Document data: \(dataDescription)")
          } else {
            print("Document does not exist")
          }
        } catch {
          print("Error getting document: \(error)")
        }
    }
}

#Preview {
    ProfileView()
}
