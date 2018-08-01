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
    var imageView : UIImageView!
    var label: UILabel!
    var window: UIWindow?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = navAndTabColor
        
        label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 60))
        label.center = CGPoint(x: view.center.x, y: UIScreen.main.bounds.height * 0.3 / 2)
        label.text = "Challenge"
        label.textAlignment = NSTextAlignment.center
        label.textColor = UIColor.white
        label.font = UIFont(name: "BodoniSvtyTwoITCTT-Bold", size: 44)
        view.addSubview(label)
        
        let labelSlogan = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 30))
        labelSlogan.center = CGPoint(x: view.center.x, y: UIScreen.main.bounds.height * 0.7 / 2)
        labelSlogan.text = "Now, It's your time."
        labelSlogan.textAlignment = NSTextAlignment.center
        labelSlogan.textColor = UIColor.white
        labelSlogan.font = UIFont(name: "Copperplate", size: 19)
        view.addSubview(labelSlogan)
        
        let labelSlogan2 = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 30))
        labelSlogan2.center = CGPoint(x: view.center.x, y: UIScreen.main.bounds.height * 0.78 / 2)
        labelSlogan2.text = "Prove yourself!"
        labelSlogan2.textAlignment = NSTextAlignment.center
        labelSlogan2.textColor = UIColor.white
        labelSlogan2.font = UIFont(name: "Copperplate", size: 17)
        view.addSubview(labelSlogan2)
        
        imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        imageView.center = CGPoint(x: view.center.x, y: UIScreen.main.bounds.height * 0.94 / 2)
        imageView.image = UIImage(named: "AppIconLogin")
        view.addSubview(imageView)
        
        let loading = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 30))
        loading.center = CGPoint(x: view.center.x, y: UIScreen.main.bounds.height * 1.2 / 2)
        loading.text = "Loading.."
        loading.textAlignment = NSTextAlignment.center
        loading.textColor = UIColor.white
        loading.font = UIFont(name: "Copperplate", size: 17)
        view.addSubview(loading)
    }
}
