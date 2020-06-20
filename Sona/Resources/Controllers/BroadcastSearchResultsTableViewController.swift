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
        let broadcasts = [
            Broadcast(
                song: Song(id: "1", title: "November Rain", artist: "Guns N' Roses"),
                user: User(firebaseUID: "1234", email: "my@email.com", username: "sylphrenetic", name: "Tyler Cheek", isPublic: true)
            ),
            Broadcast(
                song: Song(id: "2", title: "How To Disappear Completely", artist: "Radiohead"),
                user: User(firebaseUID: "1234", email: "my@email.com", username: "sylphrenetic", name: "Tyler Cheek", isPublic: true)
            ),
            Broadcast(
                song: Song(id: "3", title: "Kids", artist: "MGMT"),
                user: User(firebaseUID: User.DEFAULT_FIREBASE_ID, email: User.DEFAULT_EMAIL, username: User.DEFAULT_USERNAME, name: User.DEFAULT_NAME, isPublic: true)
            )
        ]
        datasource.broadcasts = broadcasts
        datasource.filteredBroadcasts = broadcasts
        self.tableView.dataSource = datasource
        self.tableView.reloadData()
    }
    
}
