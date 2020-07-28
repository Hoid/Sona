//
//  StreamsResponseModel.swift
//  Sona
//
//  Created by Tyler Cheek on 7/6/20.
//  Copyright © 2020 Tyler Cheek. All rights reserved.
//

import Foundation

struct StreamsApiResponse {
    let streams: [StreamApiResponse]
}

extension StreamsApiResponse: Decodable {
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        self.streams = try container.decode([StreamApiResponse].self)
    }
    
}

struct StreamApiResponse {
    let hostFirebaseUID: String
    let songId: String
    let songName: String
    let artistName: String
    let streamingService: StreamingService
    let lastModifiedAction: StreamModifyAction
    let lastModifiedDate: Date
    let timePositionSecs: Int
}

extension StreamApiResponse : Decodable {
    
    private enum StreamApiResponseCodingKeys: String, CodingKey {
        case hostFirebaseUID = "hostFirebaseUID"
        case songId = "songId"
        case songName = "songName"
        case artistName = "artistName"
        case streamingService = "streamingService"
        case lastModifiedAction = "lastModifiedAction"
        case lastModifiedDate = "lastModifiedDate"
        case timePositionSecs = "timePositionSecs"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: StreamApiResponseCodingKeys.self)
        
        hostFirebaseUID = try container.decode(String.self, forKey: .hostFirebaseUID)
        songId = try container.decode(String.self, forKey: .songId)
        songName = try container.decode(String.self, forKey: .songName)
        artistName = try container.decode(String.self, forKey: .artistName)
        let streamingServiceStr = try container.decode(String.self, forKey: .streamingService)
        streamingService = StreamingService(rawValue: streamingServiceStr) ?? StreamingService.Spotify
        let lastModifiedActionStr = try container.decode(String.self, forKey: .lastModifiedAction)
        lastModifiedAction = StreamModifyAction(rawValue: lastModifiedActionStr) ?? StreamModifyAction.started
        let lastModifiedDateStr = try container.decode(String.self, forKey: .lastModifiedDate)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS+00:00"
        lastModifiedDate = dateFormatter.date(from: lastModifiedDateStr)!
        timePositionSecs = try container.decode(Int.self, forKey: .timePositionSecs)
    }
    
}
