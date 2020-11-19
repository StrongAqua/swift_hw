//
//  PhotosCollectionViewCell.swift
//  Weather2
//
//  Created by aprirez on 8/5/20.
//  Copyright © 2020 Alla. All rights reserved.
//

import UIKit

class PhotosCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var likeView: LikeUIView!
    var photo: Photo?
    
    public func setPhotoURL(photoURL: Photo?, dataService: DataService) {
        guard let p = photoURL else { return }
        self.photo = p
        likeView.setObject(object: self.photo)

        guard let url = p.photoURL else { return }
        dataService.get(byUrl: url, completion: {
            [weak self] data in
            guard let d = data else { return }
            self?.image.image = UIImage(data: d)
        })
    }
    
}
