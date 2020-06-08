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
        do {
            if let profile = try DataModelManager.getNonDefaultProfile() {
                self.profile = profile
            } else {
                print("No profiles could be loaded from the database.")
                self.profile = Profile(userId: 0, profileImage: nil)
            }
        } catch {
            print("Could not get non-default profile.")
        }
        do {
            if let user = try DataModelManager.getUserForProfile(profile: self.profile!) {
                nameLabel.text = user.name
                usernameLabel.text = user.username
            } else {
                nameLabel.text = User.DEFAULT_NAME
                usernameLabel.text = User.DEFAULT_USERNAME
            }
        } catch {
            print("Could not get user for profile.")
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
