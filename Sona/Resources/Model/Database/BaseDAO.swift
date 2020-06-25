//
//  BaseDAO.swift
//  Sona
//
//  Created by Tyler Cheek on 6/9/20.
//  Copyright © 2020 Tyler Cheek. All rights reserved.
//

import GRDB

class BaseDAO {
    
    static var dbQueue: DatabaseQueue!
    
    public static func setupDAOs() throws {
        setupDatabase()
        UserDAO.setupTable()
        ProfileDAO.setupTable()
    }
    
    private static func setupDatabase() {
        let databaseURL = try! FileManager.default
            .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            .appendingPathComponent("db.sqlite")
        
        self.dbQueue = try! DatabaseQueue(path: databaseURL.path)
    }
    
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
    
}
