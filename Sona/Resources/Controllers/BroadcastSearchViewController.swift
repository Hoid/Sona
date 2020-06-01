//
//  BroadcastSearchViewController.swift
//  Sona
//
//  Created by Tyler Cheek on 5/28/20.
//  Copyright © 2020 Tyler Cheek. All rights reserved.
//

import UIKit

class BroadcastSearchViewController : UIViewController, UISearchBarDelegate {
    
    var broadcastSearchResultsTableVC: BroadcastSearchResultsTableViewController?
    
    @IBOutlet weak var broadcastSearchBar: UISearchBar!
    @IBOutlet weak var broadcastSearchSegmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.broadcastSearchBar.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "BroadcastSearchResultsTableViewSegue" {
            if let viewController = segue.destination as? BroadcastSearchResultsTableViewController {
                self.broadcastSearchResultsTableVC = viewController
            }
        }
    }
        
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {

    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {

    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {

    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        let broadcasts = self.broadcastSearchResultsTableVC?.datasource.broadcasts
        let broadcastSearchFilterHelper = BroadcastSearchFilterHelper(broadcasts: broadcasts)
        
        self.broadcastSearchResultsTableVC?.datasource.filteredBroadcasts = broadcastSearchFilterHelper.filter(searchText: searchText)
        
        self.broadcastSearchResultsTableVC?.tableView.reloadData()
        
    }
    
}
