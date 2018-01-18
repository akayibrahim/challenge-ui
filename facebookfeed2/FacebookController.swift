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

class FacebookController: UIViewController, FBSDKLoginButtonDelegate {
    var imageView : UIImageView!
    var label: UILabel!
    var window: UIWindow?
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = CustomTabBarController()
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let loginButton = FBSDKLoginButton()
        view.addSubview(loginButton)
        //frame's are obselete, please use constraints instead because its 2016 after all
        loginButton.frame = CGRect(x: 16, y: 50, width: view.frame.width - 32, height: 50)
        
        loginButton.delegate = self
        
        imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        imageView.center = CGPoint(x: view.center.x, y: 200)
        imageView.image = UIImage(named: "fb-art.jpg")
        view.addSubview(imageView)
        
        label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 30))
        label.center = CGPoint(x: view.center.x, y: 300)
        label.text = "Not Logged In"
        label.textAlignment = NSTextAlignment.center
        label.textColor = UIColor.white
        view.addSubview(label)
        
        navigationItem.title = "CHL"
    }
    
    func fetchFacebookProfile() {
        if(FBSDKAccessToken.current() != nil)
        {
            //print permissions, such as public_profile
            print(FBSDKAccessToken.current().permissions)
            let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields" : "id, name, email"])
            let connection = FBSDKGraphRequestConnection()
            
            connection.add(graphRequest, completionHandler: { (connection, result, error) -> Void in
                
                let data = result as! [String : AnyObject]
                
                self.label.text = data["name"] as? String
                
                let FBid = data["id"] as? String
                
                let url = NSURL(string: "https://graph.facebook.com/\(FBid!)/picture?type=large&return_ssl_resources=1")
                self.imageView.image = UIImage(data: NSData(contentsOf: url! as URL)! as Data)
            })
            connection.start()
        }
    }
}
