//
//  VKApiUserPhotos.swift
//  VkStyle
//
//  Created by aprirez on 11/19/20.
//  Copyright © 2020 Alla. All rights reserved.
//

import Foundation

class VKApiUserPhotos {
    
    let api = VKApi()

    func get(args: [String: Any], completion: @escaping ([AnyObject], VKApi.DataSource) -> Void) {

        guard let ownerId = args["owner"] as? Int else {
            fatalError("VKApiFriends requires 'owner' id in args")
        }

        api.saveService.subscribePhotosList(ownerId, completion)
        api.apiRequest( "photos.get", [
            "user_id": String(Session.instance.userId),
            "owner_id": ownerId,
            "extended": 1,
            "album_id": "profile",
            "count": VKApi.maxObjectsCount
        ], { [weak self] data in
            self?.parse(data, completion)
        })
    }
    
    func parse(_ data: Data, _ completion: @escaping ([AnyObject], VKApi.DataSource) -> Void) {
        AsyncJSONDecoder<VkApiPhotoResponse>
            .decode(data) {
                [weak self] in
                self?.api.saveService.savePhotos($0.response.items)
            }
    }
}
