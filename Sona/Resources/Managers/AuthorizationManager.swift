/*
See LICENSE folder for this sample’s licensing information.

Abstract:
`AuthorizationManager` manages requesting authorization from the user for modifying the user's `MPMediaLibrary` and querying
             the currently logged in iTunes Store account's Apple Music capabilities.
*/

import Foundation
import StoreKit
import MediaPlayer

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
    
    /// The instance of `AppleMusicManager` that will be used for querying storefront information and user token.
    let appleMusicManager: AppleMusicManager
    
    /// The current set of `SKCloudServiceCapability` that the sample can currently use.
    var cloudServiceCapabilities = SKCloudServiceCapability()
    
    /// The current set of two letter country code associated with the currently authenticated iTunes Store account.
    var cloudServiceStorefrontCountryCode = ""
    
    /// The Music User Token associated with the currently signed in iTunes Store account.
    var userToken: String!
    
    // MARK: Initialization
    
    init(appleMusicManager: AppleMusicManager) {
        self.appleMusicManager = appleMusicManager
        
        super.init()
        
        let notificationCenter = NotificationCenter.default
        
        /*
         It is important that your application listens to the `SKCloudServiceCapabilitiesDidChangeNotification` and
         `SKStorefrontCountryCodeDidChangeNotification` notifications so that your application can update its state and functionality
         when these values change if needed.
        */
        
        notificationCenter.addObserver(self,
                                       selector: #selector(requestCloudServiceCapabilities),
                                       name: .SKCloudServiceCapabilitiesDidChange,
                                       object: nil)
        if #available(iOS 11.0, *) {
            notificationCenter.addObserver(self,
                                           selector: #selector(requestStorefrontCountryCode),
                                           name: .SKStorefrontCountryCodeDidChange,
                                           object: nil)
        }
        
        /*
         If the application has already been authorized in a previous run or manually by the user then it can request
         the current set of `SKCloudServiceCapability` and Storefront Identifier.
        */
        if SKCloudServiceController.authorizationStatus() == .authorized {
            requestCloudServiceCapabilities()
            
            /// Retrieve the Music User Token for use in the application if it was stored from a previous run.
            if let token = UserDefaults.standard.string(forKey: AuthorizationManager.userTokenUserDefaultsKey) {
                userToken = token
            } else {
                /// The token was not stored previously then request one.
                requestUserToken()
            }
        }
    }
    
    deinit {
        // Remove all notification observers.
        let notificationCenter = NotificationCenter.default
        
        notificationCenter.removeObserver(self, name: .SKCloudServiceCapabilitiesDidChange, object: nil)
        
        if #available(iOS 11.0, *) {
            notificationCenter.removeObserver(self, name: .SKStorefrontCountryCodeDidChange, object: nil)
        }
        
    }
    
    // MARK: Authorization Request Methods
    
    func requestCloudServiceAuthorization() {
        /*
         An application should only ever call `SKCloudServiceController.requestAuthorization(_:)` when their
         current authorization is `SKCloudServiceAuthorizationStatusNotDetermined`
         */
        guard SKCloudServiceController.authorizationStatus() == .notDetermined else { return }
        
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
        
        if SKCloudServiceController.authorizationStatus() == .authorized {
            cloudServiceController.requestStorefrontCountryCode(completionHandler: completionHandler)
        } else {
            determineRegionWithDeviceLocale(completion: completionHandler)
        }
    }
    
    func requestUserToken() {
        guard let developerToken = appleMusicManager.fetchDeveloperToken() else {
            return
        }
        
        if SKCloudServiceController.authorizationStatus() == .authorized {
            
            let completionHandler: (String?, Error?) -> Void = { [weak self] (token, error) in
                guard error == nil else {
                    print("An error occurred when requesting user token: \(error!.localizedDescription)")
                    return
                }
                
                guard let token = token else {
                    print("Unexpected value from SKCloudServiceController for user token.")
                    return
                }
                
                self?.userToken = token
                
                /// Store the Music User Token for future use in your application.
                let userDefaults = UserDefaults.standard
                
                userDefaults.set(token, forKey: AuthorizationManager.userTokenUserDefaultsKey)
                userDefaults.synchronize()
                
                if self?.cloudServiceStorefrontCountryCode == "" {
                    self?.requestStorefrontCountryCode()
                }
                
                NotificationCenter.default.post(name: AuthorizationManager.cloudServiceDidUpdateNotification, object: nil)
            }
            
            cloudServiceController.requestUserToken(forDeveloperToken: developerToken, completionHandler: completionHandler)
        }
    }
    
}
