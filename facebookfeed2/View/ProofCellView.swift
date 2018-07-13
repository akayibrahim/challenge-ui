//
//  OtherView.swift
//  facebookfeed2
//
//  Created by iakay on 27.02.2018.
//  Copyright © 2018 challenge. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class ProofCellView: UITableViewCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        let contentGuide = self.readableContentGuide
        let screenSize = UIScreen.main.bounds
        
        addSubview(profileImageView)    
        profileImageView.layer.cornerRadius = screenWidth * 0.7 / 10 / 2
        addTopAnchor(profileImageView, anchor: contentGuide.topAnchor, constant: 0)
        addLeadingAnchor(profileImageView, anchor: contentGuide.leadingAnchor, constant: 0)
        addWidthAnchor(profileImageView, multiplier: 0.7 / 10)
        addHeightAnchor(profileImageView, multiplier: 0.7 / 10)
        
        addSubview(thinksAboutChallengeView)
        addLeadingAnchor(thinksAboutChallengeView, anchor: profileImageView.trailingAnchor, constant: screenSize.width * 0.15/10)
        addTrailingAnchor(thinksAboutChallengeView, anchor: contentGuide.trailingAnchor, constant: 4)
        thinksAboutChallengeView.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor).isActive = true
        
        addSubview(proofImageView)
        addTopAnchor(proofImageView, anchor: profileImageView.bottomAnchor, constant: screenWidth * 0.05 / 2)
        addWidthAnchor(proofImageView, multiplier: 1)
        addHeightAnchor(proofImageView, multiplier: 1 / 2)
        setImage(name: unknown, imageView: proofImageView)
    }

    
    let profileImageView: UIImageView = FeedCell().profileImageView
    let thinksAboutChallengeView: UITextView = FeedCell().thinksAboutChallengeView
    
    let proofImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = UIColor.blue
        imageView.layer.masksToBounds = true
        return imageView
    }()
}
