//
//  OtherView.swift
//  facebookfeed2
//
//  Created by iakay on 27.02.2018.
//  Copyright © 2018 challenge. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import AVKit

class ProofCellView: UITableViewCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func setup() {
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
        // setImage(name: unknown, imageView: proofImageView)
        proofImageView.alpha = 0
        
        addSubview(proofedVideoView)
        addTopAnchor(proofedVideoView, anchor: profileImageView.bottomAnchor, constant: screenWidth * 0.05 / 2)
        addWidthAnchor(proofedVideoView, multiplier: 1)
        addHeightAnchor(proofedVideoView, multiplier: 1 / 2)
        proofedVideoView.alpha = 0
        DispatchQueue.main.async {
            self.proofedVideoView.layer.addSublayer(self.avPlayerLayer)
            self.avPlayerLayer.frame = self.proofedVideoView.layer.bounds
            self.avPlayerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
            self.avPlayerLayer.repeatCount = 10            
            self.proofedVideoView.layer.masksToBounds = true
        }
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
        volumeDownImageView.alpha = 0
        
        setImage(name: volumeUp, imageView: volumeUpImageView)
        setImage(name: volumeDown, imageView: volumeDownImageView)
    }

    
    @objc let profileImageView: UIImageView = FeedCell().profileImageView
    @objc let thinksAboutChallengeView: UITextView = FeedCell().thinksAboutChallengeView
    
    @objc let proofImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        // imageView.backgroundColor = UIColor.blue
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    @objc let proofedVideoView: UIView = FeedCell.viewFunc()
    @objc let volumeUpImageView: UIImageView = FeedCell.circleImageView()
    @objc let volumeDownImageView: UIImageView = FeedCell.circleImageView()
    @objc let avPlayerLayer : AVPlayerLayer = AVPlayerLayer.init()
}
