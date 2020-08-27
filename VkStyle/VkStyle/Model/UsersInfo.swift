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

class UserInfo : Equatable {
    
    var user: String?
    var photo: UIImage?
    var photoList: Array<Photo?>?
    
    init(user: String, photo: UIImage?, photoList: Array<Photo?>?) {
        self.user = user
        self.photo = photo
        self.photoList = photoList
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
                             Photo(UIImage(named: "1135"), 0)]),
        UserInfo(user: "Cat",
                 photo: UIImage(named: "1122"),
                 photoList: [Photo(UIImage(named: "1122"), 0),
                             Photo(UIImage(named: "1133"), 0)]),
        UserInfo(user: "Todd",
                 photo: UIImage(named: "1123"),
                 photoList: [Photo(UIImage(named: "1123"), 0),
                             Photo(UIImage(named: "1131"), 0),
                             Photo(UIImage(named: "1134"), 0)]),
        UserInfo(user: "Tom",
                 photo: UIImage(named: "1124"),
                 photoList: [Photo(UIImage(named: "1124"), 0),
                             Photo(UIImage(named: "1132"), 0)])
    ]
    
    var dict = Dictionary<String, Array<UserInfo>>()
    var alphabet: [String] = []

    private init() {
        for user in users {
            guard let name = user.user else { return }
            let letter = String(name.prefix(1))
            if dict[letter] == nil {
                dict[letter] = []
            }
            dict[letter]?.append(user)
        }
        alphabet = dict.keys.sorted()
    }
    
    func getUserByIndexPath(_ indexPath: IndexPath) -> UserInfo? {
        let letter = alphabet[indexPath.section]
        let user = dict[letter]?[indexPath.row]
        return user
    }
}
