//
//  NetworkError.swift
//  Sona
//
//  Created by Tyler Cheek on 7/13/19.
//  Copyright © 2019 Tyler Cheek. All rights reserved.
//

import Foundation

public enum NetworkError: String, Error {
    case parametersNil = "Parameters were nil."
    case encodingFailed = "Parameter encoding failed."
    case missingURL = "URL is nil."
}
