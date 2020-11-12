//
//  AsyncJsonDecoder.swift
//  VkStyle
//
//  Created by aprirez on 11/8/20.
//  Copyright © 2020 Alla. All rights reserved.
//

import Foundation

class AsyncJSONDecoder<T>: Operation where T: Decodable {
    
    let decoder: JSONDecoder = JSONDecoder()
    
    var data: Data?
    var result: T?
    
    private override init() {
        super.init()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
    }

    static func decode(_ inputData: Data, _ completion: @escaping (T) -> Void) {
        let op = AsyncJSONDecoder<T>()
        op.data = inputData
        op.completionBlock = {
            if op.isCancelled == false && op.isFinished == true {
                guard let result = op.result else {return}
                completion(result)
            }
        }
        AsyncQueue.instance().queue().addOperation(op)
    }

    override func main() {
        guard let data = self.data else {return}
        do {
            result = try decoder.decode(T.self, from: data)
        } catch DecodingError.dataCorrupted(let context) {
            debugPrint(DecodingError.dataCorrupted(context))
        } catch let error {
            debugPrint(error)
            debugPrint(String(bytes: data, encoding: .utf8) ?? "")
        }
    }
}
