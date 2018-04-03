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
    var mySwitch: UISwitch = UISwitch(frame:CGRect(x: 150, y: 300, width: 0, height: 0))
    var datePicker: UIDatePicker = UIDatePicker(frame:CGRect(x: 150, y: 300, width: 0, height: 0))
    var addChallenge = AddChallengeView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: (UIScreen.main.bounds.width * 17.5/30) + 44))
    
    let screenSize = UIScreen.main.bounds
    var chlViewHeight: CGFloat = 17.5/30
    var tableRowHeightHeight: CGFloat = 44
    init(frame: CGRect, cellRow : Int) {
        super.init(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        let contentGuide = self.readableContentGuide
        
        addSubview(label)
        addLeadingAnchor(label, anchor: contentGuide.leadingAnchor, constant: 6)
        label.centerYAnchor.constraint(equalTo: contentGuide.centerYAnchor, constant: 0).isActive = true
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.gray
        
        if cellRow == 0 {
            addChallenge.backgroundColor = UIColor.lightGray
            addSubview(addChallenge)
        } else if cellRow == 1 {
            addSubview(mySegControl)
            addTrailingAnchor(mySegControl, anchor: contentGuide.trailingAnchor, constant: 0)
            mySegControl.centerYAnchor.constraint(equalTo: contentGuide.centerYAnchor, constant: 0).isActive = true
            mySegControl.selectedSegmentIndex = 0
        } else if cellRow == 6 {
            addSubview(datePicker)
            addTrailingAnchor(datePicker, anchor: contentGuide.trailingAnchor, constant: 0)
            datePicker.centerYAnchor.constraint(equalTo: contentGuide.centerYAnchor, constant: 0).isActive = true
        } else if cellRow == 7 {
            addSubview(mySwitch)
            addTrailingAnchor(mySwitch, anchor: contentGuide.trailingAnchor, constant: 0)
            mySwitch.centerYAnchor.constraint(equalTo: contentGuide.centerYAnchor, constant: 0).isActive = true
        } else {
            addSubview(labelOtherSide)
            addTrailingAnchor(labelOtherSide, anchor: contentGuide.trailingAnchor, constant: 0)
            labelOtherSide.centerYAnchor.constraint(equalTo: contentGuide.centerYAnchor, constant: 0).isActive = true
            labelOtherSide.font = UIFont.systemFont(ofSize: 14)
        }
    }
    
    func setupViews(labelText: String, cellRow: Int, resultText: String) {
        /*
         pickerData = ["READING", "LEARNING LANGUAGE", "WALKING", "RUNNING", "FOOTBALL", "TENNIS"]
         myUIPicker = UIPickerView()
         myUIPicker.delegate = self
         addSubview(myUIPicker)
         addTopAnchor(myUIPicker, anchor: mySegControl.bottomAnchor, constant: 0)
         myUIPicker.centerXAnchor.constraint(equalTo: contentGuide.centerXAnchor, constant: 0).isActive = true
         */
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
    
    let mySegControl: UISegmentedControl = AddChallengeView.segmentedControl()
    let label: UILabel = FeedCell.labelCreate(18, backColor: UIColor.white, textColor: UIColor.black)
    let labelOtherSide: UILabel = FeedCell.labelCreate(18, backColor: UIColor.white, textColor: UIColor.gray)
}
