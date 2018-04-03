//
//  OtherView.swift
//  facebookfeed2
//
//  Created by iakay on 27.02.2018.
//  Copyright © 2018 challenge. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class OtherView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let logoutButton: UIButton = {
        let button = UIButton()
        button.setTitle("Log Out", for: UIControlState())
        button.setTitleColor(UIColor.red, for: UIControlState())
        button.backgroundColor = UIColor.white
        button.titleLabel?.font = UIFont.systemFont(ofSize: 22)
        button.titleLabel?.textAlignment = .right
        button.layer.cornerRadius = 2
        return button
    }()
    
    func setupViews() {
        let contentGuide = self.readableContentGuide
        let screenSize = UIScreen.main.bounds
        self.addSubview(logoutButton)
        logoutButton.bottomAnchor.constraint(equalTo: contentGuide.bottomAnchor, constant: -(screenSize.width * 2.4 / 10)).isActive = true
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        logoutButton.leadingAnchor.constraint(equalTo: contentGuide.leadingAnchor, constant: 0).isActive = true
        logoutButton.trailingAnchor.constraint(equalTo: contentGuide.trailingAnchor, constant: 0).isActive = true
        logoutButton.heightAnchor.constraint(equalToConstant: screenSize.width * 1 / 10).isActive = true
        logoutButton.centerXAnchor.constraint(equalTo: contentGuide.centerXAnchor).isActive = true
        logoutButton.addTarget(self, action: #selector(OtherView.logout), for: .touchUpInside)
    }
    
    func logout() {
        /*
         let button2Alert: UIAlertView = UIAlertView(title: "Title", message: "message",
         delegate: self as? UIAlertViewDelegate, cancelButtonTitle: "Ok")
         button2Alert.show()
         */
        let loginManager = FBSDKLoginManager()
        loginManager.logOut()
        window?.rootViewController = FacebookController()

    }
}
