//
//  Photo.swift
//  VkStyle
//
//  Created by aprirez on 9/29/20.
//  Copyright © 2020 Alla. All rights reserved.
//

import Foundation
import RealmSwift
import Firebase

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
    @objc dynamic var ownerId: Int = 0

    // fields of the likes counter
    var likes: VkApiLikes?

    // urls of different photo sizes
    @objc dynamic var sizeSUrl: String = ""
    @objc dynamic var sizeMUrl: String = ""
    @objc dynamic var sizeXUrl: String = ""

    // news post relationship
    @objc dynamic var newsPostId: Int = 0
    @objc dynamic var newsSourceId: Int = 0

    let ref: DatabaseReference?

    override static func primaryKey() -> String? {
        return "id"
    }

    enum CodingKeys: String, CodingKey {
        case id
        case date
        case likes
        case sizes
        case ownerId
    }
    
    enum SizesKeys: String, CodingKey {
        case type
        case url
    }
    
    required init() {
        self.ref = nil
    }
    
    init(fromCoreData photo: Photos) {
        self.ref = nil
        self.id = Int(photo.id)
        self.date = Int(photo.date)
        self.sizeSUrl = photo.size_s_url ?? ""
        self.sizeMUrl = photo.size_m_url ?? ""
        self.sizeXUrl = photo.size_x_url ?? ""
        self.newsPostId = Int(photo.news_post_id)
        self.newsSourceId = Int(photo.news_source_id)
    }

    convenience required init(from decoder: Decoder) throws {
        self.init()

        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.date = try values.decode(Int.self, forKey: .date)
        self.id = try values.decode(Int.self, forKey: .id)
        self.ownerId = try values.decode(Int.self, forKey: .ownerId)

        self.likes = try? values.decode(VkApiLikes.self, forKey: .likes)
        
        var sizes = try values.nestedUnkeyedContainer(forKey: .sizes)
        for _ in 0..<(sizes.count ?? 0) {
            let firstSizeValues = try sizes.nestedContainer(keyedBy: SizesKeys.self)
            let type = try firstSizeValues.decode(String.self, forKey: .type)
            switch (type) {
                case "s":
                    self.sizeSUrl = try firstSizeValues.decode(String.self, forKey: .url)
                case "m":
                    self.sizeMUrl = try firstSizeValues.decode(String.self, forKey: .url)
                case "x":
                    self.sizeXUrl = try firstSizeValues.decode(String.self, forKey: .url)
                default:
                    // won't use it and ever know about it :)
                    break
            }
        }
    }
    
    // ------------------------------------------------------------
    // FIREBASE COMPATIBILITY:
    init?(snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String: Any],
            let id = value["id"] as? Int,
            let date = value["date"] as? Int,
            let ownerId = value["owner_id"] as? Int,
            let sizeSUrl = value["size_s_url"] as? String,
            let sizeMUrl = value["size_m_url"] as? String,
            let sizeXUrl = value["size_x_url"] as? String
        else {
            return nil
        }
        
        self.ref = snapshot.ref
        self.id = id
        self.date = date
        self.ownerId = ownerId
        self.sizeSUrl = sizeSUrl
        self.sizeMUrl = sizeMUrl
        self.sizeXUrl = sizeXUrl

        if let likes = VkApiLikes(snapshot: snapshot.childSnapshot(forPath: "likes")) {
            self.likes = likes
        }
    }
    
    func toAnyObject() -> [String: Any] {
        var anyDict: [String: Any] = [
            "id": id,
            "date": date,
            "owner_id": ownerId,
            "size_s_url": sizeSUrl,
            "size_m_url": sizeMUrl,
            "size_x_url": sizeXUrl
        ]
        if let likes = self.likes?.toAnyObject() {
            anyDict["likes"] = likes
        }
        return anyDict
    }
}

