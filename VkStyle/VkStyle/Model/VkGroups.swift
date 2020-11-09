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
    @objc dynamic var isClosed: Int = 0
    @objc dynamic var isMember: Int = 0
    @objc dynamic var photo50Url: String = ""
    
    let ref: DatabaseReference?
    
    override static func primaryKey() -> String? {
        return "id"
    }

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case isClosed
        case isMember
        case photo50
    }
    
    required init() {
        self.ref = nil
    }
    
    init(fromCoreData group: Groups) {
        self.ref = nil
        self.id = Int(group.id)
        self.name = group.name ?? "(error)"
        self.isClosed = Int(group.is_closed)
        self.isMember = Int(group.is_member)
        self.photo50Url = group.photo_50_url ?? ""
    }
    
    convenience required init(from decoder: Decoder) throws {
        self.init()

        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try values.decode(String.self, forKey: .name)
        self.id = try values.decode(Int.self, forKey: .id)
        self.isClosed = try values.decode(Int.self, forKey: .isClosed)
        let isMember = try? values.decode(Int.self, forKey: .isMember) // may not be in incoming json
        self.isMember = isMember ?? 0
        self.photo50Url = try values.decode(String.self, forKey: .photo50)

        // debugPrint("Group[\(self.id)]: name = \(self.name)")
    }
    
    // ------------------------------------------------------------
    // FIREBASE COMPATIBILITY:
    init?(snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String: Any],
            let id = value["id"] as? Int,
            let name = value["name"] as? String,
            let isClosed = value["is_closed"] as? Int,
            let isMember = value["is_member"] as? Int,
            let photo50Url = value["photo_50_url"] as? String
        else {
            return nil
        }
        
        self.ref = snapshot.ref
        self.id = id
        self.name = name
        self.isClosed = isClosed
        self.isMember = isMember
        self.photo50Url = photo50Url
    }
    
    func toAnyObject() -> [String: Any] {
        return [
            "id": id,
            "name": name,
            "is_closed": isClosed,
            "is_member": isMember,
            "photo_50_url": photo50Url
        ]
    }
}
