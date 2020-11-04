//
//  User.swift
//  VkStyle
//
//  Created by aprirez on 9/29/20.
//  Copyright © 2020 Alla. All rights reserved.
//

import Foundation
import RealmSwift
import Firebase

class VkApiUsersResponse: Decodable {
    let response: VkApiUsersResponseItems
}

class VkApiUsersResponseItems: Decodable {
    let items: [VkApiUsersItem]
}

class VkApiUsersItem: Object, Decodable {

    @objc dynamic var id: Int = 0
    @objc dynamic var firstName: String = ""
    @objc dynamic var lastName: String = ""
    @objc dynamic var photoUrl: String = ""
    
    let ref: DatabaseReference?
    
    override static func primaryKey() -> String? {
        return "id"
    }

    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case photo100 = "photo_100"
    }
    
    required init() {
        self.ref = nil
    }
    
    init(fromCoreData user: Users) {
        self.ref = nil
        self.id = Int(user.id)
        self.firstName = user.first_name ?? "(error)"
        self.lastName = user.last_name ?? "(error)"
        self.photoUrl = user.photo_url ?? "(error)"
    }
    
    convenience required init(from decoder: Decoder) throws {
        self.init()
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try values.decode(Int.self, forKey: .id)
        self.firstName = try values.decode(String.self, forKey: .firstName)
        self.lastName = try values.decode(String.self, forKey: .lastName)
        self.photoUrl = try values.decode(String.self, forKey: .photo100)
    }
    
    // ------------------------------------------------------------
    // FIREBASE COMPATIBILITY:
    init?(snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String: Any],
            let id = value["id"] as? Int,
            let firstName = value["first_name"] as? String,
            let lastName = value["last_name"] as? String,
            let photoUrl = value["photo_url"] as? String
        else {
            return nil
        }
        
        self.ref = snapshot.ref
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.photoUrl = photoUrl
    }
    
    func toAnyObject() -> [String: Any] {
        return [
            "id": id,
            "first_name": firstName,
            "last_name": lastName,
            "photo_url": photoUrl
        ]
    }

}
