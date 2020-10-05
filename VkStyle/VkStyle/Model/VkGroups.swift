//
//  Group.swift
//  VkStyle
//
//  Created by aprirez on 9/29/20.
//  Copyright © 2020 Alla. All rights reserved.
//

import Foundation

class VkApiGroupResponse: Decodable {
    let response: VkApiGroupResponseItems
}

class VkApiGroupResponseItems: Decodable {
    let items: [VkApiGroupItem]
}

class VkApiGroupItem: Decodable {
    dynamic var id: Int = 0
    dynamic var name: String = ""
    dynamic var is_closed: Int = 0
    dynamic var is_member: Int = 0
    dynamic var photo_50_url: String = ""

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case is_closed
        case is_member
        case photo_50_url = "photo_50"
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
}
