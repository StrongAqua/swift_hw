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
    
    func saveUsers(_ users: [VkApiUsersItem]) {
        do {
            let realm = try Realm()
            realm.beginWrite()
            realm.add(users, update: .all)
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

