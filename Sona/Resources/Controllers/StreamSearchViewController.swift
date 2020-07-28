//
//  StreamSearchViewController.swift
//  Sona
//
//  Created by Tyler Cheek on 5/28/20.
//  Copyright © 2020 Tyler Cheek. All rights reserved.
//

import UIKit

class StreamSearchViewController : UIViewController, UISearchBarDelegate {
    
    var streamSearchResultsTableVC: StreamSearchResultsTableViewController?
    var selectedCell: StreamSearchResultsTableViewCell?
    
    @IBOutlet weak var streamsSearchBar: UISearchBar!
    @IBOutlet weak var streamSearchSegmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.streamsSearchBar.delegate = self
        resetFilteredStreams()
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
        if segue.identifier == "StreamSearchResultsTableViewSegue" {
            if let viewController = segue.destination as? StreamSearchResultsTableViewController {
                self.streamSearchResultsTableVC = viewController
            }
        } else if segue.identifier == "segueToStreamPlayerVC" {
            if let viewController = segue.destination as? StreamPlayerViewController {
                viewController.selectedStream = self.selectedCell?.stream
            }
        }
    }
    
    @IBAction func unwindToStreamSearchVC(_ unwindSegue: UIStoryboardSegue){
        if let sourceVC = unwindSegue.source as? StreamSearchResultsTableViewController {
            self.selectedCell = sourceVC.selectedCell
            performSegue(withIdentifier: "segueToStreamPlayerVC", sender: self)
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
        
        updateFilteredStreams(searchText: searchText)
        
    }
    
    @IBAction func streamSearchSegmentedControlValueChanged(_ sender: UISegmentedControl) {
        
        if let searchText = streamsSearchBar.text {
            updateFilteredStreams(searchText: searchText)
        } else {
            resetFilteredStreams()
        }
        
    }
    
    private func updateFilteredStreams(searchText: String) {
        
        var streams: [Stream]
        if streamSearchSegmentedControl.selectedSegmentIndex == 0 {
            streams = self.streamSearchResultsTableVC?.allStreams ?? [Stream]()
        } else {
            streams = self.streamSearchResultsTableVC?.friendsStreams ?? [Stream]()
        }
        
        self.streamSearchResultsTableVC?.filteredStreams = streams.filter(byText: searchText)
        
        self.streamSearchResultsTableVC?.tableView.reloadData()
        
    }
    
    private func resetFilteredStreams() {
        
        var streams: [Stream]
        if streamSearchSegmentedControl.selectedSegmentIndex == 0 {
            streams = self.streamSearchResultsTableVC?.allStreams ?? [Stream]()
        } else {
            streams = self.streamSearchResultsTableVC?.friendsStreams ?? [Stream]()
        }
        
        self.streamSearchResultsTableVC?.filteredStreams = streams
        
        self.streamSearchResultsTableVC?.tableView.reloadData()
        
    }
    
}
