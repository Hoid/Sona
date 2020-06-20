//
//  UsersNetworkManager.swift
//  Sona
//
//  Created by Tyler Cheek on 6/12/20.
//  Copyright © 2020 Tyler Cheek. All rights reserved.
//

import Foundation

class UsersNetworkManager : NetworkManager {
    
    var environment: NetworkEnvironment = NetworkEnvironment.qa
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
    
    // This generic method helps reduce duplicated code, since this code used to be repeated in all of the above methods
    private func handleResponse<T: Decodable>(data: Data?, dataType: T.Type, response: URLResponse?, error: Error?, completion: @escaping (T?, _ error: String?) -> ()) {
        if error != nil {
            completion(nil, "Please check your network connection.")
        }

        if let response = response as? HTTPURLResponse {
            let result = self.parseResponseStatusCode(response)
            switch result {
            case .success:
                guard let responseData = data else {
                    completion(nil, HTTPNetworkError.noData.errorDescription)
                    return
                }
                do {
                    let apiResponse = try JSONDecoder().decode(dataType, from: responseData)
                    completion(apiResponse, nil)
                } catch {
                    print(error)
                    completion(nil, HTTPNetworkError.decodingFailed.errorDescription)
                }
            case .failure(let networkFailureError):
                completion(nil, networkFailureError.localizedDescription)
            }
        }
    }
    
}
