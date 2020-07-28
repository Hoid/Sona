//
//  StreamSearchResultTableViewController.swift
//  Sona
//
//  Created by Tyler Cheek on 5/28/20.
//  Copyright © 2020 Tyler Cheek. All rights reserved.
//

import UIKit
import FirebaseAuth

class StreamSearchResultsTableViewController : UITableViewController {
        
    var allStreams = [Stream]()
    var friendsStreams = [Stream]()
    var filteredStreams = [Stream]()
    var selectedCell: StreamSearchResultsTableViewCell?
    
    override func viewDidLoad() {
        
        self.tableView.dataSource = self
        self.showSpinner(onView: self.view)
        appDelegate.streamsNetworkManager.getAllStreams { (streamsApiResponse, error) in
            if let error = error {
                print(error)
                return
            }
            guard let streamsApiResponse = streamsApiResponse else {
                print("Could not unwrap streamsApiResponse in StreamSearchResultsTableViewController.viewDidLoad()")
                return
            }
            self.allStreams = streamsApiResponse.streams.map({ (streamApiResponse) -> Stream in
                return Stream(fromStreamApiResponse: streamApiResponse)
            })
            self.removeSpinner()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        guard let signedInUser = appDelegate.authorizationManager.signedInUser else {
            print("Could not get signed in user in StreamSearchResultsTableViewController.viewDidLoad()")
            return
        }
        appDelegate.streamsNetworkManager.getStreamsForFriends(ofUserWithFirebaseUID: signedInUser.firebaseUID) { (streamsApiResponse, error) in
            if error != nil {
                return
            }
            guard let streamsApiResponse = streamsApiResponse else {
                print("Could not unwrap streamsApiResponse in StreamSearchResultsTableViewController.viewDidLoad()")
                return
            }
            self.friendsStreams = streamsApiResponse.streams.map({ (streamApiResponse) -> Stream in
                return Stream(fromStreamApiResponse: streamApiResponse)
            })
            self.removeSpinner()
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
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
