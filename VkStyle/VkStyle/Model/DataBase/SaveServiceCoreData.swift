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
    
    var friendsNotification: ([AnyObject], VKApi.DataSource) -> Void = { _, _ in }
    var photosNotification: ([AnyObject], VKApi.DataSource) -> Void = { _, _ in }
    var groupNotification: ([AnyObject], VKApi.DataSource) -> Void = { _, _ in }

    init() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.contextDidSave(_ :)),
            name: NSNotification.Name.NSManagedObjectContextDidSave,
            object: nil)
    }

    enum SaveServiceCoreDataErrors: Error {
        case notImplemented
    }
    
    func clearAllData() {
        storeStack.clearAllData()
    }
    
    func fetch(context: NSManagedObjectContext, predicate: String, entity: String) -> NSManagedObject? {

        var object: NSManagedObject?
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entity)

        request.predicate = NSPredicate(format: predicate)
        if let fetchResults = try? context.fetch(request) as? [NSManagedObject] {
            if fetchResults.count > 0 {
                object = fetchResults[0]
            }
            if fetchResults.count > 1 {
                fatalError("non unique object, predicate: \(predicate), entity: \(entity)")
            }
        }
        return object
    }
    
    func saveUsers(_ users: [VkApiUsersItem]) {
        let context = storeStack.context
        for user in users {
            var u = fetch(
                context: context,
                predicate: "id == \(user.id)",
                entity: "Users"
            ) as? Users
            if u == nil {
                u = Users(context: context)
            }
            u?.id = Int64(user.id)
            u?.first_name = user.firstName
            u?.last_name = user.lastName
            u?.photo_url = user.photoUrl
        }
        storeStack.saveContext()
    }
    
    func subscribeUsersList(_ completion: @escaping ([AnyObject], VKApi.DataSource) -> Void) {
        let friends = readUsersList()
        if friends.isEmpty == false {
            completion(friends, VKApi.DataSource.cached)
        }
        friendsNotification = completion
    }
    
    @objc func contextDidSave(_ notification: Notification) {
        try! notificationSelector(notification)
    }
    
    func readUsersList() -> [VkApiUsersItem] {
        var friends: [VkApiUsersItem] = []
        let context = storeStack.context
        let users = (try? context.fetch(Users.fetchRequest()) as? [Users]) ?? []
        for user in users {
            friends.append(VkApiUsersItem(fromCoreData: user))
        }
        return friends
    }
    
    func savePhotos(_ photos: [VkApiPhotoItem]) {
        let context = storeStack.context
        savePhotosWithContext(context, photos)
        storeStack.saveContext()
    }
    
    private func savePhotosWithContext(_ context: NSManagedObjectContext, _ photos: [VkApiPhotoItem]) {
        for photo in photos {
            var ph: Photos? = self.fetch(
                context: context,
                predicate: "id == \(photo.id) ",
                entity: "Photos"
            ) as? Photos
            if ph == nil {
                ph = Photos(context: context)
            }
            ph?.id = Int64(photo.id)
            ph?.date = Int64(photo.date)
            ph?.size_s_url = photo.sizeSUrl
            ph?.size_m_url = photo.sizeMUrl
            ph?.size_x_url = photo.sizeXUrl
            ph?.owner_id = Int64(photo.ownerId)
            ph?.album_id = Int64(photo.albumId)
        }
    }
    
    func subscribePhotosList(_ userID: Int, _ completion: @escaping ([AnyObject], VKApi.DataSource) -> Void) {
        let photos = readPhotosList(userID)
        if photos.isEmpty == false {
            completion(photos, VKApi.DataSource.cached)
        }
        photosNotification = completion
    }
    
    func readPhotosList(_ userID: Int) -> [VkApiPhotoItem] {
        let predicate = NSPredicate(format: "owner_id == %i", userID)
        return readPhotosList(predicate)
    }

    func readPhotosList(_ postId: Int, _ sourceId: Int) -> [VkApiPhotoItem] {
        let predicate = NSPredicate(format: "news_post_id == %i and news_source_id == %i", postId, sourceId)
        return readPhotosList(predicate)
    }

    private func readPhotosList(_ predicate: NSPredicate) -> [VkApiPhotoItem] {
        var photos_out: [VkApiPhotoItem] = []
        let context = storeStack.context

        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Photos")
        request.predicate = predicate

        let photos = (try? context.fetch(request) as? [Photos]) ?? []
        for photo in photos {
            photos_out.append(VkApiPhotoItem(fromCoreData: photo))
        }
        return photos_out
    }
    
    func saveGroups(_ groups: [VkApiGroupItem]) {
        let context = storeStack.context
        for group in groups {
            var g = fetch(
                context: context,
                predicate: "id == \(group.id)",
                entity: "Groups"
            ) as? Groups
            if g == nil {
                g = Groups(context: context)
            }
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
    
    func subscribeGroupsList(_ completion: @escaping ([AnyObject], VKApi.DataSource) -> Void) {
        let groups = readGroupsList()
        if groups.isEmpty == false {
            completion(groups, VKApi.DataSource.cached)
        }
        groupNotification = completion
    }
    
    func processObjects(_ objects: [NSManagedObject]) {
        var friends: [VkApiUsersItem] = []
        var photos: [VkApiPhotoItem] = []
        var groups: [VkApiGroupItem] = []
        for object in objects {
            if let friend = object as? Users {
                friends.append(VkApiUsersItem(fromCoreData: friend))
            } else if let photo = object as? Photos {
                photos.append(VkApiPhotoItem(fromCoreData: photo))
            } else if let group = object as? Groups {
                groups.append(VkApiGroupItem(fromCoreData: group))
            } else {
                debugPrint("[CoreData]: WARNING: can't process unknown object")
                debugPrint(objects)
            }
        }
        if friends.isEmpty == false {
            DispatchQueue.main.async { [weak self] in
                self?.friendsNotification(friends, VKApi.DataSource.cached)
            }
        } else
        if groups.isEmpty == false {
            DispatchQueue.main.async { [weak self] in
                self?.groupNotification(groups, VKApi.DataSource.cached)
            }
        } else
        if photos.isEmpty == false {
            DispatchQueue.main.async { [weak self] in
                self?.photosNotification(photos, VKApi.DataSource.cached)
            }
        }
    }
    
    func notificationSelector(_ notification: Notification) throws {
        var objectsToProcess: [NSManagedObject] = []
        if let insertedObjects = notification.userInfo?[NSInsertedObjectsKey] as? Set<NSManagedObject>, !insertedObjects.isEmpty {
            objectsToProcess.append(contentsOf: insertedObjects)
        }
        
        if let updatedObjects = notification.userInfo?[NSUpdatedObjectsKey] as? Set<NSManagedObject>, !updatedObjects.isEmpty {
            objectsToProcess.append(contentsOf: updatedObjects)
        }

        if objectsToProcess.isEmpty == false {
            processObjects(objectsToProcess)
        }

        // We don't expect the following notifications now
        if let deletedObjects = notification.userInfo?[NSDeletedObjectsKey] as? Set<NSManagedObject>, !deletedObjects.isEmpty {
            debugPrint("[CoreData]: ERROR, deletedObjects processing is not implemented")
            throw SaveServiceCoreDataErrors.notImplemented
        }
        
        if let refreshedObjects = notification.userInfo?[NSRefreshedObjectsKey] as? Set<NSManagedObject>, !refreshedObjects.isEmpty {
            debugPrint("[CoreData]: ERROR, refreshedObjects processing is not implemented")
            throw SaveServiceCoreDataErrors.notImplemented
        }
        
        if let invalidatedObjects = notification.userInfo?[NSInvalidatedObjectsKey] as? Set<NSManagedObject>, !invalidatedObjects.isEmpty {
            debugPrint("[CoreData]: ERROR, invalidatedObjects processing is not implemented")
            throw SaveServiceCoreDataErrors.notImplemented
        }
        
        if let _ = notification.userInfo?[NSInvalidatedAllObjectsKey] as? Bool {
            debugPrint("[CoreData]: ERROR, areInvalidatedAllObjects processing is not implemented")
            throw SaveServiceCoreDataErrors.notImplemented
        }
    }
}

