//
//  BroadcastSearchBarDelegate.swift
//  Sona
//
//  Created by Tyler Cheek on 5/29/20.
//  Copyright © 2020 Tyler Cheek. All rights reserved.
//

import UIKit

class BroadcastSearchBarDelegate : NSObject, UISearchBarDelegate {
    
    var searchActive: Bool
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true;
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

//        filtered = data.filter({ (text) -> Bool in
//            let tmp: NSString = text
//            let range = tmp.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
//            return range.location != NSNotFound
//        })
//        if(filtered.count == 0){
//            searchActive = false;
//        } else {
//            searchActive = true;
//        }
//        self.tableView.reloadData()
    }
    
    init(searchActive: Bool) {
        self.searchActive = searchActive
    }
    
}
