//
//  SaveService.swift
//  VkStyle
//
//  Created by aprirez on 10/4/20.
//  Copyright © 2020 Alla. All rights reserved.
//

import Foundation
import CoreData

class SaveServiceCoreData : SaveServiceInterface {
    
    let storeStack = CoreDataStack(modelName: "VkStyleStore")
    
    func clearAllData() {
        storeStack.clearAllData()
    }
    
    func fetchUniqueObject(uniquePredicate: String, entity: String) -> NSManagedObject? {
        var object: NSManagedObject?

        let context = storeStack.context
        let predicate = NSPredicate(format: uniquePredicate)
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entity)

        request.predicate = predicate
        if let fetchResults = try? context.fetch(request) as? [NSManagedObject] {
            if fetchResults.count > 0 {
                object = fetchResults[0]
            }
            // remove non-unique objects,
            // restore uniqueness
            if fetchResults.count > 1 {
                debugPrint("WARNING: this code should never be called in normal situation")
                for i in 1..<fetchResults.count {
                    let managedObject = fetchResults[i]
                    context.delete(managedObject)
                }
            }
        }
        return object
    }
    
    func saveUsers(_ users: [VkApiUsersItem]) {
        let context = storeStack.context
        for user in users {
            let u = (fetchUniqueObject(uniquePredicate: "id == \(user.id)", entity: "Users") as? Users?) ?? Users(context: context)
            u?.id = Int64(user.id)
            u?.first_name = user.firstName
            u?.last_name = user.lastName
            u?.photo_url = user.photoUrl
        }
        storeStack.saveContext()
    }
    
    func subscribeUsersList(_ completion: @escaping ([AnyObject], VKApi.Event) -> Void) {
    }
    
    func readUsersList() -> [VkApiUsersItem] {
        var friends: [VkApiUsersItem] = []
        let context = storeStack.context
        let users = (try? context.fetch(Users.fetchRequest()) as? [Users]) ?? []
        for user in users {
            let friend = VkApiUsersItem()
            friend.id = Int(user.id)
            friend.firstName = user.first_name ?? "(error)"
            friend.lastName = user.last_name ?? "(error)"
            friend.photoUrl = user.photo_url ?? "(error)"
            friends.append(friend)
        }
        return friends
    }
    
    func savePhotos(_ photos: [VkApiPhotoItem]) {
        let context = storeStack.context
        for photo in photos {
            let ph = (fetchUniqueObject(uniquePredicate: "id == \(photo.id)", entity: "Photos") as? Photos?) ?? Photos(context: context)
            ph?.id = Int64(photo.id)
            ph?.date = Int64(photo.date)
            ph?.size_s_url = photo.sizeSUrl
            ph?.size_m_url = photo.sizeMUrl
            ph?.size_x_url = photo.sizeXUrl
            ph?.owner_id = Int64(photo.ownerId)
        }
        storeStack.saveContext()
    }
    
    func subscribePhotosList(_ userID: Int, _ completion: @escaping ([AnyObject], VKApi.Event) -> Void) {
    }
    
    func readPhotosList(_ userID: Int) -> [VkApiPhotoItem] {
        var photos_out: [VkApiPhotoItem] = []
        let context = storeStack.context

        let predicate = NSPredicate(format: "owner_id == %i", userID)
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Photos")
        request.predicate = predicate

        let photos = (try? context.fetch(request) as? [Photos]) ?? []
        for photo in photos {
            let p = VkApiPhotoItem()
            p.id = Int(photo.id)
            p.date = Int(photo.date)
            p.sizeSUrl = photo.size_s_url ?? ""
            p.sizeMUrl = photo.size_m_url ?? ""
            p.sizeXUrl = photo.size_x_url ?? ""
            photos_out.append(p)
        }
        return photos_out
    }
    
    func saveGroups(_ groups: [VkApiGroupItem]) {
        let context = storeStack.context
        for group in groups {
            let g = (fetchUniqueObject(uniquePredicate: "id == \(group.id)", entity: "Groups") as? Groups?) ?? Groups(context: context)
            g?.id = Int64(group.id)
            g?.name = group.name
            g?.is_closed = Int64(group.isClosed)
            g?.is_member = Int64(group.isMember)
            g?.photo_50_url = group.photo50Url
        }
        storeStack.saveContext()
    }
    
    func readGroupsList() -> [VkApiGroupItem] {
        var groups_out: [VkApiGroupItem] = []
        let context = storeStack.context
        let groups = (try? context.fetch(Groups.fetchRequest()) as? [Groups]) ?? []
        for group in groups {
            let grp = VkApiGroupItem()
            grp.id = Int(group.id)
            grp.name = group.name ?? "(error)"
            grp.isClosed = Int(group.is_closed)
            grp.isMember = Int(group.is_member)
            grp.photo50Url = group.photo_50_url ?? ""
            groups_out.append(grp)
        }
        return groups_out
    }
    
    func subscribeGroupsList(_ completion: @escaping ([AnyObject], VKApi.Event) -> Void) {
    }
    
}

