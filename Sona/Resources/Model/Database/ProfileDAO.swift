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
                    t.column(Profile.Columns.user_id.rawValue, .integer)
                        .notNull()
                        .references(User.databaseTableName, onDelete: .cascade, onUpdate: .cascade)
                    t.column(Profile.Columns.profile_image.rawValue, .blob)
                }
            })
        } catch {
            fatalError("Database Error: \(error)")
        }
    }
    
    public static func create(profile: Profile, handleError: ((Error) -> Void)? = nil) {
        do {
            try dbQueue.write({ (db) in
                try profile.insert(db)
            })
        } catch {
            print("Database Error: \(error)")
            handleError?(error)
        }
        
    }
    
    public static func getAllProfiles(handleError: ((Error) -> Void)? = nil) -> [Profile]? {
        do {
            let profiles = try BaseDAO.dbQueue.read({ (db) -> [Profile] in
                try Profile.fetchAll(db)
            })
            return profiles
        } catch {
            print("Database Error: \(error)")
            handleError?(error)
            return nil
        }
    }
    
    /// There should only be one non-default profile for each application
    public static func getNonDefaultProfile(handleError: ((Error) -> Void)? = nil) -> Profile? {
        do {
            let profile = try BaseDAO.dbQueue.read({ (db) -> Profile? in
                let request = Profile.filter(Column("id") != Profile.DEFAULT_ID)
                let profile = try Profile.fetchOne(db, request)
                return profile
            })
            return profile
        } catch {
            print("Database Error: \(error)")
            handleError?(error)
            return nil
        }
    }
    
    public static func getProfileFor(user: User, handleError: ((Error) -> Void)? = nil) -> Profile? {
        do {
            let profile = try BaseDAO.dbQueue.read({ (db) -> Profile? in
                try user.profile.fetchOne(db)
            })
            return profile
        } catch {
            print("Database Error: \(error)")
            handleError?(error)
            return nil
        }
    }
    
}
