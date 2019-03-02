//
//  UIFontExtension.swift
//  facebookfeed2
//
//  Created by iakay on 11.05.2018.
//  Copyright © 2018 challenge. All rights reserved.
//

import UIKit
import PINRemoteImage
import PINCache
import AVKit
import AVFoundation

final class PlayerManager {
    static let shared = PlayerManager()
    private init() {}
    
    var avPlayerView : PlayerView = PlayerView()
}

class PlayerView: UIView {
    override static var layerClass: AnyClass {
        return AVPlayerLayer.self
    }
    
    var player: AVPlayer? {
        get {
            return playerLayer.player
        }
        set {
            playerLayer.player = newValue
        }
    }
    
    var playerLayer: AVPlayerLayer {
        return layer as! AVPlayerLayer
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        playerLayer.videoGravity = videoGravityFill
        playerLayer.backgroundColor = UIColor(hexString: "0x000000").withAlphaComponent(0.9).cgColor // backColorOfMedia.cgColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        playerLayer.videoGravity = videoGravityFill
    }
}

extension UIView {
    
    func clearConstraints() {
        for subview in self.subviews {
            subview.clearConstraints()
        }
        self.removeConstraints(self.constraints)
    }
    
    func showTwoFinger() {
        DispatchQueue.main.async {
            let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.extraLight)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = self.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            
            let image = UIImageView(image: UIImage(named: "twofinger"))
            image.layer.cornerRadius = 0.4            
            image.layer.masksToBounds = true
            image.frame = CGRect(x: 0, y: 0, width: screenWidth * 2/5, height: screenWidth * 2/5)
            blurEffectView.contentView.addSubview(image)
            image.center = blurEffectView.contentView.center
            
            self.addSubview(blurEffectView)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.75, execute: {
                self.removeBluerLoader()
            })
        }
    }
    
    func showBlurLoader(){
        DispatchQueue.main.async {
            let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.extraLight)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = self.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            
            let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
            activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
            activityIndicator.startAnimating()
            
            blurEffectView.contentView.addSubview(activityIndicator)
            activityIndicator.center = blurEffectView.contentView.center
            
            self.addSubview(blurEffectView)
        }
    }
    
    func showDarkLoader(){
        DispatchQueue.main.async {
            let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = self.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            
            let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .white)
            activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
            activityIndicator.startAnimating()
            
            blurEffectView.contentView.addSubview(activityIndicator)
            activityIndicator.center = blurEffectView.contentView.center
            
            self.addSubview(blurEffectView)
        }
    }
    
    func removeBluerLoader(){
        DispatchQueue.main.async {
            self.subviews.compactMap {  $0 as? UIVisualEffectView }.forEach {
                $0.removeFromSuperview()
            }
        }
    }
    
    @objc func setImage(fbID: String?, imageView: UIImageView) {
        if (fbID != nil && fbID == "") || fbID == nil {
            setImage(name: unknown, imageView: imageView)
        } else if let peoplefbID = fbID {
            let url = URL(string: !peoplefbID.contains("google") ? "https://graph.facebook.com/\(peoplefbID)/picture?type=large&return_ssl_resources=1" : peoplefbID)
            imageView.load(url: url!, focusToFace: false)
        }
    }
    
    @objc func setImage(fbID: String?, imageView: UIImageView, focusToFace: Bool) {
        if (fbID != nil && fbID == "") || fbID == nil {
            setImage(name: unknown, imageView: imageView)
        } else if let peoplefbID = fbID {
            let url = URL(string: !peoplefbID.contains("google") ? "https://graph.facebook.com/\(peoplefbID)/picture?type=large&return_ssl_resources=1" : peoplefbID)
            imageView.load(url: url!, focusToFace: focusToFace)
        }
    }
    
    @objc func setImage(name: String?, imageView: UIImageView) {
        if let peopleImage = name {
            imageView.image = UIImage(named: peopleImage)
        }
    }
    
    func addConstraintsWithFormat(_ format: String, views: UIView...) {
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            viewsDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
    }
    
    @objc func addTopAnchor(_ view: UIView, anchor: NSLayoutAnchor<NSLayoutYAxisAnchor>, constant: CGFloat) {
        view.topAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
        view.translatesAutoresizingMaskIntoConstraints = false
    }
    
    @objc func addBottomAnchor(_ view: UIView, anchor: NSLayoutAnchor<NSLayoutYAxisAnchor>, constant: CGFloat) {
        view.bottomAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
        view.translatesAutoresizingMaskIntoConstraints = false
    }
    
    @objc func addLeadingAnchor(_ view: UIView, anchor: NSLayoutAnchor<NSLayoutXAxisAnchor>, constant: CGFloat) {
        view.leadingAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
        view.translatesAutoresizingMaskIntoConstraints = false
    }
    
    @objc func addCenterXAnchor(_ view: UIView, anchor: NSLayoutAnchor<NSLayoutXAxisAnchor>, constant: CGFloat) {
        view.centerXAnchor.constraint(equalTo: anchor, constant: constant).isActive = true        
        view.translatesAutoresizingMaskIntoConstraints = false
    }
    
    @objc func addCenterYAnchor(_ view: UIView, anchor: NSLayoutAnchor<NSLayoutYAxisAnchor>, constant: CGFloat) {
        view.centerYAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
        view.translatesAutoresizingMaskIntoConstraints = false
    }
    
    @objc func addTrailingAnchor(_ view: UIView, anchor: NSLayoutAnchor<NSLayoutXAxisAnchor>, constant: CGFloat) {
        view.trailingAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
        view.translatesAutoresizingMaskIntoConstraints = false
    }
    
    @objc func addWidthAnchor(_ view: UIView, multiplier: CGFloat) {
        let screenSize = UIScreen.main.bounds
        view.widthAnchor.constraint(equalToConstant: screenSize.width * multiplier).isActive = true
    }
    
    @objc func addHeightAnchor(_ view: UIView, multiplier: CGFloat) {
        let screenSize = UIScreen.main.bounds
        view.heightAnchor.constraint(equalToConstant: screenSize.width * multiplier).isActive = true
    }
    
    @objc func addBorders(edges: UIRectEdge = .all, color: UIColor = .black, width: CGFloat = 1.0) {
        func createBorder() -> UIView {
            let borderView = UIView(frame: CGRect.zero)
            borderView.translatesAutoresizingMaskIntoConstraints = false
            borderView.backgroundColor = color
            return borderView
        }
        if (edges.contains(.all) || edges.contains(.top)) {
            let topBorder = createBorder()
            self.addSubview(topBorder)
            NSLayoutConstraint.activate([
                topBorder.topAnchor.constraint(equalTo: self.topAnchor),
                topBorder.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                topBorder.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                topBorder.heightAnchor.constraint(equalToConstant: width)
                ])
        }
        if (edges.contains(.all) || edges.contains(.left)) {
            let leftBorder = createBorder()
            self.addSubview(leftBorder)
            NSLayoutConstraint.activate([
                leftBorder.topAnchor.constraint(equalTo: self.topAnchor),
                leftBorder.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                leftBorder.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                leftBorder.widthAnchor.constraint(equalToConstant: width)
                ])
        }
        if (edges.contains(.all) || edges.contains(.right)) {
            let rightBorder = createBorder()
            self.addSubview(rightBorder)
            NSLayoutConstraint.activate([
                rightBorder.topAnchor.constraint(equalTo: self.topAnchor),
                rightBorder.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                rightBorder.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                rightBorder.widthAnchor.constraint(equalToConstant: width)
                ])
        }
        if (edges.contains(.all) || edges.contains(.bottom)) {
            let bottomBorder = createBorder()
            self.addSubview(bottomBorder)
            NSLayoutConstraint.activate([
                bottomBorder.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                bottomBorder.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                bottomBorder.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                bottomBorder.heightAnchor.constraint(equalToConstant: width)
                ])
        }
    }
    
    @objc func getGuideView(_ topbarHeight: CGFloat) -> UIView {
        let areaBorderWidth: CGFloat = 0 //0.3
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height * 3.2/5))
        
        let chlTypesLabel : UILabel = FeedCell.labelCreate(15, backColor: UIColor(white: 1, alpha: 0), textColor: UIColor.black)
        chlTypesLabel.text = "CHALLENGE TYPES"
        chlTypesLabel.sizeToFit()
        
        view.addSubview(chlTypesLabel)
        self.addTopAnchor(chlTypesLabel, anchor: view.topAnchor, constant: topbarHeight + 15)
        self.addLeadingAnchor(chlTypesLabel, anchor: view.leadingAnchor, constant: 0)
        self.addWidthAnchor(chlTypesLabel, multiplier: 1)
        chlTypesLabel.heightAnchor.constraint(equalToConstant: 10).isActive = true
        
        let selfArea: UIView = FeedCell.lineForDivider()
        view.addSubview(selfArea)
        selfArea.layer.borderColor = UIColor.black.cgColor
        selfArea.layer.borderWidth = 0.3
        self.addTopAnchor(selfArea, anchor: chlTypesLabel.bottomAnchor, constant: 5)
        self.addCenterXAnchor(selfArea, anchor: view.centerXAnchor, constant: 0)
        self.addWidthAnchor(selfArea, multiplier: 0.8 / 1)
        self.addHeightAnchor(selfArea, multiplier: 1 / 3)
        
        let selfLabel : UILabel = FeedCell.labelCreate(12, backColor: UIColor(white: 1, alpha: 0), textColor: UIColor.rgb(0, green: 0, blue: 153))
        selfLabel.text = "SELF CHALLENGE"
        selfLabel.sizeToFit()
        
        view.addSubview(selfLabel)
        self.addTopAnchor(selfLabel, anchor: selfArea.topAnchor, constant: 5)
        self.addLeadingAnchor(selfLabel, anchor: selfArea.leadingAnchor, constant: 10)
        //self.addWidthAnchor(selfLabel, multiplier: 1)
        selfLabel.heightAnchor.constraint(equalToConstant: 10).isActive = true
        
        let vsImageView : UIImageView = FeedCell().vsImageView
        vsImageView.image = UIImage(named: "vs")
        
        view.addSubview(vsImageView)
        self.addCenterYAnchor(vsImageView, anchor: selfArea.centerYAnchor, constant: 0)
        self.addCenterXAnchor(vsImageView, anchor: view.centerXAnchor, constant: 0)
        self.addWidthAnchor(vsImageView, multiplier: 2 / 6)
        self.addHeightAnchor(vsImageView, multiplier: 0.8 / 6)
        
        let subjectLabel : UILabel = FeedCell.labelCreate(11, backColor: UIColor(white: 1, alpha: 0), textColor: UIColor.black)
        subjectLabel.text = "SUBJECT"
        subjectLabel.sizeToFit()
        
        view.addSubview(subjectLabel)
        self.addBottomAnchor(subjectLabel, anchor: selfArea.bottomAnchor, constant: -10)
        self.addCenterXAnchor(subjectLabel, anchor: selfArea.centerXAnchor, constant: 0)
        subjectLabel.heightAnchor.constraint(equalToConstant: 10).isActive = true
        
        let selfChallenger: UIView = FeedCell.lineForDivider()
        view.addSubview(selfChallenger)
        selfChallenger.layer.borderColor = UIColor.black.cgColor
        selfChallenger.layer.borderWidth = areaBorderWidth
        self.addTopAnchor(selfChallenger, anchor: selfLabel.bottomAnchor, constant: screenWidth * 1/5/6)
        self.addTrailingAnchor(selfChallenger, anchor: vsImageView.leadingAnchor, constant: 10)
        self.addWidthAnchor(selfChallenger, multiplier: 1/5)
        self.addHeightAnchor(selfChallenger, multiplier: 1/5)
        
        let selfChallengerImg: UIImageView = FeedCell.imageView()
        selfChallengerImg.image = UIImage(named: "unknownmono")
        view.addSubview(selfChallengerImg)
        self.addCenterYAnchor(selfChallengerImg, anchor: selfChallenger.centerYAnchor, constant: 0)
        self.addCenterXAnchor(selfChallengerImg, anchor: selfChallenger.centerXAnchor, constant: 0)
        self.addWidthAnchor(selfChallengerImg, multiplier: 1/6)
        self.addHeightAnchor(selfChallengerImg, multiplier: 1/6)
        selfChallengerImg.alpha = 0.3
        
        let selfChallengerText : UILabel = FeedCell.labelCreate(11, backColor: UIColor(white: 1, alpha: 0), textColor: UIColor.black)
        selfChallengerText.text = "CHALLENGER"
        selfChallengerText.sizeToFit()
        
        view.addSubview(selfChallengerText)
        self.addTopAnchor(selfChallengerText, anchor: selfChallenger.bottomAnchor, constant: 0.5)
        self.addCenterXAnchor(selfChallengerText, anchor: selfChallenger.centerXAnchor, constant: 0)
        selfChallengerText.heightAnchor.constraint(equalToConstant: 10).isActive = true
        
        let selfSubject: UIView = FeedCell.lineForDivider()
        view.addSubview(selfSubject)
        selfSubject.layer.borderColor = UIColor.black.cgColor
        selfSubject.layer.borderWidth = areaBorderWidth
        self.addTopAnchor(selfSubject, anchor: selfLabel.bottomAnchor, constant: screenWidth * 1/5/6)
        self.addLeadingAnchor(selfSubject, anchor: vsImageView.trailingAnchor, constant: -10)
        self.addWidthAnchor(selfSubject, multiplier: 1/5)
        self.addHeightAnchor(selfSubject, multiplier: 1/5)
        
        let selfSubjectImg: UIImageView = FeedCell.imageView()
        selfSubjectImg.image = UIImage(named: "unknownImage")
        view.addSubview(selfSubjectImg)
        self.addCenterYAnchor(selfSubjectImg, anchor: selfSubject.centerYAnchor, constant: 0)
        self.addCenterXAnchor(selfSubjectImg, anchor: selfSubject.centerXAnchor, constant: 0)
        self.addWidthAnchor(selfSubjectImg, multiplier: 0.8/6)
        self.addHeightAnchor(selfSubjectImg, multiplier: 0.8/6)
        selfSubjectImg.alpha = 0.3
        
        let selfSubjectText : UILabel = FeedCell.labelCreate(11, backColor: UIColor(white: 1, alpha: 0), textColor: UIColor.black)
        selfSubjectText.numberOfLines = 2
        selfSubjectText.text = "SUBJECT\n PICTURE"
        selfSubjectText.sizeToFit()
        
        view.addSubview(selfSubjectText)
        self.addTopAnchor(selfSubjectText, anchor: selfSubject.bottomAnchor, constant: -15)
        self.addCenterXAnchor(selfSubjectText, anchor: selfSubject.centerXAnchor, constant: 0)
        selfSubjectText.heightAnchor.constraint(equalToConstant: 28).isActive = true
        
        let teamArea: UIView = FeedCell.lineForDivider()
        view.addSubview(teamArea)
        teamArea.layer.borderColor = UIColor.black.cgColor
        teamArea.layer.borderWidth = 0.3
        self.addTopAnchor(teamArea, anchor: selfArea.bottomAnchor, constant: 5)
        self.addCenterXAnchor(teamArea, anchor: view.centerXAnchor, constant: 0)
        self.addWidthAnchor(teamArea, multiplier: 0.8 / 1)
        self.addHeightAnchor(teamArea, multiplier: 1 / 3)
        
        let teamLabel : UILabel = FeedCell.labelCreate(12, backColor: UIColor(white: 1, alpha: 0), textColor: UIColor.rgb(0, green: 153, blue: 153))
        teamLabel.text = "TEAM CHALLENGE"
        teamLabel.sizeToFit()
        
        view.addSubview(teamLabel)
        self.addTopAnchor(teamLabel, anchor: teamArea.topAnchor, constant: 5)
        self.addLeadingAnchor(teamLabel, anchor: teamArea.leadingAnchor, constant: 10)
        //self.addWidthAnchor(selfLabel, multiplier: 1)
        teamLabel.heightAnchor.constraint(equalToConstant: 10).isActive = true
        
        let vsImageView1 : UIImageView = FeedCell().vsImageView
        vsImageView1.image = UIImage(named: "vs")
        
        view.addSubview(vsImageView1)
        self.addCenterYAnchor(vsImageView1, anchor: teamArea.centerYAnchor, constant: 0)
        self.addCenterXAnchor(vsImageView1, anchor: view.centerXAnchor, constant: 0)
        self.addWidthAnchor(vsImageView1, multiplier: 2 / 6)
        self.addHeightAnchor(vsImageView1, multiplier: 0.8 / 6)
        
        let subjectLabel1 : UILabel = FeedCell.labelCreate(11, backColor: UIColor(white: 1, alpha: 0), textColor: UIColor.black)
        subjectLabel1.text = "SUBJECT"
        subjectLabel1.sizeToFit()
        
        view.addSubview(subjectLabel1)
        self.addBottomAnchor(subjectLabel1, anchor: teamArea.bottomAnchor, constant: -10)
        self.addCenterXAnchor(subjectLabel1, anchor: teamArea.centerXAnchor, constant: 0)
        subjectLabel1.heightAnchor.constraint(equalToConstant: 10).isActive = true
        
        let teamChallenger: UIView = FeedCell.lineForDivider()
        view.addSubview(teamChallenger)
        teamChallenger.layer.borderColor = UIColor.black.cgColor
        teamChallenger.layer.borderWidth = areaBorderWidth
        self.addTopAnchor(teamChallenger, anchor: teamLabel.bottomAnchor, constant: screenWidth * 1/5/6)
        self.addTrailingAnchor(teamChallenger, anchor: vsImageView1.leadingAnchor, constant: 10)
        self.addWidthAnchor(teamChallenger, multiplier: 0.9/5)
        self.addHeightAnchor(teamChallenger, multiplier: 0.9/5)
        
        let teamChallengerImg: UIImageView = FeedCell.imageView()
        teamChallengerImg.image = UIImage(named: "unknownmono")
        view.addSubview(teamChallengerImg)
        self.addTopAnchor(teamChallengerImg, anchor: teamChallenger.topAnchor, constant: 0)
        self.addLeadingAnchor(teamChallengerImg, anchor: teamChallenger.leadingAnchor, constant: 0)
        self.addWidthAnchor(teamChallengerImg, multiplier: 1/6/2)
        self.addHeightAnchor(teamChallengerImg, multiplier: 1/6/2)
        teamChallengerImg.alpha = 0.3
        
        let teamChallengerImg1: UIImageView = FeedCell.imageView()
        teamChallengerImg1.image = UIImage(named: "unknownmono")
        view.addSubview(teamChallengerImg1)
        self.addTopAnchor(teamChallengerImg1, anchor: teamChallenger.topAnchor, constant: 0)
        self.addTrailingAnchor(teamChallengerImg1, anchor: teamChallenger.trailingAnchor, constant: 0)
        self.addWidthAnchor(teamChallengerImg1, multiplier: 1/6/2)
        self.addHeightAnchor(teamChallengerImg1, multiplier: 1/6/2)
        teamChallengerImg1.alpha = 0.3
        
        let teamChallengerImg2: UIImageView = FeedCell.imageView()
        teamChallengerImg2.image = UIImage(named: "unknownmono")
        view.addSubview(teamChallengerImg2)
        self.addBottomAnchor(teamChallengerImg2, anchor: teamChallenger.bottomAnchor, constant: 0)
        self.addTrailingAnchor(teamChallengerImg2, anchor: teamChallenger.trailingAnchor, constant: 0)
        self.addWidthAnchor(teamChallengerImg2, multiplier: 1/6/2)
        self.addHeightAnchor(teamChallengerImg2, multiplier: 1/6/2)
        teamChallengerImg2.alpha = 0.3
        
        let teamChallengerImg3: UIImageView = FeedCell.imageView()
        teamChallengerImg3.image = UIImage(named: "unknownmono")
        view.addSubview(teamChallengerImg3)
        self.addBottomAnchor(teamChallengerImg3, anchor: teamChallenger.bottomAnchor, constant: 0)
        self.addLeadingAnchor(teamChallengerImg3, anchor: teamChallenger.leadingAnchor, constant: 0)
        self.addWidthAnchor(teamChallengerImg3, multiplier: 1/6/2)
        self.addHeightAnchor(teamChallengerImg3, multiplier: 1/6/2)
        teamChallengerImg3.alpha = 0.3
        
        let teamChallengerText : UILabel = FeedCell.labelCreate(11, backColor: UIColor(white: 1, alpha: 0), textColor: UIColor.black)
        teamChallengerText.text = "TEAM 1"
        teamChallengerText.sizeToFit()
        
        view.addSubview(teamChallengerText)
        self.addTopAnchor(teamChallengerText, anchor: teamChallenger.bottomAnchor, constant: screenWidth*0.1/5)
        self.addCenterXAnchor(teamChallengerText, anchor: teamChallenger.centerXAnchor, constant: 0)
        teamChallengerText.heightAnchor.constraint(equalToConstant: 10).isActive = true
        
        let teamChallenger2: UIView = FeedCell.lineForDivider()
        view.addSubview(teamChallenger2)
        teamChallenger2.layer.borderColor = UIColor.black.cgColor
        teamChallenger2.layer.borderWidth = areaBorderWidth
        self.addTopAnchor(teamChallenger2, anchor: teamLabel.bottomAnchor, constant: screenWidth * 1/5/6)
        self.addLeadingAnchor(teamChallenger2, anchor: vsImageView1.trailingAnchor, constant: -10)
        self.addWidthAnchor(teamChallenger2, multiplier: 0.9/5)
        self.addHeightAnchor(teamChallenger2, multiplier: 0.9/5)
        
        let teamChallenger2Img: UIImageView = FeedCell.imageView()
        teamChallenger2Img.image = UIImage(named: "unknownmono")
        view.addSubview(teamChallenger2Img)
        self.addTopAnchor(teamChallenger2Img, anchor: teamChallenger2.topAnchor, constant: 0)
        self.addLeadingAnchor(teamChallenger2Img, anchor: teamChallenger2.leadingAnchor, constant: 0)
        self.addWidthAnchor(teamChallenger2Img, multiplier: 1/6/2)
        self.addHeightAnchor(teamChallenger2Img, multiplier: 1/6/2)
        teamChallenger2Img.alpha = 0.3
        
        let teamChallenger2Img1: UIImageView = FeedCell.imageView()
        teamChallenger2Img1.image = UIImage(named: "unknownmono")
        view.addSubview(teamChallenger2Img1)
        self.addTopAnchor(teamChallenger2Img1, anchor: teamChallenger2.topAnchor, constant: 0)
        self.addTrailingAnchor(teamChallenger2Img1, anchor: teamChallenger2.trailingAnchor, constant: 0)
        self.addWidthAnchor(teamChallenger2Img1, multiplier: 1/6/2)
        self.addHeightAnchor(teamChallenger2Img1, multiplier: 1/6/2)
        teamChallenger2Img1.alpha = 0.3
        
        let teamChallenger2Img2: UIImageView = FeedCell.imageView()
        teamChallenger2Img2.image = UIImage(named: "unknownmono")
        view.addSubview(teamChallenger2Img2)
        self.addBottomAnchor(teamChallenger2Img2, anchor: teamChallenger2.bottomAnchor, constant: 0)
        self.addTrailingAnchor(teamChallenger2Img2, anchor: teamChallenger2.trailingAnchor, constant: 0)
        self.addWidthAnchor(teamChallenger2Img2, multiplier: 1/6/2)
        self.addHeightAnchor(teamChallenger2Img2, multiplier: 1/6/2)
        teamChallenger2Img2.alpha = 0.3
        
        let teamChallenger2Img3: UIImageView = FeedCell.imageView()
        teamChallenger2Img3.image = UIImage(named: "unknownmono")
        view.addSubview(teamChallenger2Img3)
        self.addBottomAnchor(teamChallenger2Img3, anchor: teamChallenger2.bottomAnchor, constant: 0)
        self.addLeadingAnchor(teamChallenger2Img3, anchor: teamChallenger2.leadingAnchor, constant: 0)
        self.addWidthAnchor(teamChallenger2Img3, multiplier: 1/6/2)
        self.addHeightAnchor(teamChallenger2Img3, multiplier: 1/6/2)
        teamChallenger2Img3.alpha = 0.3
        
        let teamChallenger2Text : UILabel = FeedCell.labelCreate(11, backColor: UIColor(white: 1, alpha: 0), textColor: UIColor.black)
        teamChallenger2Text.text = "TEAM 2"
        teamChallenger2Text.sizeToFit()
        
        view.addSubview(teamChallenger2Text)
        self.addTopAnchor(teamChallenger2Text, anchor: teamChallenger2.bottomAnchor, constant: screenWidth*0.1/5)
        self.addCenterXAnchor(teamChallenger2Text, anchor: teamChallenger2.centerXAnchor, constant: 0)
        teamChallenger2Text.heightAnchor.constraint(equalToConstant: 10).isActive = true
        
        let publicArea: UIView = FeedCell.lineForDivider()
        view.addSubview(publicArea)
        publicArea.layer.borderColor = UIColor.black.cgColor
        publicArea.layer.borderWidth = 0.3
        self.addTopAnchor(publicArea, anchor: teamArea.bottomAnchor, constant: 5)
        self.addCenterXAnchor(publicArea, anchor: view.centerXAnchor, constant: 0)
        self.addWidthAnchor(publicArea, multiplier: 0.8 / 1)
        self.addHeightAnchor(publicArea, multiplier: 1.52 / 3)
        
        let publicLabel : UILabel = FeedCell.labelCreate(12, backColor: UIColor(white: 1, alpha: 0), textColor: navAndTabColor)
        publicLabel.text = "PUBLIC CHALLENGE"
        publicLabel.sizeToFit()
        
        view.addSubview(publicLabel)
        self.addTopAnchor(publicLabel, anchor: publicArea.topAnchor, constant: 5)
        self.addLeadingAnchor(publicLabel, anchor: publicArea.leadingAnchor, constant: 10)
        publicLabel.heightAnchor.constraint(equalToConstant: 10).isActive = true
        
        let vsImageView2 : UIImageView = FeedCell().vsImageView
        vsImageView2.image = UIImage(named: "vs")
        
        view.addSubview(vsImageView2)
        self.addCenterYAnchor(vsImageView2, anchor: publicArea.centerYAnchor, constant: -(screenWidth * 0.5 / 6))
        self.addCenterXAnchor(vsImageView2, anchor: view.centerXAnchor, constant: 0)
        self.addWidthAnchor(vsImageView2, multiplier: 2 / 6)
        self.addHeightAnchor(vsImageView2, multiplier: 0.8 / 6)
        
        let subjectLabel2 : UILabel = FeedCell.labelCreate(11, backColor: UIColor(white: 1, alpha: 0), textColor: UIColor.black)
        subjectLabel2.text = "SUBJECT"
        subjectLabel2.sizeToFit()
        
        view.addSubview(subjectLabel2)
        self.addTopAnchor(subjectLabel2, anchor: vsImageView2.bottomAnchor, constant: screenWidth * 0.175 / 3)
        self.addCenterXAnchor(subjectLabel2, anchor: publicArea.centerXAnchor, constant: 0)
        subjectLabel2.heightAnchor.constraint(equalToConstant: 10).isActive = true
        
        let publicChallenger: UIView = FeedCell.lineForDivider()
        view.addSubview(publicChallenger)
        publicChallenger.layer.borderColor = UIColor.black.cgColor
        publicChallenger.layer.borderWidth = areaBorderWidth
        self.addTopAnchor(publicChallenger, anchor: publicLabel.bottomAnchor, constant: screenWidth * 1/5/6)
        self.addTrailingAnchor(publicChallenger, anchor: vsImageView2.leadingAnchor, constant: 10)
        self.addWidthAnchor(publicChallenger, multiplier: 1/5)
        self.addHeightAnchor(publicChallenger, multiplier: 1/5)
        
        let publicChallengerImg: UIImageView = FeedCell.imageView()
        publicChallengerImg.image = UIImage(named: "unknownmono")
        view.addSubview(publicChallengerImg)
        self.addCenterYAnchor(publicChallengerImg, anchor: publicChallenger.centerYAnchor, constant: 0)
        self.addCenterXAnchor(publicChallengerImg, anchor: publicChallenger.centerXAnchor, constant: 0)
        self.addWidthAnchor(publicChallengerImg, multiplier: 1/6)
        self.addHeightAnchor(publicChallengerImg, multiplier: 1/6)
        publicChallengerImg.alpha = 0.3
        
        let publicChallengerText : UILabel = FeedCell.labelCreate(11, backColor: UIColor(white: 1, alpha: 0), textColor: UIColor.black)
        publicChallengerText.text = "CHALLENGER"
        publicChallengerText.sizeToFit()
        
        view.addSubview(publicChallengerText)
        self.addTopAnchor(publicChallengerText, anchor: publicChallenger.bottomAnchor, constant: 0.5)
        self.addCenterXAnchor(publicChallengerText, anchor: publicChallenger.centerXAnchor, constant: 0)
        publicChallengerText.heightAnchor.constraint(equalToConstant: 10).isActive = true
        
        let publicChallenger2: UIView = FeedCell.lineForDivider()
        view.addSubview(publicChallenger2)
        publicChallenger2.layer.borderColor = UIColor.black.cgColor
        publicChallenger2.layer.borderWidth = areaBorderWidth
        self.addTopAnchor(publicChallenger2, anchor: publicLabel.bottomAnchor, constant: screenWidth * 1/5/6)
        self.addLeadingAnchor(publicChallenger2, anchor: vsImageView1.trailingAnchor, constant: -10)
        self.addWidthAnchor(publicChallenger2, multiplier: 0.9/5)
        self.addHeightAnchor(publicChallenger2, multiplier: 0.9/5)
        
        let publicChallenger2Img: UIImageView = FeedCell.imageView()
        publicChallenger2Img.image = UIImage(named: "unknownmono")
        view.addSubview(publicChallenger2Img)
        self.addTopAnchor(publicChallenger2Img, anchor: publicChallenger2.topAnchor, constant: 0)
        self.addLeadingAnchor(publicChallenger2Img, anchor: publicChallenger2.leadingAnchor, constant: 0)
        self.addWidthAnchor(publicChallenger2Img, multiplier: 1/6/2)
        self.addHeightAnchor(publicChallenger2Img, multiplier: 1/6/2)
        publicChallenger2Img.alpha = 0.3
        
        let publicChallenger2Img1: UIImageView = FeedCell.imageView()
        publicChallenger2Img1.image = UIImage(named: "unknownmono")
        view.addSubview(publicChallenger2Img1)
        self.addTopAnchor(publicChallenger2Img1, anchor: publicChallenger2.topAnchor, constant: 0)
        self.addTrailingAnchor(publicChallenger2Img1, anchor: publicChallenger2.trailingAnchor, constant: 0)
        self.addWidthAnchor(publicChallenger2Img1, multiplier: 1/6/2)
        self.addHeightAnchor(publicChallenger2Img1, multiplier: 1/6/2)
        publicChallenger2Img1.alpha = 0.3
        
        let publicChallenger2Img2: UIImageView = FeedCell.imageView()
        publicChallenger2Img2.image = UIImage(named: "unknownmono")
        view.addSubview(publicChallenger2Img2)
        self.addBottomAnchor(publicChallenger2Img2, anchor: publicChallenger2.bottomAnchor, constant: 0)
        self.addTrailingAnchor(publicChallenger2Img2, anchor: publicChallenger2.trailingAnchor, constant: 0)
        self.addWidthAnchor(publicChallenger2Img2, multiplier: 1/6/2)
        self.addHeightAnchor(publicChallenger2Img2, multiplier: 1/6/2)
        publicChallenger2Img2.alpha = 0.3
        
        let publicChallenger2Img3: UIImageView = FeedCell.imageView()
        publicChallenger2Img3.image = UIImage(named: "unknownmono")
        view.addSubview(publicChallenger2Img3)
        self.addBottomAnchor(publicChallenger2Img3, anchor: publicChallenger2.bottomAnchor, constant: 0)
        self.addLeadingAnchor(publicChallenger2Img3, anchor: publicChallenger2.leadingAnchor, constant: 0)
        self.addWidthAnchor(publicChallenger2Img3, multiplier: 1/6/2)
        self.addHeightAnchor(publicChallenger2Img3, multiplier: 1/6/2)
        publicChallenger2Img3.alpha = 0.3
        
        let publicChallenger2Text : UILabel = FeedCell.labelCreate(11, backColor: UIColor(white: 1, alpha: 0), textColor: UIColor.black)
        publicChallenger2Text.text = "PARTICIPANTS"
        publicChallenger2Text.sizeToFit()
        
        view.addSubview(publicChallenger2Text)
        self.addTopAnchor(publicChallenger2Text, anchor: publicChallenger2.bottomAnchor, constant: screenWidth*0.1/5)
        self.addCenterXAnchor(publicChallenger2Text, anchor: publicChallenger2.centerXAnchor, constant: 0)
        publicChallenger2Text.heightAnchor.constraint(equalToConstant: 10).isActive = true
        
        let proof: UIView = FeedCell.lineForDivider()
        view.addSubview(proof)
        proof.layer.borderColor = UIColor.black.cgColor
        proof.layer.borderWidth = 0.3
        self.addBottomAnchor(proof, anchor: publicArea.bottomAnchor, constant: -10)
        self.addCenterXAnchor(proof, anchor: view.centerXAnchor, constant: 0)
        self.addWidthAnchor(proof, multiplier: 0.75 / 1)
        self.addHeightAnchor(proof, multiplier: 0.40 / 3)
        
        let proofText : UILabel = FeedCell.labelCreate(11, backColor: UIColor(white: 1, alpha: 0), textColor: UIColor.black)
        proofText.text = "PROOF OF CHALLENGE"
        proofText.sizeToFit()
        
        view.addSubview(proofText)
        self.addCenterYAnchor(proofText, anchor: proof.centerYAnchor, constant: 0)
        self.addCenterXAnchor(proofText, anchor: proof.centerXAnchor, constant: 0)
        proofText.heightAnchor.constraint(equalToConstant: 10).isActive = true                
        
        return view
    }
    
    class func image(view: UIView, subview: UIView? = nil, isWide: Bool) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: view.frame.size.width, height: view.frame.size.height*(isWide ? 8.6 : 9.1)/10), true, 0)
        view.drawHierarchy(in: view.frame, afterScreenUpdates: true)
        var image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        if(subview != nil){
            var rect = (subview?.frame)!
            rect.size.height *= image.scale  //MOST IMPORTANT
            rect.size.width *= image.scale    //TOOK ME DAYS TO FIGURE THIS OUT
            let imageRef = image.cgImage!.cropping(to: rect)
            image = UIImage(cgImage: imageRef!, scale: image.scale, orientation: image.imageOrientation)
        }
        return image
    }
    
    func image(_ isWide: Bool) -> UIImage? {
        return UIView.image(view: self, isWide: isWide)
    }
    
    func image(_ withSubview: UIView, isWide: Bool) -> UIImage? {
        return UIView.image(view: self, subview: withSubview, isWide: isWide)
    }
    
    func shareScreenshotToInstagram(_ image: UIImage) {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let checkValidation = FileManager.default
        let getImagePath = paths.appending("image.igo")
        try?  checkValidation.removeItem(atPath: getImagePath)
        let imageData =  UIImageJPEGRepresentation(image, 1.0)
        try? imageData?.write(to: URL.init(fileURLWithPath: getImagePath), options: .atomicWrite)
        var documentController : UIDocumentInteractionController!
        documentController = UIDocumentInteractionController.init(url: URL.init(fileURLWithPath: getImagePath))
        documentController.uti = "com.instagram.exclusivegram"
        documentController.presentOptionsMenu(from: self.frame, in: self, animated: true)
    }
}
