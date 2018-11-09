//
//  FacebookController.swift
//  facebookfeed2
//
//  Created by iakay on 17.01.2018.
//  Copyright © 2018 challenge. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit

class SplashScreenController: UIViewController {
    @objc var imageView : UIImageView!
    @objc var label: UILabel!
    @objc var window: UIWindow?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = navAndTabColor
        
        imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        imageView.center = CGPoint(x: view.center.x, y: UIScreen.main.bounds.height * 0.3 / 2)
        imageView.image = UIImage(named: "AppIconLogin")
        view.addSubview(imageView)
        
        label = UILabel(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 60))
        label.center = CGPoint(x: view.center.x, y: UIScreen.main.bounds.height * 0.6 / 2)
        label.text = "CHALLENGE"
        label.textAlignment = NSTextAlignment.center
        label.textColor = UIColor.white
        // label.font = UIFont(name: "BodoniSvtyTwoITCTT-Bold", size: 44)
        label.font = label.font.withSize(36)
        label.font = UIFont.boldSystemFont(ofSize: label.font.pointSize)
        view.addSubview(label)
        
        let labelSlogan = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 30))
        labelSlogan.center = CGPoint(x: view.center.x, y: UIScreen.main.bounds.height * 0.97 / 2)
        labelSlogan.text = "Now, It's your time."
        labelSlogan.textAlignment = NSTextAlignment.center
        labelSlogan.textColor = UIColor.white
        labelSlogan.font = UIFont(name: "Copperplate", size: 19)
        view.addSubview(labelSlogan)
        
        let labelSlogan2 = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 30))
        labelSlogan2.center = CGPoint(x: view.center.x, y: UIScreen.main.bounds.height * 1.05 / 2)
        labelSlogan2.text = "Prove yourself!"
        labelSlogan2.textAlignment = NSTextAlignment.center
        labelSlogan2.textColor = UIColor.white
        labelSlogan2.font = UIFont(name: "Copperplate", size: 17)
        view.addSubview(labelSlogan2)
        
        let loading = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 30))
        loading.center = CGPoint(x: view.center.x, y: UIScreen.main.bounds.height * 1.2 / 2)
        loading.text = "Loading.."
        loading.textAlignment = NSTextAlignment.center
        loading.textColor = UIColor.white
        loading.font = UIFont(name: "Copperplate", size: 17)
        view.addSubview(loading)
        
        let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        activityIndicator.center = CGPoint(x: self.view.center.x, y: UIScreen.main.bounds.height * 1.5 / 2)
        activityIndicator.activityIndicatorViewStyle = .white
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
}
