//
//  OtherView.swift
//  facebookfeed2
//
//  Created by iakay on 27.02.2018.
//  Copyright © 2018 challenge. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class CommentCellView: UITableViewCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setups()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func setups() {        
        let contentGuide = self.readableContentGuide
        let screenSize = UIScreen.main.bounds
        backgroundColor = feedBackColor
        
        addSubview(profileImageView)    
        profileImageView.layer.cornerRadius = screenWidth * 0.9 / 10 / 2
        addLeadingAnchor(profileImageView, anchor: contentGuide.leadingAnchor, constant: screenSize.width * 0.1/10)
        addWidthAnchor(profileImageView, multiplier: 0.9/10)
        addHeightAnchor(profileImageView, multiplier: 0.9/10)
        profileImageView.centerYAnchor.constraint(equalTo: contentGuide.centerYAnchor).isActive = true
        
        thinksAboutChallengeView.backgroundColor = UIColor(white: 1, alpha: 0)
        addSubview(thinksAboutChallengeView)
        addLeadingAnchor(thinksAboutChallengeView, anchor: profileImageView.trailingAnchor, constant: screenSize.width * 0.15/10)
        addTrailingAnchor(thinksAboutChallengeView, anchor: contentGuide.trailingAnchor, constant: 4)
        thinksAboutChallengeView.centerYAnchor.constraint(equalTo: contentGuide.centerYAnchor).isActive = true
    }

    
    @objc let profileImageView: UIImageView = FeedCell().profileImageView
    @objc let thinksAboutChallengeView: UITextView = FeedCell().thinksAboutChallengeView
}
