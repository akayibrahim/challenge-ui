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
        print("User Logged In")
        if ((error) != nil) {
            print(error as Any)
        } else if result.isCancelled {
            FBSDKLoginManager().logOut()
            print("Cancelled")
        } else {
            // If you ask for multiple permissions at once, you should check if specific permissions missing
            if result.grantedPermissions.contains("email") {
                print("LoggedIn")
                self.fetchFacebookProfile()
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.window?.rootViewController = CustomTabBarController()
            }
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {        
        print("logout")
    }
    
    lazy var loginManager: FBSDKLoginManager = {
        return FBSDKLoginManager()
    }()
            
    func loginButtonWillLogin(_ loginButton: FBSDKLoginButton!) -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = navAndTabColor
        
        label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        label.center = CGPoint(x: view.center.x, y: UIScreen.main.bounds.height * 0.3 / 2)
        label.text = "Challenge"
        label.textAlignment = NSTextAlignment.center
        label.textColor = UIColor.white
        label.font = UIFont(name: "BodoniSvtyTwoITCTT-Bold", size: 44)
        view.addSubview(label)
        
        let labelSlogan = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 30))
        labelSlogan.center = CGPoint(x: view.center.x, y: UIScreen.main.bounds.height * 0.65 / 2)
        labelSlogan.text = "Now, It's your time!"
        labelSlogan.textAlignment = NSTextAlignment.center
        labelSlogan.textColor = UIColor.white
        labelSlogan.font = UIFont(name: "BodoniSvtyTwoITCTT-Bold", size: 24)
        view.addSubview(labelSlogan)
        
        imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        imageView.center = CGPoint(x: view.center.x, y: UIScreen.main.bounds.height * 0.85 / 2)
        imageView.image = UIImage(named: "AppIcon")
        view.addSubview(imageView)
        
        let labelSlogan2 = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 30))
        labelSlogan2.center = CGPoint(x: view.center.x, y: UIScreen.main.bounds.height * 1.05 / 2)
        labelSlogan2.text = "Proof yourself!"
        labelSlogan2.textAlignment = NSTextAlignment.center
        labelSlogan2.textColor = UIColor.white
        labelSlogan2.font = UIFont(name: "BodoniSvtyTwoITCTT-Bold", size: 24)
        view.addSubview(labelSlogan2)
        
        let loginButton = FBSDKLoginButton()
        loginButton.readPermissions = ["public_profile", "email", "user_friends"]
        view.addSubview(loginButton)
        //frame's are obselete, please use constraints instead because its 2016 after all
        loginButton.frame = CGRect(x: 16, y: UIScreen.main.bounds.height * 1.4 / 2, width: view.frame.width - 32, height: 50)
        loginButton.delegate = self
        
        let label2018 = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 30))
        label2018.center = CGPoint(x: view.center.x, y: UIScreen.main.bounds.height * 1.9 / 2)
        label2018.text = "@2018"
        label2018.textAlignment = NSTextAlignment.center
        label2018.textColor = UIColor.white
        label2018.font = UIFont(name: "BodoniSvtyTwoITCTT-Bold", size: 14)
        view.addSubview(label2018)
    }
    
    func fetchFacebookProfile() {
        //print permissions, such as public_profile
        let params = ["fields": "id, first_name, last_name, name, email, picture,friends"]

        let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: params)
        let connection = FBSDKGraphRequestConnection()
        
        connection.add(graphRequest, completionHandler: { (connection, result, error) -> Void in
            if error == nil {
                // print(result!)
                //print("https://graph.facebook.com/10156204749600712/invitable_friends?access_token=\(FBSDKAccessToken.current().tokenString)")
                let data = result as! [String : Any]
                // self.label.text = data["name"] as? String
                // let name = data["name"] as? String
                // print("name: " + name!)
                let first_name = data["first_name"] as? String
                // print("first_name: " + first_name!)
                let last_name = data["last_name"] as? String
                // print("last_name: " + last_name!)
                let email = data["email"] as? String
                // print("email: " + email!)
                let FBid = data["id"] as? String
                // print("facebook ID: " + FBid!)
                // let url = NSURL(string: "https://graph.facebook.com/\(FBid!)/picture?type=large&return_ssl_resources=1")
                // print("picture url: \(url!)")
                // let user_friends = data["friends"]
                // TODO let friends = user_friends as! [String : Any]
                // print(friends)
                // self.imageView.image = UIImage(data: NSData(contentsOf: url! as URL)! as Data)
                self.addMember(firstName: first_name!, surname: last_name!, email: email!, facebookID: FBid!)
            } else {
                print("Error Getting Friends \(error!)");
            }
        })
        connection.start()
    }
    
    func addMember(firstName: String, surname: String, email: String, facebookID: String) {
        let json: [String: Any] = ["name": firstName,
                                   "surname": surname,
                                   "email": email,
                                   "facebookID": facebookID,
                                   "phoneModel":"\(UIDevice().type)",
                                   "region": Locale.current.regionCode!
                                ]
        
        let url = URL(string: addMemberURL)!
        let request = ServiceLocator.prepareRequest(url: url, json: json)
        URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    DispatchQueue.main.async {
                        let idOfMember = NSString(data: data, encoding: String.Encoding.utf8.rawValue)!
                        memberID = idOfMember as String
                        memberFbID = facebookID
                        memberName = "\(firstName) \(surname)"                        
                    }
                } else {
                    let error = ServiceLocator.getErrorMessage(data: data)
                    self.popupAlert(message: error, willDelay: false)
                }
            }
        }).resume()
    }
}
