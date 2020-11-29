//
//  VkNews.swift
//  VkStyle
//
//  Created by aprirez on 10/21/20.
//  Copyright © 2020 Alla. All rights reserved.
//

import Foundation

class VkApiNewsResponse: Decodable {
    let response: VkApiNewsResponseItems
}

class VkApiNewsResponseItems: Decodable {
    let items: [VkApiNewsItem]
    let profiles: [VkApiUsersItem]
    let groups: [VkApiGroupItem]
    let nextFrom: String?

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

class VkApiNewsItem: Decodable {
    var postId: Int = 0
    var date: Int = 0
    var sourceId: Int = 0
    
    var lastName: String?
    var firstName: String?
    var avatarPhoto: String?

    var text: String?

    var photos: VkApiNewsPhotos?
    var likes: VkApiLikes?
    var attachments: [VkApiAttachment] = []
    
    enum CodingKeys: String, CodingKey {
        case postId
        case date
        case sourceId
        case text
        case photos
        case likes
        case attachments
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

        if var attachments = try? values.nestedUnkeyedContainer(forKey: .attachments),
           let attachmentsCount = attachments.count
        {
            for _ in 0..<attachmentsCount {
                if let a = try? attachments.decode(VkApiAttachment.self) {
                    a.photo?.newsPostId = self.postId
                    a.photo?.newsSourceId = self.sourceId
                    self.attachments.append(a)
                }
            }
        }

        // post-processing
        if let photos = self.photos {
            for photo in photos.items {
                photo.newsPostId = self.postId
                photo.newsSourceId = self.sourceId
            }
        }
    }
    
    func getPhoto() -> VkApiPhotoItem? {
        var photo: VkApiPhotoItem?
        if self.photos != nil && !(self.photos?.items.isEmpty ?? false) {
            photo = self.photos?.items.first
        }
        else if self.attachments.isEmpty == false {
            for attachment in self.attachments {
                if attachment.type == "photo" {
                    photo = attachment.photo
                }
            }
        }
        return photo
    }
}

class VkApiNewsPhotos: Decodable {
    var count: Int = 0
    var items: [VkApiPhotoItem] = []
}

class VkApiAttachment: Decodable {
    var type: String?
    var photo: VkApiPhotoItem?
}

