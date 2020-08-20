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
    var image: UIImage?
    
    init(title: String, image: UIImage?) {
        self.title = title
        self.image = image
    }
    
    static func ==(lhs: GroupInfo, rhs: GroupInfo) -> Bool {
        return lhs.title == rhs.title
    }
}
