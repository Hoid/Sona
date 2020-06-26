//
//  BroadcastPlayerViewController.swift
//  Sona
//
//  Created by Tyler Cheek on 6/25/20.
//  Copyright © 2020 Tyler Cheek. All rights reserved.
//

import UIKit

class BroadcastPlayerViewController : UIViewController {
    
    var selectedBroadcast: Broadcast?
    
    override func viewDidLoad() {
        print("Artist of selected broadcast: \(selectedBroadcast?.song.artistName ?? "no data")")
    }
    
}
