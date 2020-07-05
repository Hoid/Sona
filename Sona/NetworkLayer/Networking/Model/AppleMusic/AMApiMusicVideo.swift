//
//  AMMusicVideoModel.swift
//  Sona
//
//  Created by Tyler Cheek on 6/25/20.
//  Copyright © 2020 Tyler Cheek. All rights reserved.
//

struct AMApiMusicVideo : Decodable {
    
    struct Attributes : Decodable {
        let albumName: String?
        let artistName: String
        let artwork: AMApiArtwork
        let contentRating: String?
        let durationInMillis: Int64?
        let editorialNotes: AMApiEditorialNotes?
        let genreNames: [String]
        let name: String
        let playParams: AMAPiPlayParams?
        let trackNumber: Int?
        let url: String
    }
    
    struct Relationships : Decodable {
        
        let albums: AlbumRelationships?
        let artists: ArtistRelationships?
        let genres : GenreRelationships?
        
    }
    
}