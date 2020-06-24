//
//  MusicKitClaims.swift
//  Sona
//
//  Created by Tyler Cheek on 6/21/20.
//  Copyright © 2020 Tyler Cheek. All rights reserved.
//

import SwiftJWT

struct MusicKitClaims : Claims {
    let iss: String
    let sub: String
    let exp: Date
    let admin: Bool
}
