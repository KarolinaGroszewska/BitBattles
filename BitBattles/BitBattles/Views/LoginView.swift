//
//  LoginView.swift
//  BitBattles
//
//  Created by Kari Groszewska on 12/8/24.
//

import AuthenticationServices
import FirebaseCore
import FirebaseFirestore
import GoogleSignInSwift
import SwiftUI


struct LoginView: View {
    @EnvironmentObject var authManager: AuthManager
    @State private var showHomeView = false

    var body: some View {
        NavigationStack{
            ZStack {
                Color(red: 217/255, green: 244/255, blue: 241/255)
                    .ignoresSafeArea()
                VStack {
                    Text("BitBattles")
                        .monospaced()
                        .fontWeight(.semibold)
                        .font(.system(size: 24))
                        .padding(.top, 25)
                        .foregroundStyle(Color.black)
                    Image("loginImage")
                        .resizable()
                        .frame(width: 320, height: 320, alignment: .center)
                    Button {
                        Task {
                            await signInWithGoogle()
                        }
                    } label: {
                        HStack {
                            Text("Sign in with ")
                                .font(.system(size: 20))
                                .fontWeight(.medium)
                                .foregroundStyle(.black)
                            
                            Image("googleLogo")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 20)
                        }
                        .frame(width: 220.5, height: 48.5)
                        .background(.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5).stroke(Color(red: 43/255, green: 43/255, blue: 43/255), lineWidth: 0.75))
                        
                    }
                    SignInWithAppleButton(
                        onRequest: { request in
                            AppleSignInManager.shared.requestAppleAuthorization(request)
                        },
                        onCompletion: { result in
                            handleAppleID(result)
                        }
                    )
                    .frame(width: 222, height: 50)
                    .signInWithAppleButtonStyle(.whiteOutline)
                    .padding(.bottom, 40)
                    
                }
                .navigationDestination(isPresented: $showHomeView) {
                    ProfileView()
                        .navigationBarBackButtonHidden(true)
                }
            }
        }
    }
    func signInWithGoogle() async {
        do {
            guard
                let user = try await GoogleSignInManager.shared
                    .signInWithGoogle()
            else { return }
            
            let result = try await authManager.googleAuth(user)
            if let result = result {
                print("GoogleSignInSuccess: \(result.user.uid)")
                showHomeView = true
            }
        } catch {
            print("GoogleSignInError: failed to sign in with Google, \(error)")
        }
    }
    
    func handleAppleID(_ result: Result<ASAuthorization, Error>) {
        if case let .success(auth) = result {
            guard
                let appleIDCredentials = auth.credential
                    as? ASAuthorizationAppleIDCredential
            else {
                print(
                    "AppleAuthorization failed: AppleID credential not available"
                )
                return
            }
            
            Task {
                do {
                    let result = try await authManager.appleAuth(
                        appleIDCredentials,
                        nonce: AppleSignInManager.nonce
                    )
                    if result != nil {
                        showHomeView = true
                    }
                } catch {
                    print("AppleAuthorization failed: \(error)")
                }
            }
        } else if case let .failure(error) = result {
            print("AppleAuthorization failed: \(error)")
        }
    }
    
}

#Preview {
    LoginView()
}
