//
//  VKApiNews.swift
//  VkStyle
//
//  Created by aprirez on 11/19/20.
//  Copyright © 2020 Alla. All rights reserved.
//

import Foundation

class VKApiNews {
    
    let api: VKApiProtocol = VKApiLoggerProxy()

    func get(args: [String: Any] = [:], completion: @escaping ([AnyObject], String, VKApi.DataSource) -> Void) {
        var params: [String: Any] = [
            "max_photos": 1,
            "source_ids": "friends,groups",
            "filters": "photo,post"
        ]
        // merge values, left new value if keys are equal
        params.merge(args, uniquingKeysWith: { _, new in new})
        api.apiRequest( "newsfeed.get", params, { [weak self] data in
            self?.parse(data, completion)
        })
    }
    
    func parse(_ data: Data, _ completion: @escaping ([AnyObject], String, VKApi.DataSource) -> Void) {
        AsyncJSONDecoder<VkApiNewsResponse>
            .decode(data) {
                $0.response.compose()
                completion($0.response.items, $0.response.nextFrom ?? "", .live)
        }
    }
}
