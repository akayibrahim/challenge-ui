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
        
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        FBSDKAccessToken.setCurrent(nil)
        FBSDKProfile.setCurrent(nil)
        print("logout")
    }
    
    func loginButtonWillLogin(_ loginButton: FBSDKLoginButton!) -> Bool {
        let loginManager = FBSDKLoginManager()
        loginManager.loginBehavior = FBSDKLoginBehavior.systemAccount
        loginManager.logIn(withReadPermissions: ["public_profile", "email", "user_friends"], from: self.parent, handler: { (result, error) -> Void in
            if error != nil {
                print(error as Any)
            } else if (result?.isCancelled)! {
                print("Cancelled")
            } else if(FBSDKAccessToken.current() != nil) {
                print("LoggedIn")
                self.fetchFacebookProfile()
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.window?.rootViewController = CustomTabBarController()
            }
        })
        print("true")
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(white: 0.95, alpha: 1)
        
        let loginButton = FBSDKLoginButton()
        view.addSubview(loginButton)
        
        //frame's are obselete, please use constraints instead because its 2016 after all
        loginButton.frame = CGRect(x: 16, y: screenWidth / 2, width: view.frame.width - 32, height: 50)
        loginButton.delegate = self
        /*
        imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        imageView.center = CGPoint(x: view.center.x, y: 200)
        imageView.image = UIImage(named: "fb-art.jpg")
        view.addSubview(imageView)
        
        label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 30))
        label.center = CGPoint(x: view.center.x, y: 300)
        label.text = "Logged In"
        label.textAlignment = NSTextAlignment.center
        label.textColor = UIColor.white
        view.addSubview(label)
 
        navigationItem.title = "CHL"
         */
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
                                   "facebookID": facebookID
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
                        let idOfMember = NSString(data: data, encoding: String.Encoding.ascii.rawValue)!
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
