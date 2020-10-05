//
//  GroupInfo.swift
//  Weather2
//
//  Created by aprirez on 8/5/20.
//  Copyright © 2020 Alla. All rights reserved.
//

import Foundation
import UIKit

class GroupInfo : Equatable {
    
    var title: String?
    var imageURL: String?
    
    init(title: String, imageURL: String) {
        self.title = title
        self.imageURL = imageURL
    }
    
    static func ==(lhs: GroupInfo, rhs: GroupInfo) -> Bool {
        return lhs.title == rhs.title
    }
}
