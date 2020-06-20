//
//  HTTPTask.swift
//  Sona
//
//  Created by Tyler Cheek on 7/13/19.
//  Copyright © 2019 Tyler Cheek. All rights reserved.
//

import Foundation

public typealias HTTPHeaders = [String : String]

public enum HTTPTask {
    
    case request
    
    case requestWithParameters(bodyParameters: Parameters?, urlParameters: Parameters?)
    
    case requestWithParametersAndHeaders(bodyParameters: Parameters?, urlParameters: Parameters?, headers: HTTPHeaders?)
    
    // case download, upload...etc

}
