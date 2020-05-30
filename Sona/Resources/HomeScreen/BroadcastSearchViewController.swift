//
//  BroadcastSearchViewController.swift
//  Sona
//
//  Created by Tyler Cheek on 5/28/20.
//  Copyright © 2020 Tyler Cheek. All rights reserved.
//

import UIKit

class BroadcastSearchViewController : UIViewController {
    
//    var searchBarDelegate = BroadcastSearchBarDelegate(searchActive: false)
//    var broadcastSearchResultsTableVC: BroadcastSearchResultsTableViewController?
    
    @IBOutlet weak var broadcastSearchBar: UISearchBar!
    @IBOutlet weak var broadcastSearchSegmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "BroadcastSearchTableViewSegue" {
//            if let viewController = segue.destination as? BroadcastSearchResultsTableViewController {
//                self.broadcastSearchResultsTableVC = viewController
//            }
//        }
//    }
    
//    searchController = ({
//        let controller = UISearchController(searchResultsController: nil)
//        controller.delegate = self
//        controller.searchBar.delegate = self
//        controller.searchResultsUpdater = self
//        controller.dimsBackgroundDuringPresentation = false
//        controller.hidesNavigationBarDuringPresentation = true
//        return controller
//    })()
    
}
