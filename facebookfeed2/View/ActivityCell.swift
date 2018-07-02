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
    
    var activity : Activities? {
        didSet {
            if let fbID = activity?.facebookID {
                setImage(fbID: fbID, imageView: profileImageView)
            }
            if let content = activity?.content, let name = activity?.name {
                let nameAtt = NSMutableAttributedString(string: "\(name)", attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14)])
                let contentAtt = NSMutableAttributedString(string: " \(content)", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14)])
                nameAtt.append(contentAtt)
                contentText.attributedText = nameAtt
            }
            setupViews()
        }
    }
    
    func setupViews() {
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
        addTrailingAnchor(contentText, anchor: contentGuide.trailingAnchor, constant: 4)        
        contentText.centerYAnchor.constraint(equalTo: contentGuide.centerYAnchor).isActive = true
        contentText.isUserInteractionEnabled = false
    }
    
    let profileImageView: UIImageView = FeedCell().profileImageView
    let contentText : UITextView = FeedCell().thinksAboutChallengeView
}
