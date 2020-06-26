//
//  BroadcastSearchFilterHelper.swift
//  Sona
//
//  Created by Tyler Cheek on 5/31/20.
//  Copyright © 2020 Tyler Cheek. All rights reserved.
//

class BroadcastSearchFilterHelper {
    
    var broadcasts: [Broadcast]
    
    init(broadcasts: [Broadcast]?) {
        if let broadcasts = broadcasts {
            self.broadcasts = broadcasts
        } else {
            self.broadcasts = [Broadcast]()
        }
    }
    
    func filter(searchText: String) -> [Broadcast] {
        
        if self.broadcasts.isEmpty {
            return [Broadcast]()
        }
        let filteredBroadcasts = searchText.isEmpty ? broadcasts : broadcasts.filter({ (broadcast: Broadcast) -> Bool in
            let titleMeetsFilter = broadcast.song.title?.localizedCaseInsensitiveContains(searchText)
            let artistMeetsFilter = broadcast.song.artistName?.localizedCaseInsensitiveContains(searchText)
            var usernameMeetsFilter: Bool
            if let username = broadcast.user.username {
                usernameMeetsFilter = username.localizedCaseInsensitiveContains(searchText)
            } else {
                usernameMeetsFilter = false
            }
            return (titleMeetsFilter ?? false || artistMeetsFilter ?? false || usernameMeetsFilter)
        })
        return filteredBroadcasts
        
    }
    
}
