//
//  AddChallengeView.swift
//  facebookfeed2
//
//  Created by iakay on 6.03.2018.
//  Copyright © 2018 challenge. All rights reserved.
//

import UIKit
import FBSDKCoreKit

class AddChallengeView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var widthOfImage: CGFloat = 1/3
    var heightOfFullImage: CGFloat = 1/2
    var heightOfHalfImage: CGFloat = 0.975/4
    var widthOfQuarterImage: CGFloat = 0.975/6
    var heightOfMiddle: CGFloat = 0.05/4
    var widthOfMiddle: CGFloat = 0.05/6
    var pickerData: [String] = [String]()

    func setupViews() {
        let contentGuide = self.readableContentGuide
        addLayoutGuide(middleHeight)
        addLayoutGuide(rightMiddleTopWidth)
        addLayoutGuide(leftMiddleTopWidth)
        addLayoutGuide(rightMiddleBottomWidth)
        addLayoutGuide(leftMiddleBottomWidth)
        
        addSubview(challengeView)
        addTopAnchor(challengeView, anchor: contentGuide.topAnchor, constant: -7)
        challengeView.centerXAnchor.constraint(equalTo: contentGuide.centerXAnchor, constant: 0).isActive = true
        addHeightAnchor(challengeView, multiplier: heightOfFullImage + (1/15) + (0.5/30))
        addWidthAnchor(challengeView, multiplier: 1)
        
        let middleCenterGuide = UILayoutGuide()
        let middleBottomGuide = UILayoutGuide()
        challengeView.addLayoutGuide(middleTopGuide)
        challengeView.addLayoutGuide(middleCenterGuide)
        challengeView.addLayoutGuide(middleBottomGuide)
        
        let screenSize = UIScreen.main.bounds
        
        middleTopGuide.heightAnchor.constraint(equalToConstant: screenWidth * 1 / 6).isActive = true
        
        middleTopGuide.topAnchor.constraint(equalTo: challengeView.topAnchor, constant: 1).isActive = true
        
        addSubview(finishFlag)
        addBottomAnchor(finishFlag, anchor: middleTopGuide.bottomAnchor, constant: -(screenWidth * 0.15 / 6))
        addWidthAnchor(finishFlag, multiplier: 0.8 / 6)
        finishFlag.centerXAnchor.constraint(equalTo: contentGuide.centerXAnchor).isActive = true
        addHeightAnchor(finishFlag, multiplier: 0.8 / 6)
        finishFlag.isHidden = true
        
        addSubview(score)
        addTopAnchor(score, anchor: finishFlag.bottomAnchor, constant: -(screenSize.width * 0.8 / 18))
        score.centerXAnchor.constraint(equalTo: contentGuide.centerXAnchor).isActive = true
        addWidthAnchor(score, multiplier: 1.2 / 6)
        addHeightAnchor(score, multiplier: 0.4 / 6)
        score.backgroundColor = navAndTabColor
        score.textColor = UIColor.white
        score.layer.cornerRadius = 5
        score.layer.masksToBounds = true
        score.font = UIFont.boldSystemFont(ofSize: 10)
        score.isHidden = true
        
        addSubview(untilDateLabel)
        addBottomAnchor(untilDateLabel, anchor: middleTopGuide.bottomAnchor, constant: 0)
        addWidthAnchor(untilDateLabel, multiplier: 0.7/3)
        untilDateLabel.centerXAnchor.constraint(equalTo: contentGuide.centerXAnchor).isActive = true
        addHeightAnchor(untilDateLabel, multiplier: 1/6)
        
        challengeView.addSubview(vsImageView)
        challengeView.addTopAnchor(vsImageView, anchor: middleTopGuide.bottomAnchor, constant: 0)
        vsImageView.centerXAnchor.constraint(equalTo: contentGuide.centerXAnchor).isActive = true
        challengeView.addHeightAnchor(vsImageView, multiplier: 1/6)
        
        middleCenterGuide.heightAnchor.constraint(equalToConstant: screenSize.width * 0/18).isActive = true
        middleCenterGuide.topAnchor.constraint(equalTo: vsImageView.bottomAnchor).isActive = true
        
        addSubview(clapping)
        addTopAnchor(clapping, anchor: middleCenterGuide.bottomAnchor, constant: screenSize.width * 0.3 / 18)
        clapping.centerXAnchor.constraint(equalTo: contentGuide.centerXAnchor).isActive = true
        addWidthAnchor(clapping, multiplier: 0.8 / 6)
        addHeightAnchor(clapping, multiplier: 0.8 / 6)
        clapping.isHidden = true
        
        middleBottomGuide.heightAnchor.constraint(equalToConstant: screenSize.width * 0).isActive = true
        middleBottomGuide.topAnchor.constraint(equalTo: vsImageView.bottomAnchor, constant: screenSize.width * 1/6).isActive = true
        
        challengeView.addSubview(firstOneChlrPeopleImageView)
        challengeView.addTopAnchor(firstOneChlrPeopleImageView, anchor: middleTopGuide.topAnchor, constant: 2)
        challengeView.addLeadingAnchor(firstOneChlrPeopleImageView, anchor: contentGuide.leadingAnchor, constant: 0)
        challengeView.addWidthAnchor(firstOneChlrPeopleImageView, multiplier: widthOfImage)
        challengeView.addHeightAnchor(firstOneChlrPeopleImageView, multiplier: heightOfFullImage)
        
        challengeView.addSubview(firstOnePeopleImageView)
        addTopAnchor(firstOnePeopleImageView, anchor: middleTopGuide.topAnchor, constant: 2)
        addTrailingAnchor(firstOnePeopleImageView, anchor: contentGuide.trailingAnchor, constant: 0)
        addWidthAnchor(firstOnePeopleImageView, multiplier: widthOfImage)
        addHeightAnchor(firstOnePeopleImageView, multiplier: heightOfFullImage)
        
        if(FBSDKAccessToken.current().userID != nil) {
            setImage(fbID: FBSDKAccessToken.current().userID, imageView: firstOneChlrPeopleImageView)
        }
        firstOnePeopleImageView.image = UIImage(named: "unknown")

        vsImageView.image = UIImage(named: "vs")
        
        untilDateLabel.text = "DeadLine"
        untilDateLabel.font = UIFont (name: "Marker Felt", size: 24)
        untilDateLabel.textAlignment = .center
        untilDateLabel.numberOfLines = 2;
        untilDateLabel.textColor = UIColor.gray
        
        challengeView.addSubview(subjectLabel)
        challengeView.addTopAnchor(subjectLabel, anchor: middleBottomGuide.bottomAnchor, constant: screenWidth * 0.1 / 10)
        subjectLabel.centerXAnchor.constraint(equalTo: contentGuide.centerXAnchor).isActive = true
        challengeView.addHeightAnchor(subjectLabel, multiplier: 1/15)
        
        subjectLabel.text = "SUBJECT"
        subjectLabel.font = UIFont (name: "Marker Felt", size: 20)
        subjectLabel.textAlignment = .center
        subjectLabel.numberOfLines = 2;
        subjectLabel.textColor = UIColor.gray
        subjectLabel.backgroundColor = UIColor(white: 1, alpha: 0)
    }
    
    func removeChlrFromChallengeView(challengeView : UIView) {
        self.firstOneChlrPeopleImageView.removeFromSuperview()
        self.firstTwoChlrPeopleImageView.removeFromSuperview()
        self.secondTwoChlrPeopleImageView.removeFromSuperview()
        self.firstThreeChlrPeopleImageView.removeFromSuperview()
        self.secondThreeChlrPeopleImageView.removeFromSuperview()
        self.thirdThreePeopleImageView.removeFromSuperview()
        self.firstFourPeopleImageView.removeFromSuperview()
        self.secondFourPeopleImageView.removeFromSuperview()
        self.thirdFourPeopleImageView.removeFromSuperview()
        self.moreFourPeopleImageView.removeFromSuperview()
    }
    
    func generateFirstTeam(count : Int) {
        removeChlrFromChallengeView(challengeView: self.challengeView)
        let contentGuide = self.readableContentGuide
        let screenSize = UIScreen.main.bounds
        middleHeight.heightAnchor.constraint(equalToConstant: screenSize.width * heightOfMiddle).isActive = true
        if count == 1 {
            challengeView.addSubview(firstOneChlrPeopleImageView)
            challengeView.addTopAnchor(firstOneChlrPeopleImageView, anchor: middleTopGuide.topAnchor, constant: 2)
            challengeView.addLeadingAnchor(firstOneChlrPeopleImageView, anchor: contentGuide.leadingAnchor, constant: 0)
            challengeView.addWidthAnchor(firstOneChlrPeopleImageView, multiplier: widthOfImage)
            challengeView.addHeightAnchor(firstOneChlrPeopleImageView, multiplier: heightOfFullImage)
        } else if count == 2 {
            challengeView.addSubview(firstTwoChlrPeopleImageView)
            addTopAnchor(firstTwoChlrPeopleImageView, anchor: middleTopGuide.topAnchor, constant: 2)
            addLeadingAnchor(firstTwoChlrPeopleImageView, anchor: contentGuide.leadingAnchor, constant: 2)
            addBottomAnchor(firstTwoChlrPeopleImageView, anchor: middleHeight.topAnchor, constant: 0)
            addWidthAnchor(firstTwoChlrPeopleImageView, multiplier: widthOfImage)
            addHeightAnchor(firstTwoChlrPeopleImageView, multiplier: heightOfHalfImage)
            middleHeight.topAnchor.constraint(equalTo: firstTwoChlrPeopleImageView.bottomAnchor)
            challengeView.addSubview(secondTwoChlrPeopleImageView)
            addTopAnchor(secondTwoChlrPeopleImageView, anchor: middleHeight.bottomAnchor, constant: -2)
            addLeadingAnchor(secondTwoChlrPeopleImageView, anchor: contentGuide.leadingAnchor, constant: 2)
            addWidthAnchor(secondTwoChlrPeopleImageView, multiplier: widthOfImage)
            addHeightAnchor(secondTwoChlrPeopleImageView, multiplier: heightOfHalfImage)
        } else if count == 3 {
            let screenSize = UIScreen.main.bounds
            leftMiddleTopWidth.widthAnchor.constraint(equalToConstant: screenSize.width * widthOfMiddle)
            challengeView.addSubview(firstThreeChlrPeopleImageView)
            addTopAnchor(firstThreeChlrPeopleImageView, anchor: middleTopGuide.topAnchor, constant: 2)
            addLeadingAnchor(firstThreeChlrPeopleImageView, anchor: contentGuide.leadingAnchor, constant: 2)
            addTrailingAnchor(firstThreeChlrPeopleImageView, anchor: leftMiddleTopWidth.leadingAnchor, constant: 0)
            addBottomAnchor(firstThreeChlrPeopleImageView, anchor: middleHeight.topAnchor, constant: 0)
            addWidthAnchor(firstThreeChlrPeopleImageView, multiplier: widthOfQuarterImage)
            addHeightAnchor(firstThreeChlrPeopleImageView, multiplier: heightOfHalfImage)
            leftMiddleTopWidth.trailingAnchor.constraint(equalTo: secondThreeChlrPeopleImageView.leadingAnchor)
            challengeView.addSubview(secondThreeChlrPeopleImageView)
            addTopAnchor(secondThreeChlrPeopleImageView, anchor: middleTopGuide.topAnchor, constant: 2)
            addLeadingAnchor(secondThreeChlrPeopleImageView, anchor: leftMiddleTopWidth.trailingAnchor, constant: 2)
            addWidthAnchor(secondThreeChlrPeopleImageView, multiplier: widthOfQuarterImage)
            addHeightAnchor(secondThreeChlrPeopleImageView, multiplier: heightOfHalfImage)
            middleHeight.topAnchor.constraint(equalTo: firstThreeChlrPeopleImageView.bottomAnchor)
            challengeView.addSubview(thirdThreeChlrPeopleImageView)
            addTopAnchor(thirdThreeChlrPeopleImageView, anchor: middleHeight.bottomAnchor, constant: -2)
            addLeadingAnchor(thirdThreeChlrPeopleImageView, anchor: contentGuide.leadingAnchor, constant: 2)
            addWidthAnchor(thirdThreeChlrPeopleImageView, multiplier: widthOfImage)
            addHeightAnchor(thirdThreeChlrPeopleImageView, multiplier: heightOfHalfImage)
        } else {
            let screenSize = UIScreen.main.bounds
            leftMiddleTopWidth.widthAnchor.constraint(equalToConstant: screenSize.width * widthOfMiddle)
            leftMiddleBottomWidth.widthAnchor.constraint(equalToConstant: screenSize.width * widthOfMiddle)
            challengeView.addSubview(firstFourChlrPeopleImageView)
            addTopAnchor(firstFourChlrPeopleImageView, anchor: middleTopGuide.topAnchor, constant: 2)
            addLeadingAnchor(firstFourChlrPeopleImageView, anchor: contentGuide.leadingAnchor, constant: 2)
            addTrailingAnchor(firstFourChlrPeopleImageView, anchor: leftMiddleTopWidth.leadingAnchor, constant: 0)
            addBottomAnchor(firstFourChlrPeopleImageView, anchor: middleHeight.topAnchor, constant: 0)
            addWidthAnchor(firstFourChlrPeopleImageView, multiplier: widthOfQuarterImage)
            addHeightAnchor(firstFourChlrPeopleImageView, multiplier: heightOfHalfImage)
            leftMiddleTopWidth.trailingAnchor.constraint(equalTo: secondFourChlrPeopleImageView.leadingAnchor)
            challengeView.addSubview(secondFourChlrPeopleImageView)
            addTopAnchor(secondFourChlrPeopleImageView, anchor: middleTopGuide.topAnchor, constant: 2)
            addLeadingAnchor(secondFourChlrPeopleImageView, anchor: leftMiddleTopWidth.trailingAnchor, constant: 2)
            addWidthAnchor(secondFourChlrPeopleImageView, multiplier: widthOfQuarterImage)
            addHeightAnchor(secondFourChlrPeopleImageView, multiplier: heightOfHalfImage)
            middleHeight.topAnchor.constraint(equalTo: firstFourChlrPeopleImageView.bottomAnchor)
            challengeView.addSubview(thirdFourChlrPeopleImageView)
            addTopAnchor(thirdFourChlrPeopleImageView, anchor: middleHeight.bottomAnchor, constant: -2)
            addLeadingAnchor(thirdFourChlrPeopleImageView, anchor: contentGuide.leadingAnchor, constant: 2)
            addTrailingAnchor(thirdFourChlrPeopleImageView, anchor: leftMiddleBottomWidth.leadingAnchor, constant: 0)
            addWidthAnchor(thirdFourChlrPeopleImageView, multiplier: widthOfQuarterImage)
            addHeightAnchor(thirdFourChlrPeopleImageView, multiplier: heightOfHalfImage)
            leftMiddleBottomWidth.trailingAnchor.constraint(equalTo: moreFourChlrPeopleImageView.leadingAnchor)
            challengeView.addSubview(moreFourChlrPeopleImageView)
            moreFourChlrPeopleImageView.contentMode = .scaleAspectFit
            addBottomAnchor(moreFourChlrPeopleImageView, anchor: thirdFourChlrPeopleImageView.bottomAnchor, constant: 0)
            addLeadingAnchor(moreFourChlrPeopleImageView, anchor: leftMiddleBottomWidth.trailingAnchor, constant: 2)
            addWidthAnchor(moreFourChlrPeopleImageView, multiplier: widthOfQuarterImage)
            addHeightAnchor(moreFourChlrPeopleImageView, multiplier: heightOfHalfImage)
        }
    }
    
    func removeFromChallengeView(challengeView : UIView) {
        self.firstOnePeopleImageView.removeFromSuperview()
        self.firstTwoPeopleImageView.removeFromSuperview()
        self.secondTwoPeopleImageView.removeFromSuperview()
        self.firstThreePeopleImageView.removeFromSuperview()
        self.secondThreePeopleImageView.removeFromSuperview()
        self.secondThreePeopleImageView.removeFromSuperview()
        self.thirdThreePeopleImageView.removeFromSuperview()
        self.firstFourPeopleImageView.removeFromSuperview()
        self.secondFourPeopleImageView.removeFromSuperview()
        self.thirdFourPeopleImageView.removeFromSuperview()
        self.moreFourPeopleImageView.removeFromSuperview()
    }
    
    func generateSecondTeam(count : Int) {
        removeFromChallengeView(challengeView: self.challengeView)
        let contentGuide = self.readableContentGuide
        let screenSize = UIScreen.main.bounds
        middleHeight.heightAnchor.constraint(equalToConstant: screenSize.width * heightOfMiddle).isActive = true
        if count == 1 {
            challengeView.addSubview(firstOnePeopleImageView)
            addTopAnchor(firstOnePeopleImageView, anchor: middleTopGuide.topAnchor, constant: 2)
            addTrailingAnchor(firstOnePeopleImageView, anchor: contentGuide.trailingAnchor, constant: 0)
            addWidthAnchor(firstOnePeopleImageView, multiplier: widthOfImage)
            addHeightAnchor(firstOnePeopleImageView, multiplier: heightOfFullImage)
        } else if count == 2 {
            challengeView.addSubview(firstTwoPeopleImageView)
            addTopAnchor(firstTwoPeopleImageView, anchor: middleTopGuide.topAnchor, constant: 2)
            addTrailingAnchor(firstTwoPeopleImageView, anchor: contentGuide.trailingAnchor, constant: 0)
            addBottomAnchor(firstTwoPeopleImageView, anchor: middleHeight.topAnchor, constant: 0)
            addWidthAnchor(firstTwoPeopleImageView, multiplier: widthOfImage)
            addHeightAnchor(firstTwoPeopleImageView, multiplier: heightOfHalfImage)
            middleHeight.topAnchor.constraint(equalTo: firstTwoPeopleImageView.bottomAnchor)
            challengeView.addSubview(secondTwoPeopleImageView)
            addTopAnchor(secondTwoPeopleImageView, anchor: middleHeight.bottomAnchor, constant: -2)
            addTrailingAnchor(secondTwoPeopleImageView, anchor: contentGuide.trailingAnchor, constant: 0)
            addWidthAnchor(secondTwoPeopleImageView, multiplier: widthOfImage)
            addHeightAnchor(secondTwoPeopleImageView, multiplier: heightOfHalfImage)
        } else if count == 3 {
            rightMiddleBottomWidth.widthAnchor.constraint(equalToConstant: screenSize.width * widthOfMiddle)
            challengeView.addSubview(firstThreePeopleImageView)
            addTopAnchor(firstThreePeopleImageView, anchor: middleTopGuide.topAnchor, constant: 2)
            addTrailingAnchor(firstThreePeopleImageView, anchor: rightMiddleTopWidth.leadingAnchor, constant: 0)
            addWidthAnchor(firstThreePeopleImageView, multiplier: widthOfQuarterImage)
            addHeightAnchor(firstThreePeopleImageView, multiplier: heightOfHalfImage)
            addBottomAnchor(firstThreePeopleImageView, anchor: middleHeight.topAnchor, constant: 0)
            rightMiddleTopWidth.trailingAnchor.constraint(equalTo: secondThreePeopleImageView.leadingAnchor)
            challengeView.addSubview(secondThreePeopleImageView)
            addTopAnchor(secondThreePeopleImageView, anchor: middleTopGuide.bottomAnchor, constant: 2)
            addLeadingAnchor(secondThreePeopleImageView, anchor: rightMiddleTopWidth.trailingAnchor, constant: 2)
            addTrailingAnchor(secondThreePeopleImageView, anchor: contentGuide.trailingAnchor, constant: 0)
            addWidthAnchor(secondThreePeopleImageView, multiplier: widthOfQuarterImage)
            addHeightAnchor(secondThreePeopleImageView, multiplier: heightOfHalfImage)
            middleHeight.topAnchor.constraint(equalTo: firstThreePeopleImageView.bottomAnchor)
            challengeView.addSubview(thirdThreePeopleImageView)
            addTopAnchor(thirdThreePeopleImageView, anchor: middleHeight.bottomAnchor, constant: -2)
            addTrailingAnchor(thirdThreePeopleImageView, anchor: contentGuide.trailingAnchor, constant: 0)
            addWidthAnchor(thirdThreePeopleImageView, multiplier: widthOfImage)
            addHeightAnchor(thirdThreePeopleImageView, multiplier: heightOfHalfImage)
        } else {
            rightMiddleBottomWidth.widthAnchor.constraint(equalToConstant: screenSize.width * widthOfMiddle)
            challengeView.addSubview(firstFourPeopleImageView)
            addTopAnchor(firstFourPeopleImageView, anchor: middleTopGuide.topAnchor, constant: 2)
            addTrailingAnchor(firstFourPeopleImageView, anchor: rightMiddleTopWidth.leadingAnchor, constant: 0)
            addBottomAnchor(firstFourPeopleImageView, anchor: middleHeight.topAnchor, constant: 0)
            addWidthAnchor(firstFourPeopleImageView, multiplier: widthOfQuarterImage)
            addHeightAnchor(firstFourPeopleImageView, multiplier: heightOfHalfImage)
            rightMiddleTopWidth.trailingAnchor.constraint(equalTo: secondFourPeopleImageView.leadingAnchor)
            challengeView.addSubview(secondFourPeopleImageView)
            addTopAnchor(secondFourPeopleImageView, anchor: middleTopGuide.topAnchor, constant: 2)
            addLeadingAnchor(secondFourPeopleImageView, anchor: rightMiddleTopWidth.trailingAnchor, constant: 2)
            addTrailingAnchor(secondFourPeopleImageView, anchor: contentGuide.trailingAnchor, constant: 0)
            addWidthAnchor(secondFourPeopleImageView, multiplier: widthOfQuarterImage)
            addHeightAnchor(secondFourPeopleImageView, multiplier: heightOfHalfImage)
            middleHeight.topAnchor.constraint(equalTo: firstFourPeopleImageView.bottomAnchor)
            challengeView.addSubview(thirdFourPeopleImageView)
            addTopAnchor(thirdFourPeopleImageView, anchor: middleHeight.bottomAnchor, constant: -2)
            addTrailingAnchor(thirdFourPeopleImageView, anchor: rightMiddleBottomWidth.leadingAnchor, constant: 0)
            addWidthAnchor(thirdFourPeopleImageView, multiplier: widthOfQuarterImage)
            addHeightAnchor(thirdFourPeopleImageView, multiplier: heightOfHalfImage)
            rightMiddleBottomWidth.trailingAnchor.constraint(equalTo: moreFourPeopleImageView.leadingAnchor)
            challengeView.addSubview(moreFourPeopleImageView)
            moreFourPeopleImageView.contentMode = .scaleAspectFit
            addBottomAnchor(moreFourPeopleImageView, anchor: thirdFourPeopleImageView.bottomAnchor, constant: 0)
            addLeadingAnchor(moreFourPeopleImageView, anchor: rightMiddleBottomWidth.trailingAnchor, constant: 2)
            addTrailingAnchor(moreFourPeopleImageView, anchor: contentGuide.trailingAnchor, constant: 0)
            addWidthAnchor(moreFourPeopleImageView, multiplier: widthOfQuarterImage)
            addHeightAnchor(moreFourPeopleImageView, multiplier: heightOfHalfImage)
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    let firstOnePeopleImageView: UIImageView = FeedCell.imageView()
    let firstOneChlrPeopleImageView: UIImageView = FeedCell.imageView()
    let firstTwoPeopleImageView: UIImageView = FeedCell.imageView()
    let secondTwoPeopleImageView: UIImageView = FeedCell.imageView()
    let firstThreePeopleImageView: UIImageView = FeedCell.imageView()
    let secondThreePeopleImageView: UIImageView = FeedCell.imageView()
    let thirdThreePeopleImageView: UIImageView = FeedCell.imageView()
    let firstFourPeopleImageView: UIImageView = FeedCell.imageView()
    let secondFourPeopleImageView: UIImageView = FeedCell.imageView()
    let thirdFourPeopleImageView: UIImageView = FeedCell.imageView()
    let moreFourPeopleImageView: UIImageView = FeedCell.imageView()
    let firstTwoChlrPeopleImageView: UIImageView = FeedCell.imageView()
    let secondTwoChlrPeopleImageView: UIImageView = FeedCell.imageView()
    let firstThreeChlrPeopleImageView: UIImageView = FeedCell.imageView()
    let secondThreeChlrPeopleImageView: UIImageView = FeedCell.imageView()
    let thirdThreeChlrPeopleImageView: UIImageView = FeedCell.imageView()
    let firstFourChlrPeopleImageView: UIImageView = FeedCell.imageView()
    let secondFourChlrPeopleImageView: UIImageView = FeedCell.imageView()
    let thirdFourChlrPeopleImageView: UIImageView = FeedCell.imageView()
    let moreFourChlrPeopleImageView: UIImageView = FeedCell.imageView()
    
    let subjectLabel: UILabel = FeedCell.labelCreate(12, backColor: UIColor.white, textColor: UIColor.black)
    
    let challengeView: UIView = FeedCell.viewFunc()
    
    static func segmentedControl(myArray : NSArray) -> UISegmentedControl {
        let mySegControl : UISegmentedControl = UISegmentedControl(items: myArray as [AnyObject])
        mySegControl.backgroundColor = UIColor.white
        mySegControl.layer.cornerRadius = 5.0
        mySegControl.tintColor = UIColor.rgb(0, green: 123, blue: 255)
        return mySegControl
    }
    
    let mySegControl: UISegmentedControl = AddChallengeView.segmentedControl(myArray: ["Public", "Self", "Private"])
    
    let untilDateLabel: UILabel = FeedCell.labelCreate(9, backColor: UIColor.white, textColor: UIColor.white)
    let finishFlag: UIButton = FeedCell.buttonForTitle("", imageName: "finishFlag")
    
    let vsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.semanticContentAttribute = .forceRightToLeft
        return imageView
    }()
    
    let middleHeight = UILayoutGuide()
    let middleTopGuide = UILayoutGuide()
    let rightMiddleTopWidth = UILayoutGuide()
    let leftMiddleTopWidth = UILayoutGuide()
    let rightMiddleBottomWidth = UILayoutGuide()
    let leftMiddleBottomWidth = UILayoutGuide()
    
    let clapping = FeedCell.buttonForTitle("", imageName: "clap")
    let score: UILabel = FeedCell.label(12)
}
