//
//  LikePost.swift
//  VkStyle
//
//  Created by aprirez on 8/19/20.
//  Copyright © 2020 Alla. All rights reserved.
//

import Foundation
import UIKit

class LikeUIView: UIView {
    
    var likeView = UIView() // blue strip at the bottom of LikeUIView
    var likeLabel = UILabel()
    var likeButton = UIButton(type: .roundedRect)
    var commentButton = UIButton(type: .roundedRect)
    var repostButton = UIButton(type: .roundedRect)

    var object : Likeable?
    
    override func awakeFromNib() {
        likeView.backgroundColor = UIColor.blue.withAlphaComponent(0.25)

        likeButton.addTarget(self, action: #selector(likeButtonPressed), for: .touchUpInside)

        likeLabel.font = UIFont.boldSystemFont(ofSize: likeLabel.font.pointSize)
        likeLabel.textAlignment = .right

        likeView.addSubview(likeButton)
        likeView.addSubview(likeLabel)
        likeView.addSubview(commentButton)
        likeView.addSubview(repostButton)

        addSubview(likeView)
    }
    
    func setupFrames() {
        let buttonSize : CGFloat = 30
        let viewWidth = frame.width
        let viewHeight = frame.height

        likeView.frame = CGRect(x: 0, y: viewHeight - buttonSize, width: viewWidth, height: buttonSize)
        likeButton.frame = CGRect(x: viewWidth - buttonSize, y: 0, width: buttonSize, height: buttonSize)
        likeLabel.frame = CGRect(x: 0, y: 0, width: viewWidth - buttonSize - 5, height: buttonSize)

        commentButton.frame = CGRect(x: 5, y: 0, width: buttonSize, height: buttonSize)
        repostButton.frame = CGRect(x: 5 + buttonSize + 5, y: 0, width: buttonSize, height: buttonSize)

        commentButton.setTitle("✍", for: .normal)
        repostButton.setTitle("↪", for: .normal)

        setNeedsLayout()
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        setupFrames()
    }
    
    func setObject(object: Likeable?) {
        self.object = object
        if let o = object {
            setState(o.likedByMe)
        }
    }
    
    func setState(_ isLiked: Bool) {
        likeButton.setTitle(isLiked ? "💗" : "💙", for: .normal)
        likeLabel.text = isLiked ? "1" : "0"
        likeLabel.textColor = isLiked ? UIColor.red : UIColor.white
    }

    @objc func likeButtonPressed(sender: UIButton) {
        object?.likedByMe.toggle()
        if let o = object {
            setState(o.likedByMe)
        }
    }
    
}
