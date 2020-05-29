//
//  ViewController.swift
//  Sona
//
//  Created by Tyler Cheek on 5/28/20.
//  Copyright © 2020 Tyler Cheek. All rights reserved.
//

import UIKit

class HomeScreenViewController: UIViewController {

    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var isPublicSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.barTintColor = UIColor(red: 0.578, green: 0.871, blue: 1.0, alpha: 1.0)
        isPublicSwitch.isOn = false
    }
    
    @IBAction func isPublicChanged(_ sender: Any) {
        
        UIView.animate(withDuration: 0.5) { [weak self] in
            if (self?.isPublicSwitch.isOn)! {
                // soft orange
                self?.navigationBar.barTintColor = UIColor(red: 1.0, green: 0.711, blue: 0.578, alpha: 1.0)
            } else {
                // soft blue
                self?.navigationBar.barTintColor = UIColor(red: 0.578, green: 0.871, blue: 1.0, alpha: 1.0)
            }
            self?.view.layoutIfNeeded()
        }
        
        
    }
    

}

