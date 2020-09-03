//
//  AvatarCompositeView.swift
//  VkStyle
//
//  Created by aprirez on 8/18/20.
//  Copyright © 2020 Alla. All rights reserved.
//

import UIKit

@IBDesignable class AvatarCompositeView: UIView {

    @IBOutlet weak var avatarPhoto: UIImageView!
    @IBOutlet weak var avatarShadow: UIView!

    @IBInspectable var shadowWidth: CGFloat = 3 {
        didSet {
            setNeedsDisplay()
        }
    }

    @IBInspectable var opacity: Float = 0.5 {
        didSet {
            setNeedsDisplay()
        }
    }

    @IBInspectable var color: UIColor = UIColor.black {
        didSet {
            setNeedsDisplay()
        }
    }

    func setup() {
        avatarPhoto.layer.cornerRadius = 42
        avatarPhoto.setNeedsDisplay()

/**/
        let f = avatarPhoto.frame
        avatarShadow.frame = CGRect(
            x: f.origin.x/* - shadowWidth */,
            y: f.origin.y/* - shadowWidth */,
            width: f.width/* + (shadowWidth * 2) */,
            height: f.height/* + (shadowWidth * 2)*/)
 /**/
        avatarShadow.layer.shadowColor = color.cgColor
        avatarShadow.layer.shadowOpacity = opacity
        avatarShadow.layer.shadowRadius = shadowWidth
        avatarShadow.layer.shadowOffset = CGSize(width: 3, height: 3)
        avatarShadow.layer.cornerRadius = 42
        avatarShadow.setNeedsDisplay()
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
