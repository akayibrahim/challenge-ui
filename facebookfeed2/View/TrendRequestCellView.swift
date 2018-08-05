//
//  FriendRequestView.swift
//  facebookfeed2
//
//  Created by iakay on 26.02.2018.
//  Copyright © 2018 challenge. All rights reserved.
//

import UIKit
import AVKit

class TrendRequestCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    var trendRequest : TrendRequest? {
        didSet {
            if let name = trendRequest?.name, let subject = trendRequest?.subject {
                let nameAtt = NSMutableAttributedString(string: "\(name)", attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14)])
                let proofBy = NSMutableAttributedString(string: " proved ", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14)])
                let subjectAtt = NSMutableAttributedString(string: "\(subject).", attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14)])
                proofBy.append(subjectAtt)
                nameAtt.append(proofBy)
                nameLabel.attributedText = nameAtt
            }
            /*
            if let proof = trendRequest?.proof {
                requestImageView.image = UIImage(named: proof)
            }
             */
            if let prooferFBId = trendRequest?.prooferFbID {
                setImage(fbID: prooferFBId, imageView: profileImageView)
            }
            setupViews()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Sample Name"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    let requestImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        // imageView.backgroundColor = UIColor.blue
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    func setupViews() {
        let contentGuide = self.readableContentGuide
        backgroundColor = UIColor.white
        addSubview(requestImageView)
        addSubview(nameLabel)
        addSubview(profileImageView)
        addSubview(proofedVideoView)
        
        addTopAnchor(profileImageView, anchor: contentGuide.topAnchor, constant: 0)
        addLeadingAnchor(profileImageView, anchor: contentGuide.leadingAnchor, constant: 0)
        addWidthAnchor(profileImageView, multiplier: 1/10)
        addHeightAnchor(profileImageView, multiplier: 1/10)
        profileImageView.layer.cornerRadius = 4.0
        profileImageView.layer.masksToBounds = true
        profileImageView.contentMode = .scaleAspectFill
        
        addTopAnchor(nameLabel, anchor: contentGuide.topAnchor, constant: 0)
        addLeadingAnchor(nameLabel, anchor: profileImageView.trailingAnchor, constant: screenWidth * 0.05 / 2)
        addHeightAnchor(nameLabel, multiplier: 0.2 / 2)
        
        addTopAnchor(requestImageView, anchor: profileImageView.bottomAnchor, constant: screenWidth * 0.05 / 2)
        // addLeadingAnchor(requestImageView, anchor: contentGuide.leadingAnchor, constant: 0)
        // addTrailingAnchor(requestImageView, anchor: contentGuide.trailingAnchor, constant: 0)
        addWidthAnchor(requestImageView, multiplier: 1)
        addHeightAnchor(requestImageView, multiplier: 1 / 2)
        
        addTopAnchor(proofedVideoView, anchor: profileImageView.bottomAnchor, constant: screenWidth * 0.05 / 2)
        addWidthAnchor(proofedVideoView, multiplier: 1)
        addHeightAnchor(proofedVideoView, multiplier: 1 / 2)
        proofedVideoView.alpha = 0
        
        self.proofedVideoView.layer.addSublayer(self.avPlayerLayer)
        self.avPlayerLayer.frame = self.proofedVideoView.layer.bounds
        self.avPlayerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        self.avPlayerLayer.repeatCount = 3
        self.proofedVideoView.layer.masksToBounds = true
        
        addSubview(volumeUpImageView)
        addBottomAnchor(volumeUpImageView, anchor: proofedVideoView.bottomAnchor, constant: -(screenWidth * 0.2 / 10))
        addLeadingAnchor(volumeUpImageView, anchor: proofedVideoView.leadingAnchor, constant: (screenWidth * 0.2 / 10))
        addWidthAnchor(volumeUpImageView, multiplier: 0.04)
        addHeightAnchor(volumeUpImageView, multiplier: 0.04)
        volumeUpImageView.alpha = 0
        
        addSubview(volumeDownImageView)
        addBottomAnchor(volumeDownImageView, anchor: proofedVideoView.bottomAnchor, constant: -(screenWidth * 0.2 / 10))
        addLeadingAnchor(volumeDownImageView, anchor: proofedVideoView.leadingAnchor, constant: (screenWidth * 0.2 / 10))
        addWidthAnchor(volumeDownImageView, multiplier: 0.04)
        addHeightAnchor(volumeDownImageView, multiplier: 0.04)
        volumeDownImageView.alpha = 1
        
        setImage(name: volumeUp, imageView: volumeUpImageView)
        setImage(name: volumeDown, imageView: volumeDownImageView)
    }
    let profileImageView: UIImageView = FeedCell().profileImageView
    let proofedVideoView: UIView = FeedCell.viewFunc()
    let volumeUpImageView: UIImageView = FeedCell.circleImageView()
    let volumeDownImageView: UIImageView = FeedCell.circleImageView()
    let avPlayerLayer : AVPlayerLayer = AVPlayerLayer.init()
}
