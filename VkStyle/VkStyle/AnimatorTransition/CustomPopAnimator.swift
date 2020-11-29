//
//  CustomPopAnimator.swift
//  VkStyle
//
//  Created by aprirez on 9/9/20.
//  Copyright © 2020 Alla. All rights reserved.
//

import UIKit

class CustomPopAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
        
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let source = transitionContext.viewController(forKey: .from) else { return }
        guard let destination = transitionContext.viewController(forKey: .to) else { return }
        
        transitionContext.containerView.addSubview(destination.view)

        // let destination view has the same frame as our source first
        destination.view.frame = source.view.frame
        // set rotation anchor for our destination view (right-top corner: x=1/y=0)
        destination.view.setAnchorPoint(anchorPoint: CGPoint(x: 0, y: 0))
        // rotate it 90 degrees counterclockwise before animation
        destination.view.transform = CGAffineTransform(rotationAngle: 90.toRadians)
        destination.view.alpha = 0.1

        // set rotation anchor for our source view (left-top corner: x=0/y=0)
        source.view.setAnchorPoint(anchorPoint: CGPoint(x: 0, y: 0))
        
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext),
                       animations: {
                        // rotationAngle - is not a 'delta', it is the absolute final value
                        // rotationAngle = 90 here - declares that our view should be rotated
                        //                 to (not by) the 90 degrees when the animation finished
                        source.view.transform = CGAffineTransform(rotationAngle: -90.toRadians)
                        source.view.alpha = 0.1
        })
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext),
                       animations: {
                        // the same thoughts here: our destination view should have angle = 0
                        // when animation finished
                        destination.view.transform = CGAffineTransform(rotationAngle: 0)
                        destination.view.alpha = 1
        }) { finished in
            if finished { // && !transitionContext.transitionWasCancelled
                source.view.transform = .identity // 'zero' transformation
                source.view.alpha = 1
                source.view.setAnchorPoint(anchorPoint: CGPoint(x: 0.5, y: 0.5))

                destination.view.transform = .identity
                destination.view.alpha = 1
                destination.view.setAnchorPoint(anchorPoint: CGPoint(x: 0.5, y: 0.5))
                
                source.view.layoutIfNeeded()
                destination.view.layoutIfNeeded()
            }
            transitionContext.completeTransition(finished && !transitionContext.transitionWasCancelled)
        }
    }
    
    
}
