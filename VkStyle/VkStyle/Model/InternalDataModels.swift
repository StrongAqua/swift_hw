//
//  UsersInfo.swift
//  VkStyle
//
//  Created by aprirez on 8/6/20.
//  Copyright © 2020 Alla. All rights reserved.
//

import Foundation

class Likeable {
    var likedByMe: Bool = false
    var likesCount: Int = 0
}

class Photo : Likeable {
    var photoURL: String?

    init(_ photoURL: String,_ initialLikesCount: Int) {
        super.init()
        self.photoURL = photoURL
        self.likesCount = initialLikesCount
    }
}

class NewsMessage : Likeable {
    var photo: String
    var messageText: String
    var date: Date
    
    init(_ message: String, _ photo: String, _ date: Date) {
        self.photo = photo
        self.messageText = message
        self.date = date
    }
}

class UserInfo : Equatable {
    
    var id: Int = 0
    var user: String
    var photo: String
    var photoList: [Photo]
    var newsList: [NewsMessage]

    init(id: Int, user: String, photo: String, photoList: [Photo], newsList: [NewsMessage]) {
        self.id = id
        self.user = user
        self.photo = photo
        self.photoList = photoList
        self.newsList = newsList
    }
    
    static func ==(lhs: UserInfo, rhs: UserInfo) -> Bool {
        return lhs.user == rhs.user
    }
}

class UsersManager {
    
    static let shared = UsersManager()

    private var users: [Int: UserInfo] = [:]

    var dict = Dictionary<String, [UserInfo]>()
    var alphabet: [String] = []
    
    var newsList: [(NewsMessage, UserInfo)] = []
    var newsPhotoList = ["1131", "1132", "1133", "1134", "1135"]
    private var fakeNews: [String] = [
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.",
        "Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.",
        "Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
    ]

    private init() {
        rebuild()
    }
    
    func setUsersInfo(_ users: [VkApiUsersItem]) {
        for user in users {
            let name = user.firstName + " " + user.lastName
            self.users[user.id] =
                UserInfo(id: user.id, user: name,
                         photo: user.photoUrl,
                     photoList: [],
                     newsList: []
            )
        }
    }
    
    func setUserPhotos(_ userId: Int, _ photos: [VkApiPhotoItem]) {
        guard let user = users[userId] else { return }
        var newPhotoList: [Photo] = []
        for photo in photos {
            let likes_count = photo.likes_count
            let photoURL = photo.size_x_url
            let photoObject = Photo(photoURL, likes_count)
            newPhotoList.append(photoObject)
        }
        user.photoList = newPhotoList
    }
    
    func generateRandomNews() {
        let threeDaysInterval = 60*24*3 // minutes in three days
        for user_kv in users {
            var index = Int.random(in: 0..<fakeNews.count)
            for _ in 0...1 {
                let date = Date().addingTimeInterval(
                    TimeInterval(
                        -Int.random(in: 0...threeDaysInterval)
                    )
                )
                user_kv.value.newsList.append(
                    NewsMessage(
                        fakeNews[index],
                        newsPhotoList[Int.random(in: 0..<newsPhotoList.count)],
                        date)
                )
                index = (index + 1) % fakeNews.count
            }
        }
    }
    
    func prepareNewsList() -> [(NewsMessage, UserInfo)] {
        var newsList: [(NewsMessage, UserInfo)] = []
        for user_kv in users {
            for message in user_kv.value.newsList {
                newsList.append( (message, user_kv.value) )
            }
        }
        return newsList.sorted(by: {$0.0.date > $1.0.date})
    }
    
    func rebuild() {
        applyFilter("")
        // generateRandomNews()
        newsList = prepareNewsList()
    }

    func applyFilter(_ key: String) {
        var dict = Dictionary<String, [UserInfo]>()
        var alphabet: [String] = []

        for user_kv in users {
            let name = user_kv.value.user
            if (name.starts(with: key) == false) {
                continue
            }
            let letter = String(name.prefix(1))
            if dict[letter] == nil {
                dict[letter] = []
            }
            dict[letter]?.append(user_kv.value)
        }
        alphabet = dict.keys.sorted()

        self.dict = dict
        self.alphabet = alphabet
    }

    func getUserByIndexPath(_ indexPath: IndexPath) -> UserInfo? {
        let letter = alphabet[indexPath.section]
        let user = dict[letter]?[indexPath.row]
        return user
    }
}
