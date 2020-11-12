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
    
    var friendsNotification: ([AnyObject], VKApi.Event) -> Void = { _, _ in }
    var photosNotification: ([AnyObject], VKApi.Event) -> Void = { _, _ in }
    var groupNotification: ([AnyObject], VKApi.Event) -> Void = { _, _ in }
    var newsNotification: ([AnyObject], VKApi.Event) -> Void = { _, _ in }

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
            var u = fetchUniqueObject(uniquePredicate: "id == \(user.id)", entity: "Users") as? Users
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
    
    func subscribeUsersList(_ completion: @escaping ([AnyObject], VKApi.Event) -> Void) {
        let friends = readUsersList()
        if friends.isEmpty == false {
            completion(friends, VKApi.Event.dataLoadedFromDB)
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
    
    func savePhotosWithContext(_ context: NSManagedObjectContext, _ photos: [VkApiPhotoItem]) {
        for photo in photos {
            var ph: Photos? = fetchUniqueObject(
                uniquePredicate:
                    "id == \(photo.id) "
                  + "and news_post_id == \(photo.newsPostId) "
                  + "and news_source_id == \(photo.newsSourceId) "
                , entity: "Photos") as? Photos
            if ph == nil {
                ph = Photos(context: context)
            }
            ph?.id = Int64(photo.id)
            ph?.date = Int64(photo.date)
            ph?.size_s_url = photo.sizeSUrl
            ph?.size_m_url = photo.sizeMUrl
            ph?.size_x_url = photo.sizeXUrl
            ph?.owner_id = Int64(photo.ownerId)
            ph?.news_post_id = Int64(photo.newsPostId)
            ph?.news_source_id = Int64(photo.newsSourceId)
        }
    }
    
    func subscribePhotosList(_ userID: Int, _ completion: @escaping ([AnyObject], VKApi.Event) -> Void) {
        let photos = readPhotosList(userID)
        if photos.isEmpty == false {
            completion(photos, VKApi.Event.dataLoadedFromDB)
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
            var g = fetchUniqueObject(uniquePredicate: "id == \(group.id)", entity: "Groups") as? Groups
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
    
    func subscribeGroupsList(_ completion: @escaping ([AnyObject], VKApi.Event) -> Void) {
        let groups = readGroupsList()
        if groups.isEmpty == false {
            completion(groups, VKApi.Event.dataLoadedFromDB)
        }
        groupNotification = completion
    }
    
    // var likes: VkApiLikes?
    func saveNews(_ news: [VkApiNewsItem]) {
        let context = storeStack.context
        for note in news {
            var n = fetchUniqueObject(uniquePredicate: "sourceId == \(note.sourceId) and postId == \(note.postId)", entity: "News") as? News
            if n == nil {
                n = News(context: context)
            }
            n?.postId = Int64(note.postId)
            n?.date = Int64(note.date)
            n?.sourceId = Int64(note.sourceId)
            n?.lastName = note.lastName
            n?.firstName = note.firstName
            n?.avatarPhoto = note.avatarPhoto
            n?.text = note.text
            savePhotosWithContext(context, note.photos?.items ?? [])
            for item in note.attachments {
                if let photo = item.photo {
                    savePhotosWithContext(context, [photo])
                }
            }
        }
        storeStack.saveContext()
    }
    
    func readNewsList() -> [VkApiNewsItem] {
        var newsResult: [VkApiNewsItem] = []
        let context = storeStack.context
        let news = (try? context.fetch(News.fetchRequest()) as? [News]) ?? []
        for note in news {
            let n = VkApiNewsItem(fromCoreData: note)
            let photoList = readPhotosList(n.postId, n.sourceId)
            n.photos = VkApiNewsPhotos()
            n.photos?.count = photoList.count
            n.photos?.items = photoList
            newsResult.append(n)
        }
        return newsResult
    }
    
    func subscribeNewsList(_ completion: @escaping ([AnyObject], VKApi.Event) -> Void) {
        let news = readNewsList()
        if news.isEmpty == false {
            completion(news, VKApi.Event.dataLoadedFromDB)
        }
        newsNotification = completion
    }
    
    func processObjects(_ objects: [NSManagedObject]) {
        var friends: [VkApiUsersItem] = []
        var photos: [VkApiPhotoItem] = []
        var groups: [VkApiGroupItem] = []
        var news: [VkApiNewsItem] = []
        for object in objects {
            if let friend = object as? Users {
                friends.append(VkApiUsersItem(fromCoreData: friend))
            } else if let photo = object as? Photos {
                photos.append(VkApiPhotoItem(fromCoreData: photo))
            } else if let group = object as? Groups {
                groups.append(VkApiGroupItem(fromCoreData: group))
            } else if let note = object as? News {
                let n = VkApiNewsItem(fromCoreData: note)
                news.append(n)
            } else {
                debugPrint("[CoreData]: WARNING: can't process unknown object")
                debugPrint(objects)
            }
        }
        if friends.isEmpty == false {
            DispatchQueue.main.async { [weak self] in
                self?.friendsNotification(friends, VKApi.Event.dataLoadedFromDB)
            }
        } else
        if groups.isEmpty == false {
            DispatchQueue.main.async { [weak self] in
                self?.groupNotification(groups, VKApi.Event.dataLoadedFromDB)
            }
        } else
        if news.isEmpty == false {
            // photos for news are come as a mix with the news objects
            // we should bucket them properly
            // NOTE: not optimal, but works
            for photo in photos {
                for n in news {
                    if photo.newsPostId == n.postId && photo.newsSourceId == n.sourceId {
                        if (n.photos == nil) {
                            n.photos = VkApiNewsPhotos()
                        }
                        n.photos?.items.append(photo)
                        n.photos?.count = n.photos?.items.count ?? 0
                    }
                }
            }
            DispatchQueue.main.async { [weak self] in
                self?.newsNotification(news, VKApi.Event.dataLoadedFromDB)
            }
        } else
        if photos.isEmpty == false {
            DispatchQueue.main.async { [weak self] in
                self?.photosNotification(photos, VKApi.Event.dataLoadedFromDB)
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

