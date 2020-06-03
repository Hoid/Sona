//
//  ProfileViewController.swift
//  Sona
//
//  Created by Tyler Cheek on 6/1/20.
//  Copyright © 2020 Tyler Cheek. All rights reserved.
//

import UIKit

class ProfileViewController : UIViewController {
    
    var profile: Profile?
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    
    override func viewDidLoad() {
        if let profile = DataModelManager.getNonDefaultProfile() {
            self.profile = profile
        } else {
            print("No profiles could be loaded from the database.")
            self.profile = Profile(id: 0, userId: 0, profileImage: nil)
        }
        if let user = DataModelManager.getUserForProfile(profile: self.profile!) {
            nameLabel.text = user.name
            usernameLabel.text = user.username
        } else {
            nameLabel.text = User.DEFAULT_NAME
            usernameLabel.text = User.DEFAULT_USERNAME
        }
        profileImage.image = self.profile?.profileImage ?? UIImage(named: "EmptyProfileIcon")
    }
    
}
