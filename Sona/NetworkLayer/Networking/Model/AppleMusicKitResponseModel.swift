//
//  AppleMusicKitResponseModel.swift
//  Sona
//
//  Created by Tyler Cheek on 6/21/20.
//  Copyright © 2020 Tyler Cheek. All rights reserved.
//

import Foundation

struct AppleMusicResponseRoot {
    
    let data: [AppleMusicResource]?
    let results: AppleMusicResults?
    
}

struct AppleMusicResource {
    
    struct Attributes : Decodable {
        
        struct PlayParams : Decodable {
            
            let id: String
            let isLibrary: Bool
            let kind: String
            
            private enum PlayParamsCodingKeys : String, CodingKey {
                case id = "id"
                case isLibrary = "isLibrary"
                case kind = "kind"
            }
            
            init(from decoder: Decoder) throws {
                let playParamsContainer = try decoder.container(keyedBy: PlayParamsCodingKeys.self)
                
                self.id = try playParamsContainer.decode(String.self, forKey: .id)
                self.isLibrary = try playParamsContainer.decode(Bool.self, forKey: .isLibrary)
                self.kind = try playParamsContainer.decode(String.self, forKey: .kind)
            }
            
        }
        
        let albumName: String
        let artistName: String
        let artwork: Artwork
        let name: String
        let playParams: PlayParams
        let trackNumber: Int
        
        private enum AttributesCodingKeys : String, CodingKey {
            case albumName = "albumName"
            case artistName = "artistName"
            case artwork = "artwork"
            case name = "name"
            case playParams = "playParams"
            case trackNumber = "trackNumber"
        }
        
        init(from decoder: Decoder) throws {
            let attributesContainer = try decoder.container(keyedBy: AttributesCodingKeys.self)
            
            self.albumName = try attributesContainer.decode(String.self, forKey: .albumName)
            self.artistName = try attributesContainer.decode(String.self, forKey: .artistName)
            self.artwork = try attributesContainer.decode(Artwork.self, forKey: .artwork)
            self.name = try attributesContainer.decode(String.self, forKey: .name)
            self.playParams = try attributesContainer.decode(PlayParams.self, forKey: .playParams)
            self.trackNumber = try attributesContainer.decode(Int.self, forKey: .trackNumber)
        }
        
    }
    
    struct Artwork : Decodable {
        
        let height: Int
        let width: Int
        let url: String
        
        private enum ArtworkCodingKeys : String, CodingKey {
            case height = "height"
            case width = "width"
            case url = "url"
        }
        
        init(from decoder: Decoder) throws {
            let artworkContainer = try decoder.container(keyedBy: ArtworkCodingKeys.self)
            
            self.height = try artworkContainer.decode(Int.self, forKey: .height)
            self.width = try artworkContainer.decode(Int.self, forKey: .width)
            self.url = try artworkContainer.decode(String.self, forKey: .url)
        }
        
    }
    
}

struct AppleMusicResults {
    
    let stuff: String

}

struct AppleMusicSongsApiResponse {
    let songs: [AppleMusicSongApiResponse]
}

extension AppleMusicSongsApiResponse : Decodable {
    
    private enum AppleMusicSongsApiResponseCodingKeys : String, CodingKey {
        case data = "data"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: AppleMusicSongsApiResponseCodingKeys.self)
        
        self.songs = try container.decode([AppleMusicSongApiResponse].self, forKey: .data)
    }
    
}

struct AppleMusicSongApiResponse : Decodable {
    
    let attributes: AppleMusicResource.Attributes
    let id: String
    let type: String
    
    private enum AppleMusicSongApiResponseCodingKeys : String, CodingKey {
        case attributes = "attributes"
        case id = "id"
        case type = "type"
    }
    
    init(from decoder: Decoder) throws {
        let rootContainer = try decoder.container(keyedBy: AppleMusicSongApiResponseCodingKeys.self)
        
        self.attributes = try rootContainer.decode(AppleMusicResource.Attributes.self, forKey: .attributes)
        self.id = try rootContainer.decode(String.self, forKey: .id)
        self.type = try rootContainer.decode(String.self, forKey: .type)
    }
    
}
