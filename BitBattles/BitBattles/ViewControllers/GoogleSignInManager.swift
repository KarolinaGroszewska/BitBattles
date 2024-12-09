//
//  GoogleSignInManager.swift
//  BitBattles
//
//  Created by Kari Groszewska on 12/8/24.
//

import GoogleSignIn
import FirebaseCore

class GoogleSignInManager {
    static let shared = GoogleSignInManager()

    typealias GoogleAuthResult = (GIDGoogleUser?, Error?) -> Void

    private init() {}
    @MainActor
    func signInWithGoogle() async throws -> GIDGoogleUser? {
        if GIDSignIn.sharedInstance.hasPreviousSignIn() {
            return try await GIDSignIn.sharedInstance.restorePreviousSignIn()
        } else {
            guard
                let windowScene = UIApplication.shared.connectedScenes.first
                    as? UIWindowScene
            else { return nil }
            guard
                let rootViewController = windowScene.windows.first?
                    .rootViewController
            else { return nil }

            guard let clientID = FirebaseApp.app()?.options.clientID else { return nil }
            let config = GIDConfiguration(clientID: clientID)

            GIDSignIn.sharedInstance.configuration = config

            let result = try await GIDSignIn.sharedInstance.signIn(
                withPresenting: rootViewController)
            return result.user
        }
    }
    func signOutFromGoogle() {
        GIDSignIn.sharedInstance.signOut()
    }
}
