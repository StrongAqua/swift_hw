//
//  MyNewsCell.swift
//  VkStyle
//
//  Created by aprirez on 8/30/20.
//  Copyright © 2020 Alla. All rights reserved.
//

import UIKit

class NewsCell: UITableViewCell
    //, UICollectionViewDataSource
{
    
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var messageDate: UILabel!
    @IBOutlet weak var messageText: UILabel!
    // @IBOutlet weak var messagePhotos: UICollectionView!
    @IBOutlet weak var messageImage: UIImageView!
    @IBOutlet weak var likeView: LikeUIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // let nibName = UINib(nibName: "NewsPhotoCollectionCell", bundle:nil)
        // messagePhotos.register(nibName, forCellWithReuseIdentifier: "NewsPhotoCollectionCell")
        // messagePhotos.dataSource = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setup(_ item: VkApiNewsItem) {

        VKApi.instance.downloadImage(urlString: item.avatarPhoto ?? "", completion: {
            [weak self] data in
            guard let d = data else { return }
            self?.avatarImage.image = UIImage(data: d)
        })
        
        let first_name = item.firstName ?? ""
        let last_name = item.lastName ?? ""
        userName.text = "\(first_name) \(last_name)"
        
        messageText.text = item.text ?? ""

        var imageUrl: String?
        if (item.photos != nil && !(item.photos?.items.isEmpty ?? false)) {
            imageUrl = item.photos?.items.first?.sizeXUrl ?? ""
        } else if(item.attachments != nil) {
            if let attachments = item.attachments {
                for a in attachments {
                    if a.type == "photo" {
                        imageUrl = a.photo?.sizeXUrl ?? ""
                    }
                }
            }
        } else {
            messageImage.image = nil
        }
        
        if let url = imageUrl {
            VKApi.instance.downloadImage(urlString: url, completion: {
                [weak self] data in
                guard let d = data else { return }
                self?.messageImage.image = UIImage(data: d)
            })
        }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        messageDate.text = dateFormatter.string(
            from: Date(timeIntervalSince1970: TimeInterval(item.date))
        )
        // likeView.setObject(object: message)
    }
}
