//
//  AMResponseRootModel.swift
//  Sona
//
//  Created by Tyler Cheek on 6/24/20.
//  Copyright © 2020 Tyler Cheek. All rights reserved.
//

protocol AMResourceResponseRoot : Decodable {
    associatedtype DataType: Decodable
    var data: [DataType]? { get }
    var next: String? { get }
//    let results: AppleMusicResults?
//    let errors: [AppleMusicError]?
}
