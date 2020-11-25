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
    
    let saveService : SaveServiceInterface = SaveServiceCoreData()
    // let saveService : SaveServiceInterface = SaveServiceRealm()
    // let saveService : SaveServiceFirebase = SaveServiceFirebase()

    enum DataSource {
        case cached
        case live
    }

    // let's limit number of objects to download up to 10
    // will do pagination l8r
    static let maxObjectsCount = 10
    
    // VK API server request wrapper
    func apiRequest(
        _ method: String,
        _ parameters: [String: Any],
        _ completion: @escaping (Data) -> Void
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
            { response in
                switch response.result {
                case .success(let data):
                    completion(data)
                case .failure(let error):
                    debugPrint(error)
                }
            }
    }
}
