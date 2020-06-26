//
//  UserDAO.swift
//  Sona
//
//  Created by Tyler Cheek on 6/9/20.
//  Copyright © 2020 Tyler Cheek. All rights reserved.
//

import GRDB

class UserDAO : BaseDAO, DAO {
    
    // MARK: Setup
    
    static func setupTable() {
        if !BaseDAO.tableExists(tableName: User.databaseTableName) {
            createUserTable()
        }
    }
    
    // MARK: Users
    
    /// Creates the `user` table in the database
    public static func createUserTable() {
        do {
            try dbQueue.write({ (db) in
                try db.create(table: User.databaseTableName) { t in
                    t.column(User.Columns.firebase_uid.rawValue, .text).primaryKey(onConflict: .abort, autoincrement: false)
                    t.column(User.Columns.email.rawValue, .text)
                    t.column(User.Columns.username.rawValue, .text).unique(onConflict: .abort)
                    t.column(User.Columns.name.rawValue, .text)
                    t.column(User.Columns.is_public.rawValue, .boolean)
                }
            })
        } catch {
            fatalError("Database Error: \(error)")
        }
    }
    
    /// Creates a new row in the user table for a given user object
    /// - parameter user: The user object to insert.
    /// - throws: A DatabaseError whenever an SQLite error occurs.
    public static func create(user: User) throws {
        try dbQueue.write({ (db) in
            try user.insert(db)
        })
    }
    
    /// Returns whether a given user exists, based on its firebaseUID
    /// This method catches all errors found and uses a caught error to signify that the user does not exist.
    /// - parameter user: The user to evaluate.
    public static func exists(user: User) -> Bool {
        return (try? getUserFor(firebaseUID: user.firebaseUID)) != nil
    }
    
    public static func getAllUsers() throws -> [User] {
        if let users = try dbQueue.read({ (db) -> [User]? in
            try User.fetchAll(db)
        }) {
            // success
            return users
        } else {
            // failure
            throw UserError.cannotFetch
        }
    }
    
    /// Returns a user if it exists given its username.
    /// - parameter username: The user's `username` to query for.
    /// - throws: Either a DatabaseError whenever an SQLite error occurs or a UserError.notFound when the user does not exist.
    public static func getUserFor(username: String) throws -> User {
        if let user = try dbQueue.read({ (db) -> User? in
            let request = User.filter(Column("username") == username)
            return try User.fetchOne(db, request)
        }) {
            // success
            return user
        } else {
            throw UserError.notFound
        }
    }
    
    /// Returns a user if it exists given its corresponding Profile.
    /// - parameter profile: The user's corresponding `Profile` object.
    /// - throws: Either a DatabaseError whenever an SQLite error occurs or a UserError.notFound when the user does not exist.
    public static func getUserFor(profile: Profile) throws -> User {
        if let user = try dbQueue.read({ (db) -> User? in
            try profile.user.fetchOne(db)
        }) {
            // success
            return user
        } else {
            throw UserError.notFound
        }
    }
    
    /// Returns a user if it exists given its firebaseUID.
    /// - parameter firebaseUID: The user's `firebaseUID` to query for.
    /// - throws: Either a DatabaseError whenever an SQLite error occurs or a UserError.notFound when the user does not exist.
    public static func getUserFor(firebaseUID: String) throws -> User {
        if let user = try dbQueue.read({ (db) -> User? in
            let request = User.filter(Column(User.Columns.firebase_uid.rawValue) == firebaseUID)
            return try User.fetchOne(db, request)
        }) {
            // success
            return user
        } else {
            throw UserError.notFound
        }
    }
    
    /// Sets a user's username given its firebaseUID.
    /// - parameter firebaseUID: The user's `firebaseUID` to query for.
    /// - parameter username: The user's `username` to set.
    /// - throws: A DatabaseError whenever an SQLite error occurs.
    public static func setUsernameFor(firebaseUID: String, username: String) throws {
        let user = try getUserFor(firebaseUID: firebaseUID)
        user.username = username
        try dbQueue.write({ (db) in
            let modified = try user.updateChanges(db)
            if !modified {
                print("No updates to username necessary for user: \(user)")
            }
        })
    }
    
    /// Sets a user's isPublic field given its firebaseUID.
    /// - parameter firebaseUID: The user's `firebaseUID` to query for.
    /// - parameter isPublic: The user's `isPublic` value to set.
    /// - throws: A DatabaseError whenever an SQLite error occurs.
    public static func setIsPublic(forFirebaseUID firebaseUID: String, isPublic: Bool) throws {
        let user = try getUserFor(firebaseUID: firebaseUID)
        user.isPublic = isPublic
        try dbQueue.write({ (db) in
            let modified = try user.updateChanges(db)
            if !modified {
                print("No updates to isPublic necessary for user: \(user)")
            }
        })
    }
    
}
