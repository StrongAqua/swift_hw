//
//  AllGroupsTableViewCell.swift
//  Weather2
//
//  Created by aprirez on 8/5/20.
//  Copyright © 2020 Alla. All rights reserved.
//

import UIKit

class AllGroupsTableViewCell: UITableViewCell {

    @IBOutlet weak var groupName: UILabel!
    
    @IBOutlet weak var groupImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup(title: String?, imageURL: String?, dataService: DataService) {
        self.groupName.text = title ?? "(unset)"
        guard let url = imageURL else { return }
        dataService.get(byUrl: url, completion: {
            [weak self] data in
            guard let d = data else { return }
            self?.groupImage.image = UIImage(data: d)
        })
    }
}
