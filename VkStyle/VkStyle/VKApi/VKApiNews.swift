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
    
    func get(args: [String: Any] = [:], completion: @escaping ([AnyObject], VKApi.DataSource) -> Void) {
        api.saveService.subscribeNewsList(completion)
        api.apiRequest( "newsfeed.get", [
            "count": VKApi.maxObjectsCount,
            "max_photos": 1,
            "source_ids": "friends,groups",
            "filters": "photo,post"
        ], { [weak self] data in
            self?.parse(data, completion)
        })
    }
    
    func parse(_ data: Data, _ completion: @escaping ([AnyObject], VKApi.DataSource) -> Void) {
        AsyncJSONDecoder<VkApiNewsResponse>
            .decode(data) { [weak self] in
                $0.response.compose()
                self?.api.saveService.saveNews($0.response.items)
        }
    }
}
