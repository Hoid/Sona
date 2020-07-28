//
//  StreamsNetworkManager.swift
//  Sona
//
//  Created by Tyler Cheek on 6/27/20.
//  Copyright © 2020 Tyler Cheek. All rights reserved.
//

import Foundation
import Starscream

class StreamsNetworkManager : NetworkManager {
    
    var environment: NetworkEnvironment = NetworkEnvironment.staging
    var router = Router<StreamsApi>()
    
    func getEnvironment() -> NetworkEnvironment {
        return environment
    }
    
    func getAllStreams(completion: @escaping (_ streamsApiResponse: StreamsApiResponse?, _ error: String?) -> ()) {
        
        router.request(.getAllStreams) { data, response, error in
            self.handleResponse(data: data, dataType: StreamsApiResponse.self, response: response, error: error, completion: completion)
        }
        
    }
    
    func getStreamsForFriends(ofUserWithFirebaseUID firebaseUID: String, completion: @escaping (_ streamsApiResponse: StreamsApiResponse?, _ error: String?) -> ()) {
        
        router.request(.getFriendsStreams(firebaseUID: firebaseUID)) { data, response, error in
            self.handleResponse(data: data, dataType: StreamsApiResponse.self, response: response, error: error, completion: completion)
        }
        
    }
    
}
