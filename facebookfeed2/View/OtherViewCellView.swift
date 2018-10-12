//
//  OtherView.swift
//  facebookfeed2
//
//  Created by iakay on 27.02.2018.
//  Copyright © 2018 challenge. All rights reserved.
//

import UIKit

class OtherViewCell: UITableViewCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc init(frame: CGRect, cellRow : Int) {
        super.init(style: UITableViewCellStyle.default, reuseIdentifier: OtherController.cellId)
        let contentGuide = self.readableContentGuide
        let screenSize = UIScreen.main.bounds
        if cellRow == 0 {
            settings.text = "Settings & Privacy"
            settings.font = UIFont.preferredFont(forTextStyle: .headline)
            addSubview(settings)
            settings.translatesAutoresizingMaskIntoConstraints = false
            settings.heightAnchor.constraint(equalToConstant: screenSize.width * 1 / 10).isActive = true
            settings.centerXAnchor.constraint(equalTo: contentGuide.centerXAnchor).isActive = true
        } else if cellRow == 1 {
            support.text = "Terms of Use"
            support.font = UIFont.preferredFont(forTextStyle: .headline)
            addSubview(support)
            support.translatesAutoresizingMaskIntoConstraints = false
            support.heightAnchor.constraint(equalToConstant: screenSize.width * 1 / 10).isActive = true
            support.centerXAnchor.constraint(equalTo: contentGuide.centerXAnchor).isActive = true
        } else if cellRow == 2 {
            shareViaFriend.text = "Share With Friends"
            shareViaFriend.font = UIFont.preferredFont(forTextStyle: .headline)
            addSubview(shareViaFriend)
            shareViaFriend.translatesAutoresizingMaskIntoConstraints = false
            shareViaFriend.heightAnchor.constraint(equalToConstant: screenSize.width * 1 / 10).isActive = true
            shareViaFriend.centerXAnchor.constraint(equalTo: contentGuide.centerXAnchor).isActive = true
        } else if cellRow == 3 {
        } else if cellRow == 4 {
            logout.text = "Log out"
            logout.font = UIFont.preferredFont(forTextStyle: .headline)
            logout.textColor = UIColor.red
            addSubview(logout)
            logout.translatesAutoresizingMaskIntoConstraints = false
            logout.heightAnchor.constraint(equalToConstant: screenSize.width * 1 / 10).isActive = true
            logout.centerXAnchor.constraint(equalTo: contentGuide.centerXAnchor).isActive = true
        }
    }
    
    @objc let logout: UILabel = FeedCell.labelCreateDef(1)
    @objc let settings: UILabel = FeedCell.labelCreateDef(1)
    @objc let support: UILabel = FeedCell.labelCreateDef(1)
    @objc let shareViaFriend: UILabel = FeedCell.labelCreateDef(1)
    
    @objc static func button(_ title: String, titleColor: UIColor) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: UIControlState())
        button.setTitleColor(titleColor, for: UIControlState())
        button.backgroundColor = UIColor.white
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.titleLabel?.textAlignment = .right
        button.layer.cornerRadius = 2
        return button
    }
}
