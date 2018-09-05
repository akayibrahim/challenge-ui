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
    }
    
    @objc init(frame: CGRect, memberFbId: String, name: String) {
        super.init(frame: frame)
        setupViews(memberFbId: memberFbId, name: name)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc let screenSize = UIScreen.main.bounds
    @objc func setupViews(memberFbId: String, name: String) {
        backgroundColor = UIColor.white
        let contentGuide = self.readableContentGuide
        generateProfile(contentGuide, memberFbId: memberFbId, name: name)
    }
    
    @objc func generateProfile(_ contentGuide: UILayoutGuide, memberFbId: String, name: String) {
        addSubview(profileImageView)
        addTopAnchor(profileImageView, anchor: contentGuide.topAnchor, constant: 0)
        addLeadingAnchor(profileImageView, anchor: contentGuide.leadingAnchor, constant: 0)
        addWidthAnchor(profileImageView, multiplier: 1.7/10)
        addHeightAnchor(profileImageView, multiplier: 2/10)                
        setImage(fbID: memberFbId, imageView: profileImageView)
        profileImageView.layer.cornerRadius = 4.0
        profileImageView.layer.masksToBounds = true
        profileImageView.contentMode = .scaleAspectFill
        
        addSubview(nameLabel)
        let attributedText = NSMutableAttributedString(string: "\(name)", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 18)])
        nameLabel.attributedText = attributedText
        addTopAnchor(nameLabel, anchor: profileImageView.topAnchor, constant: screenSize.width * 0.15 / 10)
        addLeadingAnchor(nameLabel, anchor: profileImageView.trailingAnchor, constant: screenSize.width * 0.5 / 10)
        nameLabel.text = name
        
        addSubview(followersLabel)
        followersLabel.text = "Followers"
        followersLabel.font = UIFont.boldSystemFont(ofSize: 11)
        addBottomAnchor(followersLabel, anchor: profileImageView.bottomAnchor, constant: -(screenSize.width * 0.1 / 10))
        addLeadingAnchor(followersLabel, anchor: profileImageView.trailingAnchor, constant: screenSize.width * 0.5 / 10)
        
        addSubview(followersCount)        
        followersCount.font = UIFont.boldSystemFont(ofSize: 14)
        addBottomAnchor(followersCount, anchor: followersLabel.topAnchor, constant: 0)
        followersCount.centerXAnchor.constraint(equalTo: followersLabel.centerXAnchor).isActive = true
        
        addSubview(followingLabel)
        followingLabel.text = "Following"
        followingLabel.font = UIFont.boldSystemFont(ofSize: 11)
        addBottomAnchor(followingLabel, anchor: followersLabel.bottomAnchor, constant: 0)
        addLeadingAnchor(followingLabel, anchor: followersLabel.trailingAnchor, constant: screenSize.width * 0.3 / 10)
        
        addSubview(followingCount)
        followingCount.text = "0"
        followingCount.font = UIFont.boldSystemFont(ofSize: 14)
        addBottomAnchor(followingCount, anchor: followingLabel.topAnchor, constant: 0)
        followingCount.centerXAnchor.constraint(equalTo: followingLabel.centerXAnchor).isActive = true
        
        addSubview(challangeLabel)
        challangeLabel.text = "Challange"
        challangeLabel.font = UIFont.boldSystemFont(ofSize: 11)
        addBottomAnchor(challangeLabel, anchor: followingLabel.bottomAnchor, constant: 0)
        addLeadingAnchor(challangeLabel, anchor: followingLabel.trailingAnchor, constant: screenSize.width * 0.3 / 10)
        
        addSubview(challangeCount)
        challangeCount.text = "0"
        challangeCount.font = UIFont.boldSystemFont(ofSize: 14)
        addBottomAnchor(challangeCount, anchor: challangeLabel.topAnchor, constant: 0)
        challangeCount.centerXAnchor.constraint(equalTo: challangeLabel.centerXAnchor).isActive = true
        
        addSubview(other)
        other.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor).isActive = true
        addTrailingAnchor(other, anchor: contentGuide.trailingAnchor, constant: -(screenSize.width * 0.05 / 10))
        addHeightAnchor(other, multiplier: 0.7 / 10)
        addWidthAnchor(other, multiplier: 0.7 / 10)
        
        addSubview(follow)
        addTopAnchor(follow, anchor: profileImageView.topAnchor, constant: 0)
        addTrailingAnchor(follow, anchor: contentGuide.trailingAnchor, constant: -(screenSize.width * 0.2 / 10))
        addWidthAnchor(follow, multiplier: 2.4 / 10)
        addHeightAnchor(follow, multiplier: 0.8 / 10)
        follow.alpha = 0
        
        addSubview(unfollow)
        addTopAnchor(unfollow, anchor: profileImageView.topAnchor, constant: 0)
        addTrailingAnchor(unfollow, anchor: contentGuide.trailingAnchor, constant: -(screenSize.width * 0.2 / 10))
        addWidthAnchor(unfollow, multiplier: 2.4 / 10)
        addHeightAnchor(unfollow, multiplier: 0.8 / 10)
        unfollow.alpha = 0
        
        addSubview(requested)
        addTopAnchor(requested, anchor: profileImageView.topAnchor, constant: 0)
        addTrailingAnchor(requested, anchor: contentGuide.trailingAnchor, constant: -(screenSize.width * 0.2 / 10))
        addWidthAnchor(requested, multiplier: 2.4 / 10)
        addHeightAnchor(requested, multiplier: 0.8 / 10)
        requested.isEnabled = false
        requested.alpha = 0
        
        addSubview(privateLabel)
        privateLabel.text = "(Private Account)"
        addTopAnchor(privateLabel, anchor: nameLabel.bottomAnchor, constant: screenSize.width * 0.0 / 10)
        addLeadingAnchor(privateLabel, anchor: nameLabel.leadingAnchor, constant: -(screenSize.width * 0.0 / 10))
        privateLabel.alpha = 0
        
        /*
        addSubview(activity)
        activity.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor).isActive = true
        addTrailingAnchor(activity, anchor: other.leadingAnchor, constant: -(screenSize.width * 0.3 / 10))
        addHeightAnchor(activity, multiplier: 2/10)
         */
    }
    
    @objc let profileImageView: UIImageView = FeedCell().profileImageView
    @objc let other = FeedCell.buttonForTitle("", imageName: "settings")
    @objc let activity = FeedCell.buttonForTitle("", imageName: "activity")
    @objc let nameLabel: UILabel = FeedCell.labelCreateDef(1)
    @objc let followersCount: UILabel = FeedCell.labelCreateDef(1)
    @objc let followersLabel: UILabel = FeedCell.labelCreateDef(1)
    @objc let followingCount: UILabel = FeedCell.labelCreateDef(1)
    @objc let followingLabel: UILabel = FeedCell.labelCreateDef(1)
    @objc let challangeCount: UILabel = FeedCell.labelCreateDef(1)
    @objc let challangeLabel: UILabel = FeedCell.labelCreateDef(1)
    
    @objc static func followButton(text: String) -> subclasssedUIButton {
        let button = subclasssedUIButton()
        button.setTitle(text, for: UIControlState())
        button.setTitleColor(UIColor.white, for: UIControlState())
        button.backgroundColor = UIColor.rgb(87, green: 143, blue: 255)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.layer.cornerRadius = 2
        return button
    }
    
    @objc let follow: subclasssedUIButton = ProfileCellView.followButton(text: followButtonText)
    @objc let unfollow: subclasssedUIButton = ProfileCellView.followButton(text: "Unfollow")
    @objc let requested: subclasssedUIButton = ProfileCellView.followButton(text: "Requested")
    @objc let privateLabel : UILabel = FeedCell.labelCreate(10, backColor: UIColor(white: 1, alpha: 0), textColor: UIColor.red)
}
