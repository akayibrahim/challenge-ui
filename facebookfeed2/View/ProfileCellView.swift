//
//  ChallengeFeedCellView.swift
//  facebookfeed2
//
//  Created by iakay on 26.02.2018.
//  Copyright © 2018 challenge. All rights reserved.
//

import UIKit

class ProfileCellView: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let screenSize = UIScreen.main.bounds
    func setupViews() {
        backgroundColor = UIColor.white
        let contentGuide = self.readableContentGuide
        generateProfile(contentGuide)
    }
    
    func generateProfile(_ contentGuide: UILayoutGuide) {
        addSubview(profileImageView)
        addTopAnchor(profileImageView, anchor: contentGuide.topAnchor, constant: 0)
        addLeadingAnchor(profileImageView, anchor: contentGuide.leadingAnchor, constant: 0)
        addWidthAnchor(profileImageView, multiplier: 1.7/10)
        addHeightAnchor(profileImageView, multiplier: 2/10)                
        setImage(fbID: memberID, imageView: profileImageView)
        profileImageView.layer.cornerRadius = 4.0
        profileImageView.layer.masksToBounds = true
        profileImageView.contentMode = .scaleAspectFill
        
        addSubview(nameLabel)
        let attributedText = NSMutableAttributedString(string: "\(memberName)", attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 18)])
        nameLabel.attributedText = attributedText
        addTopAnchor(nameLabel, anchor: profileImageView.topAnchor, constant: screenSize.width * 0.2 / 10)
        addLeadingAnchor(nameLabel, anchor: profileImageView.trailingAnchor, constant: screenSize.width * 0.5 / 10)
        nameLabel.text = memberName
        
        addSubview(other)
        other.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor).isActive = true
        addTrailingAnchor(other, anchor: contentGuide.trailingAnchor, constant: -(screenSize.width * 0.05 / 10))
        addHeightAnchor(other, multiplier: 1.5/10)
        addWidthAnchor(other, multiplier: 1.5/10)
        
        /*
        addSubview(activity)
        activity.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor).isActive = true
        addTrailingAnchor(activity, anchor: other.leadingAnchor, constant: -(screenSize.width * 0.3 / 10))
        addHeightAnchor(activity, multiplier: 2/10)
         */
    }
    
    let profileImageView: UIImageView = FeedCell().profileImageView
    let other = FeedCell.buttonForTitle("", imageName: "settings")
    let activity = FeedCell.buttonForTitle("", imageName: "activity")
    let nameLabel: UILabel = FeedCell.labelCreateDef(1)
}
