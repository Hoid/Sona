//
//  AppleMusicNetworkManager.swift
//  Sona
//
//  Created by Tyler Cheek on 6/21/20.
//  Copyright © 2020 Tyler Cheek. All rights reserved.
//

import SwiftJWT

class AppleMusicNetworkManager : NetworkManager {
    
    var environment: NetworkEnvironment = NetworkEnvironment.qa
    var router = Router<AppleMusicKitApi>()
    
    func getEnvironment() -> NetworkEnvironment {
        return environment
    }
    
    /// The storefront id that is used when making Apple Music API calls.
    var storefrontID: String?
    
    /// Returns the developer token for use in Apple Music API calls.
    /// This is a relatively fast operation to getting the user token. Do no cache the developer token.
    func fetchDeveloperToken() -> String {
        let jwtHeader = Header(kid: "99JWRTYD4C")
        let jwtClaims = ClaimsStandardJWT(iss: "V3MDBDHR5T", exp: Date(timeIntervalSinceNow: 3600), iat: Date())
        var jwt = JWT(header: jwtHeader, claims: jwtClaims)
        
        let privateKeyPath = Bundle.main.bundleURL.appendingPathComponent("AppleMusicAuthKey.p8")
        do {
            let privateKey: Data = try Data(contentsOf: privateKeyPath, options: .alwaysMapped)
            let jwtSigner = JWTSigner.es256(privateKey: privateKey)
            return try jwt.sign(using: jwtSigner)
        } catch {
            fatalError("Could not fetch developer token. Error: \(error)")
        }
    }
    
    func getAllSongsInLibrary(completion: @escaping (_ appleMusicSongsApiResponse: AMLibrarySongResponse?, _ error: String?) -> ()) {
        
        router.request(.getAllSongsInLibrary) { data, response, error in
            self.handleResponse(data: data, dataType: AMLibrarySongResponse.self, response: response, error: error, completion: completion)
        }
        
    }
    
}
