//
//  VKApiNewsAdapter.swift
//  VkStyle
//
//  Created by aprirez on 12/23/20.
//  Copyright © 2020 Alla. All rights reserved.
//

import Foundation

class VKApiNewsAdapter {
    private let vkNews = VKApiNews()
    private let loadBlockCount = 10
    
    func getOnMainQueue(fromTimeIntervalSince1970: Int?, _ completion: @escaping ([NewsViewModel], String) -> Void) {
        vkNews.get(
            args: fromTimeIntervalSince1970 != nil
                ? ["start_time": (fromTimeIntervalSince1970 ?? 0) + 1]
                : ["count": loadBlockCount],
            completion: { news, nextFrom, source in
                guard source == .live,
                      let newsList = news as? [VkApiNewsItem]
                else {return}

                let sortedList = newsList.sorted(by: {$0.date > $1.date})
                let models = NewsViewModelFactory().constructViewModels(sortedList)

                DispatchQueue.main.async {
                    completion(models, nextFrom)
                }
            })
    }

    func getOnMainQueue(fromTag: String, _ completion: @escaping ([NewsViewModel], String) -> Void) {
        var args: [String: Any] = ["count": loadBlockCount]
        if fromTag.isEmpty == false {
            args["start_from"] = fromTag
        }
        vkNews.get(
            args: args,
            completion: { news, nextFrom, source in
                guard source == .live,
                      let newsList = news as? [VkApiNewsItem]
                else {return}

                let sortedList = newsList.sorted(by: {$0.date > $1.date})
                let models = NewsViewModelFactory().constructViewModels(sortedList)
                
                DispatchQueue.main.async {
                    completion(models, nextFrom)
                }
            })
    }
}
