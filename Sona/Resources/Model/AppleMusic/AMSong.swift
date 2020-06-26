//
//  AMSong.swift
//  Sona
//
//  Created by Tyler Cheek on 6/25/20.
//  Copyright © 2020 Tyler Cheek. All rights reserved.
//

struct AMSong : Song {
    let id: String
    let title: String?
    let artistName: String?
    let durationInMillis: Int64?
    let albumName: String?
    let artwork: Artwork?
    
    init(id: String, title: String? = nil, artistName: String? = nil, durationInMillis: Int64? = nil, albumName: String? = nil, artwork: Artwork? = nil) {
        self.id = id
        self.title = title
        self.artistName = artistName
        self.durationInMillis = durationInMillis
        self.albumName = albumName
        self.artwork = artwork
    }
    
    init(fromAMApiSong amApiSong: AMApiSong) {
        guard let attributes = amApiSong.attributes else {
            self.init(id: amApiSong.id)
            print("Could not unwrap attributes from AMApiSong")
            return
        }
        self.init(id: amApiSong.id, title: attributes.name, artistName: attributes.artistName, durationInMillis: attributes.durationInMillis, albumName: attributes.albumName, artwork: attributes.artwork)
    }
    
}
