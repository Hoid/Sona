//
//  ProfileViewController.swift
//  Sona
//
//  Created by Tyler Cheek on 6/1/20.
//  Copyright © 2020 Tyler Cheek. All rights reserved.
//

import UIKit
import FirebaseAuth

class ProfileViewController : UIViewController {
    
    var profile: Profile?
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var logoutButton: UIButton!
    
    override func viewDidLoad() {
        guard let firebaseUser = Auth.auth().currentUser else {
            print("Could not get currently logged in user in ProfileViewController.viewDidLoad()")
            return
        }
        do {
            self.profile = try ProfileDAO.getProfileFor(userFirebaseUID: firebaseUser.uid)
            let user = try UserDAO.getUserFor(firebaseUID: firebaseUser.uid)
            profileImage.image = self.profile?.profileImage ?? UIImage(named: "EmptyProfileIcon")
            nameLabel.text = user.name
            usernameLabel.text = user.username
        } catch {
            nameLabel.text = User.DEFAULT_NAME
            usernameLabel.text = User.DEFAULT_USERNAME
            print(error.localizedDescription)
        }
    }
    
    @IBAction func logoutButtonPressed(_ sender: Any) {
        do {
            try Auth.auth().signOut()
        } catch {
            print("Could not logout due to error: \(error)")
        }
    }
    
}
