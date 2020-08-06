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
    
    public func setPhoto(image: UIImage?) {
        photouser.image = image
    }
}
