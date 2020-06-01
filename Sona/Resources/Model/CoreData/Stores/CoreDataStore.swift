//
//  CoreDataStore.swift
//  Sona
//
//  Created by Tyler Cheek on 6/1/20.
//  Copyright © 2020 Tyler Cheek. All rights reserved.
//

import CoreData

class CoreDataStore : NSObject {
    
    let persistentContainer: NSPersistentContainer = {
        // creates the NSPersistentContainer object
        let container = NSPersistentContainer(name: "Sona")

        // load the saved database if it exists, creates it if it does not, and returns an error under failure conditions
        container.loadPersistentStores { (description, error) in
            if let error = error {
                print("Error setting up Core Data (\(error)).")
            }
        }
        return container
    }()
    
    func saveContext() {
        let viewContext = persistentContainer.viewContext
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}
