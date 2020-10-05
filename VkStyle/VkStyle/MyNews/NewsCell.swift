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
    
    var photo = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // let nibName = UINib(nibName: "NewsPhotoCollectionCell", bundle:nil)
        // messagePhotos.register(nibName, forCellWithReuseIdentifier: "NewsPhotoCollectionCell")
        // messagePhotos.dataSource = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setup(_ user: UserInfo, _ message: NewsMessage) {

        VKApi.instance.downloadImage(urlString: user.photo, completion: {
            [weak self] data in
            guard let d = data else { return }
            self?.avatarImage.image = UIImage(data: d)
        })
        
        userName.text = user.user
        messageText.text = message.messageText
        
        photo = message.photo
        messageImage.image = UIImage(named: photo)
                
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        messageDate.text = dateFormatter.string(from: message.date)
        likeView.setObject(object: message)

    }
}
