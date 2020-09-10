//
//  PhotosCollectionViewCell.swift
//  Weather2
//
//  Created by aprirez on 8/5/20.
//  Copyright © 2020 Alla. All rights reserved.
//

import UIKit

class PhotosCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var photouser: UIImageView!
    @IBOutlet weak var likeView: LikeUIView!
    var photo: Photo?
    var indexPhoto: Int = 0
    
    public func setPhoto(photo: Photo?, indexPhoto: Int) {
        self.photo = photo
        self.indexPhoto = indexPhoto
        photouser.image = photo?.photo
        likeView.setObject(object: photo)
    }
    
}
