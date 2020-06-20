//
//  ProfileDAO.swift
//  Sona
//
//  Created by Tyler Cheek on 6/9/20.
//  Copyright © 2020 Tyler Cheek. All rights reserved.
//

import GRDB

class ProfileDAO : BaseDAO, DAO {
    
    static func setupTable() {
        if !BaseDAO.tableExists(tableName: Profile.databaseTableName) {
            createProfileTable()
        }
    }
    
    public static func createProfileTable() {
        do {
            try dbQueue.write({ (db) in
                try db.create(table: Profile.databaseTableName) { t in
                    t.autoIncrementedPrimaryKey(Profile.Columns.id.rawValue)
                    t.column(Profile.Columns.user_firebase_uid.rawValue, .integer)
                        .notNull()
                        .references(User.databaseTableName, onDelete: .cascade, onUpdate: .cascade)
                    t.column(Profile.Columns.profile_image.rawValue, .blob)
                }
            })
        } catch {
            fatalError("Database Error: \(error)")
        }
    }
    
    /// Creates a new row in the `profile` table for the given profile object.
    /// - parameter profile: The profile object to insert.
    /// - throws: A DatabaseError whenever an SQLite error occurs.
    public static func create(profile: Profile) throws {
        try dbQueue.write({ (db) in
            try profile.insert(db)
        })
    }
    
    /// Returns all profiles in the database.
    /// - throws: A DatabaseError whenever an SQLite error occurs.
    public static func getAllProfiles() throws -> [Profile] {
        if let profiles = try dbQueue.read({ (db) -> [Profile]? in
            try Profile.fetchAll(db)
        }) {
            return profiles
        } else {
            throw ProfileError.notFound
        }
    }
    
    /// Returns the only non-default profile in the database. There should only be one non-default profile for each application.
    /// - throws: A DatabaseError whenever an SQLite error occurs.
    public static func getNonDefaultProfile() throws -> Profile {
        if let profile = try dbQueue.read({ (db) -> Profile? in
            let request = Profile.filter(Column("id") != Profile.DEFAULT_ID)
            return try Profile.fetchOne(db, request)
        }) {
            return profile
        } else {
            throw ProfileError.notFound
        }
    }
    
    /// Returns a profile given the corresponding user.
    /// - parameter user: The user object to query with.
    /// - throws: Either a DatabaseError whenever an SQLite error occurs or a ProfileError.not found if the profile isn't found.
    public static func getProfileFor(user: User) throws -> Profile {
        if let profile = try dbQueue.read({ (db) -> Profile? in
            try user.profile.fetchOne(db)
        }) {
            return profile
        } else {
            throw ProfileError.notFound
        }
    }
    
    /// Returns a profile given the corresponding user's `firebaseUID`.
    /// - parameter userFirebaseUID: The `firebaseUID` to query with.
    /// - throws: Either a DatabaseError whenever an SQLite error occurs or a ProfileError.not found if the profile isn't found.
    public static func getProfileFor(userFirebaseUID: String) throws -> Profile {
        if let profile = try dbQueue.read({ (db) -> Profile? in
            let request = Profile.filter(Column("user_firebase_uid") == userFirebaseUID)
            return try Profile.fetchOne(db, request)
        }) {
            return profile
        } else {
            throw ProfileError.notFound
        }
    }
    
}
