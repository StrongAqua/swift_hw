//
//  MyGroupsTableViewCell.swift
//  Weather2
//
//  Created by aprirez on 8/5/20.
//  Copyright © 2020 Alla. All rights reserved.
//

import UIKit

class MyGroupsTableViewCell: UITableViewCell {


    @IBOutlet weak var myGroupName: UILabel!
    
    @IBOutlet weak var myGroupImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
