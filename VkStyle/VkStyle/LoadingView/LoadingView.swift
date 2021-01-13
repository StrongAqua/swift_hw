//
//  LoadingView.swift
//  VkStyle
//
//  Created by aprirez on 9/5/20.
//  Copyright © 2020 Alla. All rights reserved.
//

import UIKit

 class LoadingView: UIView {
    
    var parentController: CAAnimationDelegate?

    // remember reference to the parent view controller to perform segue on animationDidStop
    func setup(_ parentController: CAAnimationDelegate) {
        self.parentController = parentController
    }

    override func draw(_ rect: CGRect) {
        
        super.draw(rect)
             
        let arrowXOffset: CGFloat = 20
        let cornerRadius: CGFloat = 40
        let arrowHeight: CGFloat = 40
        
        let mainRect = CGRect(origin: rect.origin, size: CGSize(width: rect.width, height: rect.height - arrowHeight))
        
        let leftTopPoint = mainRect.origin
        let rightTopPoint = CGPoint(x: mainRect.maxX, y: mainRect.minY)
        let rightBottomPoint = CGPoint(x: mainRect.maxX, y: mainRect.maxY)
        let leftBottomPoint = CGPoint(x: mainRect.minX, y: mainRect.maxY)
        
        let leftArrowPoint = CGPoint(x: leftBottomPoint.x + arrowXOffset, y: leftBottomPoint.y)
        let centerArrowPoint = CGPoint(x: leftArrowPoint.x + arrowHeight, y: leftArrowPoint.y + arrowHeight)
        let rightArrowPoint = CGPoint(x: leftArrowPoint.x + 2 * arrowHeight, y: leftArrowPoint.y)
        
        let path = UIBezierPath()
        
        path.addArc(withCenter: CGPoint(x: rightTopPoint.x - cornerRadius, y: rightTopPoint.y + cornerRadius), radius: cornerRadius,
                    startAngle: CGFloat(3 * Double.pi / 2), endAngle: CGFloat(2 * Double.pi), clockwise: true)

        path.addArc(withCenter: CGPoint(x: rightBottomPoint.x - cornerRadius, y: rightBottomPoint.y - cornerRadius), radius: cornerRadius,
                    startAngle: 0, endAngle: CGFloat(Double.pi / 2), clockwise: true)

        path.addLine(to: rightArrowPoint)
        path.addLine(to: centerArrowPoint)
        
        path.addArc(withCenter: CGPoint(x: leftBottomPoint.x + cornerRadius, y: leftBottomPoint.y - cornerRadius), radius: cornerRadius,
                    startAngle: CGFloat(Double.pi / 2), endAngle: CGFloat(Double.pi), clockwise: true)

        path.addArc(withCenter: CGPoint(x: leftTopPoint.x + cornerRadius, y: leftTopPoint.y + cornerRadius), radius: cornerRadius,
                    startAngle: CGFloat(Double.pi), endAngle: CGFloat(3 * Double.pi / 2), clockwise: true)

        path.close()
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.fillColor = MyColors.tableHeaderBgColor.cgColor
            // UIColor.darkGray.withAlphaComponent(0.10).cgColor
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = UIColor.magenta.withAlphaComponent(0.5).cgColor
            // UIColor.gray.cgColor
        shapeLayer.opacity = 1
        shapeLayer.lineWidth = 7

        let strokeStartAnimation = CABasicAnimation(keyPath: "strokeStart")
        strokeStartAnimation.fromValue = -0.1
        strokeStartAnimation.toValue = 1

        let strokeEndAnimation = CABasicAnimation(keyPath: "strokeEnd")
        strokeEndAnimation.fromValue = 0
        strokeEndAnimation.toValue = 1.0 + 0.1

        let animationGroup = CAAnimationGroup()
        animationGroup.duration = 1
        animationGroup.animations = [strokeStartAnimation, strokeEndAnimation]
        animationGroup.repeatCount = 1
        // set delegate to process with animationDidStop
        animationGroup.delegate = parentController
        
        shapeLayer.add(animationGroup, forKey: "groupAnimation")
        self.layer.addSublayer(shapeLayer)
    }

}
