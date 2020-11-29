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

        guard let ownerId = args["owner_id"] as? Int else {
            fatalError("VKApiFriends requires 'owner' id in args")
        }

        guard let albumId = args["album_id"] as? String else {
            fatalError("VKApiFriends requires 'album_id' id in args")
        }

        SaveService.instance().subscribePhotosList(ownerId, completion)
        var params: [String: Any] = [
            "user_id": String(Session.instance.userId),
            "extended": 1,
            "album_id": albumId,
            "count": VKApi.maxObjectsCount
        ]
        params.merge(args, uniquingKeysWith: { _, new in new})
        api.apiRequest( "photos.get", params, { [weak self] data in
            self?.parse(data, completion)
        })
    }
    
    func parse(_ data: Data, _ completion: @escaping ([AnyObject], VKApi.DataSource) -> Void) {
        AsyncJSONDecoder<VkApiPhotoResponse>
            .decode(data) {
                SaveService.instance().savePhotos($0.response.items)
            }
    }
}
