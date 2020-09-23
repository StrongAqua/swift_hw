//
//  PhotosCollectionViewController.swift
//  Weather2
//
//  Created by aprirez on 8/5/20.
//  Copyright © 2020 Alla. All rights reserved.
//

import UIKit


class PhotosCollectionViewController: UICollectionViewController {
    
    var photoList: [Photo?]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        // Register cell classes
        // Do any additional setup after loading the view.
    }
    
    public func setUserPhotoList(photoList: Array<Photo?>?) {
        self.photoList = photoList
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.collectionView.reloadData()
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        guard let bigPhotoController
            = segue.destination as? BigPhotoUIViewController else { return }
        guard let cell = sender as? PhotosCollectionViewCell else { return }
        bigPhotoController.photoList = photoList
        bigPhotoController.indexPhoto = cell.indexPhoto
    }
    
    // MARK: UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return photoList?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) ->
        UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoUser", for: indexPath) as! PhotosCollectionViewCell
            
            guard let photoList = photoList else { return cell }
            // Configure the cell
            cell.setPhoto(photo: photoList[indexPath.row], indexPhoto: indexPath.row)
            return cell
    }
    
    // MARK: UICollectionViewDelegate
    /*
     // Uncomment this method to specify if the specified item should be highlighted during tracking
     override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        // sort visible cells by row
        let cells = collectionView.visibleCells.sorted(by: {
            return collectionView.indexPath(for: $0)!.row <
                collectionView.indexPath(for: $1)!.row })
        
        // get index path for the first visible cell
        let firstVisibleIndexPath = (cells.first == nil)
            ? indexPath
            : collectionView.indexPath(for: cells.first!)
        
        // we should have only one section, otherwise this code will not work
        // calculate 'visibility index' of the first visible cell based from 0
        let index = indexPath.row - (firstVisibleIndexPath?.row ?? 0)
        
        // move-in the cell from the left side of the table
        let tableWidth: CGFloat = collectionView.bounds.size.width
        cell.transform = CGAffineTransform(translationX: -tableWidth, y: 0)
        UIView.animate(
            withDuration: 1,
            delay: 0.1 * Double(index), // calculate animation delay based in 'visibility index'
            usingSpringWithDamping: 1.2,
            initialSpringVelocity: 0,
            options: .transitionFlipFromTop,
            animations: {
                cell.transform = CGAffineTransform(translationX: 0, y: 0);
            },
            completion: nil)
        
        // fade-in the cell
        let opacity = CABasicAnimation(keyPath: "opacity")
        opacity.beginTime = CACurrentMediaTime() + 0.1 * Double(index)
        opacity.duration = 2
        opacity.fromValue = 0
        opacity.toValue = 1
        opacity.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        opacity.autoreverses = false
        opacity.repeatCount = 1
        
        cell.layer.add(opacity, forKey: "opacity")
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.5) {
            if let cell = collectionView.cellForItem(at: indexPath) as? PhotosCollectionViewCell {
                cell.transform = .init(scaleX: 1.4, y: 1.4)
                cell.contentView.backgroundColor = UIColor(red: 0.7, green: 0.7, blue: 0.7, alpha: 0.3)
            }
        }
    }

    override func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.5) {
            if let cell = collectionView.cellForItem(at: indexPath) as? PhotosCollectionViewCell {
                cell.transform = .identity
                cell.contentView.backgroundColor = .clear
            }
        }
    }
}
