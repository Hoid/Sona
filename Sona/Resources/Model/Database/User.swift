//
//  User.swift
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
    
    var id: Int64
    var username: String
    var name: String
    
    // MARK: Computed properties
    
    var profile: QueryInterfaceRequest<Profile> {
        request(for: User.profile)
    }
    
    var description: String {
        return "User = id: \(id), username: \(username), name: \(name)"
    }
    
    // MARK: Initializers
    
    init(id: Int64, username: String, name: String) {
        self.id = id
        self.username = username
        self.name = name
        super.init()
    }
    
    /// Creates a record from a database row
    required init(row: Row) {
        self.id = row[Columns.id]
        self.username = row[Columns.username]
        self.name = row[Columns.name]
        super.init(row: row)
    }
    
    // MARK: Overridden methods
    
    /// The values persisted in the database
    override func encode(to container: inout PersistenceContainer) {
        container[Columns.id] = self.id
        container[Columns.username] = self.username
        container[Columns.name] = self.name
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
        case id, username, name
    }
    
}

extension User {
    
    static let DEFAULT_ID: Int64 = 0
    static let DEFAULT_NAME = "John Doe"
    static let DEFAULT_USERNAME = "pillsbury_doe_boy"
    
}