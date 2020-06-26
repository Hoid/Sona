//
//  AMPlaylistModel.swift
//  Sona
//
//  Created by Tyler Cheek on 6/25/20.
//  Copyright © 2020 Tyler Cheek. All rights reserved.
//

import Foundation

struct AMApiPlaylist : Decodable {
    
    enum PlaylistType : String, Decodable {
        case userShared = "user-shared"
        case editorial = "editorial"
        case external = "external"
        case personalMix = "personal-mix"
    }
    
    struct Attributes : Decodable {
        let artwork: AMApiArtwork?
        let description: AMApiEditorialNotes?
        let lastModifiedDate: Date
        let name: String
        let playParams: AMAPiPlayParams?
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
