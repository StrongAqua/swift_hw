//
//  VKApiGroups.swift
//  VkStyle
//
//  Created by aprirez on 11/19/20.
//  Copyright © 2020 Alla. All rights reserved.
//

import Foundation

class VKApiGroups {
    
    let api: VKApiProtocol = VKApiLoggerProxy()

    func get(args: [String: Any] = [:], completion: @escaping ([AnyObject], VKApi.DataSource) -> Void) {
        let method = "groups.get"
        SaveService.instance().subscribeGroupsList(completion)
        var params: [String: Any] = [
            "user_id": String(Session.instance.userId),
            "count": VKApi.maxObjectsCount,
            "extended": 1,
            "fields": "id,name"
        ]
        params.merge(args, uniquingKeysWith: { _, new in new})
        api.apiRequest( method, params, { [weak self] data in
            self?.parse(method, data, completion)
        })
    }
    
    func search(args: [String: Any] = [:], completion: @escaping ([AnyObject], VKApi.DataSource) -> Void) {
        guard let query = args["query"] as? String else {
            fatalError("VKApiGroups requires 'query' arg")
        }

        let method = "groups.search"
        api.apiRequest( "groups.search", [
            "q": query,
            "type": "group",
            "count": VKApi.maxObjectsCount
        ], { [weak self] data in
            self?.parse(method, data, completion)
        })
    }

    func parse(_ method: String, _ data: Data, _ completion: @escaping ([AnyObject], VKApi.DataSource) -> Void) {
        switch method {
        case "groups.get":
            AsyncJSONDecoder<VkApiGroupResponse>
                .decode(data) { SaveService.instance().saveGroups($0.response.items) }
        case "groups.search":
            AsyncJSONDecoder<VkApiGroupResponse>
                .decode(data) {searchResponse in
                    DispatchQueue.main.async {
                        completion(searchResponse.response.items, .live)
                    }
                }
        default:
            break
        }
    }
    
    func save(_ groups: [VkApiGroupItem]) {
        SaveService.instance().saveGroups(groups)
    }

}
