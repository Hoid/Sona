//
//  AMMusicVideoModel.swift
//  Sona
//
//  Created by Tyler Cheek on 6/25/20.
//  Copyright © 2020 Tyler Cheek. All rights reserved.
//

struct AMMusicVideo : Decodable {
    
    struct Attributes : Decodable {
        let albumName: String?
        let artistName: String
        let artwork: AMArtwork
        let contentRating: String?
        let durationInMillis: Int64?
        let editorialNotes: AMEditorialNotes?
        let genreNames: [String]
        let name: String
        let playParams: AMPlayParams?
        let trackNumber: Int?
        let url: String
    }
    
    struct Relationships : Decodable {
        
        let albums: AlbumRelationships?
        let artists: ArtistRelationships?
        let genres : GenreRelationships?
        
    }
    
}
