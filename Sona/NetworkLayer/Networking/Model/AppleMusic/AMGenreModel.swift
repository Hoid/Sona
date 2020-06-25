//
//  AMGenreModel.swift
//  Sona
//
//  Created by Tyler Cheek on 6/24/20.
//  Copyright © 2020 Tyler Cheek. All rights reserved.
//

struct AMGenre : Decodable {
    
    struct Attributes : Decodable {
        let name: String
    }
    
    let attributes: Attributes?
    let type: String
    
}
