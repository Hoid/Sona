//
//  SonaUser.swift
//  Sona
//
//  Created by Tyler Cheek on 6/1/20.
//  Copyright © 2020 Tyler Cheek. All rights reserved.
//

import GRDB

public class User : Record, NetworkBodyParameterEncodable, CustomStringConvertible {
    
    // MARK: Static members
    
    static let profile = hasOne(Profile.self)
    
    // MARK: Member variables
    
    var firebaseUID: String
    var email: String
    var username: String?
    var name: String?
    var isPublic: Bool
    
    // MARK: Computed properties
    
    var profile: QueryInterfaceRequest<Profile> {
        request(for: User.profile)
    }
    
    public var description: String {
        // String(describing:) is necessary because id isn't of type String and we don't know if username will be present
        return "User = firebaseUID: \(firebaseUID), email: \(email), username: \(String(describing: username)), name: \(String(describing: name)), isPublic: \(isPublic)"
    }
    
    var bodyParameters: Parameters {
        var parameters: Parameters = [
            "firebaseUID" : firebaseUID,
            "email" : email,
            "isPublic" : isPublic
        ]
        // insert username and name as parameters, but only if they are present
        if let username = self.username {
            parameters = parameters.merging(["username" : username], uniquingKeysWith: { (_, new) -> Any in new })
        }
        if let name = self.name {
            parameters = parameters.merging(["name" : name], uniquingKeysWith: { (_, new) -> Any in new })
        }
        return parameters
    }
    
    // MARK: Initializers
    
    init(firebaseUID: String, email: String, username: String?, name: String?, isPublic: Bool) {
        self.firebaseUID = firebaseUID
        self.email = email
        self.username = username
        self.name = name
        self.isPublic = isPublic
        super.init()
    }
    
    init(fromUserApiResponse userApiResponse: UserApiResponse) {
        self.firebaseUID = userApiResponse.firebaseUID
        self.email = userApiResponse.email
        self.username = userApiResponse.username
        self.name = userApiResponse.name
        self.isPublic = userApiResponse.isPublic
        super.init()
    }
    
    /// Creates a record from a database row
    required init(row: Row) {
        self.firebaseUID = row[Columns.firebase_uid]
        self.email = row[Columns.email]
        self.username = row[Columns.username]
        self.name = row[Columns.name]
        self.isPublic = row[Columns.is_public]
        super.init(row: row)
    }
    
    convenience override init() {
        self.init(firebaseUID: User.DEFAULT_FIREBASE_ID, email: User.DEFAULT_EMAIL, username: User.DEFAULT_USERNAME, name: User.DEFAULT_NAME, isPublic: User.DEFAULT_IS_PUBLIC)
    }
    
    // MARK: Overridden methods
    
    /// The values persisted in the database
    public override func encode(to container: inout PersistenceContainer) {
        container[Columns.firebase_uid] = self.firebaseUID
        container[Columns.email] = self.email
        container[Columns.username] = self.username
        container[Columns.name] = self.name
        container[Columns.is_public] = self.isPublic
    }
    
    // MARK: Record properties
    
    /// The table name
    public override class var databaseTableName: String { "user" }
    
    /// The table columns
    enum Columns: String, ColumnExpression {
        case firebase_uid, email, username, name, is_public
    }
    
}

extension User {
    
    static let DEFAULT_EMAIL = "my@email.com"
    static let DEFAULT_NAME = "John Doe"
    static let DEFAULT_USERNAME = "pillsbury_doe_boy"
    static let DEFAULT_FIREBASE_ID = "HELLOWORLD1234"
    static let DEFAULT_IS_PUBLIC = false
    
}
