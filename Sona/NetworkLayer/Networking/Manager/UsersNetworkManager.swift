//
//  UsersNetworkManager.swift
//  Sona
//
//  Created by Tyler Cheek on 6/12/20.
//  Copyright © 2020 Tyler Cheek. All rights reserved.
//

import Foundation

class UsersNetworkManager : NetworkManager {
    
    var environment: NetworkEnvironment = NetworkEnvironment.staging
    var router = Router<UsersApi>()
    
    func getEnvironment() -> NetworkEnvironment {
        return environment
    }
    
    func getAllUsers(completion: @escaping (_ userApiResponses: [UserApiResponse]?, _ error: String?) -> ()) {
        
        router.request(.getUsers) { data, response, error in
            self.handleResponse(data: data, dataType: [UserApiResponse].self, response: response, error: error, completion: completion)
        }
        
    }
        
    func getPublicUsers(completion: @escaping (_ userApiResponses: [UserApiResponse]?, _ error: String?) -> ()) {
    
        router.request(.getPublicUsers) { data, response, error in
            self.handleResponse(data: data, dataType: [UserApiResponse].self, response: response, error: error, completion: completion)
        }
    
    }
    
    func createUser(user: User, completion: @escaping (_ userApiResponse: UserApiResponse?, _ error: String?) -> ()) {
        
        router.request(.newUser(user: user)) { data, response, error in
            self.handleResponse(data: data, dataType: UserApiResponse.self, response: response, error: error, completion: completion)
        }
        
    }
    
    func set(username: String, forUser user: User, completion: @escaping (_ userApiResponse: UserApiResponse?, _ error: String?) -> ()) {
        
        user.username = username
        router.request(.putUser(user: user)) { (data, response, error) in
            self.handleResponse(data: data, dataType: UserApiResponse.self, response: response, error: error, completion: completion)
        }
        
    }
    
    func set(isPublic: Bool, forUserFirebaseUID userFirebaseUID: String, completion: @escaping (_ userApiResponse: UserIsPublicApiResponse?, _ error: String?) -> ()) {
        
        router.request(.setIsPublic(isPublic: isPublic, userFirebaseUID: userFirebaseUID)) { (data, response, error) in
            self.handleResponse(data: data, dataType: UserIsPublicApiResponse.self, response: response, error: error, completion: completion)
        }
        
    }
    
}
