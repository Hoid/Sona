//
//  SpotifySong.swift
//  Sona
//
//  Created by Tyler Cheek on 6/21/20.
//  Copyright © 2020 Tyler Cheek. All rights reserved.
//

struct SpotifySong : Song {
    let id: String
    let title: String?
    let artistName: String?
    let durationInMillis: Int64?
    let albumName: String?
    let artwork: Artwork?
}
