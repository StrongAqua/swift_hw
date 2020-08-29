//
//  BigPhotoUIViewController.swift
//  VkStyle
//
//  Created by aprirez on 8/27/20.
//  Copyright © 2020 Alla. All rights reserved.
//

import UIKit

class BigPhotoUIViewController: UIViewController {

    @IBOutlet weak var photoImage: UIImageView!
    @IBOutlet weak var likeView: LikeUIView!

    var photo: Photo?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        photoImage.image = photo?.photo
        likeView.setObject(object: photo)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
