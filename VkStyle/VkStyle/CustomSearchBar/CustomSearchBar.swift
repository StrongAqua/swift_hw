//
//  CustomSearchBar.swift
//  VkStyle
//
//  Created by aprirez on 9/12/20.
//  Copyright © 2020 Alla. All rights reserved.
//

import UIKit

class CustomSearchBar: UIView {

    @IBOutlet var rootView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchBarCover: UIImageView!
    let bgColor = UIColor.init(displayP3Red: 0.85, green: 0.78, blue: 0.85, alpha: 1)

    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeXib()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initializeXib()
    }
    
    private func initializeXib() {
        Bundle.main.loadNibNamed("CustomSearchBar", owner: self, options: nil)
        addSubview(rootView)
    }
    
    func setup(delegate: UISearchBarDelegate) {
        rootView.frame = frame
        searchBar.delegate = delegate
        searchBar.isHidden = true

        rootView.backgroundColor = bgColor
        searchBarCover.isHidden = false
        searchBarCover.backgroundColor = UIColor.white.withAlphaComponent(0)

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(CustomSearchBar.dismissCover))
        tap.cancelsTouchesInView = false
        searchBarCover.addGestureRecognizer(tap)
    }
    
    @objc func dismissCover() {
        self.searchBar.isHidden = false
        self.searchBar.alpha = 0
        UIView.animate(
            withDuration: 0.5,
            delay: 0.0,
            usingSpringWithDamping: 0.5,
            initialSpringVelocity: 0.5,
            options: .curveEaseOut,
            animations: { [weak self] in
                self?.searchBarCover.transform = CGAffineTransform(
                    translationX: 0 - ((self?.searchBar.frame.width ?? 0) * 0.45),
                    y: 0)
            },
            completion: { finished in
                if finished {
                    UIView.animate(
                        withDuration: 0.5,
                        animations: { [weak self] in
                            self?.searchBarCover.alpha = 0
                            self?.searchBar.alpha = 1
                        },
                        completion: { finished in
                            if finished {
                                self.searchBarCover.isHidden = true
                            }
                        })
                    }
                }
            )
        searchBar.searchTextField.becomeFirstResponder()
    }
    
    func cancel() {
        self.searchBarCover.isHidden = false
        UIView.animate(
            withDuration: 0.5,
            animations: { [weak self] in
                self?.searchBarCover.alpha = 1
                self?.searchBar.alpha = 0
            },
            completion: { finished in
                self.searchBar.isHidden = true
                if finished {
                    UIView.animate(
                        withDuration: 0.5,
                        animations: { [weak self] in
                            self?.searchBarCover.transform = CGAffineTransform(translationX: 0, y: 0)
                        },
                        completion: { finished in
                            self.searchBarCover.isHidden = false
                        }
                    )
                }
            })
    }
}
