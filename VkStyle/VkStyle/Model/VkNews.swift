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
    let groups: [VkApiGroupItem]

    func compose() {
        for item in items {
            if (item.sourceId >= 0) {
                for profile in profiles {
                    if (item.sourceId == profile.id) {
                        item.firstName = profile.firstName
                        item.lastName = profile.lastName
                        item.avatarPhoto = profile.photoUrl
                    }
                }
            } else {
                for group in groups {
                    if (abs(item.sourceId) == group.id) {
                        item.firstName = group.name
                        item.lastName = ""
                        item.avatarPhoto = group.photo50Url
                    }
                }
            }
        }
    }
}

class VkApiNewsItem: Object, Decodable {
    @objc dynamic var postId: Int = 0
    @objc dynamic var date: Int = 0
    @objc dynamic var sourceId: Int = 0
    
    @objc dynamic var lastName: String?
    @objc dynamic var firstName: String?
    @objc dynamic var avatarPhoto: String?

    @objc dynamic var text: String?

    var photos: VkApiNewsPhotos?
    var likes: VkApiLikes?
    var attachments: [VkApiAttachment]?

    var ref: DatabaseReference?
    
    enum CodingKeys: String, CodingKey {
        case postId
        case date
        case sourceId
        case text
        case photos
        case likes
        case attachments
    }

    required init() {
        self.ref = nil
    }
    
    init(fromCoreData note: News) {
        self.ref = nil
        self.postId = Int(note.postId)
        self.date = Int(note.date)
        self.sourceId = Int(note.sourceId)
        self.lastName = note.lastName
        self.firstName = note.firstName
        self.avatarPhoto = note.avatarPhoto
        self.text = note.text
    }

    convenience required init(from decoder: Decoder) throws {
        self.init()
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.postId = try values.decode(Int.self, forKey: .postId)
        self.date = try values.decode(Int.self, forKey: .date)
        self.sourceId = try values.decode(Int.self, forKey: .sourceId)

        self.text = try? values.decode(String.self, forKey: .text)
        self.photos = try? values.decode(VkApiNewsPhotos.self, forKey: .photos)
        self.likes = try? values.decode(VkApiLikes.self, forKey: .likes)
        var attachments = try? values.nestedUnkeyedContainer(forKey: .attachments)
        self.attachments = []
        for _ in 0..<(attachments?.count ?? 0) {
            if let a = try? attachments?.decode(VkApiAttachment.self) {
                a.photo?.newsPostId = self.postId
                a.photo?.newsSourceId = self.sourceId
                self.attachments!.append(a)
            }
        }

        // post-processing
        for photo in (self.photos?.items ?? []) {
            photo.newsPostId = self.postId
            photo.newsSourceId = self.sourceId
        }
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
            let text = value["text"] as? String
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
        self.text = text
        if let photos = VkApiNewsPhotos(snapshot: snapshot.childSnapshot(forPath: "photos")) {
            self.photos = photos
        }
        let attachments = snapshot.childSnapshot(forPath: "attachments")
        self.attachments = []
        for i in 0..<attachments.childrenCount {
            if let a = VkApiAttachment(snapshot: attachments.childSnapshot(forPath: "\(i)")) {
                self.attachments?.append(a)
            }
        }
    }

    func toAnyObject() -> [String: Any] {
        var result: [String: Any] = [
            "post_id": postId,
            "date": date,
            "source_id": sourceId,
            "first_name": firstName ?? "",
            "last_name": lastName ?? "",
            "avatar_photo": avatarPhoto ?? "",
            "text": text ?? ""
        ]
        if let ps = photos {
            result["photos"] = ps.toAnyObject()
        }
        if let ats = attachments {
            var items: [Any] = []
            for item in ats {
                items.append(item.toAnyObject())
            }
            if (!items.isEmpty) {
                result["attachments"] = items
            }
        }
        return result
    }
}

class VkApiNewsPhotos: Decodable {
    @objc dynamic var count: Int = 0
    @objc dynamic var items: [VkApiPhotoItem] = []
    
    init() {} // dummy initializer
    
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

class VkApiAttachment: Decodable {
    var type: String?
    // possible attachment is a photo
    var photo: VkApiPhotoItem?
    
    init?(snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String: Any],
            let type = value["type"] as? String
        else {
            return
        }

        self.type = type
        
        if let photo = VkApiPhotoItem(snapshot: snapshot.childSnapshot(forPath: "photo")) {
            self.photo = photo
        }

    }
    
    func toAnyObject() -> [String: Any] {
        if type == "photo" {
            return [
                "type": type!,
                "photo": photo!.toAnyObject()
            ]
        }
        return [:]
    }
}

