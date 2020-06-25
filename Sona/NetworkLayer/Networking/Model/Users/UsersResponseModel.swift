//
//  UsersResponseModel.swift
//  Sona
//
//  Created by Tyler Cheek on 6/12/20.
//  Copyright © 2020 Tyler Cheek. All rights reserved.
//

import Foundation

struct UsersApiResponse {
    let users: [UserApiResponse]
}

extension UsersApiResponse: Decodable {
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        self.users = try container.decode([UserApiResponse].self)
    }
    
}

struct UserApiResponse {
    let firebaseUID: String
    let email: String
    let username: String?
    let name: String?
    let isPublic: Bool
}

extension UserApiResponse: Decodable {
    
    private enum UserApiResponseCodingKeys: String, CodingKey {
        case firebaseUID = "firebaseUID"
        case email = "email"
        case username = "username"
        case name = "name"
        case isPublic = "isPublic"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: UserApiResponseCodingKeys.self)
        
        firebaseUID = try container.decode(String.self, forKey: .firebaseUID)
        email = try container.decode(String.self, forKey: .email)
        username = try container.decodeIfPresent(String.self, forKey: .username)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        isPublic = try container.decode(Bool.self, forKey: .isPublic)
    }
    
}

struct UserIsPublicApiResponse {
    let isPublic: Bool
}

extension UserIsPublicApiResponse: Decodable {
    
    private enum UserIsPublicApiResponseCodingKeys: String, CodingKey {
        case isPublic = "isPublic"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: UserIsPublicApiResponseCodingKeys.self)
        
        isPublic = try container.decode(Bool.self, forKey: .isPublic)
    }
    
}
