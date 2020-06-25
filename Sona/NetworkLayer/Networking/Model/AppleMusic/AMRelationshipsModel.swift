//
//  AMRelationshipsModel.swift
//  Sona
//
//  Created by Tyler Cheek on 6/25/20.
//  Copyright © 2020 Tyler Cheek. All rights reserved.
//

struct AlbumRelationships : Decodable {
    let data: [AMAlbum]
}

struct ArtistRelationships : Decodable {
    let data: [AMArtist]
}

struct GenreRelationships : Decodable {
    let data: [AMGenre]
}

struct PlaylistRelationships : Decodable {
    let data: [AMPlaylist]
}

struct CuratorRelationships : Decodable {
    let data: [AMCurator]
}

struct StationRelationship : Decodable {
    let data: AMStation
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
