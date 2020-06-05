//
//  ChooseUsernameViewController.swift
//  Sona
//
//  Created by Tyler Cheek on 6/4/20.
//  Copyright © 2020 Tyler Cheek. All rights reserved.
//

import UIKit

class ChooseUsernameViewController : UIViewController {
    
    var username: String?
    
    @IBOutlet weak var usernameInputTextField: UITextField!
    @IBOutlet weak var checkUsernameUniquenessButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    
    override func viewDidLoad() {
        
    }
    
    @IBAction func usernameInputTextChanged(_ sender: UITextField) {
        self.submitButton.isEnabled = false
    }
    
    @IBAction func checkUsernameUniquenessButtonPressed(_ sender: UIButton) {
        // if username is unique, enable submit button
        if let usernameInputText = usernameInputTextField.text {
            do {
                if try DataModelManager.getUserForUsername(username: usernameInputText) == nil {
                    self.submitButton.isEnabled = true
                } else {
                    self.submitButton.isEnabled = false
                }
            } catch {
                print("Error checking username for uniqueness. Error: \(error)")
                self.submitButton.isEnabled = false
            }
        } else {
            self.submitButton.isEnabled = false
        }
        
    }
    
    @IBAction func submitButtonPressed(_ sender: UIButton) {
        // self.username is guaranteed to be present now, because we unwrap it in checkUsernameUniquenessButtonPressed and the only way the submit button can be enabled is if text is present
        self.username = self.usernameInputTextField.text
    }
    
}
