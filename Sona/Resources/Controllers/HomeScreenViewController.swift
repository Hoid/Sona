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
        do {
            if let users = try DataModelManager.getAllUsers() {
                print("Users: \(users)")
            } else {
                print("No users found.")
            }
        } catch {
            print("Could not get users from database.")
        }
        
    }
    
    @IBAction func isPublicChanged(_ sender: Any) {
        
    }
    

}

