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
        datasource.broadcasts = [
            Broadcast(
                song: Song(id: "1", title: "November Rain", artist: "Guns N' Roses"),
                user: User(username: "sylphrenetic")
            ),
            Broadcast(
                song: Song(id: "2", title: "How To Disappear Completely", artist: "Radiohead"),
                user: User(username: "sylphrenetic")
            ),
            Broadcast(
                song: Song(id: "3", title: "Kids", artist: "MGMT"),
                user: User(username: "other_username")
            )
        ]
        self.tableView.dataSource = datasource
        self.tableView.reloadData()
    }
    
}
