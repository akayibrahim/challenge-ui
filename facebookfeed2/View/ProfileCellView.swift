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
        backgroundColor = feedBackColor
        let contentGuide = self.readableContentGuide
        generateProfile(contentGuide, memberFbId: memberFbId, name: name)
    }
    
    @objc func generateProfile(_ contentGuide: UILayoutGuide, memberFbId: String, name: String) {
        addSubview(profileImageView)
        addTopAnchor(profileImageView, anchor: contentGuide.topAnchor, constant: 0)
        addLeadingAnchor(profileImageView, anchor: contentGuide.leadingAnchor, constant: 0)
        addWidthAnchor(profileImageView, multiplier: 2/10)
        addHeightAnchor(profileImageView, multiplier: 2/10)                
        setImage(fbID: memberFbId, imageView: profileImageView)
        profileImageView.layer.cornerRadius = 4.0
        profileImageView.layer.masksToBounds = true
        profileImageView.contentMode = .scaleAspectFill
        
        /*
        addSubview(nameLabel)
        let attributedText = NSMutableAttributedString(string: "\(name)", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 18)])
        nameLabel.attributedText = attributedText
        addTopAnchor(nameLabel, anchor: profileImageView.topAnchor, constant: screenSize.width * 0.15 / 10)
        addLeadingAnchor(nameLabel, anchor: profileImageView.trailingAnchor, constant: screenSize.width * 0.5 / 10)
        // nameLabel.text = name
        addWidthAnchor(nameLabel, multiplier: 4.5/10)
        nameLabel.adjustsFontSizeToFitWidth = true
        */
        addSubview(followersLabel)
        addSubview(followersCount)
        followersCount.font = UIFont.boldSystemFont(ofSize: 14)
        addTopAnchor(followersCount, anchor: profileImageView.topAnchor, constant: screenWidth * 0.25 / 10)
        followersCount.centerXAnchor.constraint(equalTo: followersLabel.centerXAnchor).isActive = true
        
        followersLabel.text = "Followers"
        followersLabel.font = UIFont.boldSystemFont(ofSize: 11)
        addTopAnchor(followersLabel, anchor: followersCount.bottomAnchor, constant: 0)
        //addLeadingAnchor(followersLabel, anchor: profileImageView.trailingAnchor, constant: screenSize.width * 0.5 / 10)
        addCenterXAnchor(followersLabel, anchor: contentGuide.centerXAnchor, constant: -(screenWidth*1.25/10))
        
        addSubview(followingLabel)
        addSubview(followingCount)
        followingCount.text = "0"
        followingCount.font = UIFont.boldSystemFont(ofSize: 14)
        addTopAnchor(followingCount, anchor: profileImageView.topAnchor, constant: screenWidth * 0.25 / 10)
        followingCount.centerXAnchor.constraint(equalTo: followingLabel.centerXAnchor).isActive = true
        
        followingLabel.text = "Following"
        followingLabel.font = UIFont.boldSystemFont(ofSize: 11)
        addTopAnchor(followingLabel, anchor: followingCount.bottomAnchor, constant: 0)
        addLeadingAnchor(followingLabel, anchor: followersLabel.trailingAnchor, constant: screenSize.width * 0.9 / 10)
        
        addSubview(challangeLabel)
        addSubview(challangeCount)
        challangeCount.text = "0"
        challangeCount.font = UIFont.boldSystemFont(ofSize: 14)
        addTopAnchor(challangeCount, anchor: profileImageView.topAnchor, constant: screenWidth * 0.25 / 10)
        challangeCount.centerXAnchor.constraint(equalTo: challangeLabel.centerXAnchor).isActive = true
        
        challangeLabel.text = "Challange"
        challangeLabel.font = UIFont.boldSystemFont(ofSize: 11)
        addTopAnchor(challangeLabel, anchor: challangeCount.bottomAnchor, constant: 0)
        addLeadingAnchor(challangeLabel, anchor: followingLabel.trailingAnchor, constant: screenSize.width * 0.9 / 10)
        
        /*
        addSubview(other)
        other.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor).isActive = true
        addTrailingAnchor(other, anchor: contentGuide.trailingAnchor, constant: -(screenSize.width * 0.05 / 10))
        addHeightAnchor(other, multiplier: 0.7 / 10)
        addWidthAnchor(other, multiplier: 0.7 / 10)
        */
        
        addSubview(follow)
        addBottomAnchor(follow, anchor: profileImageView.bottomAnchor, constant: 0)
        addCenterXAnchor(follow, anchor: followingLabel.centerXAnchor, constant: 0)
        addWidthAnchor(follow, multiplier: 5.5 / 10)
        addHeightAnchor(follow, multiplier: 0.8 / 10)
        follow.alpha = 0
        
        addSubview(unfollow)
        addBottomAnchor(unfollow, anchor: profileImageView.bottomAnchor, constant: 0)
        addCenterXAnchor(unfollow, anchor: followingLabel.centerXAnchor, constant: 0)
        addWidthAnchor(unfollow, multiplier: 5.5 / 10)
        addHeightAnchor(unfollow, multiplier: 0.8 / 10)
        unfollow.alpha = 0
        
        addSubview(requested)
        addBottomAnchor(requested, anchor: profileImageView.bottomAnchor, constant: 0)
        addCenterXAnchor(requested, anchor: followingLabel.centerXAnchor, constant: 0)
        addWidthAnchor(requested, multiplier: 5.5 / 10)
        addHeightAnchor(requested, multiplier: 0.8 / 10)
        requested.isEnabled = false
        requested.alpha = 0
        
        addSubview(inviteFriends)
        addBottomAnchor(inviteFriends, anchor: profileImageView.bottomAnchor, constant: 0)
        addCenterXAnchor(inviteFriends, anchor: followingLabel.centerXAnchor, constant: 0)
        addWidthAnchor(inviteFriends, multiplier: 5.5 / 10)
        addHeightAnchor(inviteFriends, multiplier: 0.8 / 10)
        inviteFriends.backgroundColor = UIColor.red
        
        addSubview(privateLabel)
        privateLabel.text = "(Private Account)"
        privateLabel.numberOfLines = 1
        addTopAnchor(privateLabel, anchor: profileImageView.bottomAnchor, constant: (screenWidth * 0.05 / 10))
        addCenterXAnchor(privateLabel, anchor: profileImageView.centerXAnchor, constant: 0)
        privateLabel.font = UIFont.boldSystemFont(ofSize: 8)
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
        button.layer.cornerRadius = 3.0
        button.clipsToBounds = true
        return button
    }
    
    @objc let follow: subclasssedUIButton = ProfileCellView.followButton(text: followButtonText)
    @objc let unfollow: subclasssedUIButton = ProfileCellView.followButton(text: "Unfollow")
    @objc let requested: subclasssedUIButton = ProfileCellView.followButton(text: "Requested")
    @objc let inviteFriends: subclasssedUIButton = ProfileCellView.followButton(text: "Invite Friends")
    @objc let privateLabel : UILabel = FeedCell.labelCreate(10, backColor: UIColor(white: 1, alpha: 0), textColor: UIColor.red)
}
