//
//  Song.swift
//  Sona
//
//  Created by Tyler Cheek on 5/29/20.
//  Copyright © 2020 Tyler Cheek. All rights reserved.
//

protocol Song {
    var id: String { get }
    var title: String? { get }
    var artistName: String? { get }
    var durationInMillis: Int64? { get }
    var albumName: String? { get }
    var artwork: Artwork? { get }
}
