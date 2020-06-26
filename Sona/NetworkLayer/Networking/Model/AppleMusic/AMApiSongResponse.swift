//
//  AppleMusicApiResponseModel.swift
//  Sona
//
//  Created by Tyler Cheek on 6/21/20.
//  Copyright © 2020 Tyler Cheek. All rights reserved.
//

import Foundation

class AMApiSongResponse : AMApiResourceResponseRoot {
    let data: [AMApiSong]?
    let next: String?
//    let results: AMResults?
//    let errors: [AMError]?
}
