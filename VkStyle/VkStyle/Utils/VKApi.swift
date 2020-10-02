//
//  VKApi.swift
//  VkStyle
//
//  Created by aprirez on 9/26/20.
//  Copyright © 2020 Alla. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class VKApi {
    
    // let's limit number of objects to download up to 10
    // will do pagination l8r
    static let MAX_OBJECTS_COUNT = 10
    
    static let instance = VKApi()
    private init() {} // dummy
    
    // VK API request wrapper
    private func apiRequest(
        _ method: String,
        _ parameters: [String: Any],
        _ completion: @escaping ([AnyObject]) -> Void
    ) {
        var url = URLComponents()

        url.scheme = "https"
        url.host = "api.vk.com"
        url.path = "/method/" + method

        url.queryItems = [
            URLQueryItem(name: "access_token", value: Session.instance.token),
            URLQueryItem(name: "v", value: "5.124")
        ]

        AF.request(url.url!, method: .get, parameters: parameters).responseData
        { response in
            self.processResponse(url.url!, method, response, completion)
        }
    }
    
    // VK API response processor
    private func processResponse(
        _ url: URL,
        _ method: String,
        _ response: AFDataResponse<Data>,
        _ completion: @escaping ([AnyObject]) -> Void)
    {
        switch response.result {
        case .success(let data):
            do {
                switch(method) {
                case "photos.get":
                    let photosResponse: VkApiPhotoResponse = try JSONDecoder().decode(VkApiPhotoResponse.self, from: data)
                    completion(photosResponse.response.items)
                case "groups.get":
                    let groupsResponse: VkApiGroupResponse = try JSONDecoder().decode(VkApiGroupResponse.self, from: data)
                    completion(groupsResponse.response.items)
                case "friends.get":
                    let friendsResponse: VkApiUsersResponse = try JSONDecoder().decode(VkApiUsersResponse.self, from: data)
                    completion(friendsResponse.response.items)
                case "groups.search":
                    let groupsResponse: VkApiGroupResponse = try JSONDecoder().decode(VkApiGroupResponse.self, from: data)
                    completion(groupsResponse.response.items)
                default:
                    // doesn't matter
                    break
                }
            } catch DecodingError.dataCorrupted(let context) {
                debugPrint(DecodingError.dataCorrupted(context))
            } catch { // let error
                debugPrint("Error while decoding json from \(url)")
                // debugPrint(error)
                // debugPrint(String(bytes: data, encoding: .utf8) ?? "")
            }
        case .failure(let error):
            debugPrint(error)
        }
    }

    // VK API friends.get wrapper
    func getFriendsList(_ completion: @escaping ([AnyObject]) -> Void) {
        apiRequest( "friends.get", [
            "user_id": String(Session.instance.userId),
            "count": VKApi.MAX_OBJECTS_COUNT,
            "order": "name",
            "fields": "id,first_name,last_name,photo_200_orig"
        ], completion)
    }
    
    // VK API photos.get wrapper
    func getUserPhotos(_ userID: Int, _ completion: @escaping ([AnyObject]) -> Void) {
        apiRequest( "photos.get", [
            "user_id": String(Session.instance.userId),
            "owner_id": userID,
            "extended": 1,
            "album_id": "profile",
            "count": VKApi.MAX_OBJECTS_COUNT
        ],
        completion)
    }
    
    // VK API photos.get wrapper
    func getGroupsList(_ completion: @escaping ([AnyObject]) -> Void) {
        apiRequest( "groups.get", [
            "user_id": String(Session.instance.userId),
            "count": VKApi.MAX_OBJECTS_COUNT,
            "extended": 1,
            "fields": "id,name"
        ], completion)
    }
    
    func searchGroups(_ query: String, _ completion: @escaping ([AnyObject]) -> Void) {
        apiRequest( "groups.search", [
            "q": query,
            "type": "group",
            "count": VKApi.MAX_OBJECTS_COUNT
        ], completion)
    }
    
    private func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func downloadImage(urlString: String, completion: @escaping (Data?) -> ()) {
        guard let url = URL(string: urlString) else { return }
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async() {
                completion(data)
            }
        }
    }
    
}
