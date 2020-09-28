//
//  VKApi.swift
//  VkStyle
//
//  Created by aprirez on 9/26/20.
//  Copyright © 2020 Alla. All rights reserved.
//

import Foundation
import Alamofire

class VKApi {
    
    static let instance = VKApi()
    private init() {} // dummy
    
    private func apiRequest(_ method: String, _ parameters: [String: Any]) {
        var url = URLComponents()

        url.scheme = "https"
        url.host = "api.vk.com"
        url.path = "/method/" + method

        url.queryItems = [
            URLQueryItem(name: "user_id", value: String(Session.instance.userId)),
            URLQueryItem(name: "access_token", value: Session.instance.token),
            URLQueryItem(name: "v", value: "5.124")
        ]
        AF.request(url.url!,
                   method: .get,
                   parameters: parameters)
        .validate()
        .responseJSON
        { response in
            // print("Current thread #1 \(Thread.current)")
            switch response.result {
                case .success(let value):
                    if let value = value as? [String: AnyObject] {
                        self.processResponse(method, value)
                    }
                case .failure(let error):
                    debugPrint(error)
            }
        }
    }

    func processResponse(_ method: String, _ value: [String: AnyObject] ) {
        switch method {
        case "friends.get":
            debugPrint("Friends List:")
            processFriendsList(value)
        case "groups.get":
            debugPrint("Groups List:")
            processGroupsList(value)
        case "groups.search":
            debugPrint("Search Result:")
            processGroupsList(value)
        case "photos.get":
            debugPrint("User Photos:")
            processPhotosList(value)
        default:
            debugPrint(value)
        }
    }
    
    func processFriendsList(_ value: [String: AnyObject]) {
        if let response = value["response"] as? [String: AnyObject] {
            if let items = response["items"] as? [AnyObject] {
                for item in items {
                    if let id = item["id"] as? Int,
                       let first_name = item["first_name"] as? String,
                       let last_name = item["last_name"] as? String {
                        debugPrint("\(id): " + first_name + " " + last_name)
                    }
                }
            }
        }
    }
    
    func processGroupsList(_ value: [String: AnyObject]) {
        if let response = value["response"] as? [String: AnyObject] {
            if let items = response["items"] as? [AnyObject] {
                for item in items {
                    if let id = item["id"] as? Int,
                       let name = item["name"] as? String {
                        debugPrint("\(id): " + name)
                    }
                }
            }
        }
    }
    
    func processPhotosList(_ value: [String: AnyObject]) {
        if let response = value["response"] as? [String: AnyObject] {
            if let items = response["items"] as? [AnyObject] {
                for item in items {
                    if let date = item["date"] as? Int,
                       let likes = item["likes"] as? [String: AnyObject],
                       let urls = item["sizes"] as? [AnyObject] {
                        if let likes_count = likes["count"] as? Int {
                            for url in urls {
                                if let type = url["type"] as? String,
                                   let url_str = url["url"] as? String {
                                    if type == "x" {
                                        debugPrint("\(date): " + url_str + ", likes: \(likes_count)")
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    // Example: https://api.vk.com/method/friends.get
    // ?user_id=210700286
    // &fields=id,first_name,last_name
    // &access_token=533bacf01e11f55b536a565b57531ac114461ae8736d6506a3
    // &v=5.124
    func getFriendsList() {
        apiRequest( "friends.get", [
            "count": 10,
            "order": "name",
            "fields": "id,first_name,last_name"
        ])
    }
    
    func getUserPhotos(_ userID: Int) {
        apiRequest( "photos.get", [
            "owner_id": userID,
            "extended": 1,
            "album_id": "profile",
            "count": 10
        ])
    }
    
    func getGroupsList() {
        apiRequest( "groups.get", [
            "count": 10,
            "extended": 1,
            "fields": "id,name"
        ])
    }
    
    func searchGroups(_ query: String) {
        apiRequest( "groups.search", [
            "q": query,
            "type": "group",
            "limit": 10
        ])
    }
    
}
