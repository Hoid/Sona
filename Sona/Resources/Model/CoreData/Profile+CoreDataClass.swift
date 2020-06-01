//
//  Profile+CoreDataClass.swift
//  Sona
//
//  Created by Tyler Cheek on 5/31/20.
//  Copyright © 2020 Tyler Cheek. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Profile)
public class Profile: NSManagedObject {
    
    func assignUser(user: User?) {
        
        self.user = user ?? User()
        
    }
    
    override public func awakeFromInsert() {
        super.awakeFromInsert()

        // Give properties initial values
        self.user = User()
    }

}
