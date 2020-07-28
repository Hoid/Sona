//
//  StreamPlayerViewController.swift
//  Sona
//
//  Created by Tyler Cheek on 6/25/20.
//  Copyright © 2020 Tyler Cheek. All rights reserved.
//

import UIKit

class StreamPlayerViewController : UIViewController {
    
    var selectedStream: Stream?
    
    @IBOutlet weak var artworkUiImageView: UIImageView!
    @IBOutlet weak var songNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var playPauseToggleButton: UIButton!
    @IBOutlet weak var volumeSlider: UISlider!
    
    override func viewDidLoad() {
        guard let selectedStream = selectedStream else {
            print("Could not unwrap selectedStream in StreamPlayerViewComntroller.viewDidLoad()")
            return
        }
        songNameLabel.text = selectedStream.song.title ?? "no title data"
        artistNameLabel.text = selectedStream.song.artistName ?? "no artist data"
        artworkUiImageView.load(url: URL(string: selectedStream.song.artwork?.url ?? "https://upload.wikimedia.org/wikipedia/commons/3/37/Empty_book.jpg")!)
        appDelegate.amPlayerManager.beginPlayback(itemID: selectedStream.song.id)
    }
    
    @IBAction func playPauseToggled(_ sender: Any) {
        print("playPauseToggleButton pressed")
        appDelegate.amPlayerManager.togglePlayPause()
    }
    
    @IBAction func volumeChanged(_ sender: UISlider) {
        print("volume value changed")
    }
    
    
}
