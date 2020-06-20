//
//  ViewController.swift
//  Sona
//
//  Created by Tyler Cheek on 5/28/20.
//  Copyright © 2020 Tyler Cheek. All rights reserved.
//

import UIKit

class HomeScreenViewController: UIViewController {

    @IBOutlet weak var isPublicSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            let users = try UserDAO.getAllUsers()
            print("Users: \(String(describing: users))")
        } catch {
            print("Could not get all users in HomeScreenViewController.viewDidLoad(). Error: \(error.localizedDescription)")
        }
        self.showSpinner(onView: self.view)
        let usersNetworkManager = UsersNetworkManager()
        usersNetworkManager.getAllUsers { (userApiResponses, error) in
            if let error = error {
                print(error)
                self.removeSpinner()
                return
            }
            var users = [User]()
            if let userApiResponses = userApiResponses {
                userApiResponses.forEach { (userApiResponse) in
                    users.append(User(firebaseUID: userApiResponse.firebaseUID, email: userApiResponse.email, username: userApiResponse.username, name: userApiResponse.name, isPublic: userApiResponse.isPublic))
                }
                print("Users: \(users)")
            }
            self.removeSpinner()
        }
    }
    
    @IBAction func isPublicChanged(_ sender: Any) {
        
    }

}
