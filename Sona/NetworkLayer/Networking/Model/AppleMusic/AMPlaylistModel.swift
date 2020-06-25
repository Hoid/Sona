//
//  AMPlaylistModel.swift
//  Sona
//
//  Created by Tyler Cheek on 6/25/20.
//  Copyright © 2020 Tyler Cheek. All rights reserved.
//

import Foundation

struct AMPlaylist : Decodable {
    
    enum PlaylistType : String, Decodable {
        case userShared = "user-shared"
        case editorial = "editorial"
        case external = "external"
        case personalMix = "personal-mix"
    }
    
    struct Attributes : Decodable {
        let artwork: AMArtwork?
        let description: AMEditorialNotes?
        let lastModifiedDate: Date
        let name: String
        let playParams: AMPlayParams?
        let playlistType: PlaylistType
        let url: String
    }
    
    struct Relationships : Decodable {
        let curators: CuratorRelationships?
    }
    
    let attributes: Attributes?
    let relationships: Relationships?
    let type: String
    
}
