//
//  StreamSearchFilterHelper.swift
//  Sona
//
//  Created by Tyler Cheek on 5/31/20.
//  Copyright © 2020 Tyler Cheek. All rights reserved.
//

extension Array where Element == Stream {

    func filter(byText searchText: String) -> [Stream] {
        
        if self.isEmpty {
            return [Stream]()
        }
        let filteredStreams = searchText.isEmpty ? self : self.filter({ (stream: Stream) -> Bool in
            let titleMeetsFilter = stream.song.title?.localizedCaseInsensitiveContains(searchText)
            let artistMeetsFilter = stream.song.artistName?.localizedCaseInsensitiveContains(searchText)
            var usernameMeetsFilter: Bool
            if let username = stream.host.username {
                usernameMeetsFilter = username.localizedCaseInsensitiveContains(searchText)
            } else {
                usernameMeetsFilter = false
            }
            return (titleMeetsFilter ?? false || artistMeetsFilter ?? false || usernameMeetsFilter)
        })
        return filteredStreams
        
    }
    
}
