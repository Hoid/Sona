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
        
        let streams = self.streamSearchResultsTableVC?.streams
        
        self.streamSearchResultsTableVC?.filteredStreams = streams?.filter(byText: searchText) ?? [Stream]()
        
        self.streamSearchResultsTableVC?.tableView.reloadData()
        
    }
    
}
