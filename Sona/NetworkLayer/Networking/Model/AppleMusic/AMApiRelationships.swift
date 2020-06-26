//
//  AMRelationshipsModel.swift
//  Sona
//
//  Created by Tyler Cheek on 6/25/20.
//  Copyright © 2020 Tyler Cheek. All rights reserved.
//

struct AlbumRelationships : Decodable {
    let data: [AMApiAlbum]
}

struct ArtistRelationships : Decodable {
    let data: [AMApiArtist]
}

struct GenreRelationships : Decodable {
    let data: [AMApiGenre]
}

struct PlaylistRelationships : Decodable {
    let data: [AMApiPlaylist]
}

struct CuratorRelationships : Decodable {
    let data: [AMApiCurator]
}

struct StationRelationship : Decodable {
    let data: AMApiStation
}

// TODO: Implement this
//struct TrackRelationships : Decodable {
//
//    let data: [(AMSong, AMMusicVideo)]
//
//    private enum TrackRelationshipsCodingKeys : String, CodingKeys {
//        case
//    }
//
//}
