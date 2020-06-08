//
//  UserError.swift
//  Sona
//
//  Created by Tyler Cheek on 6/7/20.
//  Copyright © 2020 Tyler Cheek. All rights reserved.
//

enum UserError : Error {
    
    case notFound(firebaseUID: String)
    
}
