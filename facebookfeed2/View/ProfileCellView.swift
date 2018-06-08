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
        setImage(fbID: memberFbID, imageView: profileImageView)
        profileImageView.layer.cornerRadius = 4.0
        profileImageView.layer.masksToBounds = true
        profileImageView.contentMode = .scaleAspectFill
        
        addSubview(nameLabel)
        let attributedText = NSMutableAttributedString(string: "\(memberName)", attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 18)])
        nameLabel.attributedText = attributedText
        addTopAnchor(nameLabel, anchor: profileImageView.topAnchor, constant: screenSize.width * 0.2 / 10)
        addLeadingAnchor(nameLabel, anchor: profileImageView.trailingAnchor, constant: screenSize.width * 0.5 / 10)
        nameLabel.text = memberName
        
        addSubview(followersLabel)
        followersLabel.text = "Followers"
        followersLabel.font = UIFont.systemFont(ofSize: 10)
        addBottomAnchor(followersLabel, anchor: profileImageView.bottomAnchor, constant: -(screenSize.width * 0.1 / 10))
        addLeadingAnchor(followersLabel, anchor: profileImageView.trailingAnchor, constant: screenSize.width * 0.5 / 10)
        
        addSubview(followersCount)        
        followersCount.font = UIFont.boldSystemFont(ofSize: 14)
        addBottomAnchor(followersCount, anchor: followersLabel.topAnchor, constant: 0)
        followersCount.centerXAnchor.constraint(equalTo: followersLabel.centerXAnchor).isActive = true
        
        addSubview(followingLabel)
        followingLabel.text = "Following"
        followingLabel.font = UIFont.systemFont(ofSize: 10)
        addBottomAnchor(followingLabel, anchor: followersLabel.bottomAnchor, constant: 0)
        addLeadingAnchor(followingLabel, anchor: followersLabel.trailingAnchor, constant: screenSize.width * 0.3 / 10)
        
        addSubview(followingCount)
        followingCount.text = "117"
        followingCount.font = UIFont.boldSystemFont(ofSize: 14)
        addBottomAnchor(followingCount, anchor: followingLabel.topAnchor, constant: 0)
        followingCount.centerXAnchor.constraint(equalTo: followingLabel.centerXAnchor).isActive = true
        
        addSubview(challangeLabel)
        challangeLabel.text = "Challange"
        challangeLabel.font = UIFont.systemFont(ofSize: 10)
        addBottomAnchor(challangeLabel, anchor: followingLabel.bottomAnchor, constant: 0)
        addLeadingAnchor(challangeLabel, anchor: followingLabel.trailingAnchor, constant: screenSize.width * 0.3 / 10)
        
        addSubview(challangeCount)
        challangeCount.text = "8"
        challangeCount.font = UIFont.boldSystemFont(ofSize: 14)
        addBottomAnchor(challangeCount, anchor: challangeLabel.topAnchor, constant: 0)
        challangeCount.centerXAnchor.constraint(equalTo: challangeLabel.centerXAnchor).isActive = true
        
        addSubview(other)
        other.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor).isActive = true
        addTrailingAnchor(other, anchor: contentGuide.trailingAnchor, constant: -(screenSize.width * 0.05 / 10))
        addHeightAnchor(other, multiplier: 0.8 / 10)
        addWidthAnchor(other, multiplier: 0.8 / 10)
        
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
    let followersCount: UILabel = FeedCell.labelCreateDef(1)
    let followersLabel: UILabel = FeedCell.labelCreateDef(1)
    let followingCount: UILabel = FeedCell.labelCreateDef(1)
    let followingLabel: UILabel = FeedCell.labelCreateDef(1)
    let challangeCount: UILabel = FeedCell.labelCreateDef(1)
    let challangeLabel: UILabel = FeedCell.labelCreateDef(1)
}
