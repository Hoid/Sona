//
//  AppleMusicPlayerController.swift
//  Sona
//
//  Created by Tyler Cheek on 6/21/20.
//  Copyright © 2020 Tyler Cheek. All rights reserved.
//

import StoreKit
import MediaPlayer

class AppleMusicPlayerController {
    
    let systemMusicPlayer = MPMusicPlayerController.systemMusicPlayer
    
    var storefrontId: String?
    
    init() {
        checkIfDeviceCanPlayback()
        fetchStorefrontRegion()
    }
    
    func checkIfDeviceCanPlayback() {
        let serviceController = SKCloudServiceController()
        serviceController.requestCapabilities { (capability: SKCloudServiceCapability, error: Error?) in
            
            if error != nil {
                print("An error occurred while attempting to request capabilities from SKCloudServiceController()")
                return
            }
            if capability.contains(.addToCloudMusicLibrary) {
                print("The user has an Apple Music subscription, can playback music AND can add to the Cloud Music Library")
            } else if capability.contains(.musicCatalogPlayback) {
                print("The user has an Apple Music subscription and can playback music!")
            } else if capability.contains(.musicCatalogSubscriptionEligible) {
                print("The user doesn't have an Apple Music subscription available. Now would be a good time to prompt them to buy one?")
            } else {
                print("Capability not recognized in AppleMusicPlayerController.checkIfDeviceCanPlayback()")
            }
            
        }
        
    }
    
    func fetchStorefrontRegion() {
        
        let serviceController = SKCloudServiceController()
        serviceController.requestStorefrontIdentifier { (storefrontId: String?, err: Error?) in
            guard err == nil else {
                print("An error occured. Handle it here.")
                return
            }
            guard let storefrontId = storefrontId else {
                print("Could not unwrap storefrontId for user in AppleMusicPlayerController.appleMusicFetchStorefrontRegion()")
                return
            }
            self.storefrontId = storefrontId
        }
        
    }
    
    func appleMusicPlayTrackId(ids: [String]) {
        
        systemMusicPlayer.setQueue(with: ids)
        systemMusicPlayer.play()
        
    }
    
}
