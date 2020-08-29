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
    
    public func setPhoto(photo: Photo?) {
        self.photo = photo
        photouser.image = photo?.photo
        likeView.setObject(object: photo)
    }
    
}
