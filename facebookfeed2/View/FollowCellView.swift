//
//  OtherView.swift
//  facebookfeed2
//
//  Created by iakay on 19.05.2018.
//  Copyright © 2018 challenge. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class FollowCellView: UITableViewCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(frame: CGRect) {
        super.init(style: UITableViewCellStyle.default, reuseIdentifier: OtherController.cellId)
        let contentGuide = self.readableContentGuide
        let screenSize = UIScreen.main.bounds
        
        addSubview(profileImageView)    
        profileImageView.layer.cornerRadius = screenWidth * 0.9 / 10 / 2
        addLeadingAnchor(profileImageView, anchor: contentGuide.leadingAnchor, constant: screenSize.width * 0.1/10)
        addWidthAnchor(profileImageView, multiplier: 0.9/10)
        addHeightAnchor(profileImageView, multiplier: 0.9/10)
        profileImageView.centerYAnchor.constraint(equalTo: contentGuide.centerYAnchor).isActive = true
        
        addSubview(thinksAboutChallengeView)
        addLeadingAnchor(thinksAboutChallengeView, anchor: profileImageView.trailingAnchor, constant: screenSize.width * 0.15/10)
        addTrailingAnchor(thinksAboutChallengeView, anchor: contentGuide.trailingAnchor, constant: 4)
        thinksAboutChallengeView.centerYAnchor.constraint(equalTo: contentGuide.centerYAnchor).isActive = true
        thinksAboutChallengeView.textAlignment = NSTextAlignment.left
        thinksAboutChallengeView.textColor = UIColor.black
        
        addSubview(followButton)
        addTrailingAnchor(followButton, anchor: contentGuide.trailingAnchor, constant: 4)
        addWidthAnchor(followButton, multiplier: 2/10)
        followButton.centerYAnchor.constraint(equalTo: contentGuide.centerYAnchor).isActive = true
        followButton.alpha = 0
    }

    
    let profileImageView: UIImageView = FeedCell().profileImageView
    let thinksAboutChallengeView: UILabel = FeedCell.label(12)
    
    let followButton: subclasssedUIButton = {
        let button = subclasssedUIButton()
        button.setTitle(followButtonText, for: UIControlState())
        button.setTitleColor(UIColor.white, for: UIControlState())
        button.backgroundColor = UIColor.rgb(87, green: 143, blue: 255)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 10)
        button.layer.cornerRadius = 2
        return button
    }()
}
