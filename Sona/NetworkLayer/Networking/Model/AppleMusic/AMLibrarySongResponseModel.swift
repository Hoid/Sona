//
//  AMLibrarySongResponseModel.swift
//  Sona
//
//  Created by Tyler Cheek on 6/25/20.
//  Copyright © 2020 Tyler Cheek. All rights reserved.
//

class AMLibrarySongResponse : AMResourceResponseRoot {
    let data: [AMLibrarySong]?
    let next: String?
//    let results: AMResults?
//    let errors: [AMError]?
}
