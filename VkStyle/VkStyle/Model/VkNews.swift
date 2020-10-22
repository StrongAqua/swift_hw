//
//  VkNews.swift
//  VkStyle
//
//  Created by aprirez on 10/21/20.
//  Copyright © 2020 Alla. All rights reserved.
//

import Foundation
import RealmSwift
import Firebase

class VkApiNewsResponse: Decodable {
    let response: VkApiNewsResponseItems
}

class VkApiNewsResponseItems: Decodable {
    let items: [VkApiNewsItem]
    let profiles: [VkApiUsersItem]
    
    func compose() {
        for item in items {
            for profile in profiles {
                if (item.sourceId == profile.id) {
                    item.firstName = profile.firstName
                    item.lastName = profile.lastName
                    item.avatarPhoto = profile.photoUrl
                }
            }
        }
    }
}

class VkApiNewsItem: Decodable {
    @objc dynamic var postId: Int = 0
    @objc dynamic var date: Int = 0
    @objc dynamic var sourceId: Int = 0

    @objc dynamic var lastName: String?
    @objc dynamic var firstName: String?
    @objc dynamic var avatarPhoto: String?

    var photos: VkApiNewsPhotos?

    var ref: DatabaseReference?
    
    enum CodingKeys: String, CodingKey {
        case post_id
        case date
        case source_id
        case photos
    }

    required init() {
        self.ref = nil
    }

    convenience required init(from decoder: Decoder) throws {
        self.init()
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.postId = try values.decode(Int.self, forKey: .post_id)
        self.date = try values.decode(Int.self, forKey: .date)
        self.sourceId = try values.decode(Int.self, forKey: .source_id)
        self.photos = try values.decode(VkApiNewsPhotos.self, forKey: .photos)
    }

    // ------------------------------------------------------------
    // FIREBASE COMPATIBILITY:
    init?(snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String: Any],
            let postId = value["post_id"] as? Int,
            let date = value["date"] as? Int,
            let sourceId = value["source_id"] as? Int,
            let firstName = value["first_name"] as? String,
            let lastName = value["last_name"] as? String,
            let avatarPhoto = value["avatar_photo"] as? String,
            let photos = VkApiNewsPhotos(snapshot: snapshot.childSnapshot(forPath: "photos"))
        else {
            debugPrint("ERROR: DataSnapshot:VkApiNewsItem guard failed")
            return nil
        }
        
        self.ref = snapshot.ref
        self.postId = postId
        self.date = date
        self.sourceId = sourceId
        self.firstName = firstName
        self.lastName = lastName
        self.avatarPhoto = avatarPhoto
        self.photos = photos
    }

    func toAnyObject() -> [String: Any] {
        var result: [String: Any] = [
            "post_id": postId,
            "date": date,
            "source_id": sourceId,
            "first_name": firstName ?? "",
            "last_name": lastName ?? "",
            "avatar_photo": avatarPhoto ?? ""
        ]
        if let ps = photos {
            result["photos"] = ps.toAnyObject()
        }
        return result
    }
}

class VkApiNewsPhotos: Decodable {
    @objc dynamic var count: Int = 0
    @objc dynamic var items: [VkApiPhotoItem] = []
    
    init?(snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String: Any],
            let count = value["count"] as? Int,
            let items = value["items"] as? [Any]
        else {
            return
        }
        
        for i in 0..<items.count {
            let childSnapshot = snapshot.childSnapshot(forPath: "items/\(i)")
            if let pi = VkApiPhotoItem(snapshot: childSnapshot) {
                self.items.append(pi)
            }
        }

        self.count = count
    }

    func toAnyObject() -> [String: Any] {
        var items: [Any] = []
        for item in self.items {
            items.append(item.toAnyObject())
        }
        return [
            "count": count,
            "items": items
        ]
    }
}
