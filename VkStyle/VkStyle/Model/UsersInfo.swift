//
//  UsersInfo.swift
//  Weather2
//
//  Created by aprirez on 8/6/20.
//  Copyright © 2020 Alla. All rights reserved.
//

import Foundation
import UIKit

class Likeable {
    var likedByMe: Bool = false
    var likesCount: Int = 0
}

class Photo : Likeable {
    var photo: UIImage?
    
    init(_ photo: UIImage?,_ initialLikesCount: Int) {
        super.init()
        self.photo = photo
        self.likesCount = initialLikesCount
    }
}

class NewsMessage : Likeable {
    var photoList: [Photo]
    var messageText: String
    var date: Date
    
    init(_ message: String, _ photoList: [Photo], _ date: Date) {
        self.photoList = photoList
        self.messageText = message
        self.date = date
    }
}

class UserInfo : Equatable {
    
    var user: String
    var photo: UIImage?
    var photoList: [Photo]
    var newsList: [NewsMessage]

    init(user: String, photo: UIImage?, photoList: [Photo], newsList: [NewsMessage]) {
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

    private var users: [UserInfo] = [
        UserInfo(user: "Helga",
                 photo: UIImage(named: "1121"),
                 photoList: [Photo(UIImage(named: "1121"), 0),
                             Photo(UIImage(named: "1131"), 0),
                             Photo(UIImage(named: "1135"), 0)],
                 newsList: []
        ),
        UserInfo(user: "Cat",
                 photo: UIImage(named: "1122"),
                 photoList: [Photo(UIImage(named: "1122"), 0),
                             Photo(UIImage(named: "1133"), 0)],
                 newsList: []
        ),
        UserInfo(user: "Todd",
                 photo: UIImage(named: "1123"),
                 photoList: [Photo(UIImage(named: "1123"), 0),
                             Photo(UIImage(named: "1131"), 0),
                             Photo(UIImage(named: "1134"), 0)],
                 newsList: []
        ),
        UserInfo(user: "Tom",
                 photo: UIImage(named: "1124"),
                 photoList: [Photo(UIImage(named: "1124"), 0),
                             Photo(UIImage(named: "1132"), 0)],
                 newsList: []
        )
    ]
    
    private var fakeNews: [String] = [
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.",
        "Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.",
        "Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
    ]
    
    var dict = Dictionary<String, [UserInfo]>()
    var alphabet: [String] = []
    var newsList: [(NewsMessage, UserInfo)] = []

    private init() {
        applyFilter("")
        generateRandomNews()
        newsList = prepareNewsList()
    }
    
    func generateRandomNews() {
        let threeDaysInterval = 60*24*3 // minutes in three days
        for user in users {
            var index = Int.random(in: 0..<fakeNews.count)
            for _ in 0...1 {
                let date = Date().addingTimeInterval(
                    TimeInterval(
                        -Int.random(in: 0...threeDaysInterval)
                    )
                )
                user.newsList.append(NewsMessage(fakeNews[index], [], date))
                index = (index + 1) % fakeNews.count
            }
        }
    }
    
    func prepareNewsList() -> [(NewsMessage, UserInfo)] {
        var newsList: [(NewsMessage, UserInfo)] = []
        // var phase = 0
        for user in users {
            for message in user.newsList {
                // if phase % 2 != 0 {
                    message.photoList = user.photoList
                // }
                // phase += 1
                newsList.append( (message, user) )
            }
        }
        return newsList.sorted(by: {$0.0.date > $1.0.date})
    }
    
    func applyFilter(_ key: String) {
        var dict = Dictionary<String, [UserInfo]>()
        var alphabet: [String] = []

        for user in users {
            let name = user.user
            if (name.starts(with: key) == false) {
                continue
            }
            let letter = String(name.prefix(1))
            if dict[letter] == nil {
                dict[letter] = []
            }
            dict[letter]?.append(user)
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
