//
//  SaveService.swift
//  VkStyle
//
//  Created by aprirez on 11/26/20.
//  Copyright © 2020 Alla. All rights reserved.
//

import Foundation

class SaveService {

    static let service = SaveService()
    
    let saveServiceImpl: SaveServiceInterface = SaveServiceCoreData()
    // let saveService : SaveServiceInterface = SaveServiceRealm()
    // let saveService : SaveServiceFirebase = SaveServiceFirebase()

    private init() { }
    
    static func instance() -> SaveServiceInterface {
        return service.saveServiceImpl
    }
    
}
