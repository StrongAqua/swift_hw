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
    
    func savePhotos(_ photos: [VkApiPhotoItem])
    func readPhotosList(_ userID: Int) -> [VkApiPhotoItem]
    
    func saveGroups(_ groups: [VkApiGroupItem])
    func readGroupsList() -> [VkApiGroupItem]
    
    func clearAllData()
}

