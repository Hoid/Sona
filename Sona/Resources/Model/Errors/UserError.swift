//
//  UserError.swift
//  Sona
//
//  Created by Tyler Cheek on 6/7/20.
//  Copyright © 2020 Tyler Cheek. All rights reserved.
//

enum UserError : Error {
    
    case notFound(message: String)
    case alreadyExists(message: String)
    
    var localizedDescription: String {
        switch self {
        case let .notFound(message), let .alreadyExists(message):
            return message
        }
    }
    
}
