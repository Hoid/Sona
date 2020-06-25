//
//  AMAlbumModel.swift
//  Sona
//
//  Created by Tyler Cheek on 6/24/20.
//  Copyright © 2020 Tyler Cheek. All rights reserved.
//

struct AMAlbum : Decodable {
    
    struct Attributes : Decodable {
        let artistName: String
        let artwork: AMArtwork
        let contentRating: String?
        let name: String
        let playParams: AMPlayParams?
        let trackCount: Int
    }
    
    struct Relationships : Decodable {
        
        let artistRelationships: ArtistRelationships?
        let genreRelationships: GenreRelationships?
        
    }
    
    let attributes: Attributes?
    let relationships: Relationships?
    let type: String
    
    
}
