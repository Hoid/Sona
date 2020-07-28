//
//  Stream.swift
//  Sona
//
//  Created by Tyler Cheek on 5/29/20.
//  Copyright © 2020 Tyler Cheek. All rights reserved.
//

import Foundation
import UIKit

class Stream {
    var host: User?
    var song: Song
    var lastModifiedAction: StreamModifyAction
    var lastModifiedDate: Date
    var timePositionSecs: Int
    
    init(host: User?, song: Song, lastModifiedAction: StreamModifyAction, lastModifiedDate: Date, timePositionSecs: Int) {
        self.host = host
        self.song = song
        self.lastModifiedAction = lastModifiedAction
        self.lastModifiedDate = lastModifiedDate
        self.timePositionSecs = timePositionSecs
    }
    
    init(fromStreamApiResponse streamApiResponse: StreamApiResponse) {
        switch streamApiResponse.streamingService {
        case .AppleMusic:
            self.song = AMSong(id: streamApiResponse.songId, title: streamApiResponse.songName, artistName: streamApiResponse.artistName, durationInMillis: nil, albumName: nil, artwork: nil)
            self.lastModifiedAction = streamApiResponse.lastModifiedAction
            self.lastModifiedDate = streamApiResponse.lastModifiedDate
            self.timePositionSecs = streamApiResponse.timePositionSecs
            initHost(firebaseUID: streamApiResponse.hostFirebaseUID)
        case .Spotify:
            self.song = SpotifySong(id: streamApiResponse.songId, title: streamApiResponse.songName, artistName: streamApiResponse.artistName, durationInMillis: nil, albumName: nil, artwork: nil)
            self.lastModifiedAction = streamApiResponse.lastModifiedAction
            self.lastModifiedDate = streamApiResponse.lastModifiedDate
            self.timePositionSecs = streamApiResponse.timePositionSecs
            initHost(firebaseUID: streamApiResponse.hostFirebaseUID)
        }
    }
    
    static func getDefaultStream() -> Stream {
        return Stream(host: User(), song: AMSong(), lastModifiedAction: StreamModifyAction.started, lastModifiedDate: Date(), timePositionSecs: 0)
    }
    
    private func initHost(firebaseUID: String) {
        DispatchQueue.main.async {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                print("Could not get appDelegate in Stream.initHost()")
                return
            }
            appDelegate.usersNetworkManager.getUser(firebaseUID: firebaseUID) { (userApiResponse, error) in
                if let error = error {
                    print(error)
                    return
                }
                guard let userApiResponse = userApiResponse else {
                    print("Could not unwrap userApiResponse in Stream.initHost()")
                    return
                }
                self.host = User(fromUserApiResponse: userApiResponse)
            }
        }
    }
}
