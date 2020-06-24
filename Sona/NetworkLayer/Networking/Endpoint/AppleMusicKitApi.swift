//
//  AppleMusicKitApi.swift
//  Sona
//
//  Created by Tyler Cheek on 6/21/20.
//  Copyright © 2020 Tyler Cheek. All rights reserved.
//

import Foundation
import SwiftJWT
import StoreKit

public enum AppleMusicKitApi {
    case getAllSongsInLibrary
}

extension AppleMusicKitApi : EndPointType {

    var environmentBaseURL : String {
        let networkManager = AppleMusicKitNetworkManager()
        switch networkManager.environment {
        case .production:   return "https://api.music.apple.com/v1/"
        case .qa:           return "https://api.music.apple.com/v1/"
        case .staging:      return "https://api.music.apple.com/v1/"
        }
    }
    
    var baseURL: URL {
        guard let url = URL(string: environmentBaseURL) else { fatalError("baseURL could not be configured.")}
        return url
    }

    var path: String {
        switch self {
        case .getAllSongsInLibrary:
            return "me/library/songs"
        }
    }

    var httpMethod: HTTPMethod {
        switch self {
        case .getAllSongsInLibrary:
            return .get
        }
    }

    var task: HTTPTask {
        switch self {
        case .getAllSongsInLibrary:
            return .requestWithParametersAndHeaders(bodyParameters: nil, urlParameters: nil, headers: headers)
        }
    }

    var headers: HTTPHeaders? {
        return nil
    }
}
