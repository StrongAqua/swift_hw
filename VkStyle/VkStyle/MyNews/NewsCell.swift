//
//  MyNewsCell.swift
//  VkStyle
//
//  Created by aprirez on 8/30/20.
//  Copyright © 2020 Alla. All rights reserved.
//

import UIKit
import PromiseKit

class NewsCell: UITableViewCell
{
    
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var messageDate: UILabel!
    @IBOutlet weak var messageText: UILabel!
    @IBOutlet weak var messageImage: UIImageView!
    @IBOutlet weak var likeView: LikeUIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setup(_ item: VkApiNewsItem) {

        VKApi.instance.downloadImageWithPromise(item.avatarPhoto ?? "")
            .get {
                [weak self] data in
                self?.avatarImage.image = UIImage(data: data)
            }
            .catch { error in
                debugPrint("Fail to download image: \(error)")
            }
        
        let first_name = item.firstName ?? ""
        let last_name = item.lastName ?? ""
        userName.text = "\(first_name) \(last_name)"
        
        messageText.text = item.text ?? ""

        var imageUrl: String?
        if item.photos != nil && !(item.photos?.items.isEmpty ?? false) {
            imageUrl = item.photos?.items.first?.sizeXUrl ?? ""
        } else if item.attachments.isEmpty == false {
            for a in item.attachments {
                if a.type == "photo" {
                    imageUrl = a.photo?.sizeXUrl ?? ""
                }
            }
        } else {
            messageImage.image = nil
        }
        
        VKApi.instance.downloadImageWithPromise(imageUrl ?? "")
            .get {
                [weak self] data in
                self?.messageImage.image = UIImage(data: data)
            }
            .catch { error in
                debugPrint("Fail to download image: \(error)")
            }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        messageDate.text = dateFormatter.string(
            from: Date(timeIntervalSince1970: TimeInterval(item.date))
        )
        // likeView.setObject(object: message)
    }

}
