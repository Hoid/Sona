//
//  AppleMusicManager.swift
//  Sona
//
//  Created by Tyler Cheek on 6/21/20.
//  Copyright © 2020 Tyler Cheek. All rights reserved.
//

import SwiftJWT
import StoreKit
import MediaPlayer
import NotificationCenter

class AppleMusicManager {
    
    // cache this somewhere soon
    var authHeader: HTTPHeaders?
    
    /// The storefront id that is used when making Apple Music API calls.
    var storefrontID: String?
    
    init() {
        initAuthHeader()
    }
    
    func fetchDeveloperToken() -> String? {
        
        // MARK: ADAPT: YOU MUST IMPLEMENT THIS METHOD
        let developerAuthenticationToken: String? = nil
        return developerAuthenticationToken
    }
    
    func initAuthorizationStatus() {
        
        let authStatus = MPMediaLibrary.authorizationStatus()
        if authStatus == .denied {
            print("User has denied Apple Music permissions.")
            return
        } else if authStatus == .restricted {
            print("User has restricted some Apple Music permissions.")
            return
        } else if authStatus == .authorized {
            print("User has already allowed all Apple Music permissions!")
            return
        } else if authStatus == .notDetermined {
            MPMediaLibrary.requestAuthorization { (status) in
                if status != .authorized {
                    print("User did not provide needed permissions.")
                } else {
                    print("User provided all needed permissions!")
                }
            }
        }
        
    }
    
    func initAuthHeader() {
        

            let skCloudServiceController = SKCloudServiceController()
            skCloudServiceController.requestUserToken(forDeveloperToken: signedJWT) { (userToken, error) in
                if error != nil {
                    print("Could not create user token from signed JWT")
                    return
                }
                guard let userToken = userToken else {
                    print("Could not unwrap newly created user token in AppleMusicController.initJWTHeader()")
                    return
                }
                self.authHeader = [
                    "Authorization" : "Bearer \(signedJWT)",
                    "Music-User-Token" : userToken
                ]
            }
        } catch {
            print("Could not either make privateKey from privateKeyPath or sign JWT token in AppleMusicKitApi.headers; Error: \(error)")
            return
        }
        
    }
    
}
