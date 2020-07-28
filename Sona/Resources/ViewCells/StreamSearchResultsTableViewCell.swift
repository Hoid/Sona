//
//  StreamSearchResultsTableViewCell.swift
//  Sona
//
//  Created by Tyler Cheek on 5/28/20.
//  Copyright © 2020 Tyler Cheek. All rights reserved.
//

import UIKit

class StreamSearchResultsTableViewCell : UITableViewCell {
    
    @IBOutlet weak var songTitleLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    
    var stream: Stream?
    
    public func setup(stream: Stream) {
        
        self.stream = stream
        
        self.songTitleLabel.text = stream.song.title
        self.artistLabel.text = stream.song.artistName
        self.usernameLabel.text = stream.host?.username
        
    }
    
}
