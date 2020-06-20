//
//  ParameterEncoding.swift
//  Sona
//
//  Created by Tyler Cheek on 7/13/19.
//  Copyright © 2019 Tyler Cheek. All rights reserved.
//

import Foundation

public typealias Parameters = [String : Any]

public protocol ParameterEncoder {
    
    static func encode(urlRequest: inout URLRequest, with parameters: Parameters) throws
    
}
