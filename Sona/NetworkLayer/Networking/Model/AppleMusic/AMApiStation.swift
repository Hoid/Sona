//
//  AMStationModel.swift
//  Sona
//
//  Created by Tyler Cheek on 6/24/20.
//  Copyright © 2020 Tyler Cheek. All rights reserved.
//

struct AMApiStation : Decodable {
    
    struct Attributes : Decodable {
        let artwork: AMApiArtwork
        let durationInMillis: Int64?
        let isLive: Bool
        let name: String
        let url: String
    }
    
    let attributes: Attributes?
    let type: String
    
}
