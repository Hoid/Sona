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
    var userStore: UserStore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.userStore = UserStore()
        self.userStore.saveNewUser(username: "My User", profileImage: nil)
        self.userStore.fetchPersistedData { (fetchUsersResult) in
            print(fetchUsersResult)
        }
    }
    
    @IBAction func isPublicChanged(_ sender: Any) {
        
    }
    

}

