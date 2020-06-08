//
//  ChooseUsernameViewController.swift
//  Sona
//
//  Created by Tyler Cheek on 6/4/20.
//  Copyright © 2020 Tyler Cheek. All rights reserved.
//

import UIKit
import FirebaseAuth

class ChooseUsernameViewController : UIViewController {
    
    @IBOutlet weak var usernameInputTextField: UITextField!
    @IBOutlet weak var checkUsernameUniquenessButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    
    let transition = PopAnimator()
    
    override func viewDidLoad() {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.submitButton.isEnabled = false
        self.checkUsernameUniquenessButton.isEnabled = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let loggedInUser = Auth.auth().currentUser {
            let firebaseUID = loggedInUser.uid
            do {
                if let user = try DataModelManager.getUserForFirebaseUID(firebaseUID: firebaseUID) {
                    if user.username != nil {
                        // if logged in user has a username already, go to home page
                        print("User with FirebaseUID \(firebaseUID) is currently signed in. Attempting to present home page.")
                        performSegue(withIdentifier: "showHomePage", sender: self)
                    }
                }
            } catch {
                print("Could not get user for firebaseUID in ChooseUsernameViewController.viewDidAppear(_:)")
            }
        } else {
            print("No user signed in. Attempting to present sign in page.")
            let vc = SignInController().getAuthViewController()
            vc.transitioningDelegate = self
            vc.modalPresentationStyle = .fullScreen
            vc.navigationItem.hidesBackButton = true
            present(vc, animated: true)
        }
    }
    
    @IBAction func usernameEditingChanged(_ sender: UITextField) {
        self.submitButton.isEnabled = false
        if usernameInputTextField.text != nil {
            self.checkUsernameUniquenessButton.isEnabled = true
        } else {
            self.checkUsernameUniquenessButton.isEnabled = false
        }
    }
    
    @IBAction func checkUsernameUniquenessButtonPressed(_ sender: UIButton) {
        // if username is unique, enable submit button
        if let usernameInputText = usernameInputTextField.text {
            print("Checking uniqueness of username: \(usernameInputText)")
            do {
                if try DataModelManager.getUserForUsername(username: usernameInputText) == nil {
                    print("No user found with username \(usernameInputText).")
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
        // username is guaranteed to be present now, because we unwrap it in checkUsernameUniquenessButtonPressed and the only way the submit button can be enabled is if text is present
        guard let username = self.usernameInputTextField.text else {
            print("Username not present in text field in ChooseUsernameViewController.submitButtonPressed(_:)")
            return
        }
        guard let firebaseUser = Auth.auth().currentUser else {
            print("No user is currently signed in in ChooseUsernameViewController.submitButtonPressed(_:)")
            return
        }
        do {
            if try DataModelManager.getUserForFirebaseUID(firebaseUID: firebaseUser.uid) == nil {
                guard let email = firebaseUser.email, let name = firebaseUser.displayName else {
                    print("Could not unwrap firebase email or displayName in ChooseUsernameViewController.submitButtonPressed(_:)")
                    return // should I be returning here?
                }
                try DataModelManager.createUser(user: User(email: email, username: username, name: name, firebaseUID: firebaseUser.uid))
                return
            }
        } catch {
            print("Database Error: \(error)")
        }
    }
    
}

extension ChooseUsernameViewController : UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return nil
    }
    
}
