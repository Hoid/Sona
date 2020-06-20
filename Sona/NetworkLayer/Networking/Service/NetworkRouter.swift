//
//  NetworkRouter.swift
//  Sona
//
//  Created by Tyler Cheek on 7/13/19.
//  Copyright © 2019 Tyler Cheek. All rights reserved.
//

import Foundation

public typealias NetworkRouterCompletion = (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> ()

protocol NetworkRouter: class {
    
    associatedtype EndPoint: EndPointType
    func request(_ route: EndPoint, completion: @escaping NetworkRouterCompletion)
    func cancel()
    
}
