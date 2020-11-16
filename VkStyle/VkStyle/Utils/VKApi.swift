//
//  VKApi.swift
//  VkStyle
//
//  Created by aprirez on 9/26/20.
//  Copyright © 2020 Alla. All rights reserved.
//

import Foundation
import Alamofire
import PromiseKit

class VKApi {
    
    let saveService : SaveServiceInterface = SaveServiceCoreData()
    // let saveService : SaveServiceInterface = SaveServiceRealm()
    // let saveService : SaveServiceFirebase = SaveServiceFirebase()
    
    enum Event {
        // this events is used if data really changed or initial load completed
        // and we should update our table/collection views
        case dataLoadedFromDB

        // this event is used when we received data from the server
        // at least we should end up our refreshing indicator
        case dataLoadedFromServer
    }
    
    // let's limit number of objects to download up to 10
    // will do pagination l8r
    static let maxObjectsCount = 10

    static let instance = VKApi()
    private init() {} // dummy
    
    // VK API server request wrapper
    private func apiRequest(
        _ method: String,
        _ parameters: [String: Any],
        _ completion: @escaping ([AnyObject], VKApi.Event) -> Void = {_, _ in }
    ) {
        var url = URLComponents()

        url.scheme = "https"
        url.host = "api.vk.com"
        url.path = "/method/" + method

        url.queryItems = [
            URLQueryItem(name: "access_token", value: Session.instance.token),
            URLQueryItem(name: "v", value: "5.124")
        ]

        AF.request(url.url!, method: .get, parameters: parameters)
            .responseData(queue: DispatchQueue.global())
        { [weak self] response in
            self?.parseResponse(url.url!, method, response, completion)
        }
    }
    
    // VK API server response processor
    private func parseResponse(
        _ url: URL,
        _ method: String,
        _ response: AFDataResponse<Data>,
        _ completion: @escaping ([AnyObject], VKApi.Event) -> Void)
    {
        switch response.result {
        case .success(let data):
            switch(method) {
            case "photos.get":
                // no need to call UI controller completion here,
                // the SaveServiceCoreData will do this
                AsyncJSONDecoder<VkApiPhotoResponse>
                    .decode(data) { self.saveService.savePhotos($0.response.items) }
                // TODO: eliminate subscriptions and do display data independently
                // from db IO operation
            case "groups.get":
                AsyncJSONDecoder<VkApiGroupResponse>
                    .decode(data) { self.saveService.saveGroups($0.response.items) }
            case "friends.get":
                AsyncJSONDecoder<VkApiUsersResponse>
                    .decode(data) { self.saveService.saveUsers($0.response.items) }
            case "groups.search":
                AsyncJSONDecoder<VkApiGroupResponse>
                    .decode(data) {searchResponse in
                        DispatchQueue.main.async {
                            completion(searchResponse.response.items, .dataLoadedFromServer)
                        }
                }
            case "newsfeed.get":
                AsyncJSONDecoder<VkApiNewsResponse>
                    .decode(data) {
                        $0.response.compose()
                        self.saveService.saveNews($0.response.items)
                        
                }
            default:
                // doesn't matter
                break
            }
        case .failure(let error):
            debugPrint(error)
        }
    }

    // VK API friends.get wrapper
    func getFriendsList(_ completion: @escaping ([AnyObject], Event) -> Void) {
        // Subscribe to DB notification with UI controller completion block.
        // SaveService controls that you subscribed only once.
        saveService.subscribeUsersList(completion)
        // Call the server. When the server data is got, parsed and stored DB will
        // call UI controller completion to display the data (friends list).
        apiRequest( "friends.get", [
            "user_id": String(Session.instance.userId),
            "count": VKApi.maxObjectsCount,
            "order": "name",
            "fields": "id,first_name,last_name,photo_100"
        ])
    }
    
    // VK API photos.get wrapper
    func getUserPhotos(_ userID: Int, _ completion: @escaping ([AnyObject], Event) -> Void) {
        saveService.subscribePhotosList(userID, completion)
        apiRequest( "photos.get", [
            "user_id": String(Session.instance.userId),
            "owner_id": userID,
            "extended": 1,
            "album_id": "profile",
            "count": VKApi.maxObjectsCount
        ])
    }
    
    // VK API photos.get wrapper
    func getGroupsList(_ completion: @escaping ([AnyObject], Event) -> Void) {
        saveService.subscribeGroupsList(completion)
        apiRequest( "groups.get", [
            "user_id": String(Session.instance.userId),
            "count": VKApi.maxObjectsCount,
            "extended": 1,
            "fields": "id,name"
        ])
    }
    
    func getNewsList(_ completion: @escaping ([AnyObject], Event) -> Void) {
        saveService.subscribeNewsList(completion)
        apiRequest( "newsfeed.get", [
            "count": VKApi.maxObjectsCount,
            "max_photos": 1,
            "source_ids": "friends,groups",
            "filters": "photo,post"
        ])
    }
    
    func searchGroups(_ query: String, _ completion: @escaping ([AnyObject], Event) -> Void) {
        debugPrint("Call the server search groups operation")
        apiRequest( "groups.search", [
            "q": query,
            "type": "group",
            "count": VKApi.maxObjectsCount
        ], completion) // completion will be called immediately after parsing is done
    }
    
    private func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    enum DownloadErrors : Error {
        case wrongURL
    }

    func downloadImageWithPromise(_ urlString: String) -> Promise<Data> {
        let promiseData = Promise<Data> { resolver in
            guard let url = URL(string: urlString) else {
                resolver.reject(DownloadErrors.wrongURL)
                return
            }
            URLSession.shared.dataTask(with: url) {
                data, _, error in
                if let error = error {
                    resolver.reject(error)
                } else {
                    resolver.fulfill(data ?? Data())
                }
            }
            .resume()
        }
        return promiseData
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
    
    func clearCachedData() {
        saveService.clearAllData()
    }
    
    func saveGroups(_ groups: [VkApiGroupItem]) {
        saveService.saveGroups(groups)
    }
}
