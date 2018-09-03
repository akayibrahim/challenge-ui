//
//  OtherView.swift
//  facebookfeed2
//
//  Created by iakay on 27.02.2018.
//  Copyright © 2018 challenge. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class ActivityCell: UITableViewCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc var activity : Activities? {
        didSet {
            self.profileImageView.removeFromSuperview()
            self.proofImageView.removeFromSuperview()
            if let fbID = activity?.facebookID {
                setImage(fbID: fbID, imageView: profileImageView)
            }
            if let content = activity?.content, let name = activity?.name {
                let nameAtt = NSMutableAttributedString(string: "\(name)", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14)])
                let contentAtt = NSMutableAttributedString(string: " \(content)", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14)])
                nameAtt.append(contentAtt)
                contentText.attributedText = nameAtt
            }
            if let mediaObjectId = activity?.mediaObjectId {
                self.proofImageView.loadByObjectId(objectId: mediaObjectId)
            }
            if let type = activity?.type {
                setupViews(type: type, mediaObjectId: activity?.mediaObjectId ?? "-1")
            }
        }
    }
    
    @objc func setupViews(type: String, mediaObjectId: String) {
        let contentGuide = self.readableContentGuide
        let screenSize = UIScreen.main.bounds
        
        addSubview(profileImageView)
        profileImageView.layer.cornerRadius = screenWidth * 0.9 / 10 / 2
        addLeadingAnchor(profileImageView, anchor: contentGuide.leadingAnchor, constant: screenSize.width * 0.1/10)
        addWidthAnchor(profileImageView, multiplier: 0.9/10)
        addHeightAnchor(profileImageView, multiplier: 0.9/10)
        profileImageView.centerYAnchor.constraint(equalTo: contentGuide.centerYAnchor).isActive = true
        
        addSubview(contentText)
        addLeadingAnchor(contentText, anchor: profileImageView.trailingAnchor, constant: screenSize.width * 0.15/10)
        contentText.centerYAnchor.constraint(equalTo: contentGuide.centerYAnchor).isActive = true
        contentText.isUserInteractionEnabled = false
        addTrailingAnchor(contentText, anchor: contentGuide.trailingAnchor, constant: type == "PROOF" ? -(screenWidth * 1.5/10) : 4)
        
        if type == "PROOF" {
            addSubview(proofImageView)
            proofImageView.layer.cornerRadius = 0
            addTrailingAnchor(proofImageView, anchor: contentGuide.trailingAnchor, constant: screenSize.width * 0.1/10)
            addWidthAnchor(proofImageView, multiplier: 1.5/10)
            addHeightAnchor(proofImageView, multiplier: 1.5/10/2)
            proofImageView.centerYAnchor.constraint(equalTo: contentGuide.centerYAnchor).isActive = true
        }
    }
    
    @objc let profileImageView: UIImageView = FeedCell().profileImageView
    @objc let contentText : UITextView = FeedCell().thinksAboutChallengeView
    @objc let proofImageView: UIImageView = FeedCell().profileImageView
}
