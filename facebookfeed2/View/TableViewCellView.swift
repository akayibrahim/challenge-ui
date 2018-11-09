//
//  TableViewCellContent.swift
//  facebookfeed2
//
//  Created by iakay on 27.03.2018.
//  Copyright © 2018 challenge. All rights reserved.
//

import UIKit
import FBSDKCoreKit

class TableViewCellContent: UITableViewCell {
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    @objc var pickerData: [String] = [String]()
    @objc var myUIPicker: UIPickerView!
    @objc var isDone: UISwitch = UISwitch(frame:CGRect(x: 150, y: 300, width: 0, height: 0))
    @objc var datePicker: UIDatePicker = UIDatePicker(frame:CGRect(x: 150, y: 300, width: 0, height: 0))
    @objc var addChallenge = AddChallengeView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: (UIScreen.main.bounds.width * 17.5/30) + 22))
    
    @objc let screenSize = UIScreen.main.bounds
    @objc var chlViewHeight: CGFloat = 17.5/30
    @objc var tableRowHeightHeight: CGFloat = 44
    
    var firstTeamScore: Int!
    var secondTeamScore: Int!
    var homeWin: Bool!
    var awayWin: Bool!
    @objc init(frame: CGRect, cellRow : Int, typeIndex : Int) {
        super.init(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        let contentGuide = self.readableContentGuide
        
        if cellRow != segControlIndexPath.row {
            addSubview(label)
            addLeadingAnchor(label, anchor: contentGuide.leadingAnchor, constant: 6)
            label.centerYAnchor.constraint(equalTo: contentGuide.centerYAnchor, constant: 0).isActive = true
            label.font = UIFont.systemFont(ofSize: 16)
            label.textColor = UIColor.gray
        } else {
            addSubview(mySegControl)
            mySegControl.centerXAnchor.constraint(equalTo: contentGuide.centerXAnchor, constant: 0).isActive = true
            mySegControl.centerYAnchor.constraint(equalTo: contentGuide.centerYAnchor, constant: 0).isActive = true
            mySegControl.selectedSegmentIndex = 0
            let font = UIFont.systemFont(ofSize: 11)
            mySegControl.setTitleTextAttributes([NSAttributedStringKey.font: font], for: .normal)
            mySegControl.translatesAutoresizingMaskIntoConstraints = false
        }
        
        if cellRow == addViewIndexPath.row {
            addChallenge.backgroundColor =  UIColor.rgb(229, green: 231, blue: 235)
            addSubview(addChallenge)
        } else if cellRow == calenddarIndexPath.row {
            addSubview(deadLines)
            deadLines.selectedSegmentIndex = 1
            addTopAnchor(deadLines, anchor: contentGuide.topAnchor, constant: (screenWidth * 0 / 10))
            deadLines.centerXAnchor.constraint(equalTo: contentGuide.centerXAnchor, constant: 0).isActive = true
            let font = UIFont.systemFont(ofSize: 10)
            deadLines.setTitleTextAttributes([NSAttributedStringKey.font: font], for: .normal)
            
            addSubview(datePicker)
            addTopAnchor(datePicker, anchor: deadLines.bottomAnchor, constant: -(screenWidth * 0.25 / 10))
            addTrailingAnchor(datePicker, anchor: contentGuide.trailingAnchor, constant: 0)
            // datePicker.centerYAnchor.constraint(equalTo: contentGuide.centerYAnchor, constant: 0).isActive = true
            let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date())
            datePicker.minimumDate = tomorrow            
        } else if cellRow == visibilityIndexPath.row {
            visibilitySegControl.selectedSegmentIndex = 1
            addSubview(visibilitySegControl)
            addTrailingAnchor(visibilitySegControl, anchor: contentGuide.trailingAnchor, constant: 0)
            visibilitySegControl.centerYAnchor.constraint(equalTo: contentGuide.centerYAnchor, constant: 0).isActive = true
            addWidthAnchor(visibilitySegControl, multiplier: 2 / 3)
            let font = UIFont.boldSystemFont(ofSize: 10)
            visibilitySegControl.setTitleTextAttributes([NSAttributedStringKey.font: font], for: .normal)
            if typeIndex == 1 || typeIndex == 3 {
                visibilitySegControl.selectedSegmentIndex = 2
            }
            
        } else if cellRow == doneIndexPath.row {
            addSubview(isDone)
            addTrailingAnchor(isDone, anchor: contentGuide.trailingAnchor, constant: 0)
            isDone.centerYAnchor.constraint(equalTo: contentGuide.centerYAnchor, constant: 0).isActive = true
        } else if cellRow == proofIndexPath.row {
            addSubview(proofImageView)
            addTrailingAnchor(proofImageView, anchor: contentGuide.trailingAnchor, constant: -(screenWidth * 0.3 / 10))
            addWidthAnchor(proofImageView, multiplier: 2 / 10)
            addHeightAnchor(proofImageView, multiplier: 1 / 10)
            proofImageView.centerYAnchor.constraint(equalTo: contentGuide.centerYAnchor, constant: 0).isActive = true
            proofImageView.alpha = 0
            
            addSubview(labelOtherSide)
            addTrailingAnchor(labelOtherSide, anchor: contentGuide.trailingAnchor, constant: 0)
            labelOtherSide.centerYAnchor.constraint(equalTo: contentGuide.centerYAnchor, constant: 0).isActive = true
            labelOtherSide.font = UIFont.systemFont(ofSize: 14)
        } else if cellRow == deadlineIndexPath.row {
            addSubview(labelOtherSide)
            addTrailingAnchor(labelOtherSide, anchor: contentGuide.trailingAnchor, constant: 0)
            labelOtherSide.centerYAnchor.constraint(equalTo: contentGuide.centerYAnchor, constant: 0).isActive = true
            labelOtherSide.font = UIFont.systemFont(ofSize: 14)
        } else {
            addSubview(labelOtherSide)
            addTrailingAnchor(labelOtherSide, anchor: contentGuide.trailingAnchor, constant: 0)
            labelOtherSide.centerYAnchor.constraint(equalTo: contentGuide.centerYAnchor, constant: 0).isActive = true
            labelOtherSide.font = UIFont.systemFont(ofSize: 14)
        }
    }
    
    @objc func addNew() {
        self.removeFromSuperview()
    }
    
    @objc func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return pickerData.count
    }
    
    @objc func pickerView(_ pickerView: UIPickerView!, titleForRow row: Int, forComponent component: Int) -> String! {
        return pickerData[row]
    }
    
    @objc func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    @objc let proofImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.semanticContentAttribute = .forceRightToLeft
        return imageView
    }()
    
    @objc let visibilitySegControl: UISegmentedControl = AddChallengeView.segmentedControl(myArray: ["Team Members", "Friends", "Everyone"])
    @objc let mySegControl: UISegmentedControl = AddChallengeView.segmentedControl(myArray: ["TEAM", "FRIENDS", "MYSELF", "EVERYONE"])
    @objc let deadLines: UISegmentedControl = AddChallengeView.segmentedControl(myArray: ["A DAY", "A WEEK", "A MONTH", "A YEAR"])
    @objc let label: UILabel = FeedCell.labelCreate(18, backColor: UIColor.white, textColor: UIColor.black)
    @objc let labelOtherSide: UILabel = FeedCell.labelCreate(18, backColor: UIColor.white, textColor: UIColor.gray)
    @objc let homeScoreLabel: UILabel = FeedCell.labelCreate(14, backColor: UIColor.white, textColor: UIColor.gray)
    @objc let awayScoreLabel: UILabel = FeedCell.labelCreate(14, backColor: UIColor.white, textColor: UIColor.gray)
}

class TableViewCommentCellContent: UITableViewCell, UITextViewDelegate {
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    @objc let screenSize = UIScreen.main.bounds
    @objc var chlViewHeight: CGFloat = 17.5/30
    @objc var tableRowHeightHeight: CGFloat = 44
    @objc init(frame: CGRect, cellRow : Int, typeIndex : Int) {
        super.init(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        let contentGuide = self.readableContentGuide
        /*
        addSubview(label)
        addTopAnchor(label, anchor: contentGuide.topAnchor, constant: 0)
        addLeadingAnchor(label, anchor: contentGuide.leadingAnchor, constant: 6)
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.gray
        */
        // self.commentView.delegate = self
        addSubview(commentView)
        commentView.centerYAnchor.constraint(equalTo: contentGuide.centerYAnchor, constant: 0).isActive = true
        addLeadingAnchor(commentView, anchor: contentGuide.leadingAnchor, constant: 0)
        addWidthAnchor(commentView, multiplier: 0.93)
        commentView.heightAnchor.constraint(equalToConstant: globalHeight - 10).isActive = true
    }
    
    @objc let label: UILabel = FeedCell.labelCreate(18, backColor: UIColor.white, textColor: UIColor.black)
    
    @objc let commentView: UITextView = {
        let textView = UITextView()
        textView.textColor = UIColor.lightGray
        textView.text = "Comment"
        textView.isScrollEnabled = false
        // textView.showsVerticalScrollIndicator = false
        // textView.font = UIFont.boldSystemFont(ofSize: 16)
        textView.font = UIFont.preferredFont(forTextStyle: .headline)
        // textView.alwaysBounceHorizontal = true
        textView.layer.borderColor = UIColor (red:204.0/255.0, green:204.0/255.0, blue:204.0/255.0, alpha:1.0).cgColor;
        textView.layer.borderWidth = 1.0;
        textView.layer.cornerRadius = 5.0;
        textView.textContainer.maximumNumberOfLines = 8
        return textView
    }()
}
