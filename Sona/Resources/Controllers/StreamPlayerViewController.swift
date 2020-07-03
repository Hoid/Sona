//
//  StreamPlayerViewController.swift
//  Sona
//
//  Created by Tyler Cheek on 6/25/20.
//  Copyright © 2020 Tyler Cheek. All rights reserved.
//

import UIKit

class StreamPlayerViewController : UIViewController {
    
    var selectedBroadcast: Broadcast?
    
    var streamsManager = StreamsManager()
    
    override func viewDidLoad() {
        print("Artist of selected broadcast: \(self.selectedBroadcast?.song.artistName ?? "no data")")
        if self.streamsManager.isConnected {
            self.streamsManager.sendMessage("{\"type\": \"message\", \"data\": {\"time\": 1472513071731,\"text\": \":]\",\"author\": \"iPhone Simulator\",\"color\": \"orange\"}}")
        } else {
            print("Stream not connected.")
        }
    }
    
}
