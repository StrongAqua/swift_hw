//
//  NewsViewModel.swift
//  VkStyle
//
//  Created by aprirez on 12/23/20.
//  Copyright © 2020 Alla. All rights reserved.
//

import Foundation
import UIKit

class NewsViewModel {
    var fullName = ""
    var text = ""
    var avatarURL = ""
    var photoURL = "" // size_x
    var photoSize = CGSize()
    var date = Date()
    var dateInt = 0
    var dateString = ""
}

class NewsViewModelBuilder {
    private static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter
    }()
    
    private var viewModel = NewsViewModel()
    
    func setFullName(firstName: String, lastName: String) -> NewsViewModelBuilder {
        viewModel.fullName = "\(firstName) \(lastName)"
        return self
    }
    
    func setText(_ text: String) -> NewsViewModelBuilder {
        viewModel.text = text
        return self
    }
    
    func setAvatarURL(_ url: String) -> NewsViewModelBuilder {
        viewModel.avatarURL = url
        return self
    }
    
    func setPhotoURL(_ url: String) -> NewsViewModelBuilder {
        viewModel.photoURL = url
        return self
    }
    
    func setPhotoSize(_ size: CGSize) -> NewsViewModelBuilder {
        viewModel.photoSize = size
        return self
    }
    
    func setDate(timeIntervalSince1970: Int) -> NewsViewModelBuilder {
        viewModel.dateInt = timeIntervalSince1970
        viewModel.date = Date(timeIntervalSince1970: TimeInterval(viewModel.dateInt))
        viewModel.dateString =
            NewsViewModelBuilder.dateFormatter.string(from: viewModel.date)
        return self
    }
    
    func build() -> NewsViewModel {
        return viewModel
    }
}

final class NewsViewModelFactory {
    
    func constructViewModels(_ apiItems: [VkApiNewsItem]) -> [NewsViewModel] {
        return apiItems.compactMap(self.vkPostToViewModel)
    }
    
    private func vkPostToViewModel(_ item: VkApiNewsItem) -> NewsViewModel {
        let photo = item.getPhoto()?.getSize("x")
        return NewsViewModelBuilder()
            .setFullName(firstName: item.firstName ?? "", lastName: item.lastName ?? "")
            .setText(item.text ?? "")
            .setAvatarURL(item.avatarPhoto ?? "")
            .setPhotoURL(photo?.url ?? "")
            .setPhotoSize(CGSize(width: CGFloat(photo?.width ?? 0),
                                 height: CGFloat(photo?.height ?? 0)))
            .setDate(timeIntervalSince1970: item.date)
            .build()
    }
}
