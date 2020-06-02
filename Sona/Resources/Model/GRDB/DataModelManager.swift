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
    
    static func setup(in application: UIApplication) throws {
        let databaseURL = try! FileManager.default
            .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            .appendingPathComponent("db.sqlite")

        self.dbQueue = try! DatabaseQueue(path: databaseURL.path)
    }
    
    static func tableExists(tableName: String) -> Bool{
        do {
            return try dbQueue.read { db in
                try db.tableExists(tableName)
            }
        } catch {
            print("Database Error: \(error)")
            return false
        }
        
    }
    
    static func createUserTable() {
        do {
            try dbQueue.write({ (db) in
                try db.create(table: "user") { t in
                    t.autoIncrementedPrimaryKey("id")
                    t.column("username", .text).unique(onConflict: .abort) // <--
                }
            })
        } catch {
            print("Database Error: \(error)")
        }
    }
    
    static func createUser(user: User) {
        
        do {
            try dbQueue.write({ (db) in
                try user.insert(db)
            })
        } catch {
            print("Database Error: \(error)")
        }
        
    }
    
    func getAllUsers() -> [User]? {
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
    
}
