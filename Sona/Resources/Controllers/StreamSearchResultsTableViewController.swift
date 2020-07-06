//
//  StreamSearchResultTableViewController.swift
//  Sona
//
//  Created by Tyler Cheek on 5/28/20.
//  Copyright © 2020 Tyler Cheek. All rights reserved.
//

import UIKit

class StreamSearchResultsTableViewController : UITableViewController {
        
    var streams = [Stream]()
    var filteredStreams = [Stream]()
    var selectedCell: StreamSearchResultsTableViewCell?
    
    override func viewDidLoad() {
        let streams = [
            Stream(
                song: AMSong(id: "1", title: "November Rain", artistName: "Guns N' Roses", durationInMillis: 10000, albumName: "Idk", artwork: AMApiArtwork(height: 400, width: 400, url: "")),
                host: User(firebaseUID: "1234", email: "my@email.com", username: "sylphrenetic", name: "Tyler Cheek", isPublic: true)
            ),
            Stream(
                song: AMSong(id: "2", title: "How To Disappear Completely", artistName: "Radiohead", durationInMillis: 10000, albumName: "Idk", artwork: AMApiArtwork(height: 400, width: 400, url: "")),
                host: User(firebaseUID: "1234", email: "my@email.com", username: "sylphrenetic", name: "Tyler Cheek", isPublic: true)
            ),
            Stream(
                song: AMSong(id: "3", title: "Kids", artistName: "MGMT", durationInMillis: 10000, albumName: "Idk", artwork: AMApiArtwork(height: 400, width: 400, url: "")),
                host: User(firebaseUID: User.DEFAULT_FIREBASE_ID, email: User.DEFAULT_EMAIL, username: User.DEFAULT_USERNAME, name: User.DEFAULT_NAME, isPublic: true)
            )
        ]
        self.streams = streams
        self.filteredStreams = streams
        self.tableView.dataSource = self
        self.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredStreams.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "StreamSearchResultsTableViewCellReuseIdentifier", for: indexPath) as? StreamSearchResultsTableViewCell else {
            fatalError("The dequeued cell is not an instance of StreamSearchResultsTableViewCell.")
        }
        guard let filteredStream = self.filteredStreams[safe: indexPath.row] else {
            fatalError("Could not unwrap filteredStream object for indexPath in StreamSearchResultsTableViewController.swift")
        }
        cell.setup(stream: filteredStream)
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCell = self.tableView(tableView, cellForRowAt: indexPath) as? StreamSearchResultsTableViewCell
        self.performSegue(withIdentifier: "unwindToStreamSearchVC", sender: self)
    }
    
}

extension Collection where Indices.Iterator.Element == Index {
    subscript (safe index: Index) -> Iterator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
