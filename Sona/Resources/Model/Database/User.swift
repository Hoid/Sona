//
//  User.swift
//  Sona
//
//  Created by Tyler Cheek on 6/1/20.
//  Copyright © 2020 Tyler Cheek. All rights reserved.
//

import GRDB

class User : Record, CustomStringConvertible {
    
    var id: Int64
    var username: String
    var description: String {
        return "User = id: \(id), username: \(username)"
    }
    
    init(id: Int64, username: String) {
        self.id = id
        self.username = username
        super.init()
    }
    
    /// The table name
    override class var databaseTableName: String { "user" }
    
    /// The table columns
    enum Columns: String, ColumnExpression {
        case id, username
    }
    
    /// Creates a record from a database row
    required init(row: Row) {
        self.id = row[Columns.id]
        self.username = row[Columns.username]
        super.init(row: row)
    }
    
    /// The values persisted in the database
    override func encode(to container: inout PersistenceContainer) {
        container[Columns.id] = self.id
        container[Columns.username] = self.username
    }
    
    /// Update record ID after a successful insertion
    override func didInsert(with rowID: Int64, for column: String?) {
        id = rowID
    }
    
}
