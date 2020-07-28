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
    let usersNetworkManager = UsersNetworkManager()
    
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
                let user = try UserDAO.getUserFor(firebaseUID: firebaseUID)
                appDelegate.authorizationManager.signedInUser = user
                if user.username != nil {
                    // if logged in user has a username already, go to home page
                    print("User with FirebaseUID \(firebaseUID) is currently signed in. Attempting to present home page.")
                    performSegue(withIdentifier: "showHomePage", sender: self)
                }
                // if no username is set for the user, continue to allow username creation
            } catch UserError.notFound {
                // if no user is created for given firebaseUID yet, continue and it will be created when submit button pressed
            } catch {
                // DatabaseError
                presentUnknownErrorAlert()
            }
        } else {
            // no user is logged in, present the auth sign in page
            presentSignInAuthViewController()
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
        if let usernameInputText = usernameInputTextField.text {
            print("Checking uniqueness of username: \(usernameInputText)")
            do {
                let _ = try UserDAO.getUserFor(username: usernameInputText)
            } catch UserError.notFound {
                // success; user can create a new user with this username
                print("No user found with username \(usernameInputText).")
                enableSubmitButton()
            } catch {
                // DatabaseError; force the user to try the check again
                print("Error checking username for uniqueness. Error: \(error)")
                disableSubmitButton()
            }
        } else {
            disableSubmitButton()
        }
    }
    
    @IBAction func submitButtonPressed(_ sender: UIButton) {
        // username is guaranteed to be present now, because we unwrap it in checkUsernameUniquenessButtonPressed and the only way the submit button can be enabled is if text is present
        // these should never fail, so if they do, quit the app to signify a serious error
        guard let username = self.usernameInputTextField.text else {
            fatalError("Username not present in text field in ChooseUsernameViewController.submitButtonPressed(_:)")
        }
        guard let firebaseUser = Auth.auth().currentUser else {
            fatalError("No user is currently signed in in ChooseUsernameViewController.submitButtonPressed(_:)")
        }
        
        do {
            let user = try UserDAO.getUserFor(firebaseUID: firebaseUser.uid)
            
            // user exists in local database for given firebaseUID
            // now ensure a profile exists for this user
            createLocalProfileIfNotExistsFor(user: user)
            
            self.appDelegate.authorizationManager.signedInUser = user
        } catch UserError.notFound {
            // if a user isn't present in the database for the given firebaseUID yet, that's fine, just create it and its corresponding profile
            // if however we can't unwrap the firebaseUser data we need, crash to signify an unrecoverable error
            guard let email = firebaseUser.email else {
                fatalError("Could not unwrap firebase email in ChooseUsernameViewController.submitButtonPressed(_:)")
            }
            guard let name = firebaseUser.displayName else {
                fatalError("Could not unwrap firebase displayName in ChooseUsernameViewController.submitButtonPressed(_:)")
            }
            let user = User(firebaseUID: firebaseUser.uid, email: email, username: username, name: name, isPublic: false)
            
            self.showSpinner(onView: self.view)
            // TODO: Move the check for if a user exists into the checkUsernameUniquenessButtonPressed(_:) method
            DispatchQueue.main.async {
                self.usersNetworkManager.createUser(user: user) { (userApiResponse, error) in
                    if error != nil {
                        self.removeSpinner()
                        fatalError("Could not create user on the server. Error: \(String(describing: error.debugDescription))")
                    }
                    guard let userApiResponse = userApiResponse else {
                        self.removeSpinner()
                        fatalError("Could not unwrap userApiResponse in ChooseUsernameViewController.submitButtonPressed(_:)")
                    }
                    let newUser = User(fromUserApiResponse: userApiResponse)
                    self.createLocalUser(newUser)
                    self.createLocalProfileIfNotExistsFor(user: newUser)
                    
                    self.appDelegate.authorizationManager.signedInUser = newUser
                    
                    self.removeSpinner()
                }
            }
        } catch {
            // DatabaseError; quit the application to signify unrecoverable error
            fatalError("Could not get user for firebaseUID \(firebaseUser.uid). Error: \(error)")
        }
    }
    
    private func createLocalProfileIfNotExistsFor(user: User) {
        do {
            // TODO: Create a ProfileDAO.exists(userFirebaseUID:) method for cases like this
            if (try? ProfileDAO.getProfileFor(user: user)) == nil {
                try ProfileDAO.create(profile: Profile(userFirebaseUID: user.firebaseUID, profileImage: nil))
                print("Created new local profile for userFirebaseUID \(user.firebaseUID)")
            }
        } catch {
            // could not create profile for some reason; crash to signify an unrecoverable error
            fatalError("Could not create profile in ChooseUsernameViewController.createLocalProfileIfNotExistsFor(user:) Error: \(error.localizedDescription)")
        }
    }
    
    private func createLocalUser(_ user: User) {
        do {
            try UserDAO.create(user: user)
        } catch {
            // could not create user for some reason; crash to signify an unrecoverable error
            fatalError("Could not create user in ChooseUsernameViewController.submitButtonPressed(_:). Error: \(error.localizedDescription)")
        }
    }
    
    private func enableSubmitButton() {
        self.submitButton.backgroundColor = UIColor(red: 0.321, green: 0.7, blue: 0.95, alpha: 1.0)
        self.submitButton.isEnabled = true
    }
    
    private func disableSubmitButton() {
        self.submitButton.backgroundColor = .lightGray
        self.submitButton.isEnabled = false
    }
    
    private func presentSignInAuthViewController() {
        print("No user signed in. Attempting to present sign in page.")
        let vc = SignInController().getAuthViewController()
        vc.transitioningDelegate = self
        vc.modalPresentationStyle = .fullScreen
        vc.navigationItem.hidesBackButton = true
        present(vc, animated: true)
    }
    
    private func presentUnknownErrorAlert() {
        let alert = UIAlertController(title: "An unknown error occurred.", message: "Please retry if possible.", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))

        self.present(alert, animated: true)
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
