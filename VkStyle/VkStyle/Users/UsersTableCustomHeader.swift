//
//  UsersTableCustomHeader.swift
//  VkStyle
//
//  Created by aprirez on 8/29/20.
//  Copyright © 2020 Alla. All rights reserved.
//

import UIKit

class UsersTableCustomHeader: UITableViewHeaderFooterView {

    let bgView = UIView()
    let title = UILabel()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configureContents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureContents() {
        title.translatesAutoresizingMaskIntoConstraints = false
        bgView.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(bgView)

        bgView.leftAnchor.constraint(equalTo: leftAnchor, constant: 0).isActive = true
        bgView.rightAnchor.constraint(equalTo: rightAnchor, constant: 0).isActive = true
        bgView.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        bgView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true

        bgView.addSubview(title)

        title.font = UIFont.boldSystemFont(ofSize: title.font.pointSize)
        title.leftAnchor.constraint(equalTo: leftAnchor, constant: 15).isActive = true
        title.rightAnchor.constraint(equalTo: rightAnchor, constant: -15).isActive = true
        title.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        title.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
    }

    func setup(_ letter: String) {
        bgView.backgroundColor = MyColors.tableHeaderBgColor
        title.text = letter
    }

}
