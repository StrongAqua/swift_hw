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
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setup(title: String?, imageURL: String?) {
        self.myGroupName.text = title ?? "(unset)"
        guard let url = imageURL else { return }
        VKApi.instance.downloadImage(urlString: url, completion: {
            [weak self] data in
            guard let d = data else { return }
            self?.myGroupImage.image = UIImage(data: d)
        })
    }

}
