//
//  OtherView.swift
//  facebookfeed2
//
//  Created by iakay on 27.02.2018.
//  Copyright © 2018 challenge. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import AVFoundation

class ActivityCell: UITableViewCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        self.proofImageView.image = UIImage()
        self.proofImageView.removeFromSuperview()
        self.profileImageView.removeFromSuperview()
        self.proofVideoView.removeFromSuperview()
        self.proofVideoView.player?.replaceCurrentItem(with: nil)
        super.prepareForReuse()
    }
    
    @objc var activity : Activities? {
        didSet {
            prepareForReuse()
            if let fbID = activity?.facebookID {
                setImage(fbID: fbID, imageView: profileImageView)
            }
            if let content = activity?.content, let name = activity?.name {
                let nameAtt = NSMutableAttributedString(string: "\(name)", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14)])
                let contentAtt = NSMutableAttributedString(string: " \(content)", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14)])
                nameAtt.append(contentAtt)
                contentText.attributedText = nameAtt
            }
            if self.activity?.type == "PROOF" {
                if let mediaObjectId = self.activity?.mediaObjectId {
                    if let proofWithImage = self.activity?.provedWithImage {
                        if proofWithImage {
                            self.proofImageView.loadByObjectId(objectId: mediaObjectId)
                        } else {
                            self.proofVideoView.playerLayer.loadByObjectId(objectId: mediaObjectId)
                        }
                    }
                }
            }
            if let type = activity?.type {
                let proofWithImage = activity?.provedWithImage != nil ? activity?.provedWithImage : false
                setupViews(type: type, mediaObjectId: activity?.mediaObjectId ?? "-1", proofWithImage: proofWithImage!)
            }
        }
    }
    
    @objc func setupViews(type: String, mediaObjectId: String, proofWithImage: Bool) {
        let contentGuide = self.readableContentGuide
        let screenSize = UIScreen.main.bounds
        
        addSubview(profileImageView)
        profileImageView.layer.cornerRadius = screenWidth * 0.9 / 10 / 2
        addLeadingAnchor(profileImageView, anchor: contentGuide.leadingAnchor, constant: screenSize.width * 0.1/10)
        addWidthAnchor(profileImageView, multiplier: 0.9/10)
        addHeightAnchor(profileImageView, multiplier: 0.9/10)
        profileImageView.centerYAnchor.constraint(equalTo: contentGuide.centerYAnchor).isActive = true
        profileImageView.isOpaque = true
        profileImageView.layer.shouldRasterize = true
        
        addSubview(contentText)
        addLeadingAnchor(contentText, anchor: profileImageView.trailingAnchor, constant: screenSize.width * 0.15/10)
        contentText.centerYAnchor.constraint(equalTo: contentGuide.centerYAnchor).isActive = true
        contentText.isUserInteractionEnabled = false
        addTrailingAnchor(contentText, anchor: contentGuide.trailingAnchor, constant: type == "PROOF" ? -(screenWidth * 1.5/10) : 4)
        contentText.backgroundColor = UIColor(white: 0.0, alpha: 0.0)
        contentText.isOpaque = true
        contentText.layer.shouldRasterize = true
        
        if type == "PROOF" {
            if !proofWithImage {
                addSubview(proofVideoView)
                proofVideoView.layer.cornerRadius = 0
                addTrailingAnchor(proofVideoView, anchor: contentGuide.trailingAnchor, constant: screenSize.width * 0.1/10)
                addWidthAnchor(proofVideoView, multiplier: 1.5/10)
                addHeightAnchor(proofVideoView, multiplier: 1.5/10/2)
                proofVideoView.centerYAnchor.constraint(equalTo: contentGuide.centerYAnchor).isActive = true
                self.proofVideoView.layer.masksToBounds = true
                proofVideoView.isOpaque = true
                proofVideoView.layer.shouldRasterize = true
                /*DispatchQueue.main.async {
                    self.proofVideoView.layer.addSublayer(self.avPlayerLayer)
                    self.avPlayerLayer.frame = self.proofVideoView.layer.bounds
                    self.avPlayerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
                }*/
            } else {
                addSubview(proofImageView)
                proofImageView.layer.cornerRadius = 0
                addTrailingAnchor(proofImageView, anchor: contentGuide.trailingAnchor, constant: screenSize.width * 0.1/10)
                addWidthAnchor(proofImageView, multiplier: 1.5/10)
                addHeightAnchor(proofImageView, multiplier: 1.5/10/2)
                proofImageView.centerYAnchor.constraint(equalTo: contentGuide.centerYAnchor).isActive = true
                proofImageView.isOpaque = true
                proofImageView.layer.shouldRasterize = true
            }
        }
    }
    
    @objc let profileImageView: UIImageView = FeedCell().profileImageView
    @objc let contentText : UITextView = FeedCell().thinksAboutChallengeView
    @objc let proofImageView: UIImageView = FeedCell().profileImageView
    @objc let proofVideoView: PlayerView = PlayerView()
    // @objc var avPlayerLayer : AVPlayerLayer = AVPlayerLayer.init()
}
