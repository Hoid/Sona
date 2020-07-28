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
            let usernameMeetsFilter = stream.host?.username?.localizedCaseInsensitiveContains(searchText)
            return (titleMeetsFilter ?? false || artistMeetsFilter ?? false || usernameMeetsFilter ?? false)
        })
        return filteredStreams
        
    }
    
}
