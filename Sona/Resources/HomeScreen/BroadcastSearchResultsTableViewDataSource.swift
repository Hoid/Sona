//
//  BroadcastSearchResultsTableViewDataSource.swift
//  Sona
//
//  Created by Tyler Cheek on 5/29/20.
//  Copyright © 2020 Tyler Cheek. All rights reserved.
//

import os.log
import UIKit

class BroadcastSearchResultsTableViewDataSource : NSObject, UITableViewDataSource {
    
    var broadcasts = [Broadcast]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.broadcasts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BroadcastSearchResultsTableViewCellReuseIdentifier", for: indexPath) as? BroadcastSearchResultsTableViewCell else {
            fatalError("The dequeued cell is not an instance of BroadcastSearchResultsTableViewCell.")
        }
        guard let broadcast = self.broadcasts[safe: indexPath.row] else {
            fatalError("Could not unwrap broadcast object for indexPath in ConferencesTableViewController.swift")
        }
        
        cell.setup(broadcast: broadcast)
        
        return cell
        
    }
    
}

extension Collection where Indices.Iterator.Element == Index {
    subscript (safe index: Index) -> Iterator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
