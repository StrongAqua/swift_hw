//
//  UsersInfo.swift
//  Weather2
//
//  Created by aprirez on 8/6/20.
//  Copyright © 2020 Alla. All rights reserved.
//

import Foundation
import UIKit

class UserInfo : Equatable {
    
    var user: String?
    var photo: UIImage?
    var photoList: Array<UIImage?>?
    
    init(user: String, photo: UIImage?, photoList: Array<UIImage?>?) {
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
                 photoList: [UIImage(named: "1121"),
                             UIImage(named: "1131"),
                             UIImage(named: "1135")]),
        UserInfo(user: "Cat",
                 photo: UIImage(named: "1122"),
                 photoList: [UIImage(named: "1122"),
                             UIImage(named: "1133")]),
        UserInfo(user: "Todd",
                 photo: UIImage(named: "1123"),
                 photoList: [UIImage(named: "1123"),
                             UIImage(named: "1131"),
                             UIImage(named: "1134")]),
        UserInfo(user: "Tom",
                 photo: UIImage(named: "1124"),
                 photoList: [UIImage(named: "1124"),
                             UIImage(named: "1132")])
    ]
    
    var dict = Dictionary<Character, Array<UserInfo>>()
    var alphabet: [Character] = []

    private init() {
        for user in users {
            guard let name = user.user else { return }
            guard let letter = name.first else { return }
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
