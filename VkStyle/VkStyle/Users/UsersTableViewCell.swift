//
//  UsersTableViewCell.swift
//  Weather2
//
//  Created by aprirez on 8/5/20.
//  Copyright © 2020 Alla. All rights reserved.
//

import UIKit

class UsersTableViewCell: UITableViewCell {

    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var avatarView: AvatarCompositeView!
        
    var userIndex: Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setup(user: UsersInfo) {
        avatarView.avatarPhoto.image = user.photo
        userName.text = user.user
        avatarView.setup()
    }
}
