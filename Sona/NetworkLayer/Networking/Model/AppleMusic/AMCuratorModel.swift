//
//  AMCuratorModel.swift
//  Sona
//
//  Created by Tyler Cheek on 6/25/20.
//  Copyright © 2020 Tyler Cheek. All rights reserved.
//

struct AMCurator : Decodable {
    
    struct Attributes : Decodable {
        let artwork: AMArtwork
        let editorialNotes: AMEditorialNotes?
        let name: String
        let url: String
    }
    
    struct Relationships : Decodable {
        let playlists: PlaylistRelationships?
    }
    
    let attributes: Attributes?
    let relationships: Relationships?
    let type: String
    
}
