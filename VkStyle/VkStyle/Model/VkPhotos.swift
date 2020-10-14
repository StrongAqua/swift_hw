//
//  Photo.swift
//  VkStyle
//
//  Created by aprirez on 9/29/20.
//  Copyright © 2020 Alla. All rights reserved.
//

import Foundation
import RealmSwift

class VkApiPhotoResponse: Decodable {
    let response: VkApiPhotoResponseItems
}

class VkApiPhotoResponseItems: Decodable {
    let items: [VkApiPhotoItem]
}

class VkApiPhotoItem: Object, Decodable {
    // photo object fields
    @objc dynamic var id: Int = 0
    @objc dynamic var date: Int = 0
    @objc dynamic var owner_id: Int = 0

    // fields of the likes counter
    @objc dynamic var likes_count: Int = 0
    @objc dynamic var user_likes: Int = 0

    // urls of different photo sizes
    @objc dynamic var size_s_url: String = ""
    @objc dynamic var size_m_url: String = ""
    @objc dynamic var size_x_url: String = ""

    override static func primaryKey() -> String? {
        return "id"
    }

    enum CodingKeys: String, CodingKey {
        case id
        case date
        case likes
        case sizes
        case owner_id
    }
    
    enum LikesKeys: String, CodingKey {
        case likes_count = "count"
        case user_likes
    }

    enum SizesKeys: String, CodingKey {
        case type
        case url
    }

    convenience required init(from decoder: Decoder) throws {
        self.init()

        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.date = try values.decode(Int.self, forKey: .date)
        self.id = try values.decode(Int.self, forKey: .id)
        self.owner_id = try values.decode(Int.self, forKey: .owner_id)

        let likes = try values.nestedContainer(keyedBy: LikesKeys.self, forKey: .likes)
        self.likes_count = try likes.decode(Int.self, forKey: .likes_count)
        self.user_likes = try likes.decode(Int.self, forKey: .user_likes)
        
        var sizes = try values.nestedUnkeyedContainer(forKey: .sizes)
        for _ in 0..<(sizes.count ?? 0) {
            let firstSizeValues = try sizes.nestedContainer(keyedBy: SizesKeys.self)
            let type = try firstSizeValues.decode(String.self, forKey: .type)
            switch (type) {
                case "s":
                    self.size_s_url = try firstSizeValues.decode(String.self, forKey: .url)
                case "m":
                    self.size_m_url = try firstSizeValues.decode(String.self, forKey: .url)
                case "x":
                    self.size_x_url = try firstSizeValues.decode(String.self, forKey: .url)
                default:
                    // won't use it and ever know about it :)
                    break
            }
        }
    }
}

