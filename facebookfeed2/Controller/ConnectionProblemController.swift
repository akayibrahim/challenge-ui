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
    @objc let reloadT = UILabel(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 30))
    
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
        /*
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
        */
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
        
        reloadT.center = CGPoint(x: view.center.x, y: UIScreen.main.bounds.height * 1.4 / 2)
        reloadT.text = "Tab To Reload"
        reloadT.textAlignment = NSTextAlignment.center
        reloadT.textColor = UIColor.white
        reloadT.lineBreakMode = .byWordWrapping
        reloadT.font = UIFont(name: "Copperplate", size: 17)
        view.addSubview(reloadT)
        
        let tabToReload = UITapGestureRecognizer(target: self, action: #selector(self.reload))
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(tabToReload)
        
        activityIndicator.center = CGPoint(x: self.view.center.x, y: UIScreen.main.bounds.height * 1.7 / 2)
        activityIndicator.activityIndicatorViewStyle = .white
        self.view.addSubview(self.activityIndicator)
    }
    
    let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
    @objc func reload() {
        DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
            self.activityIndicator.startAnimating()
            self.reloadT.alpha = 0
        })
        if Reachability.isConnectedToNetwork() {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.openApp()
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                self.activityIndicator.stopAnimating()
                // self.activityIndicator.removeFromSuperview()
                self.still.alpha = 1
                self.reloadT.alpha = 1
            })
        }
    }
}
