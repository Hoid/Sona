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
        let filteredBroadcasts = searchText.isEmpty ? broadcasts : broadcasts.filter({ (broadcast) -> Bool in
            let title = broadcast.song.title
            let artist = broadcast.song.artist
            let username = broadcast.user.username
            return title.contains(searchText) || artist.contains(searchText) || username.contains(searchText)
        })
        return filteredBroadcasts
        
    }
    
}
