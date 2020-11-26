//
//  PhotosCollectionViewController.swift
//  Weather2
//
//  Created by aprirez on 8/5/20.
//  Copyright © 2020 Alla. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class PhotoAlbum {
    
    var id = 0
    var photoIds: Set<Int> = []
    var photos: [VkApiPhotoItem] = []
    
    init(_ id: Int) {
        self.id = id
    }
    
    func push(_ photo: VkApiPhotoItem) {
        guard photoIds.contains(photo.id) == false else {return}
        photoIds.insert(photo.id)
        photos.append(photo)
    }
}

class PhotosCollectionViewController: ASDKViewController<ASDisplayNode>, ASCollectionDelegate, ASCollectionDataSource {
    
    var user: UserInfo?
    var albums: [PhotoAlbum] = []
    
    var dataService = DataService()
    let vkPhotos = VKApiUserPhotos()

    let collectionNode: ASCollectionNode
    
    override init() {
        let screenSize: CGRect = UIScreen.main.bounds
        let effectiveWidth = screenSize.width - 20
        let flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: 4, left: 4, bottom: 40, right: 4)
        flowLayout.itemSize = CGSize(width: effectiveWidth / 2, height: effectiveWidth / 2)

        collectionNode = ASCollectionNode(frame: CGRect.zero, collectionViewLayout: flowLayout)
        
        super.init(node: collectionNode)
        
        collectionNode.delegate = self
        collectionNode.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func pushPhoto(_ photo: VkApiPhotoItem) {
        for album in albums {
            if album.id == photo.albumId {
                album.push(photo)
                return
            }
        }
        let album = PhotoAlbum(photo.albumId)
        album.push(photo)
        albums.append(album)
    }
    
    func processPhotos(_ photos: [VkApiPhotoItem]) {
        for photo in photos {
            pushPhoto(photo)
        }
        collectionNode.reloadData()
    }

    func reloadData() {
        guard let user = self.user else { return }
        vkPhotos.get(
            args: ["owner_id": user.id, "album_id": "profile"],
            completion: {[weak self] photos, source in
                if (source == .cached) {
                    guard let photoItems = photos as? [VkApiPhotoItem] else { return }
                    self?.processPhotos(photoItems)
                }
                // TODO: fix refresh-control
                // self?.refreshCtrl.endRefreshing()
            })
        vkPhotos.get(
            args: ["owner_id": user.id, "album_id": "wall"],
            completion: {[weak self] photos, source in
                if (source == .cached) {
                    guard let photoItems = photos as? [VkApiPhotoItem] else { return }
                    if photoItems.count <= 0 { return }
                    self?.processPhotos(photoItems)
                }
                // TODO: fix refresh-control
                // self?.refreshCtrl.endRefreshing()
            })
    }
    
    public func setUser(user: UserInfo) {
        self.user = user
        reloadData()
    }
    
    // MARK: UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return albums.count
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, numberOfItemsInSection section: Int) -> Int {
        return albums[section].photoIds.count
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, nodeBlockForItemAt indexPath: IndexPath)
        -> ASCellNodeBlock
    {
        guard albums.count > indexPath.section else {return {ASCellNode()}}
        guard albums[indexPath.section].photoIds.count > indexPath.row else {return {ASCellNode()}}
        
        let cellNodeBlock = { [weak self] () -> ASCellNode in
            guard let self = self else {return ASCellNode()}
            let photos = self.albums[indexPath.section].photos

            let cellNode = PhotosCollectionViewCell(
                photo: photos[indexPath.row]
            )
            return cellNode
        }
          
        return cellNodeBlock
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, didSelectItemAt indexPath: IndexPath) {
        guard albums.count > indexPath.section else {return}
        guard albums[indexPath.section].photoIds.count > indexPath.row else {return}

        let photos = self.albums[indexPath.section].photos

        let bigPhotoController = BigPhotoUIViewController()
        
        bigPhotoController.photoList = photos
        bigPhotoController.indexPhoto = indexPath.row
        bigPhotoController.navigationItem.title = "\(navigationItem.title ?? "User")\("'s photos")"
        
        navigationController?.pushViewController(bigPhotoController, animated: true)
    }

    // TODO: fix data prefetch

}

