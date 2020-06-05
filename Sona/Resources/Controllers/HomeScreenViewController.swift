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
    let signInController = SignInController()
    let transition = PopAnimator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            let users = try DataModelManager.getAllUsers()
            print("Users: \(users)")
        } catch {
            print("Could not get users from database.")
        }
        let vc = signInController.getAuthViewController()
        vc.transitioningDelegate = self
        vc.modalPresentationStyle = .fullScreen
        vc.navigationItem.hidesBackButton = true
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func isPublicChanged(_ sender: Any) {
        
    }

}

extension HomeScreenViewController : UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return nil
    }
    
}
