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
    
    func setupSubViews() {
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
    override func awakeFromNib() {
        setupSubViews()
    }
    
    func setupFrames() {
        setupFrames(frame)
    }
    
    func setupFrames(_ frame: CGRect) {
        let buttonSize : CGFloat = 30
        let viewWidth = frame.width
        let viewHeight = frame.height
        
        self.frame = frame

        likeView.frame = CGRect(x: 0, y: viewHeight - buttonSize, width: viewWidth, height: buttonSize)
        likeButton.frame = CGRect(x: viewWidth - buttonSize, y: 0, width: buttonSize, height: buttonSize)
        likeLabel.frame = CGRect(x: 0, y: 0, width: viewWidth - buttonSize - 5, height: buttonSize)

        commentButton.frame = CGRect(x: 5, y: 0, width: buttonSize, height: buttonSize)
        repostButton.frame = CGRect(x: 5 + buttonSize + 5, y: 0, width: buttonSize, height: buttonSize)

        commentButton.setTitle("✍", for: .normal)
        repostButton.setTitle("↪", for: .normal)

        setNeedsLayout()
        setNeedsDisplay()
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
        pulsate(sender)
        flash(likeLabel)
        object?.likedByMe.toggle()
        if let o = object {
            setState(o.likedByMe)
        }
    }
    
    func pulsate(_ sender: UIView) {
        
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration = 1
        pulse.fromValue = 0.75
        pulse.toValue = 1.5
        pulse.autoreverses = true
        pulse.repeatCount = 1
        pulse.initialVelocity = 0.5
        pulse.damping = 1.0
        
        sender.layer.add(pulse, forKey: "pulse")
    }
    
    func flash(_ sender: UIView) {
        
        let flash = CABasicAnimation(keyPath: "opacity")
        flash.duration = 0.5
        flash.fromValue = 1
        flash.toValue = 0.1
        flash.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        flash.autoreverses = true
        flash.repeatCount = 2
        
        sender.layer.add(flash, forKey: nil)
    }

}
