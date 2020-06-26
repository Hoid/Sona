//
//  BroadcastSearchResultsTableViewCell.swift
//  Sona
//
//  Created by Tyler Cheek on 5/28/20.
//  Copyright © 2020 Tyler Cheek. All rights reserved.
//

import UIKit

class BroadcastSearchResultsTableViewCell : UITableViewCell {
    
    @IBOutlet weak var songTitleLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    
    var broadcast: Broadcast?
    
    public func setup(broadcast: Broadcast) {
        
        self.broadcast = broadcast
        
        self.songTitleLabel.text = broadcast.song.title
        self.artistLabel.text = broadcast.song.artistName
        self.usernameLabel.text = broadcast.user.username
        
    }
    
}
