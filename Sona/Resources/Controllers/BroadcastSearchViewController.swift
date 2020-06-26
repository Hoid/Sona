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
    var selectedCell: BroadcastSearchResultsTableViewCell?
    
    @IBOutlet weak var broadcastSearchBar: UISearchBar!
    @IBOutlet weak var broadcastSearchSegmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.broadcastSearchBar.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
        super.viewWillDisappear(animated)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "BroadcastSearchResultsTableViewSegue" {
            if let viewController = segue.destination as? BroadcastSearchResultsTableViewController {
                self.broadcastSearchResultsTableVC = viewController
            }
        } else if segue.identifier == "segueToBroadcastPlayerVC" {
            if let viewController = segue.destination as? BroadcastPlayerViewController {
                viewController.selectedBroadcast = self.selectedCell?.broadcast
            }
        }
    }
    
    @IBAction func unwindToBroadcastSearchVC(_ unwindSegue: UIStoryboardSegue){
        if let sourceVC = unwindSegue.source as? BroadcastSearchResultsTableViewController {
            self.selectedCell = sourceVC.selectedCell
            performSegue(withIdentifier: "segueToBroadcastPlayerVC", sender: self)
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
        
        let broadcasts = self.broadcastSearchResultsTableVC?.broadcasts
        let broadcastSearchFilterHelper = BroadcastSearchFilterHelper(broadcasts: broadcasts)
        
        self.broadcastSearchResultsTableVC?.filteredBroadcasts = broadcastSearchFilterHelper.filter(searchText: searchText)
        
        self.broadcastSearchResultsTableVC?.tableView.reloadData()
        
    }
    
}
