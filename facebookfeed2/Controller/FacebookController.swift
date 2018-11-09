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
import GoogleSignIn

class FacebookController: UIViewController, FBSDKLoginButtonDelegate, GIDSignInUIDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UIGestureRecognizerDelegate {
    @objc var imageView : UIImageView!
    @objc var label: UILabel!
    var myPickerView : UIPickerView!
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if Util.controlNetwork() {
            return
        }
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
                ServiceLocator.fetchFacebookFriends()
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.window?.rootViewController = SplashScreenController()
                splashTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(splashScreenToMain), userInfo: nil, repeats: false)
            }
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {        
        print("logout")
    }
    
    @objc lazy var loginManager: FBSDKLoginManager = {
        return FBSDKLoginManager()
    }()
            
    func loginButtonWillLogin(_ loginButton: FBSDKLoginButton!) -> Bool {
        return true
    }
    
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        self.present(viewController, animated: true, completion: nil)
    }
    
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = navAndTabColor
        
        if Util.controlNetwork() {
            return
        }
        
        GIDSignIn.sharedInstance().uiDelegate = self
        
        imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        imageView.center = CGPoint(x: view.center.x, y: UIScreen.main.bounds.height * 0.3 / 2)
        imageView.image = UIImage(named: "AppIconLogin")
        view.addSubview(imageView)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.openPickerView))
        tapGestureRecognizer.numberOfTapsRequired = 5
        //tapGestureRecognizer.numberOfTouchesRequired = 2
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGestureRecognizer)
        
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
        
        
        
        instagramLogin.frame = CGRect(x: view.center.x  - ((view.frame.width - 64) / 2), y: UIScreen.main.bounds.height * 1.2 / 2, width: view.frame.width - 64, height: 44)
        // instagramLogin.center = CGPoint(x: view.center.x, y: UIScreen.main.bounds.height * 0.3 / 2)
        // view.addSubview(instagramLogin)
        instagramLogin.addTarget(self, action: #selector(self.loginWithInstagram), for: UIControlEvents.touchUpInside)
        
        let loginButton = FBSDKLoginButton()
        loginButton.readPermissions = ["public_profile", "email", "user_friends"]
        view.addSubview(loginButton)
        //frame's are obselete, please use constraints instead because its 2016 after all
        loginButton.frame = CGRect(x: view.center.x  - ((view.frame.width - 64) / 2), y: UIScreen.main.bounds.height * 1.25 / 2, width: view.frame.width - 64, height: 44)
        loginButton.delegate = self
        
        let signInButton = GIDSignInButton()
        view.addSubview(signInButton)
        signInButton.frame = CGRect(x: view.center.x  - ((view.frame.width - 64) / 2), y: UIScreen.main.bounds.height * 1.45 / 2, width: view.frame.width - 64, height: 44)
        
        /*
        let akayButton = FeedCell.buttonForTitle("ibrahim akay", imageName: "")
        akayButton.setTitleColor(UIColor.white, for: UIControlState())
        akayButton.frame = CGRect(x: view.center.x, y: UIScreen.main.bounds.height * 1.05 / 2, width: 200, height: 30)
        view.addSubview(akayButton)
        akayButton.addTarget(self, action: #selector(self.akay), for: UIControlEvents.touchUpInside)
        
        let aykutButton = FeedCell.buttonForTitle("serkan aykut", imageName: "")
        aykutButton.setTitleColor(UIColor.white, for: UIControlState())
        aykutButton.frame = CGRect(x: view.center.x, y: UIScreen.main.bounds.height * 1.15 / 2, width: 200, height: 30)
        view.addSubview(aykutButton)
        aykutButton.addTarget(self, action: #selector(self.aykut), for: UIControlEvents.touchUpInside)
        
        let melisButton = FeedCell.buttonForTitle("melisa bahçıvan", imageName: "")
        melisButton.setTitleColor(UIColor.white, for: UIControlState())
        melisButton.frame = CGRect(x: view.center.x, y: UIScreen.main.bounds.height * 1.25 / 2, width: 200, height: 30)
        view.addSubview(melisButton)
        melisButton.addTarget(self, action: #selector(self.melis), for: UIControlEvents.touchUpInside)
        
        let belkayButton = FeedCell.buttonForTitle("belkay bahçıvan", imageName: "")
        belkayButton.setTitleColor(UIColor.white, for: UIControlState())
        belkayButton.frame = CGRect(x: 0, y: UIScreen.main.bounds.height * 1.25 / 2, width: 200, height: 30)
        view.addSubview(belkayButton)
        belkayButton.addTarget(self, action: #selector(self.belkay), for: UIControlEvents.touchUpInside)
        
        let canButton = FeedCell.buttonForTitle("Seher Can", imageName: "")
        canButton.setTitleColor(UIColor.white, for: UIControlState())
        canButton.frame = CGRect(x: 0, y: UIScreen.main.bounds.height * 1.05 / 2, width: 200, height: 30)
        view.addSubview(canButton)
        canButton.addTarget(self, action: #selector(self.can), for: UIControlEvents.touchUpInside)
        
        let uzunButton = FeedCell.buttonForTitle("Taner Uzun", imageName: "")
        uzunButton.setTitleColor(UIColor.white, for: UIControlState())
        uzunButton.frame = CGRect(x: 0, y: UIScreen.main.bounds.height * 1.15 / 2, width: 200, height: 30)
        view.addSubview(uzunButton)
        uzunButton.addTarget(self, action: #selector(self.uzun), for: UIControlEvents.touchUpInside)
 */
    }
    
    @objc func openPickerView() {
        self.myPickerView = UIPickerView(frame:CGRect(x: 0, y: self.view.frame.size.height - 216, width: self.view.frame.size.width, height: 216))
        self.myPickerView.delegate = self
        self.myPickerView.dataSource = self
        self.myPickerView.backgroundColor = UIColor.white
        self.myPickerView.showsSelectionIndicator = true
        view.addSubview(myPickerView)
        
        let pickerTapGesture : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.tapToPicker))
        pickerTapGesture.delegate = self
        myPickerView.isUserInteractionEnabled = true
        myPickerView.addGestureRecognizer(pickerTapGesture)
        
        let toolbar = UIToolbar()
        toolbar.barStyle = UIBarStyle.blackOpaque
        toolbar.isTranslucent = true
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(self.pickerDone))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(pickerCancel))
        
        toolbar.setItems([cancelButton, spaceButton, doneButton], animated: true)
        toolbar.isUserInteractionEnabled = true
        // myPickerView.addSubview(toolbar)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    var pickerData = ["Usain bolt" , "Barcelona" , "Real Madrid" , "Photographer", "Nadal", "Football Fans",
                      "Tom Jery", "Music Fans", "Roger federer", "Christian pulisic", "Smith", "Childlike",
                      "Peppa", "Minion", "Simpson", "Tweety", "Ibrahimovic fans", "NBA Fans", "Bart Simpson",
                      "Lisa Simpson", "Marge Simpson", "Magie Simpson", "Andre De Grasse", "Tasmanian", "Joker",
                      "Sportsman", "Gamers", "Swimmer", "Travelers", "France", "Croatia"]
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }
    
    @objc func pickerCancel() {
        myPickerView.removeFromSuperview()
    }
    
    @objc func tapToPicker(tapRecognizer: UITapGestureRecognizer) {
        pickerDone()
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    @objc func pickerDone() {
        let row = myPickerView.selectedRow(inComponent: 0);
        if row == 0 {
            openMember(id: "5bb71ec9d35c6545e8bdbf1b")
        } else if row == 1 {
            openMember(id: "5bb71ee3d35c6545e8bdbf1d")
        } else if row == 2 {
            openMember(id: "5bb71efad35c6545e8bdbf1f")
        } else if row == 3 {
            openMember(id: "5bb71f20d35c6545e8bdbf22")
        } else if row == 4 {
            openMember(id: "5bb71f33d35c6545e8bdbf24")
        } else if row == 5 {
            openMember(id: "5bb71f58d35c6545e8bdbf26")
        } else if row == 6 {
            openMember(id: "5bb71f80d35c6545e8bdbf28")
        } else if row == 7 {
            openMember(id: "5bb71f99d35c6545e8bdbf2a")
        } else if row == 8 {
            openMember(id: "5bb71fb2d35c6545e8bdbf2c")
        } else if row == 9 {
            openMember(id: "5bb7207ad35c6545e8bdbf2e")
        } else if row == 10 {
            openMember(id: "5bb72094d35c6545e8bdbf30")
        } else if row == 11 {
            openMember(id: "5bb720b4d35c6545e8bdbf32")
        } else if row == 12 {
            openMember(id: "5bb720c6d35c6545e8bdbf34")
        } else if row == 13 {
            openMember(id: "5bb720d5d35c6545e8bdbf36")
        } else if row == 14 {
            openMember(id: "5bb720e4d35c6545e8bdbf38")
        } else if row == 15 {
            openMember(id: "5bbba3c5d35c6545e8bdcf7d")
        } else if row == 16 {
            openMember(id: "5bbba3dfd35c6545e8bdcf7f")
        } else if row == 17 {
            openMember(id: "5bbba3f7d35c6545e8bdcf81")
        } else if row == 18 {
            openMember(id: "5bbba41bd35c6545e8bdcf83")
        } else if row == 19 {
            openMember(id: "5bbba437d35c6545e8bdcf85")
        } else if row == 20 {
            openMember(id: "5bbba44bd35c6545e8bdcf87")
        } else if row == 21 {
            openMember(id: "5bbba461d35c6545e8bdcf89")
        } else if row == 22 {
            openMember(id: "5bbba47cd35c6545e8bdcf8b")
        } else if row == 23 {
            openMember(id: "5bbba48ed35c6545e8bdcf8d")
        } else if row == 24 {
            openMember(id: "5bbba4a2d35c6545e8bdcf8f")
        } else if row == 25 {
            openMember(id: "5bcc5d33d35c65283a6e4894")
        } else if row == 26 {
            openMember(id: "5bcc5db9d35c65283a6e4896")
        } else if row == 27 {
            openMember(id: "5bcc5dd6d35c65283a6e4898")
        } else if row == 28 {
            openMember(id: "5bce3dbdd35c653fc4e0ddb1")
        } else if row == 29 {
            openMember(id: "5bce3df0d35c653fc4e0ddb3")
        } else if row == 30 {
            openMember(id: "5bce3e15d35c653fc4e0ddb5")
        }
        myPickerView.removeFromSuperview()
    }
    
    @objc func loginWithInstagram() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = InstagramLoginVC()
    }
    
    @objc func akay() {
        openMember(id: isLocal ? "5b5a3c61d35c65260545d832" : "5b5a3c61d35c65260545d832")
    }
    @objc func melis() {
        openMember(id: isLocal ? "5b5aa83dd35c650e3ffeeb62" : "5b5aa83dd35c650e3ffeeb62")
    }
    @objc func belkay() {
        openMember(id: isLocal ? "5b5aa85bd35c650e3ffeeb63" : "5b5aa85bd35c650e3ffeeb63")
    }
    @objc func aykut() {
        openMember(id: isLocal ? "5b5aa7aad35c650e3ffeeb61" : "5b5aa7aad35c650e3ffeeb61")
    }
    @objc func can() {
        openMember(id: isLocal ? "5b60b05ad35c6506237e6ae7" : "5b60b05ad35c6506237e6ae7")
    }
    @objc func uzun() {
        openMember(id: isLocal ? "5b5aa8a4d35c650e3ffeeb64" : "5b5aa8a4d35c650e3ffeeb64")
    }
    @objc let group = DispatchGroup()
    @objc func getMemberInfo(memberId: String) {
        let jsonURL = URL(string: getMemberInfoURL + memberId)!
        group.enter()
        jsonURL.get { data, response, error in
            guard
                let returnData = data,
                let postOfMember = try? JSONSerialization.jsonObject(with: returnData, options: .mutableContainers) as? [String: AnyObject]
                else {
                    if data != nil {
                        ServiceLocator.logErrorMessage(data: data!, chlId: "", sUrl: getMemberInfoURL, inputs: "memberID=\(memberId)")
                    }
                    return
            }
            self.group.leave()
            if let post = postOfMember {
                memberID = memberId
                memberFbID = (post["facebookID"] as? String)!
                memberName = "\((post["name"] as? String)!) \((post["surname"] as? String)!)"
                countOffollowers = (post["followerCount"] as? Int)!
                countOffollowing = (post["followingCount"] as? Int)!
                privateAccount = (post["privateMember"] as? Bool)!
            }
        }
    }
    
    @objc var splashTimer: Timer?
    @objc func openMember(id:String) {
        if Util.controlNetwork() {
            return
        }
        let defaults = UserDefaults.standard
        defaults.set(id, forKey: "memberID")
        defaults.synchronize()
        getMemberInfo(memberId: id)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = SplashScreenController()
        splashTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(splashScreenToMain), userInfo: nil, repeats: false)
    }
    
    @objc func splashScreenToMain() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let waitResult = self.group.wait(timeout: .now() + 15)
        if waitResult == .timedOut {
            appDelegate.window?.rootViewController = ConnectionProblemController()
            return
        }
        appDelegate.window?.rootViewController = CustomTabBarController()
    }
    
    @objc func fetchFacebookProfile() {
        self.group.enter()
        //print permissions, such as public_profile
        let params = ["fields": "id, first_name, last_name, name, email, picture, friends, age_range, gender"]

        let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: params)
        let connection = FBSDKGraphRequestConnection()
        
        connection.add(graphRequest, completionHandler: { (connection, result, error) -> Void in
            if error == nil {
                // print("1")
                // print(result!)
                // print("https://graph.facebook.com/10156204749600712/invitable_friends?access_token=\(FBSDKAccessToken.current().tokenString)")
                let data = result as! [String : Any]
                let first_name = data["first_name"] as? String
                let last_name = data["last_name"] as? String
                let email = data["email"] as? String
                let FBid = data["id"] as? String
                let age_range = data["age_range"] as? String
                let gender = data["gender"] as? String
                self.addMember(firstName: first_name!, surname: last_name!, email: email!, facebookID: FBid!, age_range: age_range ?? "", gender: gender!)
            } else {
                print("Error Getting Friends \(error!)");
            }
        })
        connection.start()
    }
    
    @objc func addMember(firstName: String, surname: String, email: String, facebookID: String, age_range: String, gender: String) {
        let deviceNotifyToken = UserDefaults.standard.object(forKey: "DeviceToken")
            
        let json: [String: Any] = ["name": firstName,
                                   "surname": surname,
                                   "email": email,
                                   "facebookID": facebookID,
                                   "phoneModel":"\(UIDevice().type)",
                                   "region": Locale.current.regionCode!,
                                   "language":Locale.current.languageCode!,
                                   "releaseVersion": Bundle.main.releaseVersionNumber!,
                                   "buildVersion" : Bundle.main.buildVersionNumber!,
                                   "osVersion": UIDevice.current.systemVersion,
                                   "age_range": age_range,
                                   "gender": gender,
                                   "deviceNotifyToken": deviceNotifyToken ?? ""
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
                    self.group.leave()
                    DispatchQueue.main.async {
                        let idOfMember = NSString(data: data, encoding: String.Encoding.utf8.rawValue)!
                        memberID = idOfMember as String
                        memberFbID = facebookID
                        memberName = "\(firstName) \(surname)"
                        let defaults = UserDefaults.standard
                        defaults.set(memberID, forKey: "memberID")
                        defaults.synchronize()
                    }
                } else {
                    let error = ServiceLocator.getErrorMessage(data: data, chlId: "", sUrl: addMemberURL, inputs: "name:\(firstName), surname: \(surname), email:\(email), facebookID:\(facebookID), phoneModel:\(UIDevice().type), region:\(Locale.current.regionCode!), language:\(Locale.current.languageCode!)")
                    self.popupAlert(message: error, willDelay: false)
                }
            }
        }).resume()
    }
    
    @objc let instagramLogin: UIButton = {
        let button = UIButton(type: UIButtonType.system)
        button.setTitle("Continue with Instagram", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.backgroundColor = UIColor(red: 59/255, green: 89/255, blue: 153/255, alpha: 1)
        button.layer.cornerRadius = 2        
        return button
    }()    
}
