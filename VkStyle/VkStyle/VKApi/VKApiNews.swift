//
//  VKApiNews.swift
//  VkStyle
//
//  Created by aprirez on 11/19/20.
//  Copyright © 2020 Alla. All rights reserved.
//

import Foundation

class VKApiNews {
    
    let api = VKApi()

    // TODO: restore CoreData cache for the news
    func get(args: [String: Any] = [:], completion: @escaping ([AnyObject], String, VKApi.DataSource) -> Void) {
        // TODO: api.saveService.subscribeNewsList(completion)
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
            .decode(data) { // TODO: [weak self] in
                $0.response.compose()
                // TODO: self?.api.saveService.saveNews($0.response.items)
                completion($0.response.items, $0.response.nextFrom, .live)
        }
    }
}
