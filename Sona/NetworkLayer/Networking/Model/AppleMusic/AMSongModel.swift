//
//  AMSongModel.swift
//  Sona
//
//  Created by Tyler Cheek on 6/25/20.
//  Copyright © 2020 Tyler Cheek. All rights reserved.
//

class AMSong : Decodable {
 
    struct Attributes : Decodable {
        let albumName: String
        let artistName: String
        let artwork: AMArtwork
        let composerName: String?
        let contentRating: String?
        let durationInMillis: Int64
        let genreNames: [String]
        let name: String
        let playParams: AMPlayParams
        let trackNumber: Int
        let url: String
    }
    
    struct Relationships : Decodable {
        let albums: AlbumRelationships?
        let artists: ArtistRelationships?
        let genres: GenreRelationships?
        let station: StationRelationship?
    }
    
    let id: String
    let attributes: Attributes?
    let relationships: Relationships?
    let type: String
    
}
