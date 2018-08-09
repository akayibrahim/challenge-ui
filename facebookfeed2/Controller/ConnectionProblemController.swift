//
//  FacebookController.swift
//  facebookfeed2
//
//  Created by iakay on 17.01.2018.
//  Copyright © 2018 challenge. All rights reserved.
//

import UIKit

class ConnectionProblemController: UIViewController {
    @objc var imageView : UIImageView!
    @objc var label: UILabel!
    @objc var window: UIWindow?
    @objc let still = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 30))
    
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
        
        still.center = CGPoint(x: view.center.x, y: UIScreen.main.bounds.height * 1.15 / 2)
        still.text = "Still,"
        still.textAlignment = NSTextAlignment.center
        still.textColor = UIColor.white
        still.font = UIFont(name: "Copperplate", size: 17)
        view.addSubview(still)
        still.alpha = 0
        
        let loading = UILabel(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 30))
        loading.center = CGPoint(x: view.center.x, y: UIScreen.main.bounds.height * 1.2 / 2)
        loading.text = "There is a connection problem!"
        loading.textAlignment = NSTextAlignment.center
        loading.textColor = UIColor.white
        loading.lineBreakMode = .byWordWrapping
        loading.font = UIFont(name: "Copperplate", size: 17)
        view.addSubview(loading)
        
        let reload = UILabel(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 30))
        reload.center = CGPoint(x: view.center.x, y: UIScreen.main.bounds.height * 1.4 / 2)
        reload.text = "Tab To Reload"
        reload.textAlignment = NSTextAlignment.center
        reload.textColor = UIColor.white
        reload.lineBreakMode = .byWordWrapping
        reload.font = UIFont(name: "Copperplate", size: 17)
        view.addSubview(reload)
        
        let tabToReload = UITapGestureRecognizer(target: self, action: #selector(self.reload))
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(tabToReload)
    }
    
    @objc func reload() {
        still.alpha = 1
        if Reachability.isConnectedToNetwork() {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.openApp()
        }
    }
}
