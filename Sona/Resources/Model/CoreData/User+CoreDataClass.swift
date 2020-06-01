//
//  User+CoreDataClass.swift
//  Sona
//
//  Created by Tyler Cheek on 5/31/20.
//  Copyright © 2020 Tyler Cheek. All rights reserved.
//
//

import Foundation
import CoreData
import UIKit.UIImage

@objc(User)
public class User: NSManagedObject  {
    
    override public func awakeFromInsert() {
        super.awakeFromInsert()

        // Give properties initial values
        self.username = "no username"
        self.profileImage = UIImage(named: "no item image!")
    }
    
}
