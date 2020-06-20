//
//  NetworkManager.swift
//  Sona
//
//  Created by Tyler Cheek on 6/12/20.
//  Copyright © 2020 Tyler Cheek. All rights reserved.
//

import Foundation

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
        case 501...599: return .failure(HTTPNetworkError.serverSideError)
        default: return .failure(HTTPNetworkError.failed)
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
    
    public var errorDescription: String? {
        switch self {
        case .parametersNil:
            return NSLocalizedString("Error Found: Parameters are nil.", comment: "")
        case .headersNil:
            return NSLocalizedString("Error Found: Headers are Nil", comment: "")
        case .encodingFailed:
            return NSLocalizedString("Error Found: Parameter Encoding failed.", comment: "")
        case .decodingFailed:
            return NSLocalizedString("Error Found: Unable to Decode the data.", comment: "")
        case .missingURL:
            return NSLocalizedString("Error Found: The URL is nil.", comment: "")
        case .couldNotParse:
            return NSLocalizedString("Error Found: Unable to parse the JSON response.", comment: "")
        case .noData:
            return NSLocalizedString("Error Found: The data from API is Nil.", comment: "")
        case .fragmentResponse:
            return NSLocalizedString("Error Found: The API's response's body has fragments.", comment: "")
        case .unwrappingError:
            return NSLocalizedString("Error Found: Unable to unwrape the data.", comment: "")
        case .dataTaskFailed:
            return NSLocalizedString("Error Found: The Data Task object failed.", comment: "")
        case .authenticationError:
            return NSLocalizedString("Error Found: You must be Authenticated.", comment: "")
        case .badRequest:
            return NSLocalizedString("Error Found: Bad Request", comment: "")
        case .pageNotFound:
            return NSLocalizedString("Error Found: Page/Route rquested not found.", comment: "")
        case .failed:
            return NSLocalizedString("Error Found: Network Request failed", comment: "")
        case .serverSideError:
            return NSLocalizedString("Error Found: Server error", comment: "")
        }
    }
    
}

enum Result<T> {
    
    case success(T)
    case failure(Error)
    
}

extension URLRequest {
    public func log() -> Self {
        print("-------- URLRequest --------")
        print("\(self.httpMethod ?? "NO HTTP METHOD") \(self)")
        print("body: \n \(self.httpBody?.debugDescription ?? "none")")
        print("headers: \n \(self.allHTTPHeaderFields ?? [String:String]())")
        return self
    }
}

extension Data {
    public func log() {
        let payload = String(decoding: self, as: UTF8.self)
        print("Data: \n \(payload)")
    }
}
