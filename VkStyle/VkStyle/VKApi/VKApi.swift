//
//  VKApi.swift
//  VkStyle
//
//  Created by aprirez on 9/26/20.
//  Copyright © 2020 Alla. All rights reserved.
//

import Foundation
import Alamofire

protocol VKApiProtocol {
    func apiRequest(
        _ method: String,
        _ parameters: [String: Any],
        _ completion: @escaping (Data) -> Void
    )
}

class VKApi: VKApiProtocol {
    
    enum DataSource {
        case cached
        case live
    }

    // let's limit number of objects to download up to 10
    // will do pagination l8r
    static let maxObjectsCount = 100
    
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

class VKApiLoggerProxy: VKApiProtocol {

    private let vkApi = VKApi()
    private var clientCompletionClosure: ((Data) -> Void)?
    
    private func responseHandler(data: Data) {
        print("[VK RESPONSE]: API response data = \(data)")
        clientCompletionClosure?(data)
    }
    
    func apiRequest(
        _ method: String,
        _ parameters: [String : Any],
        _ completion: @escaping (Data) -> Void
    ) {
        clientCompletionClosure = completion
        
        print("[VK REQUEST]: call API method = \(method), with parameters = \(parameters)")
        vkApi.apiRequest(method, parameters, responseHandler)
    }
    
}
