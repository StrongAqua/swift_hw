//
//  LoadingViewController.swift
//  VkStyle
//
//  Created by aprirez on 9/5/20.
//  Copyright © 2020 Alla. All rights reserved.
//

import UIKit
import Alamofire

class LoadingViewController: UIViewController {

    @IBOutlet weak var loadingView: LoadingView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set reference to the parent view controller to perform segue on animationDidStop
        loadingView.setup(self)
    }
}

// extend self with CAAnimationDelegate to process with animationDidStop
extension LoadingViewController : CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        // perform segue to the major UIViewController
        self.performSegue(withIdentifier: "DidLoad", sender: self)
    }
}
