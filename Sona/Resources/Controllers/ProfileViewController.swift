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
        guard let profile = ProfileDAO.getNonDefaultProfile() else {
            print("Non-default profile could not be loaded from the database.")
            return
        }
        self.profile = profile
        if let user = UserDAO.getUserFor(profile: self.profile!) {
            nameLabel.text = user.name
            usernameLabel.text = user.username
        } else {
            nameLabel.text = User.DEFAULT_NAME
            usernameLabel.text = User.DEFAULT_USERNAME
        }
        profileImage.image = self.profile?.profileImage ?? UIImage(named: "EmptyProfileIcon")
    }
    
    @IBAction func logoutButtonPressed(_ sender: Any) {
        do {
            try Auth.auth().signOut()
        } catch {
            print("Could not logout due to error: \(error)")
        }
    }
    
}
