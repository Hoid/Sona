//
//  AMArtworkModel.swift
//  Sona
//
//  Created by Tyler Cheek on 6/24/20.
//  Copyright © 2020 Tyler Cheek. All rights reserved.
//

struct AMApiArtwork : Artwork, Decodable {
    let height: Int
    let width: Int
    let url: String
}
