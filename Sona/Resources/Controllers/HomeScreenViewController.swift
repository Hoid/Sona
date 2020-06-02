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
    let userDataModelManager = DataModelManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let users = userDataModelManager.getAllUsers() {
            print("Users: \(users)")
        } else {
            print("No users found.")
        }
    }
    
    @IBAction func isPublicChanged(_ sender: Any) {
        
    }
    

}

