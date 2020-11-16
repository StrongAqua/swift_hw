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
        
    var indexPath: IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setup(user: UserInfo, dataService: DataService) {
        dataService.data(byUrl: user.photo, completion: {
            [weak self] data in
            guard let d = data else { return }
            self?.avatarView.avatarPhoto.image = UIImage(data: d)
        })
        
        userName.text = user.user
        avatarView.setup()
    }
}
