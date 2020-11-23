//
//  MyNewsCell.swift
//  VkStyle
//
//  Created by aprirez on 8/30/20.
//  Copyright © 2020 Alla. All rights reserved.
//

import UIKit
import PromiseKit

class NewsCell: UITableViewCell
{
    
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var messageDate: UILabel!
    @IBOutlet weak var messageText: UILabel!
    @IBOutlet weak var messageImage: UIImageView!
    @IBOutlet weak var likeView: LikeUIView!
    
    @IBOutlet weak var imageHeight: NSLayoutConstraint!
    @IBOutlet weak var messageTextHeight: NSLayoutConstraint!

    @IBOutlet weak var showMoreButton: UIButton!
    @IBOutlet weak var showMoreButtonHeight: NSLayoutConstraint!

    let fiveLinesText = "\n\n\n\n\n"
    var maxMessageHeight: CGFloat?
    var onShowMoreClicked: ((NewsCell) -> Void)?

    @IBAction func showMoreAction(_ sender: Any) {
        onShowMoreClicked?(self)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setup(_ item: VkApiNewsItem,
               _ dataService: DataService,
               _ expanded: Bool,
               _ onShowMoreClicked: @escaping (NewsCell) -> Void ) {

        self.onShowMoreClicked = onShowMoreClicked
        
        dataService.getPromise(item.avatarPhoto ?? "")
            .get {
                [weak self] data in
                self?.avatarImage.image = UIImage(data: data)
            }
            .catch { error in
                debugPrint("Fail to download image: \(error)")
            }
        
        let first_name = item.firstName ?? ""
        let last_name = item.lastName ?? ""
        userName.text = "\(first_name) \(last_name)"
        
        let text = item.text ?? ""
        messageText.numberOfLines = 0
        messageText.text = text
        
        if self.maxMessageHeight == nil {
            self.maxMessageHeight = messageText.calculateHeight(forText: fiveLinesText)
        }
        let maxMessageHeight = self.maxMessageHeight ?? 0
        
        if text.isEmpty {
            messageText.isHidden = true
            messageTextHeight.constant = 0
            showMoreButton.isHidden = true
            showMoreButtonHeight.constant = 0
        } else {
            showMoreButton.setTitle(expanded ? "Show less..." : "Show more...", for: .normal)
            messageText.isHidden = false
            let requiredTextHeight = messageText.requiredHeight
            if requiredTextHeight > maxMessageHeight {
                messageText.isHidden = false
                messageTextHeight.constant =
                    expanded
                        ? requiredTextHeight
                        : maxMessageHeight
                showMoreButton.isHidden = false
                showMoreButtonHeight.constant = 30
            } else {
                messageTextHeight.constant = requiredTextHeight
                showMoreButton.isHidden = true
                showMoreButtonHeight.constant = 0
            }
        }
        
        if let vkPhoto = item.getPhoto(),
           let size = vkPhoto.getSize("x") {

            let aspectRatio = CGFloat(size.height) / CGFloat(size.width)
            messageImage.isHidden = false
            imageHeight.constant =
                min( self.messageImage.frame.width * aspectRatio, 400 )
            
            dataService.getPromise(vkPhoto.sizeXUrl)
                .get {
                    [weak self] data in
                    guard let self = self else {return}
                    self.messageImage.image = UIImage(data: data)
                }
                .catch { error in
                    debugPrint("Fail to download image: \(error)")
                }
        }
        else {
            messageImage.image = nil
            messageImage.isHidden = true
            imageHeight.constant = 0
        }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        messageDate.text = dateFormatter.string(
            from: Date(timeIntervalSince1970: TimeInterval(item.date))
        )
        // likeView.setObject(object: message)
    }

}
