//
//  ViewController.swift
//  Sona
//
//  Created by Tyler Cheek on 5/28/20.
//  Copyright © 2020 Tyler Cheek. All rights reserved.
//

import UIKit
import FirebaseAuth

class HomeScreenViewController: UIViewController {

    @IBOutlet weak var isPublicSwitch: UISwitch!
    
    let usersNetworkManager = UsersNetworkManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            let users = try UserDAO.getAllUsers()
            print("Users: \(String(describing: users))")
        } catch {
            print("Could not get all users in HomeScreenViewController.viewDidLoad(). Error: \(error.localizedDescription)")
        }
    }
    
    @IBAction func isPublicChanged(_ sender: UISwitch) {
        guard let firebaseUser = Auth.auth().currentUser else {
            sender.isOn = false
            print("Could not get currently logged in user in HomeScreenViewController.isPublicChanged(_:)")
            return
        }
        usersNetworkManager.set(isPublic: sender.isOn, forUserFirebaseUID: firebaseUser.uid) { (userIsPublicApiResponse, error) in
            if let error = error {
                print(error)
                return
            }
            guard let userIsPublicApiResponse = userIsPublicApiResponse else {
                print("Could not unwrap userIsPublicApiResponse in HomeScreenViewController.isPublicChanged(_:)")
                return
            }
            do {
                try UserDAO.setIsPublic(forFirebaseUID: firebaseUser.uid, isPublic: userIsPublicApiResponse.isPublic)
            } catch {
                print(error.localizedDescription)
            }
        }
    }

}
