//
//  NetworkManager.swift
//  Sona
//
//  Created by Tyler Cheek on 6/12/20.
//  Copyright © 2020 Tyler Cheek. All rights reserved.
//

import Foundation

typealias NetworkResponse<T> = (T?, _ error: String?) -> ()

enum NetworkEnvironment {
    case qa
    case production
    case staging
}

protocol NetworkManager {
    
    associatedtype DataType: EndPointType
    
    var environment: NetworkEnvironment { get }
    var router: Router<DataType> { get set }
    
}

extension NetworkManager {
    
    public func parseResponseStatusCode(_ response: HTTPURLResponse) -> Result<String> {
        
        switch response.statusCode {
        case 200...299: return .success("Successful network request.")
        case 401...403: return .failure(HTTPNetworkError.authenticationError)
        case 404: return .failure(HTTPNetworkError.pageNotFound)
        case 409: return .failure(HTTPNetworkError.resourceAlreadyExists)
        case 429: return .failure(HTTPNetworkError.rateLimitExceeded)
        case 501...599: return .failure(HTTPNetworkError.serverSideError)
        default: return .failure(HTTPNetworkError.failed)
        }
        
    }
    
    /// This generic method helps reduce duplicated code, since this code used to be repeated in all of the NetworkManager adopters' methods.
    /// - Parameters:
    ///   - data: The actual data returned from the API
    ///   - dataType: The data's Type in the model that will be used to `decode` the response data
    ///   - response: The URLResponse for the request
    ///   - error: The error, if there is one
    ///   - completion: Escaping completion handler which should handle either the decoded response data or the error, if present
    public func handleResponse<T : Decodable>(data: Data?, dataType: T.Type?, response: URLResponse?, error: Error?, completion: @escaping NetworkResponse<T>) {
        if error != nil {
            completion(nil, "Please check your network connection or server status.")
        }

        if let response = response as? HTTPURLResponse {
            let result = self.parseResponseStatusCode(response)
            switch result {
            case .success:
                guard let responseData = data else {
                    // still a success case, just with only a response status and no response body
                    completion(nil, nil)
                    return
                }
                do {
                    if let dataType = dataType {
                        let apiResponse = try JSONDecoder().decode(dataType, from: responseData)
                        completion(apiResponse, nil)
                    } else {
                        // still a success case, just with only a response status and no response body
                        completion(nil, nil)
                    }
                } catch {
                    print(error)
                    completion(nil, HTTPNetworkError.decodingFailed.errorDescription)
                }
            case .failure(let networkFailureError):
                completion(nil, networkFailureError.localizedDescription)
            }
        }
    }
    
}

// The enumeration defines possible errrors to encounter during Network Request
public enum HTTPNetworkError: LocalizedError {
    
    case parametersNil
    case headersNil
    case encodingFailed
    case decodingFailed
    case missingURL
    case couldNotParse
    case noData
    case fragmentResponse
    case unwrappingError
    case dataTaskFailed
    case authenticationError
    case badRequest
    case pageNotFound
    case failed
    case serverSideError
    case resourceAlreadyExists
    case rateLimitExceeded
    
    public var errorDescription: String? {
        switch self {
        case .parametersNil:
            return NSLocalizedString("Error Found: Parameters are nil.", comment: "")
        case .headersNil:
            return NSLocalizedString("Error Found: Headers are Nil", comment: "")
        case .encodingFailed:
            return NSLocalizedString("Error Found: Parameter Encoding failed.", comment: "")
        case .decodingFailed:
            return NSLocalizedString("Error Found: Unable to Decode the data", comment: "")
        case .missingURL:
            return NSLocalizedString("Error Found: The URL is nil", comment: "")
        case .couldNotParse:
            return NSLocalizedString("Error Found: Unable to parse the JSON response", comment: "")
        case .noData:
            return NSLocalizedString("Error Found: The data from API is Nil", comment: "")
        case .fragmentResponse:
            return NSLocalizedString("Error Found: The API's response's body has fragments", comment: "")
        case .unwrappingError:
            return NSLocalizedString("Error Found: Unable to unwrape the data", comment: "")
        case .dataTaskFailed:
            return NSLocalizedString("Error Found: The Data Task object failed", comment: "")
        case .authenticationError:
            return NSLocalizedString("Error Found: You must be Authenticated", comment: "")
        case .badRequest:
            return NSLocalizedString("Error Found: Bad Request", comment: "")
        case .pageNotFound:
            return NSLocalizedString("Error Found: Page/Route rquested not found", comment: "")
        case .failed:
            return NSLocalizedString("Error Found: Network Request failed", comment: "")
        case .serverSideError:
            return NSLocalizedString("Error Found: Server error", comment: "")
        case .resourceAlreadyExists:
            return NSLocalizedString("Error Found: Resource already exists", comment: "")
        case .rateLimitExceeded:
            return NSLocalizedString("Error Found: Rate limit exceeded for service", comment: "")
        }
    }
    
}

enum Result<T> {
    
    case success(T)
    case failure(Error)
    
}

extension URLRequest {
    public func log() {
        print("-------- URLRequest --------")
        print("\(self.httpMethod ?? "NO HTTP METHOD") \(self)")
        print("body: \n \(self.httpBody?.debugDescription ?? "none")")
        print("headers: \n \(self.allHTTPHeaderFields ?? [String:String]())")
    }
}

extension HTTPURLResponse {
    public func log() {
        print("-------- URLResponse --------")
        print("status: \n \(self.statusCode)")
    }
}

extension Data {
    public func log() {
        let payload = String(decoding: self, as: UTF8.self)
        print("Data: \n \(payload)")
    }
}
