//
//  PhotosCollectionViewCell.swift
//  Weather2
//
//  Created by aprirez on 8/5/20.
//  Copyright © 2020 Alla. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class PhotosCollectionViewCell: ASCellNode {

    private let imageNode = ASNetworkImageNode()
    private var photo: VkApiPhotoItem?
    private let imageHeight: CGFloat = 50
    
    init(photo: VkApiPhotoItem?) {
        super.init()
        
        guard let photo = photo else { return }
        let url = photo.sizeXUrl

        self.photo = photo
        backgroundColor = UIColor.red
        
        imageNode.url = URL(string: url)
        imageNode.clipsToBounds = false
        imageNode.shouldRenderProgressImages = true
        imageNode.contentMode = .scaleAspectFill
        addSubnode(imageNode)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        imageNode.style.preferredSize = CGSize(width: 100, height: 100)
        return ASWrapperLayoutSpec(layoutElement: imageNode)
    }
}
