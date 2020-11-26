//
//  VKApiFriends.swift
//  VkStyle
//
//  Created by aprirez on 11/19/20.
//  Copyright © 2020 Alla. All rights reserved.
//

import Foundation

class VKApiFriends {
    
    let api = VKApi()

    func get(args: [String: Any] = [:], completion: @escaping ([AnyObject], VKApi.DataSource) -> Void) {
        // Subscribe to DB notification with UI controller completion block.
        // SaveService controls that you subscribed only once.
        api.saveService.subscribeUsersList(completion)
        // Call the server. When the server data is got, parsed and stored DB will
        // call UI controller completion to display the data (friends list).
        var params: [String: Any] = [
            "user_id": String(Session.instance.userId),
            "count": VKApi.maxObjectsCount,
            "order": "name",
            "fields": "id,first_name,last_name,photo_100"
        ]
        params.merge(args, uniquingKeysWith: { _, new in new})
        api.apiRequest( "friends.get", params, { [weak self] data in
            self?.parse(data, completion)
        })
    }
    
    func parse(_ data: Data, _ completion: @escaping ([AnyObject], VKApi.DataSource) -> Void) {
        // no need to call UI controller completion here,
        // the SaveServiceCoreData will do this
        AsyncJSONDecoder<VkApiUsersResponse>
            .decode(data) {
                [weak self] in
                self?.api.saveService.saveUsers($0.response.items)
            }
        // TODO: eliminate subscriptions and do display data independently
        // from db IO operation
    }
}
