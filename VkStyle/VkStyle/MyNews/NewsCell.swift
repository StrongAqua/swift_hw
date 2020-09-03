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
    
    var photos: [Photo] = []
    
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

        avatarImage.image = user.photo
        userName.text = user.user
        messageText.text = message.messageText
        photos = message.photoList
                
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        messageDate.text = dateFormatter.string(from: message.date)
        messageImage.image = message.photoList.last?.photo
        
        likeView.setObject(object: message)
/*
        if user.user == "Helga" {
            messagePhotos.isHidden = true
        }
*/
    }
/*
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewsPhotoCollectionCell", for: indexPath) as! NewsPhotoCollectionCell
        cell.imageView.image = photos[indexPath.row].photo
        return cell
    }
*/
}
