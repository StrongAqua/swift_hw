//
//  AnimationHelpers.swift
//  VkStyle
//
//  Created by aprirez on 9/9/20.
//  Copyright © 2020 Alla. All rights reserved.
//

import UIKit

extension UIView {
    
    // this code was honestly stolen from:
    // https://stackoverflow.com/questions/48060394/how-to-rotate-uiview-in-its-top-left-coordinates
    func setAnchorPoint(anchorPoint: CGPoint) {
        // relative coordinates of current anchor point (in coordinates system of our view)
        var oldPoint = CGPoint(
            x: frame.size.width * layer.anchorPoint.x,
            y: frame.size.height * layer.anchorPoint.y
        )
        // relative coordinates of future anchor point (in coordinates system of our view)
        var newPoint = CGPoint(
            x: frame.size.width * anchorPoint.x,
            y: frame.size.height * anchorPoint.y
        )

        // applying current transform (if exists) to the relative points
        oldPoint = oldPoint.applying(transform)
        newPoint = newPoint.applying(transform)

        // applying new anchor moves our view, so we should compensate this moving
        var position : CGPoint = layer.position

        position.x -= oldPoint.x
        position.x += newPoint.x

        position.y -= oldPoint.y
        position.y += newPoint.y

        // apply compensated position
        layer.position = position
        // apply new anchor
        layer.anchorPoint = anchorPoint
    }
}

// convertor: degrees to radians:
extension CGFloat {
    var toRadians: CGFloat {
        return self * CGFloat(Double.pi / 180.0)
    }
}

// convertor: int degrees to radians:
extension Int {
    var toRadians: CGFloat {
        return CGFloat(self).toRadians
    }
}
