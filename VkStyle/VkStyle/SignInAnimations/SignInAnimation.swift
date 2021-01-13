//
//  SignInAnimation.swift
//  VkStyle
//
//  Created by aprirez on 9/2/20.
//  Copyright © 2020 Alla. All rights reserved.
//

import UIKit

class SignInAnimation: UIView {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var rootView: UIView!
    
    var onFinishCallback: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeXib()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initializeXib()
    }
    
    private func initializeXib() {
        Bundle.main.loadNibNamed("SignInAnimation", owner: self, options: nil)
        rootView.backgroundColor = MyColors.transparent
        contentView.backgroundColor = MyColors.transparent
        addSubview(rootView)
    }

    // WTF is @escaping ???
    // Variant 1:
    func showAnimatingDotsInImageView(_ doOnFinish: @escaping () -> Void) {
    // Variant 2:
    // func showAnimatingDotsInImageView(_ delegate: CAAnimationDelegate) {

        // Variant 1:
        onFinishCallback = doOnFinish
                
        let lay = CAReplicatorLayer()
        lay.frame = CGRect(x: 0, y: 0, width: 100, height: 50) //yPos == 12
        
        let circle = CALayer()
        circle.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        circle.cornerRadius = circle.frame.width / 2
        circle.backgroundColor = UIColor(red: 110/255.0, green: 110/255.0, blue: 110/255.0, alpha: 1).cgColor//lightGray.cgColor //UIColor.black.cgColor
        
        lay.addSublayer(circle)
        lay.instanceCount = 3
        lay.instanceTransform = CATransform3DMakeTranslation(33, 0, 0)
        
        let anim = CABasicAnimation(keyPath: #keyPath(CALayer.opacity))
        anim.fromValue = 1.0
        anim.toValue = 0.2
        anim.duration = 0.5
        anim.repeatCount = 1
        // Variant 1:
        anim.delegate = self
        // Variant 2: anim.delegate = delegate

        circle.add(anim, forKey: nil)
        
        lay.instanceDelay = anim.duration / Double(lay.instanceCount)
        
        contentView.layer.addSublayer(lay)
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

// Variant 1:
extension SignInAnimation: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        onFinishCallback?()
    }
}
