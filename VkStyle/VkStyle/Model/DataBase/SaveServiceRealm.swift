//
//  SaveService.swift
//  VkStyle
//
//  Created by aprirez on 10/4/20.
//  Copyright © 2020 Alla. All rights reserved.
//

import Foundation
import RealmSwift

class SaveServiceRealm : SaveServiceInterface {
    
    var friendsNotificationToken: NotificationToken?
    var photosNotificationToken: NotificationToken?
    var photosNotificationTokenUserId = -1
    var groupsNotificationToken: NotificationToken?
    
    func saveUsers(_ users: [VkApiUsersItem]) {
        do {
            let realm = try Realm()
            realm.beginWrite()
            realm.add(users, update: .all)
            debugPrint("Commit users to the Realms")
            try realm.commitWrite()
        } catch {
            debugPrint(error)
        }
    }

    func readUsersList() -> [VkApiUsersItem] {
        do {
            let realm = try Realm()
            let objects = realm.objects(VkApiUsersItem.self)
            return [VkApiUsersItem](objects)
        } catch {
            debugPrint(error)
        }
        return [VkApiUsersItem]()
    }
    
    func subscribeUsersList(_ completion: @escaping ([AnyObject], VKApi.Event) -> Void) {
        if friendsNotificationToken != nil { return }
        do {
            let realm = try Realm()
            let objects = realm.objects(VkApiUsersItem.self)
            debugPrint("Subscribe to users list changes")
            friendsNotificationToken = objects.observe { (changes: RealmCollectionChange) in
                debugPrint("Realm notified about changes.")
                switch changes {
                case .initial (let results):
                    let users = [VkApiUsersItem](results)
                    debugPrint(".initial : \(users.count) users loaded from DB")
                    completion(users, .dataLoadedFromDB)
                case .update(let results, _, _, _):
                    let users = [VkApiUsersItem](results)
                    debugPrint(".update : \(users.count) users changed")
                    completion(users, .dataLoadedFromDB)
                case .error(let error):
                    debugPrint(".error")
                    debugPrint(error)
                }
            }
        } catch {
            debugPrint(error)
        }
    }
    
    func savePhotos(_ photos: [VkApiPhotoItem]) {
        do {
            let realm = try Realm()
            realm.beginWrite()
            realm.add(photos, update: .all)
            try realm.commitWrite()
        } catch let error {
            debugPrint(error)
        }
    }
    
    func readPhotosList(_ userID: Int) -> [VkApiPhotoItem] {
        do {
            let realm = try Realm()
            let objects = realm.objects(VkApiPhotoItem.self).filter("owner_id == \(userID)")
            return [VkApiPhotoItem](objects)
        } catch {
            debugPrint(error)
        }
        return [VkApiPhotoItem]()
    }
    
    func subscribePhotosList(_ userID: Int, _ completion: @escaping ([AnyObject], VKApi.Event) -> Void) {
        if photosNotificationToken != nil && userID == photosNotificationTokenUserId { return }
        do {
            let realm = try Realm()
            let objects = realm.objects(VkApiPhotoItem.self).filter("owner_id == \(userID)")
            debugPrint("Subscribe to photos list changes")
            photosNotificationToken = objects.observe { (changes: RealmCollectionChange) in
                debugPrint("Realm notified about changes.")
                switch changes {
                case .initial (let results):
                    let photos = [VkApiPhotoItem](results)
                    debugPrint(".initial : \(photos.count) groups loaded from DB")
                    completion(photos, .dataLoadedFromDB)
                case .update(let results, _, _, _):
                    let photos = [VkApiPhotoItem](results)
                    debugPrint(".update : \(photos.count) photos changed")
                    completion(photos, .dataLoadedFromDB)
                case .error(let error):
                    debugPrint(".error")
                    debugPrint(error)
                }
            }
            photosNotificationTokenUserId = userID
        } catch {
            debugPrint(error)
        }
    }
    func saveGroups(_ groups: [VkApiGroupItem]) {
        do {
            let realm = try Realm()
            realm.beginWrite()
            realm.add(groups, update: .all)
            try realm.commitWrite()
        } catch let error {
            debugPrint(error)
        }
    }
    
    func readGroupsList() -> [VkApiGroupItem] {
        do {
            let realm = try Realm()
            let objects = realm.objects(VkApiGroupItem.self)
            return [VkApiGroupItem](objects)
        } catch {
            debugPrint(error)
        }
        return [VkApiGroupItem]()
    }
    
    func subscribeGroupsList(_ completion: @escaping ([AnyObject], VKApi.Event) -> Void) {
        if groupsNotificationToken != nil { return }
        do {
            let realm = try Realm()
            let objects = realm.objects(VkApiGroupItem.self)
            debugPrint("Subscribe to groups list changes")
            groupsNotificationToken = objects.observe { (changes: RealmCollectionChange) in
                debugPrint("Realm notified about changes.")
                switch changes {
                case .initial (let results):
                    let groups = [VkApiGroupItem](results)
                    debugPrint(".initial : \(groups.count) groups loaded from DB")
                    completion(groups, .dataLoadedFromDB)
                case .update(let results, _, _, _):
                    let groups = [VkApiGroupItem](results)
                    debugPrint(".update : \(groups.count) groups changed")
                    completion(groups, .dataLoadedFromDB)
                case .error(let error):
                    debugPrint(".error")
                    debugPrint(error)
                }
            }
        } catch {
            debugPrint(error)
        }
    }
    func clearAllData() {
        do {
            let realm = try Realm()
            try realm.write {
                realm.deleteAll()
            }
        } catch {
            debugPrint(error)
        }
    }
}

