//
//  OtherView.swift
//  facebookfeed2
//
//  Created by iakay on 27.02.2018.
//  Copyright © 2018 challenge. All rights reserved.
//

import UIKit

class OtherViewCell: UITableViewCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(frame: CGRect, cellRow : Int) {
        super.init(style: UITableViewCellStyle.default, reuseIdentifier: OtherController.cellId)
        let contentGuide = self.readableContentGuide
        let screenSize = UIScreen.main.bounds
        if cellRow == 0 {
            addSubview(settingsButton)
            settingsButton.translatesAutoresizingMaskIntoConstraints = false
            settingsButton.heightAnchor.constraint(equalToConstant: screenSize.width * 1 / 10).isActive = true
            settingsButton.centerXAnchor.constraint(equalTo: contentGuide.centerXAnchor).isActive = true
        } else if cellRow == 1 {
            addSubview(privacyButton)
            privacyButton.translatesAutoresizingMaskIntoConstraints = false
            privacyButton.heightAnchor.constraint(equalToConstant: screenSize.width * 1 / 10).isActive = true
            privacyButton.centerXAnchor.constraint(equalTo: contentGuide.centerXAnchor).isActive = true
        } else if cellRow == 2 {
            addSubview(supportButton)
            supportButton.translatesAutoresizingMaskIntoConstraints = false
            supportButton.heightAnchor.constraint(equalToConstant: screenSize.width * 1 / 10).isActive = true
            supportButton.centerXAnchor.constraint(equalTo: contentGuide.centerXAnchor).isActive = true
        } else if cellRow == 3 {
        } else if cellRow == 4 {
            addSubview(logoutButton)
            logoutButton.translatesAutoresizingMaskIntoConstraints = false
            logoutButton.heightAnchor.constraint(equalToConstant: screenSize.width * 1 / 10).isActive = true
            logoutButton.centerXAnchor.constraint(equalTo: contentGuide.centerXAnchor).isActive = true            
        }
    }
    
    let logoutButton: UIButton = OtherViewCell.button("Log Out", titleColor: UIColor.red)
    let settingsButton: UIButton = OtherViewCell.button("Settings", titleColor: UIColor.black)
    let supportButton: UIButton = OtherViewCell.button("Support", titleColor: UIColor.black)
    let privacyButton: UIButton = OtherViewCell.button("Privacy", titleColor: UIColor.black)
    
    static func button(_ title: String, titleColor: UIColor) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: UIControlState())
        button.setTitleColor(titleColor, for: UIControlState())
        button.backgroundColor = UIColor.white
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.titleLabel?.textAlignment = .right
        button.layer.cornerRadius = 2
        return button
    }
}
