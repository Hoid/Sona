//
//  ProfileError.swift
//  Sona
//
//  Created by Tyler Cheek on 6/19/20.
//  Copyright © 2020 Tyler Cheek. All rights reserved.
//

enum ProfileError : Error {
    
    case notFound
    case alreadyExists(profileId: Int64)
    case cannotCreate
    case cannotFetch
    
    var localizedDescription: String {
        switch self {
        case .notFound:
            return "Profile not found"
        case .alreadyExists(let profileId):
            return "Profile with id \(profileId) already exists"
        case .cannotCreate:
            return "Something went wrong while trying to create profile"
        case .cannotFetch:
            return "Something went wrong while trying to fetch profile"
        }
    }
    
}
