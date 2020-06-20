//
//  AppDelegate.swift
//  Sona
//
//  Created by Tyler Cheek on 5/28/20.
//  Copyright © 2020 Tyler Cheek. All rights reserved.
//

import UIKit
import CoreData
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    let usersNetworkManager = UsersNetworkManager()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        try! BaseDAO.setup()
        return true
    }

    // MARK: UISceneSession Lifecycle

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
        
        // set isPublic to off everywhere
        guard let firebaseUser = Auth.auth().currentUser else {
            print("Could not get currently logged in user in AppDelegate.swift")
            return
        }
        usersNetworkManager.set(isPublic: false, forUserFirebaseUID: firebaseUser.uid) { (_, error) in
            if let error = error {
                print(error)
                return
            }
            do {
                try UserDAO.setIsPublicFor(firebaseUID: firebaseUser.uid, isPublic: false)
            } catch {
                print(error.localizedDescription)
            }
        }
    }

}

