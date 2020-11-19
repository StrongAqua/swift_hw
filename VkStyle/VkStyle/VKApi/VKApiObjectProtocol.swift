//
//  VKApiObjectProtocol.swift
//  VkStyle
//
//  Created by aprirez on 11/19/20.
//  Copyright © 2020 Alla. All rights reserved.
//

import Foundation

protocol VKApiObjectProtocol {
    func get(_ parameters: [String: Any], _ completion: @escaping ([AnyObject], VKApi.DataSource) -> Void)
}
