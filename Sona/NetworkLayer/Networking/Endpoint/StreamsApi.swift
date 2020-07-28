//
//  StreamsApi.swift
//  Sona
//
//  Created by Tyler Cheek on 7/6/20.
//  Copyright © 2020 Tyler Cheek. All rights reserved.
//

import Foundation

public enum StreamsApi {
    case getAllStreams
    case getFriendsStreams(firebaseUID: String)
}

extension StreamsApi : EndPointType {

    var environmentBaseURL : String {
        let networkManager = StreamsNetworkManager()
        switch networkManager.environment {
        case .production:   return "http://sona-server.us-east-1.elasticbeanstalk.com/"
        case .qa:           return "http://localhost:5000/"
        case .staging:      return "http://sona-server.us-east-1.elasticbeanstalk.com/"
        }
    }
    
    var baseURL: URL {
        guard let url = URL(string: environmentBaseURL) else { fatalError("baseURL could not be configured.")}
        return url
    }

    var path: String {
        switch self {
        case .getAllStreams:
            return "streams"
        case .getFriendsStreams(let firebaseUID):
            return "streams/friends-of/\(firebaseUID)"
        }
    }

    var httpMethod: HTTPMethod {
        switch self {
        case .getAllStreams:
            return .get
        case .getFriendsStreams(_):
            return .get
        }
    }

    var task: HTTPTask {
        switch self {
        case .getAllStreams, .getFriendsStreams(_):
            return .requestWithParametersAndHeaders(bodyParameters: nil, urlParameters: nil, headers: headers)
        }
    }

    var headers: HTTPHeaders? {
        let username = "admin"
        let password = "passcode"
        let loginData = String(format: "%@:%@", username, password).data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString()
        let authString = "Basic \(base64LoginString)"
        return ["Authorization" : authString]
    }
}
