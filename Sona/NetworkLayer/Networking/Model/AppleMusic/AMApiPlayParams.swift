//
//  AMPlayParamsModel.swift
//  Sona
//
//  Created by Tyler Cheek on 6/24/20.
//  Copyright © 2020 Tyler Cheek. All rights reserved.
//

struct AMAPiPlayParams : Decodable {
    let id: String
    let isLibrary: Bool
    let kind: String
}
