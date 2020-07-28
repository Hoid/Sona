/*
See LICENSE folder for this sample’s licensing information.

Abstract:
`AuthorizationManager` manages requesting authorization from the user for modifying the user's `MPMediaLibrary` and querying
             the currently logged in iTunes Store account's Apple Music capabilities.
*/

import Foundation
import StoreKit
import MediaPlayer
import FirebaseAuth

@objcMembers
class AuthorizationManager: NSObject {
    
    // MARK: Types
    
    /// Notification that is posted whenever there is a change in the capabilities or Storefront identifier of the `SKCloudServiceController`.
    static let cloudServiceDidUpdateNotification = Notification.Name("cloudServiceDidUpdateNotification")
    
    /// Notification that is posted whenever there is a change in the authorization status that other parts of the sample should respond to.
    static let authorizationDidUpdateNotification = Notification.Name("authorizationDidUpdateNotification")
    
    /// The `UserDefaults` key for storing and retrieving the Music User Token associated with the currently signed in iTunes Store account.
    static let userTokenUserDefaultsKey = "UserTokenUserDefaultsKey"
    
    // MARK: Properties
    
    /// The instance of `SKCloudServiceController` that will be used for querying the available `SKCloudServiceCapability` and Storefront Identifier.
    let cloudServiceController = SKCloudServiceController()
    
    /// The instance of `AppleMusicNetworkManager` that will be used for querying storefront information and user token.
    let appleMusicNetworkManager: AppleMusicNetworkManager
    
    /// The current set of `SKCloudServiceCapability`s that the sample can currently use.
    var cloudServiceCapabilities = SKCloudServiceCapability()
    
    /// The current set of two letter country code associated with the currently authenticated iTunes Store account.
    var cloudServiceStorefrontCountryCode = ""
    
    /// The currently signed in user. Will be assigned on app startup.
    var signedInUser: User?
    
    /// The authorization header to be used in API requests to the Apple Music API.
    var authHeader: HTTPHeaders?
    
    /// The Music User Token associated with the currently signed in iTunes Store account.
    private var userToken: String?
    
    // MARK: Initialization
    
    init(appleMusicNetworkManager: AppleMusicNetworkManager) {
        self.appleMusicNetworkManager = appleMusicNetworkManager
        
        super.init()
        
        let notificationCenter = NotificationCenter.default
        
        /*
         It is important that the application listens to the `SKCloudServiceCapabilitiesDidChangeNotification` and
         `SKStorefrontCountryCodeDidChangeNotification` notifications so that your application can update its state and functionality
         when these values change if needed.
        */
        notificationCenter.addObserver(self,
                                       selector: #selector(requestCloudServiceCapabilities),
                                       name: .SKCloudServiceCapabilitiesDidChange,
                                       object: nil)
        notificationCenter.addObserver(self,
                                       selector: #selector(requestStorefrontCountryCode),
                                       name: .SKStorefrontCountryCodeDidChange,
                                       object: nil)
        
        requestCloudServiceAuthorization()
        
        /*
         If the application has already been authorized in a previous run or manually by the user then it can request
         the current set of `SKCloudServiceCapability` and Storefront Identifier.
        */
        if SKCloudServiceController.authorizationStatus() == .authorized {
            requestCloudServiceCapabilities()
            
            // Retrieve the Music User Token  for use in the application if it was stored from a previous run.
            if let token = UserDefaults.standard.string(forKey: AuthorizationManager.userTokenUserDefaultsKey) {
                userToken = token
            } else {
                // If the token was not stored previously then request one.
                requestUserToken()
            }
            
            initAuthHeader()
        }
    }
    
    deinit {
        // Remove all notification observers.
        let notificationCenter = NotificationCenter.default
        
        notificationCenter.removeObserver(self, name: .SKCloudServiceCapabilitiesDidChange, object: nil)
        notificationCenter.removeObserver(self, name: .SKStorefrontCountryCodeDidChange, object: nil)
    }
    
    private func initAuthHeader() {
        
        let developerToken = appleMusicNetworkManager.fetchDeveloperToken()
        let authToken = getUserToken()
        self.authHeader = [
            "Authorization" : "Bearer \(developerToken)",
            "Music-User-Token" : authToken
        ]
        print("Auth Header = \(self.authHeader ?? ["no data" : "no data"])")
        
    }
    
    private func getUserToken() -> String {
        if let userToken = self.userToken {
            return userToken
        } else {
            requestUserToken()
            if let userToken = self.userToken {
                return userToken
            } else {
                fatalError("Could not return user token even after requesting a new one from Apple.")
            }
        }
    }
    
    func checkIfDeviceCanPlayback() {
        
        requestCloudServiceCapabilities()
        
        if self.cloudServiceCapabilities.contains(.addToCloudMusicLibrary) {
            print("The user has an Apple Music subscription, can playback music AND can add to the Cloud Music Library")
        } else if self.cloudServiceCapabilities.contains(.musicCatalogPlayback) {
            print("The user has an Apple Music subscription and can playback music.")
        } else if self.cloudServiceCapabilities.contains(.musicCatalogSubscriptionEligible) {
            print("The user doesn't have an Apple Music subscription available. Now would be a good time to prompt them to buy one?")
        } else {
            print("Capability not recognized in AppleMusicPlayerController.checkIfDeviceCanPlayback()")
        }
        
    }
    
    // MARK: Authorization Request Methods
    
    func requestCloudServiceAuthorization() {
        /*
         An application should only ever call `SKCloudServiceController.requestAuthorization(_:)` when their
         current authorization is `SKCloudServiceAuthorizationStatusNotDetermined`
         */
        guard SKCloudServiceController.authorizationStatus() == .notDetermined else {
            print("User has already given/rejected cloud service authorization.")
            return
        }
        
        /*
         `SKCloudServiceController.requestAuthorization(_:)` triggers a prompt for the user asking if they wish to allow the application
         that requested authorization access to the device's cloud services information.  This allows the application to query information
         such as the what capabilities the currently authenticated iTunes Store account has and if the account is eligible for an Apple Music
         Subscription Trial.
         
         This prompt will also include the value provided in the application's Info.plist for the `NSAppleMusicUsageDescription` key.
         This usage description should reflect what the application intends to use this access for.
         */
        
        SKCloudServiceController.requestAuthorization { [weak self] (authorizationStatus) in
            switch authorizationStatus {
            case .authorized:
                print("Successfully gained cloud service authorization")
                self?.requestCloudServiceCapabilities()
                self?.requestUserToken()
            default:
                break
            }
            
            NotificationCenter.default.post(name: AuthorizationManager.authorizationDidUpdateNotification, object: nil)
        }
    }
    
    func requestMediaLibraryAuthorization() {
        /*
         An application should only ever call `MPMediaLibrary.requestAuthorization(_:)` when their
         current authorization is `MPMediaLibraryAuthorizationStatusNotDetermined`
         */
        guard MPMediaLibrary.authorizationStatus() == .notDetermined else { return }
        
        /*
         `MPMediaLibrary.requestAuthorization(_:)` triggers a prompt for the user asking if they wish to allow the application
         that requested authorization access to the device's media library.
         
         This prompt will also include the value provided in the application's Info.plist for the `NSAppleMusicUsageDescription` key.
         This usage description should reflect what the application intends to use this access for.
         */
        
        MPMediaLibrary.requestAuthorization { (_) in
            NotificationCenter.default.post(name: AuthorizationManager.cloudServiceDidUpdateNotification, object: nil)
        }
    }
    
    // MARK: `SKCloudServiceController` Related Methods
    
    func requestCloudServiceCapabilities() {
        cloudServiceController.requestCapabilities(completionHandler: { [weak self] (cloudServiceCapability, error) in
            guard error == nil else {
                fatalError("An error occurred when requesting capabilities: \(error!.localizedDescription)")
            }
            
            self?.cloudServiceCapabilities = cloudServiceCapability
            
            NotificationCenter.default.post(name: AuthorizationManager.cloudServiceDidUpdateNotification, object: nil)
        })
    }
    
    func requestStorefrontCountryCode() {
        let completionHandler: (String?, Error?) -> Void = { [weak self] (countryCode, error) in
            guard error == nil else {
                print("An error occurred when requesting storefront country code: \(error!.localizedDescription)")
                return
            }
            
            guard let countryCode = countryCode else {
                print("Unexpected value from SKCloudServiceController for storefront country code.")
                return
            }
            
            self?.cloudServiceStorefrontCountryCode = countryCode
            
            NotificationCenter.default.post(name: AuthorizationManager.cloudServiceDidUpdateNotification, object: nil)
        }
        
        guard SKCloudServiceController.authorizationStatus() == .authorized else {
            print("App does not have Apple Music authorization. Could not request storefront country code.")
            return
        }
        cloudServiceController.requestStorefrontCountryCode(completionHandler: completionHandler)
    }
    
    func requestUserToken() {
        
        let developerToken = appleMusicNetworkManager.fetchDeveloperToken()
        
        if SKCloudServiceController.authorizationStatus() == .authorized {
            
            cloudServiceController.requestUserToken(forDeveloperToken: developerToken) { (token, error) in
                guard error == nil else {
                    print("An error occurred when requesting user token: \(error!.localizedDescription)")
                    return
                }
                
                guard let token = token else {
                    print("Unexpected value from SKCloudServiceController for user token.")
                    return
                }
                
                self.userToken = token
                
                /// Store the Music User Token for future use in your application.
                let userDefaults = UserDefaults.standard
                
                userDefaults.set(token, forKey: AuthorizationManager.userTokenUserDefaultsKey)
                userDefaults.synchronize()
                
                if self.cloudServiceStorefrontCountryCode == "" {
                    self.requestStorefrontCountryCode()
                }
                
                NotificationCenter.default.post(name: AuthorizationManager.cloudServiceDidUpdateNotification, object: nil)
            }
            
        }
        
    }
    
}
