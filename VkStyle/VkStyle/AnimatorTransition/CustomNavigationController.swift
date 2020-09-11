//
//  CustomNavigationController.swift
//  VkStyle
//
//  Created by aprirez on 9/9/20.
//  Copyright © 2020 Alla. All rights reserved.
//

import UIKit


class CustomNavigationController: UINavigationController, UINavigationControllerDelegate {
    
    let interactiveTransition = CustomInteractiveTransition()

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }
    
    func navigationController(_ navigationController: UINavigationController,
                              animationControllerFor operation: UINavigationController.Operation,
                              from fromVC: UIViewController,
                              to toVC: UIViewController)
        -> UIViewControllerAnimatedTransitioning? {
            if operation == .push {
                self.interactiveTransition.viewController = toVC
                return CustomPushAnimator()
            } else if operation == .pop {
                if navigationController.viewControllers.first != toVC {
                    self.interactiveTransition.viewController = fromVC
                }
                return CustomPopAnimator()
            }
            return nil
    }
    
    /*func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
     if operation == .push {
     return CustomPushAnimator()
     } else if operation == .pop {
     return CustomPopAnimator()
     }
     return nil
     }
     */
        
    func navigationController(_ navigationController: UINavigationController,
                              interactionControllerFor animationController: UIViewControllerAnimatedTransitioning)
        -> UIViewControllerInteractiveTransitioning? {
            return interactiveTransition.hasStarted ? interactiveTransition : nil
    }
}



/*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 // Get the new view controller using segue.destination.
 // Pass the selected object to the new view controller.
 }
 */

