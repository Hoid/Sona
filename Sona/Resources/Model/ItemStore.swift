//
//  ItemStore.swift
//  Sona
//
//  Created by Tyler Cheek on 6/1/20.
//  Copyright © 2020 Tyler Cheek. All rights reserved.
//

import UIKit
import CoreData

class UserStore: NSObject {
    
    let persistentContainer: NSPersistentContainer = {
        // creates the NSPersistentContainer object
        // must be given the name of the Core Data model file “LoanedItems”
        let container = NSPersistentContainer(name: "LoanedItems")

        // load the saved database if it exists, creates it if it does not, and returns an error under failure conditions
        container.loadPersistentStores { (description, error) in
            if let error = error {
                print("Error setting up Core Data (\(error)).")
            }
        }
        return container
    }()
    
}
