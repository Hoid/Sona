//
//  AMArtistModel.swift
//  Sona
//
//  Created by Tyler Cheek on 6/24/20.
//  Copyright © 2020 Tyler Cheek. All rights reserved.
//

struct AMApiArtist : Decodable {
    
    struct Attributes : Decodable {
        let genreNames: [String]
        let name: String
        let url: String
    }
    
    struct Relationships : Decodable {
        let albumRelationships: AlbumRelationships?
        let genreRelationships: GenreRelationships?
        let playlistRelationships: PlaylistRelationships?
    }
    
    let attributes: Attributes?
    let relationships: Relationships?
    let type: String
    
}
