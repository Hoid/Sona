//
//  UserError.swift
//  Sona
//
//  Created by Tyler Cheek on 6/7/20.
//  Copyright © 2020 Tyler Cheek. All rights reserved.
//

enum UserError : Error {
    
    case notFound
    case alreadyExists(firebaseUID: String)
    case cannotCreate
    case cannotFetch
    
    var localizedDescription: String {
        switch self {
        case .notFound:
            return "User not found"
        case .alreadyExists:
            return "User already exists"
        case .cannotCreate:
            return "Something went wrong while trying to create user"
        case .cannotFetch:
            return "Something went wrong while trying to fetch user"
        }
    }
    
}
