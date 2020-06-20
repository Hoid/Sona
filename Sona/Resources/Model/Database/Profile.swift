//
//  Profile.swift
//  Sona
//
//  Created by Tyler Cheek on 6/1/20.
//  Copyright © 2020 Tyler Cheek. All rights reserved.
//

import GRDB

public class Profile : Record, CustomStringConvertible {
    
    // MARK: Static members
    
    static let user = belongsTo(User.self,
                                using: ForeignKey([Columns.user_firebase_uid.rawValue], to: [User.Columns.firebase_uid.rawValue]))
    
    // MARK: Member variables
    
    private(set) var id: Int64!
    var userFirebaseUID: String
    var profileImage: UIImage?
    
    // MARK: Computed properties
    
    var user: QueryInterfaceRequest<User> {
        request(for: Profile.user)
    }
    
    var profileImageExists: Bool {
        return self.profileImage != nil
    }
    
    public var description: String {
        return "Profile = id: \(String(describing: self.userFirebaseUID)), userFirebaseUID: \(self.userFirebaseUID), profileImage: \(self.profileImageExists)"
    }
    
    // MARK: Initializers
    
    init(userFirebaseUID: String, profileImage: UIImage?) {
        self.userFirebaseUID = userFirebaseUID
        self.profileImage = profileImage
        super.init()
    }
    
    /// Creates a record from a database row
    required init(row: Row) {
        self.id = row[Columns.id]
        self.userFirebaseUID = row[Columns.user_firebase_uid]
        if let profileImageBlob = row[Columns.profile_image] as? Data {
            self.profileImage = UIImage(data: profileImageBlob)
        } else {
            self.profileImage = nil
        }
        super.init(row: row)
    }
    
    // MARK: Overridden methods
    
    /// The values persisted in the database
    public override func encode(to container: inout PersistenceContainer) {
        container[Columns.id] = self.id
        container[Columns.user_firebase_uid] = self.userFirebaseUID
        container[Columns.profile_image] = self.profileImage?.pngData()
    }
    
    /// Update record ID after a successful insertion
    public override func didInsert(with rowID: Int64, for column: String?) {
        id = rowID
    }
    
    // MARK: Record properties
    
    /// The table name
    public override class var databaseTableName: String { "profile" }
    
    /// The table columns
    enum Columns: String, ColumnExpression {
        case id, user_firebase_uid, profile_image
    }
    
}

extension Profile {
    
    static let DEFAULT_ID: Int64 = 0
    
}
