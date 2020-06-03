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
            DataModelManager.createUser(user: User(id: User.DEFAULT_ID, username: User.DEFAULT_USERNAME, name: User.DEFAULT_NAME))
            DataModelManager.createUser(user: User(id: 1, username: "sylphrenetic", name: "Tyler Cheek"))
        }
    }
    
    private static func setupProfileTable() {
        if !DataModelManager.tableExists(tableName: Profile.databaseTableName) {
            DataModelManager.createProfileTable()
            DataModelManager.createProfile(profile: Profile(id: Profile.DEFAULT_ID, userId: User.DEFAULT_ID, profileImage: nil))
            DataModelManager.createProfile(profile: Profile(id: 1, userId: 1, profileImage: nil))
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
                    t.column(User.Columns.username.rawValue, .text).unique(onConflict: .abort)
                    t.column(User.Columns.name.rawValue, .text)
                }
            })
        } catch {
            print("Database Error: \(error)")
        }
    }
    
    public static func createUser(user: User) {
        do {
            try dbQueue.write({ (db) in
                try user.insert(db)
            })
        } catch {
            print("Database Error: \(error)")
        }
    }
    
    public static func getAllUsers() -> [User]? {
        do {
            let users = try DataModelManager.dbQueue.read({ (db) -> [User] in
                try User.fetchAll(db)
            })
            return users
        } catch {
            print("Database Error: \(error)")
            return nil
        }
    }
    
    public static func getUserForId(id: Int64) -> User? {
        do {
            let user = try DataModelManager.dbQueue.read({ (db) -> User? in
                let request = Profile.filter(Column("id") == id)
                let user = try User.fetchOne(db, request)
                return user
            })
            return user
        } catch {
            print("Database Error: \(error)")
            return nil
        }
    }
    
    public static func getUserForProfile(profile: Profile) -> User? {
        do {
            let user = try DataModelManager.dbQueue.read({ (db) -> User? in
                try profile.user.fetchOne(db)
            })
            return user
        } catch {
            print("Database Error: \(error)")
            return nil
        }
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
    
    public static func createProfile(profile: Profile) {
        do {
            try dbQueue.write({ (db) in
                try profile.insert(db)
            })
        } catch {
            print("Database Error: \(error)")
        }
    }
    
    public static func getAllProfiles() -> [Profile]? {
        do {
            let profiles = try DataModelManager.dbQueue.read({ (db) -> [Profile] in
                try Profile.fetchAll(db)
            })
            return profiles
        } catch {
            print("Database Error: \(error)")
            return nil
        }
    }
    
    /// There should only be one non-default profile for each application
    public static func getNonDefaultProfile() -> Profile? {
        do {
            let profile = try DataModelManager.dbQueue.read({ (db) -> Profile? in
                let request = Profile.filter(Column("id") != Profile.DEFAULT_ID)
                let profile = try Profile.fetchOne(db, request)
                return profile
            })
            return profile
        } catch {
            print("Database Error: \(error)")
            return nil
        }
    }
    
    public static func getProfileForUser(user: User) -> Profile? {
        do {
            let profile = try DataModelManager.dbQueue.read({ (db) -> Profile? in
                try user.profile.fetchOne(db)
            })
            return profile
        } catch {
            print("Database Error: \(error)")
            return nil
        }
    }
    
}
