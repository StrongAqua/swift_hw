//
//  SaveService.swift
//  VkStyle
//
//  Created by aprirez on 10/4/20.
//  Copyright © 2020 Alla. All rights reserved.
//

import Foundation
import FirebaseDatabase

class SaveServiceFirebase : SaveServiceInterface {
    
    let friendsListRef = Database.database().reference().child("\(Session.instance.userId)/friends")
    var isSetFriendsObserver : Bool = false

    var photosListRef : DatabaseReference?
    var isSetPhotosObserver : Bool = false
    var photosObserverUserID : Int = -1

    let groupsListRef = Database.database().reference().child("\(Session.instance.userId)/groups")
    var isSetGroupsObserver : Bool = false
    
    let newsListRef = Database.database().reference().child("\(Session.instance.userId)/news")
    var isSetNewsObserver : Bool = false
    
    func saveUsers(_ users: [VkApiUsersItem]) {
        debugPrint("Save users to the Firebase")
        for user in users {
            friendsListRef.child(String(user.id)).setValue(user.toAnyObject())
        }
    }

    // required only for the CoreData
    func readUsersList() -> [VkApiUsersItem] {
        debugPrint("ERROR: should not be used for Firebase")
        return []
    }
    
    func subscribeUsersList(_ completion: @escaping ([AnyObject], VKApi.DataSource) -> Void) {
        if isSetFriendsObserver == false {
            isSetFriendsObserver = true
            debugPrint("Subscribe to the Firebase events")
            // observe - calls our callback for initial data and for further data updates
            friendsListRef.observe(.value, with: {
                dataBaseSnapshot in
                debugPrint("Firebase updated event")
                var friends : [VkApiUsersItem] = []
                for child in dataBaseSnapshot.children {
                    if let objectSnapshot = child as? DataSnapshot,
                        let friend = VkApiUsersItem(snapshot: objectSnapshot) {
                        friends.append(friend)
                    }
                }
                completion(friends, .cached)
            })
        }
    }
    
    func savePhotos(_ photos: [VkApiPhotoItem]) {
        debugPrint("Save photos to the Firebase")
        for photo in photos {
            debugPrint("  - saving photo id = \(photo.id)")
            photosListRef?.child("\(photo.id)").setValue(photo.toAnyObject())
        }
    }
    
    func readPhotosList(_ userID: Int) -> [VkApiPhotoItem] {
        return []
    }
    
    func subscribePhotosList(_ userID: Int, _ completion: @escaping ([AnyObject], VKApi.DataSource) -> Void) {
        if isSetPhotosObserver == false || userID != photosObserverUserID {
            isSetPhotosObserver = true

            photosObserverUserID = userID
            photosListRef = Database.database().reference().child("\(Session.instance.userId)/photos/\(userID)")

            debugPrint("Subscribe to the Firebase events")
            // observe - calls our callback for initial data and for further data updates
            photosListRef?.observe(.value, with: {
                dataBaseSnapshot in
                debugPrint("  - firebase event (!)")
                var photos : [VkApiPhotoItem] = []
                for child in dataBaseSnapshot.children {
                    if let objectSnapshot = child as? DataSnapshot,
                        let photo = VkApiPhotoItem(snapshot: objectSnapshot) {
                        debugPrint("  - photo \(photo.id) is updated in the Firebase")
                        photos.append(photo)
                    }
                }
                debugPrint("  - call completion for \(photos.count) photo(s)")
                completion(photos, .cached)
            })
        }
    }
    
    func saveGroups(_ groups: [VkApiGroupItem]) {
        debugPrint("Save groups to the Firebase")
        for group in groups {
            groupsListRef.child(String(group.id)).setValue(group.toAnyObject())
        }
    }
    
    func readGroupsList() -> [VkApiGroupItem] {
        return []
    }
    
    func subscribeGroupsList(_ completion: @escaping ([AnyObject], VKApi.DataSource) -> Void) {
        if isSetGroupsObserver == false {
            isSetGroupsObserver = true
            debugPrint("Subscribe to the Firebase events")
            // observe - calls our callback for initial data and for further data updates
            groupsListRef.observe(.value, with: {
                dataBaseSnapshot in
                debugPrint("Firebase updated event")
                var groups : [VkApiGroupItem] = []
                for child in dataBaseSnapshot.children {
                    if let objectSnapshot = child as? DataSnapshot,
                        let group = VkApiGroupItem(snapshot: objectSnapshot) {
                        groups.append(group)
                    }
                }
                completion(groups, .cached)
            })
        }
    }
 
    func saveNews(_ news: [VkApiNewsItem]) {
        debugPrint("Save news to the Firebase, count = \(news.count)")
        for note in news {
            newsListRef.child("\(note.sourceId):\(note.postId)").setValue(note.toAnyObject())
        }
    }
    
    func readNewsList() -> [VkApiNewsItem] {
        return []
    }

    func subscribeNewsList(_ completion: @escaping ([AnyObject], VKApi.DataSource) -> Void) {
        if isSetNewsObserver == false {
            isSetNewsObserver = true
            debugPrint("Subscribe to the Firebase events")
            newsListRef.observe(.value, with: {
                dataBaseSnapshot in
                debugPrint("Firebase updated event")
                var news : [VkApiNewsItem] = []
                for child in dataBaseSnapshot.children {
                    if let objectSnapshot = child as? DataSnapshot,
                        let note = VkApiNewsItem(snapshot: objectSnapshot) {
                        news.append(note)
                    }
                }
                completion(news, .cached)
            })
        }
    }

    func clearAllData() {
    }
}

