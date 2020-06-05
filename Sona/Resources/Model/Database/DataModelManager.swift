//
//  DataModelManager.swift
//  Sona
//
//  Created by Tyler Cheek on 6/1/20.
//  Copyright © 2020 Tyler Cheek. All rights reserved.
//

import GRDB

class DataModelManager {
    
    private static var dbQueue: DatabaseQueue!
    
    // MARK: Setup
    
    public static func setup(in application: UIApplication) throws {
        setupDatabase()
        setupTables()
    }
    
    private static func setupDatabase() {
        let databaseURL = try! FileManager.default
            .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            .appendingPathComponent("db.sqlite")
        
        self.dbQueue = try! DatabaseQueue(path: databaseURL.path)
    }
    
    private static func setupTables() {
        setupUserTable()
        setupProfileTable()
    }
    
    private static func setupUserTable() {
        if !DataModelManager.tableExists(tableName: User.databaseTableName) {
            DataModelManager.createUserTable()
            do {
                if (try DataModelManager.getUserForUsername(username: User.DEFAULT_USERNAME)) == nil {
                    try DataModelManager.createUser(user: User(email: User.DEFAULT_EMAIL, username: User.DEFAULT_USERNAME, name: User.DEFAULT_NAME))
                }
            } catch {
                print("Database Error: \(error)")
            }
        }
    }
    
    private static func setupProfileTable() {
        if !DataModelManager.tableExists(tableName: Profile.databaseTableName) {
            DataModelManager.createProfileTable()
            do {
                try DataModelManager.createProfile(profile: Profile(userId: User.DEFAULT_ID, profileImage: nil))
            } catch {
                print("Database Error: \(error)")
            }
        }
    }
    
    // MARK: Convenience methods
    
    public static func tableExists(tableName: String) -> Bool {
        do {
            return try dbQueue.read { db in
                try db.tableExists(tableName)
            }
        } catch {
            print("Database Error: \(error)")
            return false
        }
        
    }
    
    // MARK: Users
    
    public static func createUserTable() {
        do {
            try dbQueue.write({ (db) in
                try db.create(table: User.databaseTableName) { t in
                    t.autoIncrementedPrimaryKey(User.Columns.id.rawValue)
                    t.column(User.Columns.email.rawValue, .text)
                    t.column(User.Columns.username.rawValue, .text).unique(onConflict: .abort)
                    t.column(User.Columns.name.rawValue, .text)
                }
            })
        } catch {
            print("Database Error: \(error)")
        }
    }
    
    public static func createUser(user: User) throws {
        try dbQueue.write({ (db) in
            if let username = user.username {
                let request = User.filter(Column("username") == username)
                let userExists = try User.fetchOne(db, request) != nil
                if !userExists {
                    try user.insert(db)
                } else {
                    throw UsernameError.alreadyExists
                }
            } else {
                // username is not present in User object, so we need not check if a user with that username already exists
                try user.insert(db)
            }
        })
    }
    
    public static func getAllUsers() throws -> [User] {
        let users = try DataModelManager.dbQueue.read({ (db) -> [User] in
            try User.fetchAll(db)
        })
        return users
    }
    
    public static func getUserForUsername(username: String) throws -> User? {
        let user = try DataModelManager.dbQueue.read({ (db) -> User? in
            let request = User.filter(Column("username") == username)
            let user = try User.fetchOne(db, request)
            return user
        })
        return user
    }
    
    public static func getUserForId(id: Int64) throws -> User? {
        let user = try DataModelManager.dbQueue.read({ (db) -> User? in
            let request = Profile.filter(Column("id") == id)
            let user = try User.fetchOne(db, request)
            return user
        })
        return user
    }
    
    public static func getUserForProfile(profile: Profile) throws -> User? {
        let user = try DataModelManager.dbQueue.read({ (db) -> User? in
            try profile.user.fetchOne(db)
        })
        return user
    }
        
    // MARK: Profiles
    
    public static func createProfileTable() {
        do {
            try dbQueue.write({ (db) in
                try db.create(table: Profile.databaseTableName) { t in
                    t.autoIncrementedPrimaryKey(Profile.Columns.id.rawValue)
                    t.column(Profile.Columns.user_id.rawValue, .integer)
                        .notNull()
                        .references(User.databaseTableName, onDelete: .cascade, onUpdate: .cascade)
                    t.column(Profile.Columns.profile_image.rawValue, .blob)
                }
            })
        } catch {
            print("Database Error: \(error)")
        }
    }
    
    public static func createProfile(profile: Profile) throws {
        try dbQueue.write({ (db) in
            try profile.insert(db)
        })
    }
    
    public static func getAllProfiles() throws -> [Profile] {
        let profiles = try DataModelManager.dbQueue.read({ (db) -> [Profile] in
            try Profile.fetchAll(db)
        })
        return profiles
    }
    
    /// There should only be one non-default profile for each application
    public static func getNonDefaultProfile() throws -> Profile? {
        let profile = try DataModelManager.dbQueue.read({ (db) -> Profile? in
            let request = Profile.filter(Column("id") != Profile.DEFAULT_ID)
            let profile = try Profile.fetchOne(db, request)
            return profile
        })
        return profile
    }
    
    public static func getProfileForUser(user: User) throws -> Profile? {
        let profile = try DataModelManager.dbQueue.read({ (db) -> Profile? in
            try user.profile.fetchOne(db)
        })
        return profile
    }
    
}
