//
//  SonaUser.swift
//  Sona
//
//  Created by Tyler Cheek on 6/1/20.
//  Copyright © 2020 Tyler Cheek. All rights reserved.
//

import GRDB

class User : Record, CustomStringConvertible {
    
    // MARK: Static members
    
    static let profile = hasOne(Profile.self)
    
    // MARK: Member variables
    
    private(set) var id: Int64!
    var email: String
    var username: String?
    var name: String
    var firebaseUID: String
    
    // MARK: Computed properties
    
    var profile: QueryInterfaceRequest<Profile> {
        request(for: User.profile)
    }
    
    var description: String {
        // String(describing:) is necessary because id isn't of type String and we don't know if username will be present
        return "User = id: \(String(describing: id)), email: \(email), username: \(String(describing: username)), name: \(name)"
    }
    
    // MARK: Initializers
    
    init(email: String, username: String?, name: String, firebaseUID: String) {
        self.email = email
        self.username = username
        self.name = name
        self.firebaseUID = firebaseUID
        super.init()
    }
    
    /// Creates a record from a database row
    required init(row: Row) {
        self.id = row[Columns.id]
        self.email = row[Columns.email]
        self.username = row[Columns.username]
        self.name = row[Columns.name]
        self.firebaseUID = row[Columns.firebase_uid]
        super.init(row: row)
    }
    
    // MARK: Overridden methods
    
    /// The values persisted in the database
    override func encode(to container: inout PersistenceContainer) {
        container[Columns.id] = self.id
        container[Columns.email] = self.email
        container[Columns.username] = self.username
        container[Columns.name] = self.name
        container[Columns.firebase_uid] = self.firebaseUID
    }
    
    /// Update record ID after a successful insertion
    override func didInsert(with rowID: Int64, for column: String?) {
        id = rowID
    }
    
    // MARK: Record properties
    
    /// The table name
    override class var databaseTableName: String { "user" }
    
    /// The table columns
    enum Columns: String, ColumnExpression {
        case id, email, username, name, firebase_uid
    }
    
}

extension User {
    
    static let DEFAULT_ID: Int64 = 0
    static let DEFAULT_EMAIL = "my@email.com"
    static let DEFAULT_NAME = "John Doe"
    static let DEFAULT_USERNAME = "pillsbury_doe_boy"
    static let DEFAULT_FIREBASE_ID = "1234"
    
}
