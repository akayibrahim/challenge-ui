//
//  OtherView.swift
//  facebookfeed2
//
//  Created by iakay on 27.02.2018.
//  Copyright © 2018 challenge. All rights reserved.
//

import UIKit
import FBSDKLoginKit

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
            addSubview(logoutButton)
            logoutButton.translatesAutoresizingMaskIntoConstraints = false
            logoutButton.heightAnchor.constraint(equalToConstant: screenSize.width * 1 / 10).isActive = true
            logoutButton.centerXAnchor.constraint(equalTo: contentGuide.centerXAnchor).isActive = true
            logoutButton.addTarget(self, action: #selector(OtherViewCell.logout), for: .touchUpInside)
        }
    }
    
    func logout() {
        let loginManager = FBSDKLoginManager()
        loginManager.logOut()
        window?.rootViewController = FacebookController()
    }
    
    let logoutButton: UIButton = {
        let button = UIButton()
        button.setTitle("Log Out", for: UIControlState())
        button.setTitleColor(UIColor.red, for: UIControlState())
        button.backgroundColor = UIColor.white
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.titleLabel?.textAlignment = .right
        button.layer.cornerRadius = 2
        return button
    }()
}
