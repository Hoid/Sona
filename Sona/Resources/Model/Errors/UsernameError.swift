//
//  UsernameError.swift
//  Sona
//
//  Created by Tyler Cheek on 6/4/20.
//  Copyright © 2020 Tyler Cheek. All rights reserved.
//

enum UsernameError : Error {
    
    case alreadyExists(username: String)
    case notPresent
    
    var localizedDescription: String {
        switch self {
        case .alreadyExists(let username):
            return "Username \(username) already exists"
        case .notPresent:
            return "Username is not present in user object"
        }
    }
    
}
