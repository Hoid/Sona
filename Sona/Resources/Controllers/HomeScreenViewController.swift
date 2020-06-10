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
        if let users = UserDAO.getAllUsers() {
            print("Users: \(String(describing: users))")
        } else {
            print("Could not get all users in HomeScreenViewController.viewDidLoad()")
        }
    }
    
    @IBAction func isPublicChanged(_ sender: Any) {
        
    }

}
