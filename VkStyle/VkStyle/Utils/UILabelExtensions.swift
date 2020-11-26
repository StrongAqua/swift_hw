//
//  UILabelExtensions.swift
//  VkStyle
//
//  Created by aprirez on 11/23/20.
//  Copyright © 2020 Alla. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {

    var requiredHeight: CGFloat {

        guard let labelText = text else {
            return 0
        }
        return calculateHeight(forText: labelText)
    }
    
    func calculateHeight(forText: String) -> CGFloat {
        let labelTextSize = (forText as NSString).boundingRect(
            with: CGSize(width: frame.size.width, height: .greatestFiniteMagnitude),
            options: .usesLineFragmentOrigin,
            attributes: [.font: font as Any],
            context: nil).size

        return labelTextSize.height
    }
}
