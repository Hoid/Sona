//
//  UserStore.swift
//  Sona
//
//  Created by Tyler Cheek on 6/1/20.
//  Copyright © 2020 Tyler Cheek. All rights reserved.
//

import UIKit
import CoreData

class UserStore: CoreDataStore {
    
    func fetchPersistedData(completion: @escaping (FetchUsersResult) -> Void) {

        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        let managedContext = self.persistentContainer.viewContext

        do {
            let allUsers = try managedContext.fetch(fetchRequest)
            completion(.success(allUsers))
        } catch {
            completion(.failure(error))
        }
    }
    
    // Always use this function to create a new user and store it in Core Data
    public func saveNewUser(username: String?, profileImage: UIImage?) {
        
        let managedContext = self.persistentContainer.viewContext
        let userEntity = NSEntityDescription.entity(forEntityName: "User", in: managedContext)!
        let newUser = User(entity: userEntity, insertInto: managedContext)
        newUser.setValue(username, forKey: "username")
        newUser.setValue(profileImage, forKey: "profileImage")
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save new team to CoreData. \(error), \(error.userInfo)")
        }
        
    }
    
}

enum FetchUsersResult {
    case success([User])
    case failure(Error)
}
