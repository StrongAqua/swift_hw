//
//  Group.swift
//  VkStyle
//
//  Created by aprirez on 9/29/20.
//  Copyright © 2020 Alla. All rights reserved.
//

import Foundation
import RealmSwift
import Firebase

class VkApiGroupResponse: Decodable {
    let response: VkApiGroupResponseItems
}

class VkApiGroupResponseItems: Decodable {
    let items: [VkApiGroupItem]
}

class VkApiGroupItem: Object, Decodable {
    @objc dynamic var id: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var is_closed: Int = 0
    @objc dynamic var is_member: Int = 0
    @objc dynamic var photo_50_url: String = ""
    
    let ref: DatabaseReference?
    
    override static func primaryKey() -> String? {
        return "id"
    }

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case is_closed
        case is_member
        case photo_50_url = "photo_50"
    }
    
    required init() {
        self.ref = nil
    }
    
    convenience required init(from decoder: Decoder) throws {
        self.init()

        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try values.decode(String.self, forKey: .name)
        self.id = try values.decode(Int.self, forKey: .id)
        self.is_closed = try values.decode(Int.self, forKey: .is_closed)
        self.is_member = try values.decode(Int.self, forKey: .is_member)
        self.photo_50_url = try values.decode(String.self, forKey: .photo_50_url)

        // debugPrint("Group[\(self.id)]: name = \(self.name)")
    }
    
    // ------------------------------------------------------------
    // FIREBASE COMPATIBILITY:
    init?(snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String: Any],
            let id = value["id"] as? Int,
            let name = value["name"] as? String,
            let is_closed = value["is_closed"] as? Int,
            let is_member = value["is_member"] as? Int,
            let photo_50_url = value["photo_50_url"] as? String
        else {
            return nil
        }
        
        self.ref = snapshot.ref
        self.id = id
        self.name = name
        self.is_closed = is_closed
        self.is_member = is_member
        self.photo_50_url = photo_50_url
    }
    
    func toAnyObject() -> [String: Any] {
        return [
            "id": id,
            "name": name,
            "is_closed": is_closed,
            "is_member": is_member,
            "photo_50_url": photo_50_url
        ]
    }
}
