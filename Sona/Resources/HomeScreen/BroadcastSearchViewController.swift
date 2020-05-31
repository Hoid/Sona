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

        let filteredBroadcasts = broadcasts?.filter({ (broadcast) -> Bool in
            let title = broadcast.song.title
            let artist = broadcast.song.artist
            let username = broadcast.user.username
            return title.contains(searchText) || artist.contains(searchText) || username.contains(searchText)
        })
        self.broadcastSearchResultsTableVC?.datasource.filteredBroadcasts = filteredBroadcasts ?? [Broadcast]()
        self.broadcastSearchResultsTableVC?.tableView.reloadData()
    }
    
}
