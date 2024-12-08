//
//  LoginView.swift
//  BitBattles
//
//  Created by Kari Groszewska on 12/8/24.
//

import GoogleSignInSwift
import SwiftUI
import AuthenticationServices

struct LoginView: View {
    @EnvironmentObject var authManager: AuthManager

    var body: some View {
        //TODO: Add in a logo
        Image("loginImage")
            .resizable()
            .frame(width: 300, height: 300, alignment: .center)
        Button {
            Task {
                await signInWithGoogle()
            }
        } label: {
            HStack{
                Text("Sign in with ")
                    .font(.system(size: 18))
                    .foregroundStyle(.black)
                Image("googleLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 30)
            }
            .padding(5)
            .padding([.leading, .trailing], 30)
            .overlay(RoundedRectangle(cornerRadius: 50).stroke(Color.gray, lineWidth: 1))
        }
//        SignInWithAppleButton(onRequest: AppleSignInManager.shared.requestAppleAuthorization(request), onCompletion: handleAppleID(result))
    }
    
    func signInWithGoogle() async {
        do {
            guard let user = try await GoogleSignInManager.shared.signInWithGoogle() else { return }

            let result = try await authManager.googleAuth(user)
            if let result = result {
                print("GoogleSignInSuccess: \(result.user.uid)")
//                HomeView()
            }
        } catch {
            print("GoogleSignInError: failed to sign in with Google, \(error)")
        }
    }
    
    
    func handleAppleID(_ result: Result<ASAuthorization, Error>) {
        if case let .success(auth) = result {
            guard let appleIDCredentials = auth.credential as? ASAuthorizationAppleIDCredential else {
                print("AppleAuthorization failed: AppleID credential not available")
                return
            }

            Task {
                do {
                    let result = try await authManager.appleAuth(
                        appleIDCredentials,
                        nonce: AppleSignInManager.nonce
                    )
                    if let result = result {
//                        HomeView()
                    }
                } catch {
                    print("AppleAuthorization failed: \(error)")
                }
            }
        }
        else if case let .failure(error) = result {
            print("AppleAuthorization failed: \(error)")
            // Here you can show error message to user.
        }
    }

}

#Preview {
    LoginView()
}
