//
//  Router.swift
//  Sona
//
//  Created by Tyler Cheek on 7/13/19.
//  Copyright © 2019 Tyler Cheek. All rights reserved.
//

import Foundation

class Router<EndPoint: EndPointType>: NetworkRouter {
    
    private var task: URLSessionTask?
    
    func request(_ route: EndPoint, completion: @escaping NetworkRouterCompletion) {
        
        let session = URLSession.shared
        do {
            let request = try self.buildRequest(from: route).log() // .log() prints the request to the console
            self.task = session.dataTask(with: request, completionHandler: {
                data, response, error in
                print("-------- URLResponse --------")
                data?.log()
                completion(data, response, error)
            })
        } catch {
            completion(nil, nil, error)
        }
        self.task?.resume()
        
    }
    
    private func buildRequest(from route: EndPoint) throws -> URLRequest {
        
        var request = URLRequest(url: route.baseURL.appendingPathComponent(route.path), cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10.0)
        
        request.httpMethod = route.httpMethod.rawValue
        
        // set Authentication header value for every request
        let username = "admin"
        let password = "passcode"
        let loginData = String(format: "%@:%@", username, password).data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString()
        let authString = "Basic \(base64LoginString)"
        request.setValue(authString, forHTTPHeaderField: "Authorization")
    
        switch route.task {
        case .request:
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        case .requestWithParameters(let bodyParameters, let urlParameters):
            try self.configureParameters(bodyParameters: bodyParameters, urlParameters: urlParameters, request: &request)
        case .requestWithParametersAndHeaders(bodyParameters: let bodyParameters, urlParameters: let urlParameters, headers: let additionalHeaders):
            self.addAdditionalHeaders(additionalHeaders, request: &request)
            try self.configureParameters(bodyParameters: bodyParameters, urlParameters: urlParameters, request: &request)
        }
        
        return request
        
    }
    
    private func configureParameters(bodyParameters: Parameters?,
                                         urlParameters: Parameters?,
                                         request: inout URLRequest) throws {
        
        do {
            if let bodyParameters = bodyParameters {
                try JSONParameterEncoder.encode(urlRequest: &request, with: bodyParameters)
            }
            if let urlParameters = urlParameters {
                try URLParameterEncoder.encode(urlRequest: &request, with: urlParameters)
            }
        } catch {
            throw error
        }
        
    }
    
    private func addAdditionalHeaders(_ additionalHeaders: HTTPHeaders?, request: inout URLRequest) {
        
        guard let headers = additionalHeaders else { return }
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
        
    }
    
    func cancel() {
        self.task?.cancel()
    }
    
}
