//
//  BroadcastSearchResultTableViewController.swift
//  Sona
//
//  Created by Tyler Cheek on 5/28/20.
//  Copyright © 2020 Tyler Cheek. All rights reserved.
//

import UIKit

class BroadcastSearchResultsTableViewController : UITableViewController {
    
    let datasource = BroadcastSearchResultsTableViewDatasource()
    
    override func viewDidLoad() {
        let user1 = User()
        user1.username = "sylphrenetic"
        let user2 = User()
        user2.username = "other_username"
        let broadcasts = [
            Broadcast(
                song: Song(id: "1", title: "November Rain", artist: "Guns N' Roses"),
                user: user1
            ),
            Broadcast(
                song: Song(id: "2", title: "How To Disappear Completely", artist: "Radiohead"),
                user: user1
            ),
            Broadcast(
                song: Song(id: "3", title: "Kids", artist: "MGMT"),
                user: user2
            )
        ]
        datasource.broadcasts = broadcasts
        datasource.filteredBroadcasts = broadcasts
        self.tableView.dataSource = datasource
        self.tableView.reloadData()
    }
    
}
