//
//  Profile.swift
//  Sona
//
//  Created by Tyler Cheek on 6/1/20.
//  Copyright © 2020 Tyler Cheek. All rights reserved.
//

import GRDB

class Profile : Record, CustomStringConvertible {
    
    // MARK: Static members
    
    static let user = belongsTo(User.self,
                                using: ForeignKey([Columns.user_id.rawValue], to: [User.Columns.id.rawValue]))
    
    // MARK: Member variables
    
    private(set) var id: Int64!
    var userId: Int64
    var profileImage: UIImage?
    
    // MARK: Computed properties
    
    var user: QueryInterfaceRequest<User> {
        request(for: Profile.user)
    }
    
    var profileImageExists: Bool {
        return self.profileImage != nil
    }
    
    var description: String {
        return "Profile = id: \(String(describing: self.id)), userId: \(self.userId), profileImage: \(self.profileImageExists)"
    }
    
    // MARK: Initializers
    
    init(userId: Int64, profileImage: UIImage?) {
        self.userId = userId
        self.profileImage = profileImage
        super.init()
    }
    
    /// Creates a record from a database row
    required init(row: Row) {
        self.id = row[Columns.id]
        self.userId = row[Columns.user_id]
        if let profileImageBlob = row[Columns.profile_image] as? Data {
            self.profileImage = UIImage(data: profileImageBlob)
        } else {
            self.profileImage = nil
        }
        super.init(row: row)
    }
    
    // MARK: Overridden methods
    
    /// The values persisted in the database
    override func encode(to container: inout PersistenceContainer) {
        container[Columns.id] = self.id
        container[Columns.user_id] = self.userId
        container[Columns.profile_image] = self.profileImage?.pngData()
    }
    
    /// Update record ID after a successful insertion
    override func didInsert(with rowID: Int64, for column: String?) {
        id = rowID
    }
    
    // MARK: Record properties
    
    /// The table name
    override class var databaseTableName: String { "profile" }
    
    /// The table columns
    enum Columns: String, ColumnExpression {
        case id, profile_image, user_id
    }
    
}

extension Profile {
    
    static let DEFAULT_ID: Int64 = 0
    
}
