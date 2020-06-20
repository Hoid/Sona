//
//  SignInController.swift
//  Sona
//
//  Created by Tyler Cheek on 6/3/20.
//  Copyright © 2020 Tyler Cheek. All rights reserved.
//

import UIKit
import AuthenticationServices
import CryptoKit
import FirebaseUI

class SignInController : NSObject, FUIAuthDelegate {

    typealias FAUser = FirebaseAuth.User
    
    /// Unhashed nonce.
    fileprivate var currentNonce: String?

    func getAuthViewController() -> UINavigationController {
        let authUI = FUIAuth.defaultAuthUI()!
        authUI.delegate = self
        var providers: [FUIAuthProvider] = [
          FUIGoogleAuth()
        ]
        if #available(iOS 13, *) {
            providers.append(FUIOAuth.appleAuthProvider())
        }
        authUI.providers = providers
        return authUI.authViewController()
    }
    
    func authUI(_ authUI: FUIAuth, didSignInWith firebaseUser: FAUser?, error: Error?) {
        if let error = error {
            // TODO: Present an alert to the user that there was an error and they should close the app and try to sign in again
            fatalError("Could not sign in using Firebase. Error: \(error)")
        }
        // create user in database without a username
        guard let firebaseUser = firebaseUser else {
            // TODO: Present an alert to the user that there was an error and they should close the app and try to sign in again
            fatalError("Could not create user from auth because user from Firebase is nil.")
        }
        guard let email = firebaseUser.email, let name = firebaseUser.displayName else {
            // TODO: Present an alert to the user that there was an error and they should close the app and try to sign in again
            print("Could not create user from auth because either the email or displayName property wasn't present.")
            // show something to the user that says there was an error and to try again
            return
        }
        do {
            let _ = try UserDAO.getUserFor(firebaseUID: firebaseUser.uid)
        } catch UserError.notFound {
            // attempt to create the user on the server, then in the local database
            let newUser = User(firebaseUID: firebaseUser.uid, email: email, username: nil, name: name, isPublic: false)
            UsersNetworkManager().createUser(user: newUser) { (userApiResponse, error) in
                if let error = error {
                    fatalError("Could not create user on the server. Error: \(error)")
                }
                do {
                    try UserDAO.create(user: newUser)
                    print("Created user in local database with firebaseUID \(newUser.firebaseUID)")
                } catch let error as UserError {
                    print(error.localizedDescription)
                } catch {
                    // DatabaseError.
                    fatalError("Could not create user in the local database. Error: \(error)")
                }
            }
        } catch {
            // DatabaseError.
            fatalError("Could not get user from local database. Error: \(error)")
        }
    }
    
    @available(iOS 13, *)
    func startSignInWithAppleFlow() {
        let nonce = randomNonceString()
        currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)

        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.performRequests()
    }

    @available(iOS 13, *)
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
        return String(format: "%02x", $0)
        }.joined()

        return hashString
    }

    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: Array<Character> =
            Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length

        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }

            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }

                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }

        return result
    }


}

@available(iOS 13.0, *)
extension SignInController : ASAuthorizationControllerDelegate {

  func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            }
            // Initialize a Firebase credential.
            let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                    idToken: idTokenString,
                                                    rawNonce: nonce)
            // Sign in with Firebase.
            Auth.auth().signIn(with: credential) { (authResult, error) in
                if let error = error {
                    // Error. If error.code == .MissingOrInvalidNonce, make sure
                    // you're sending the SHA256-hashed nonce as a hex string with
                    // your request to Apple.
                    print(error.localizedDescription)
                    return
                }
                // User is signed in to Firebase with Apple.
                // ...
            }
        }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        if controller.authorizationRequests.count == 1 {
        print("Error signing in with auth request = \(controller.authorizationRequests[0])")
        }
        print("Error signing in. Could not unwrap auth requests.")
        print("Sign in with Apple errored: \(error)")
    }

}
