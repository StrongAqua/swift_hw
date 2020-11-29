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

class VkApiPhotoSize: Decodable {
    let type: String
    let url: String
    let width: Int
    let height: Int
}

// TODO: re-implement with automatic parse
// TODO: repair CoreData cache for the news
class VkApiPhotoItem: Object, Decodable {
    // photo object fields
    @objc dynamic var id: Int = 0
    @objc dynamic var date: Int = 0
    @objc dynamic var ownerId: Int = 0

    // fields of the likes counter
    var likes: VkApiLikes?
    var sizes: [VkApiPhotoSize] = []

    // urls of different photo sizes
    @objc dynamic var sizeSUrl: String = ""
    @objc dynamic var sizeMUrl: String = ""
    @objc dynamic var sizeXUrl: String = ""

    // news post relationship
    @objc dynamic var newsPostId: Int = 0
    @objc dynamic var newsSourceId: Int = 0

    @objc dynamic var albumId: Int = 0
    
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
        case albumId
    }
    
    enum SizesKeys: String, CodingKey {
        case type
        case url
        case width
        case height
    }
    
    required override init() {
        self.ref = nil
    }
    
    init(fromCoreData photo: Photos) {
        self.ref = nil
        self.id = Int(photo.id)
        self.date = Int(photo.date)
        self.sizeSUrl = photo.size_s_url ?? ""
        self.sizeMUrl = photo.size_m_url ?? ""
        self.sizeXUrl = photo.size_x_url ?? ""
        self.albumId = Int(photo.album_id)
    }

    convenience required init(from decoder: Decoder) throws {
        self.init()

        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.date = try values.decode(Int.self, forKey: .date)
        self.id = try values.decode(Int.self, forKey: .id)
        self.ownerId = try values.decode(Int.self, forKey: .ownerId)

        self.likes = try? values.decode(VkApiLikes.self, forKey: .likes)
        self.sizes = (try? values.decode([VkApiPhotoSize].self, forKey: .sizes)) ?? []

        self.albumId = try values.decode(Int.self, forKey: .albumId)

        debugPrint("sizes count = \(self.sizes.count)")
        
        sizeSUrl = getSize("s")?.url ?? ""
        sizeMUrl = getSize("m")?.url ?? ""
        sizeXUrl = getSize("x")?.url ?? ""
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
            let sizeXUrl = value["size_x_url"] as? String,
            let albumId = value["album_id"] as? Int
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
        self.albumId = albumId

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
            "size_x_url": sizeXUrl,
            "album_id": albumId
        ]
        if let likes = self.likes?.toAnyObject() {
            anyDict["likes"] = likes
        }
        return anyDict
    }

    // TODO: temporary required till parsing will be re-implemented
    func getSize(_ type: String) -> VkApiPhotoSize? {
        for size in sizes {
            if size.type == type {
                return size
            }
        }
        return nil
    }

}

class VkApiLikes: Decodable {
    // snake style for parsing (!)
    @objc dynamic var count: Int = 0
    @objc dynamic var user_likes: Int = 0
    
    init?(snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String: Any],
            let count = value["count"] as? Int,
            let user_likes = value["user_likes"] as? Int
        else {
            return
        }
        self.count = count
        self.user_likes = user_likes
    }
    
    func toAnyObject() -> [String: Any] {
        return [
            "count": count,
            "user_likes": user_likes
        ]
    }
}
