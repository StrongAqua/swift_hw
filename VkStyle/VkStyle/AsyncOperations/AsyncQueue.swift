//
//  AsyncQueue.swift
//  VkStyle
//
//  Created by aprirez on 11/8/20.
//  Copyright © 2020 Alla. All rights reserved.
//

import Foundation

class AsyncQueue {
    
    private let myOwnQueue = OperationQueue()
    
    private static let queueInstance: AsyncQueue = AsyncQueue()
    
    public static func instance() -> AsyncQueue {
        return queueInstance
    }
    
    public func queue() -> OperationQueue {
        return myOwnQueue
    }
    
}
