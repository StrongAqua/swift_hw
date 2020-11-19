//
//  SaveService.swift
//  VkStyle
//
//  Created by aprirez on 10/4/20.
//  Copyright © 2020 Alla. All rights reserved.
//

import Foundation
import CoreData

protocol SaveServiceInterface {
    func saveUsers(_ users: [VkApiUsersItem])
    func readUsersList() -> [VkApiUsersItem]
    func subscribeUsersList(_ completion: @escaping ([AnyObject], VKApi.DataSource) -> Void)
    
    func savePhotos(_ photos: [VkApiPhotoItem])
    func readPhotosList(_ userID: Int) -> [VkApiPhotoItem]
    func subscribePhotosList(_ userID: Int, _ completion: @escaping ([AnyObject], VKApi.DataSource) -> Void)

    func saveGroups(_ groups: [VkApiGroupItem])
    func readGroupsList() -> [VkApiGroupItem]
    func subscribeGroupsList(_ completion: @escaping ([AnyObject], VKApi.DataSource) -> Void)
    
    func saveNews(_ news: [VkApiNewsItem])
    func readNewsList() -> [VkApiNewsItem]
    func subscribeNewsList(_ completion: @escaping ([AnyObject], VKApi.DataSource) -> Void)
    
    func clearAllData()
}

