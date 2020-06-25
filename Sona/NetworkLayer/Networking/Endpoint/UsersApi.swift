//
//  UsersApi.swift
//  Sona
//
//  Created by Tyler Cheek on 7/18/19.
//  Copyright © 2019 Tyler Cheek. All rights reserved.
//

import Foundation

public enum UsersApi {
    case getUsers
    case getPublicUsers
    case getUser(firebaseUID: String)
    case setIsPublic(isPublic: Bool, userFirebaseUID: String)
    case putUser(user: User)
    case newUser(user: User)
}

extension UsersApi : EndPointType {

    var environmentBaseURL : String {
        let networkManager = UsersNetworkManager()
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
        case .getUsers:
            return "users"
        case .getPublicUsers:
            return "users/public"
        case .getUser(let id):
            return "users/\(id)"
        case .setIsPublic(_, let userFirebaseUID):
            return "users/\(userFirebaseUID)/public"
        case .putUser(let user):
            return "users/\(user.firebaseUID)/"
        case .newUser:
            return "users"
        }
    }

    var httpMethod: HTTPMethod {
        switch self {
        case .getUsers:
            return .get
        case .getPublicUsers:
            return .get
        case .getUser:
            return .get
        case .setIsPublic:
            return .put
        case .putUser:
            return .put
        case .newUser:
            return .post
        }
    }

    var task: HTTPTask {
        switch self {
        case .getUsers, .getPublicUsers, .getUser:
            return .requestWithParametersAndHeaders(bodyParameters: nil, urlParameters: nil, headers: headers)
        case .setIsPublic(let isPublic, _):
            return .requestWithParametersAndHeaders(bodyParameters: ["isPublic" : isPublic], urlParameters: nil, headers: headers)
        case .newUser(let user):
            return .requestWithParametersAndHeaders(bodyParameters: user.bodyParameters, urlParameters: nil, headers: headers)
        case .putUser(let user):
            return .requestWithParametersAndHeaders(bodyParameters: user.bodyParameters, urlParameters: nil, headers: headers)
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
