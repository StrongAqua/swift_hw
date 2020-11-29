//
//  BigPhotoUIViewController.swift
//  VkStyle
//
//  Created by aprirez on 8/27/20.
//  Copyright © 2020 Alla. All rights reserved.
//

import UIKit

class BigPhotoUIViewController: UIViewController {
    
    let photoImageCurrent = UIImageView()
    let likeView = LikeUIView()
    let dataService = DataService()
    
    var indexPhoto: Int?
    var photoList: [VkApiPhotoItem] = []
    var interactiveAnimator: UIViewPropertyAnimator?
    
    // do we swipe to the right?
    var isRightDirection: Bool?
    var forceYTranslation: Bool = false
    
    // keep the initial image view frame here
    var imageInitialFrame: CGRect = CGRect.zero
    var initialViewFrame: CGRect = CGRect.zero
    
    // keep initial transform of the image view frame here
    var imageInitialTransform: CGAffineTransform = .identity
    
    var viewTranslation = CGPoint(x: 0, y: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createUI()
        
        // Do any additional setup after loading the view.
        guard let index = indexPhoto else {return}
        let count = photoList.count
        
        if count == 0 {return}
        if count <= index {return}

        let photo = photoList[index]
        let url = photo.sizeXUrl
        
        dataService.get(byUrl: url, completion: {
            [weak self] data in
            guard let d = data else { return }
            self?.photoImageCurrent.image = UIImage(data: d)
        })
        
        // TODO: fix likes
        // likeView.setObject(object: photo)
        
        // set up a brand new gesture recognizer
        let recognizer = UIPanGestureRecognizer(target: self, action: #selector(onPan(_:)))
        self.view.addGestureRecognizer(recognizer)
        
    }
    
    override func viewDidLayoutSubviews() {
        
        let usefulFrame = CGRect(
            x: 0,
            y: topBarHeight,
            width: view.frame.width,
            height: view.frame.height -
                topBarHeight -
                self.navigationController!.navigationBar.frame.height
        )
        
        likeView.setupFrames(usefulFrame)
    }
    
    func createUI() {
        
        view.addSubview(photoImageCurrent)
        
        photoImageCurrent.translatesAutoresizingMaskIntoConstraints = false
        photoImageCurrent.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        photoImageCurrent.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        photoImageCurrent.contentMode = .scaleAspectFit
        photoImageCurrent.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        likeView.setupSubViews()
        view.addSubview(likeView)
    }
    
    // this function detects if we changed swipe direction
    func isDirectionChanged(_ dx: CGFloat) -> Bool {
        
        // if we have no any direction yet, let's just detect it
        if (self.isRightDirection == nil) {
            // do we swipe to right?
            self.isRightDirection = ( dx > 0 )
            // return true as in the case if we changed direction
            return true
        }
        
        // do we sweep to right now?
        let isRightDirection = ( dx > 0 )
        
        // is previous swipe direction not equal to current?
        if isRightDirection != self.isRightDirection {
            self.isRightDirection = isRightDirection
            // return true only if we changed direction
            return true
        }
        // direction was not changed
        return false
    }
    
    func createInteractiveAnimationForView_FadeOut(view: UIView, isRightDirection: Bool) -> UIViewPropertyAnimator {
        return UIViewPropertyAnimator(
            duration: 0.5,
            curve: .easeIn,
            // final state of the image should be described inside 'animations' block
            animations: {
                view.alpha = 0
                view.frame =
                    view.frame.offsetBy(
                        // set final x-coordinate depending on where we go:
                        //   left to right or right to left
                        dx:
                        ( isRightDirection )
                            ? 0 + view.frame.width
                            : 0 - view.frame.width,
                        dy: 0)
                // also add the scaling transformation
                view.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        })
    }
    
    func processPhotoCarousel(_ translation: CGPoint) {
        
        if isDirectionChanged(translation.x) {
            
            // if we have already started swipe animation
            if (interactiveAnimator != nil) {
                // stop previous animation
                interactiveAnimator?.stopAnimation(true)
                // restore image frame and transform
                photoImageCurrent.frame = imageInitialFrame
                photoImageCurrent.transform = imageInitialTransform
            }
            
            // create swipe animation
            interactiveAnimator =
                createInteractiveAnimationForView_FadeOut(
                    view: photoImageCurrent,
                    isRightDirection: ( translation.x > 0 )
            )
            // pause it
            interactiveAnimator?.pauseAnimation()
            
            // when swipe animation completed, let's start next image appearance
            interactiveAnimator?.addCompletion({ (_) in
                guard var index = self.indexPhoto else {return}
                let count = self.photoList.count
                
                // unwrap optional value
                let isRightDirection = self.isRightDirection ?? true
                
                // select next photo from photoList depending on direction
                if (isRightDirection == true) {
                    // should add '+ count' here because % does not work on negative numbers
                    index = ((index - 1) + count) % count
                } else {
                    index = (index + 1) % count
                }

                // TODO: fix likes
                // set up next photo image to our image view
                // self.likeView.setObject(object: self.photoList[index])
                
                let url = self.photoList[index].sizeXUrl
                self.dataService.get(byUrl: url, completion: {
                    [weak self] data in
                    guard let d = data else { return }
                    self?.photoImageCurrent.image = UIImage(data: d)
                })
                
                // update current photo index
                self.indexPhoto = index
                
                // set initial image view alpha and frame
                self.photoImageCurrent.alpha = 0
                self.photoImageCurrent.frame =
                    self.imageInitialFrame.offsetBy(
                        // if isRightDirection is nil let's use default 'true'
                        // ... but it can't be nil here
                        dx: (self.isRightDirection ?? true)
                            //
                            ? 0 - self.photoImageCurrent.frame.width
                            : 0 + self.photoImageCurrent.frame.width,
                        dy: 0)
                // let's fade-in our image and move it to imageInitialFrame
                UIViewPropertyAnimator.runningPropertyAnimator(
                    withDuration: 0.5,
                    delay: 0,
                    options: [],
                    animations: {
                        self.photoImageCurrent.alpha = 1
                        self.photoImageCurrent.frame = self.imageInitialFrame
                        self.photoImageCurrent.transform = self.imageInitialTransform
                        self.isRightDirection = nil
                })
            })
        }
        
        // fractionComplete is like the 'time' of the animation measured from 0 (just started) to 1 (completed).
        // To get where we are in the 'time' let's divide delta X (translation.x) to out image width.
        // So our animation is completed when we have delta X more than image width.
        interactiveAnimator?.fractionComplete =
            // should use absolute value here
            abs(translation.x) / self.photoImageCurrent.frame.width
        
    }
    
    func is_y_translation(_ translation: CGPoint) -> Bool {
        return abs(translation.y) > abs(translation.x)
    }
    
    // callback for pan gesture
    @objc func onPan(_ recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
            
        case .began:
            // save initial image frame and transform
            if (self.initialViewFrame.isEmpty) {
                self.initialViewFrame = self.view.frame
            }
            self.imageInitialFrame = photoImageCurrent.frame
            self.imageInitialTransform = photoImageCurrent.transform
            
        case .changed:
            let translation = recognizer.translation(in: self.view)
            
            if forceYTranslation || is_y_translation(translation) {
                forceYTranslation = true
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    self.view.transform = CGAffineTransform(translationX: 0, y: translation.y)
                })
            } else {
                // if gesture changed its X direction
                processPhotoCarousel(translation)
            } // end of else block
            break
            
        case .ended:
            // end the swipe
            let translation = recognizer.translation(in: self.view)
            if forceYTranslation || is_y_translation(translation) {
                if translation.y < 200 {
                    interactiveAnimator?.fractionComplete = 0
                    interactiveAnimator?.stopAnimation(false)
                    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                        self.view.transform = .identity
                        self.view.alpha = 1
                        self.view.frame = self.initialViewFrame
                    })
                } else {
                    // dismiss(animated: true, completion: nil)
                    self.navigationController?.popViewController(animated: false)
                }
                forceYTranslation = false
            } else {
                interactiveAnimator?.continueAnimation(withTimingParameters: nil, durationFactor: 0)
            }
            break
            
        default: return
        }
    }
}

extension UIViewController {
    
    var topBarHeight: CGFloat {
        return (view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0.0) +
            (self.navigationController?.navigationBar.frame.height ?? 0.0)
    }
}

