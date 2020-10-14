//
//  User.swift
//  VkStyle
//
//  Created by aprirez on 9/29/20.
//  Copyright © 2020 Alla. All rights reserved.
//

import Foundation
import RealmSwift

class VkApiUsersResponse: Decodable {
    let response: VkApiUsersResponseItems
}

class VkApiUsersResponseItems: Decodable {
    let items: [VkApiUsersItem]
}

class VkApiUsersItem: Object, Decodable {
    @objc dynamic var id: Int = 0
    @objc dynamic var first_name: String = ""
    @objc dynamic var last_name: String = ""
    @objc dynamic var photo_url: String = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }

    enum CodingKeys: String, CodingKey {
        case id
        case first_name
        case last_name
        case photo_200_orig
    }
    
    convenience required init(from decoder: Decoder) throws {
        self.init()

        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try values.decode(Int.self, forKey: .id)
        self.first_name = try values.decode(String.self, forKey: .first_name)
        self.last_name = try values.decode(String.self, forKey: .last_name)
        self.photo_url = try values.decode(String.self, forKey: .photo_200_orig)

        // debugPrint("Users[\(self.id)]: name = \(self.first_name) \(last_name), photo = \(self.photo_url)")
    }
}
