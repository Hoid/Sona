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
    
    public static func createUserTable() {
        do {
            try dbQueue.write({ (db) in
                try db.create(table: User.databaseTableName) { t in
                    t.autoIncrementedPrimaryKey(User.Columns.id.rawValue)
                    t.column(User.Columns.email.rawValue, .text)
                    t.column(User.Columns.username.rawValue, .text).unique(onConflict: .abort)
                    t.column(User.Columns.name.rawValue, .text)
                    t.column(User.Columns.firebase_uid.rawValue, .text).unique(onConflict: .abort)
                }
            })
        } catch {
            fatalError("Database Error: \(error)")
        }
    }
    
    public static func create(user: User, handleError: ((Error) -> Void)? = nil) {
        do {
            if let username = user.username {
                if getUserFor(username: username) == nil {
                    // no user present with that username
                    try dbQueue.write({ (db) in
                        try user.insert(db)
                    })
                } else {
                    throw UsernameError.alreadyExists(message: "User with username \(username) already exists.")
                }
            } else {
                // username is not present in User object, so we need not check if a user with that username already exists
                try dbQueue.write({ (db) in
                    try user.insert(db)
                })
            }
        } catch {
            print("Database Error: \(error)")
            handleError?(error)
        }
    }
    
    public static func getUser(_ user: User, handleError: ((Error) -> Void)? = nil) -> User? {
        do {
            let user = try dbQueue.read({ (db) -> User? in
                let request = User.filter(Column(User.Columns.name.rawValue) == user.name)
                    .filter(Column(User.Columns.email.rawValue) == user.email)
                    .filter(Column(User.Columns.firebase_uid.rawValue) == user.firebaseUID)
                    .filter(Column(User.Columns.username.rawValue) == user.username)
                return try User.fetchOne(db, request)
            })
            return user
        } catch {
            print("Database Error: \(error)")
            handleError?(error)
            return nil
        }
    }
    
    public static func getAllUsers(handleError: ((Error) -> Void)? = nil) -> [User]? {
        do {
            let users = try dbQueue.read({ (db) -> [User] in
                try User.fetchAll(db)
            })
            return users
        } catch {
            handleError?(error)
            return nil
        }
    }
    
    public static func getUserFor(username: String, handleError: ((Error) -> Void)? = nil) -> User? {
        do {
            let user = try dbQueue.read({ (db) -> User? in
                let request = User.filter(Column("username") == username)
                let user = try User.fetchOne(db, request)
                return user
            })
            return user
        } catch {
            print("Database Error: \(error)")
            handleError?(error)
            return nil
        }
    }
    
    public static func getUserFor(id: Int64, handleError: ((Error) -> Void)? = nil) -> User? {
        do {
            let user = try dbQueue.read({ (db) -> User? in
                let request = Profile.filter(Column("id") == id)
                let user = try User.fetchOne(db, request)
                return user
            })
            return user
        } catch {
            print("Database Error: \(error)")
            handleError?(error)
            return nil
        }
    }
    
    public static func getUserFor(profile: Profile, handleError: ((Error) -> Void)? = nil) -> User? {
        do {
            let user = try dbQueue.read({ (db) -> User? in
                try profile.user.fetchOne(db)
            })
            return user
        } catch {
            print("Database Error: \(error)")
            handleError?(error)
            return nil
        }
    }
    
    public static func getUserFor(firebaseUID: String, handleError: ((Error) -> Void)? = nil) -> User? {
        do {
            let user = try dbQueue.read({ (db) -> User? in
                let request = User.filter(Column(User.Columns.firebase_uid.rawValue) == firebaseUID)
                let user = try User.fetchOne(db, request)
                return user
            })
            return user
        } catch {
            print("Database Error: \(error)")
            handleError?(error)
            return nil
        }
    }
    
    public static func setUsernameFor(firebaseUID: String, username: String, handleError: ((Error) -> Void)? = nil) {
        do {
            guard let user = getUserFor(firebaseUID: firebaseUID) else {
                throw UserError.notFound(message: "No user found with firebaseUID \(firebaseUID)")
            }
            user.username = username
            try dbQueue.write({ (db) in
                let modified = try user.updateChanges(db)
                if !modified {
                    print("No updates necessary for user: \(user)")
                }
            })
        } catch {
            print("Database Error: \(error)")
            handleError?(error)
        }
    }
    
}
