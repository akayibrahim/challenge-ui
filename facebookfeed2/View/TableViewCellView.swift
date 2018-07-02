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
    
    var pickerData: [String] = [String]()
    var myUIPicker: UIPickerView!
    var isDone: UISwitch = UISwitch(frame:CGRect(x: 150, y: 300, width: 0, height: 0))
    var datePicker: UIDatePicker = UIDatePicker(frame:CGRect(x: 150, y: 300, width: 0, height: 0))
    var addChallenge = AddChallengeView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: (UIScreen.main.bounds.width * 17.5/30) + 22))
    
    let screenSize = UIScreen.main.bounds
    var chlViewHeight: CGFloat = 17.5/30
    var tableRowHeightHeight: CGFloat = 44
    init(frame: CGRect, cellRow : Int, typeIndex : Int) {
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
            let font = UIFont.systemFont(ofSize: 12)
            mySegControl.setTitleTextAttributes([NSFontAttributeName: font], for: .normal)
            mySegControl.translatesAutoresizingMaskIntoConstraints = false
        }
        
        if cellRow == addViewIndexPath.row {
            addChallenge.backgroundColor =  UIColor.rgb(229, green: 231, blue: 235)
            addSubview(addChallenge)
        } else if cellRow == calenddarIndexPath.row {
            addSubview(datePicker)
            addTrailingAnchor(datePicker, anchor: contentGuide.trailingAnchor, constant: 0)
            datePicker.centerYAnchor.constraint(equalTo: contentGuide.centerYAnchor, constant: 0).isActive = true
            let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date())
            datePicker.minimumDate = tomorrow
        } else if cellRow == visibilityIndexPath.row {
            if typeIndex == 2 {
                visibilitySegControlForSelf.selectedSegmentIndex = 0
                addSubview(visibilitySegControlForSelf)
                addTrailingAnchor(visibilitySegControlForSelf, anchor: contentGuide.trailingAnchor, constant: 0)
                visibilitySegControlForSelf.centerYAnchor.constraint(equalTo: contentGuide.centerYAnchor, constant: 0).isActive = true
            } else {
                visibilitySegControl.selectedSegmentIndex = 1
                addSubview(visibilitySegControl)
                addTrailingAnchor(visibilitySegControl, anchor: contentGuide.trailingAnchor, constant: 0)
                visibilitySegControl.centerYAnchor.constraint(equalTo: contentGuide.centerYAnchor, constant: 0).isActive = true
            }
            if typeIndex == 0 {
                visibilitySegControl.selectedSegmentIndex = 0
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
            addSubview(deadLines)
            addLeadingAnchor(deadLines, anchor: label.trailingAnchor, constant: (screenWidth * 0.1 / 10))
            let font = UIFont.systemFont(ofSize: 10)
            deadLines.setTitleTextAttributes([NSFontAttributeName: font], for: .normal)
            deadLines.centerYAnchor.constraint(equalTo: contentGuide.centerYAnchor, constant: 0).isActive = true
            
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
    
    func addNew() {
        self.removeFromSuperview()
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView!, titleForRow row: Int, forComponent component: Int) -> String! {
        return pickerData[row]
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    let proofImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.semanticContentAttribute = .forceRightToLeft
        return imageView
    }()
    
    let visibilitySegControlForSelf: UISegmentedControl = AddChallengeView.segmentedControl(myArray: ["Just Me", "Friend", "Everyone"])
    let visibilitySegControl: UISegmentedControl = AddChallengeView.segmentedControl(myArray: ["Friend", "Everyone"])
    let mySegControl: UISegmentedControl = AddChallengeView.segmentedControl(myArray: ["AS A TEAM", "TO PEOPLE", "TO MYSELF", "TO WORLD"])
    let deadLines: UISegmentedControl = AddChallengeView.segmentedControl(myArray: ["DAY", "WEEK", "MONTH", "CUSTOM"])
    let label: UILabel = FeedCell.labelCreate(18, backColor: UIColor.white, textColor: UIColor.black)
    let labelOtherSide: UILabel = FeedCell.labelCreate(18, backColor: UIColor.white, textColor: UIColor.gray)
    let homeScoreLabel: UILabel = FeedCell.labelCreate(14, backColor: UIColor.white, textColor: UIColor.gray)
    let awayScoreLabel: UILabel = FeedCell.labelCreate(14, backColor: UIColor.white, textColor: UIColor.gray)
}

class TableViewCommentCellContent: UITableViewCell, UITextViewDelegate {
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    let screenSize = UIScreen.main.bounds
    var chlViewHeight: CGFloat = 17.5/30
    var tableRowHeightHeight: CGFloat = 44
    init(frame: CGRect, cellRow : Int, typeIndex : Int) {
        super.init(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        let contentGuide = self.readableContentGuide
        /*
        addSubview(label)
        addTopAnchor(label, anchor: contentGuide.topAnchor, constant: 0)
        addLeadingAnchor(label, anchor: contentGuide.leadingAnchor, constant: 6)
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.gray
        */
        self.commentView.delegate = self
        addSubview(commentView)
        commentView.centerYAnchor.constraint(equalTo: contentGuide.centerYAnchor, constant: 0).isActive = true
        addLeadingAnchor(commentView, anchor: contentGuide.leadingAnchor, constant: 0)
        addWidthAnchor(commentView, multiplier: 0.93)
        commentView.heightAnchor.constraint(equalToConstant: globalHeight - 10).isActive = true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if commentView.textColor == UIColor.lightGray {
            commentView.text = nil
            commentView.textColor = UIColor.gray
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if commentView.text.isEmpty {
            commentView.text = "Comment"
            commentView.textColor = UIColor.lightGray
        }
    }
    
    let label: UILabel = FeedCell.labelCreate(18, backColor: UIColor.white, textColor: UIColor.black)
    
    let commentView: UITextView = {
        let textView = UITextView()
        textView.textColor = UIColor.lightGray
        textView.text = "Comment"
        textView.isScrollEnabled = true
        textView.showsVerticalScrollIndicator = false
        textView.font = UIFont.boldSystemFont(ofSize: 16)
        textView.alwaysBounceHorizontal = true
        textView.layer.borderColor = UIColor (red:204.0/255.0, green:204.0/255.0, blue:204.0/255.0, alpha:1.0).cgColor;
        textView.layer.borderWidth = 1.0;
        textView.layer.cornerRadius = 5.0;
        return textView
    }()

}
