//
//  UsersInfo.swift
//  Weather2
//
//  Created by aprirez on 8/6/20.
//  Copyright © 2020 Alla. All rights reserved.
//

import Foundation
import UIKit

class UsersInfo : Equatable {
    
    var user: String?
    var photo: UIImage?
    var photoList: Array<UIImage?>?
    
    init(user: String, photo: UIImage?, photoList: Array<UIImage?>?) {
        self.user = user
        self.photo = photo
        self.photoList = photoList
    }
    
    static func ==(lhs: UsersInfo, rhs: UsersInfo) -> Bool {
        return lhs.user == rhs.user
    }
}
