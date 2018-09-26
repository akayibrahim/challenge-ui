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

class FacebookController: UIViewController, FBSDKLoginButtonDelegate, GIDSignInUIDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
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
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.openPickerView))
        tapGestureRecognizer.numberOfTapsRequired = 2
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGestureRecognizer)
        
        instagramLogin.frame = CGRect(x: view.center.x  - ((view.frame.width - 64) / 2), y: UIScreen.main.bounds.height * 1.2 / 2, width: view.frame.width - 64, height: 44)
        // instagramLogin.center = CGPoint(x: view.center.x, y: UIScreen.main.bounds.height * 0.3 / 2)
        // view.addSubview(instagramLogin)
        instagramLogin.addTarget(self, action: #selector(self.loginWithInstagram), for: UIControlEvents.touchUpInside)
        
        let loginButton = FBSDKLoginButton()
        loginButton.readPermissions = ["public_profile", "email", "user_friends"]
        view.addSubview(loginButton)
        //frame's are obselete, please use constraints instead because its 2016 after all
        loginButton.frame = CGRect(x: view.center.x  - ((view.frame.width - 64) / 2), y: UIScreen.main.bounds.height * 1.4 / 2, width: view.frame.width - 64, height: 44)
        loginButton.delegate = self
        
        let signInButton = GIDSignInButton()
        view.addSubview(signInButton)
        signInButton.frame = CGRect(x: view.center.x  - ((view.frame.width - 64) / 2), y: UIScreen.main.bounds.height * 1.6 / 2, width: view.frame.width - 64, height: 44)
        
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
    var pickerData = ["İbrahim AKAY" , "Serkan AYKUT" , "Melisa Bahçıvan" , "Berkay Bahçıvan", "Seher CAN", "Taner UZUN"]
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerDone()
    }
    
    @objc func pickerCancel() {
        myPickerView.removeFromSuperview()
    }
    
    @objc func pickerDone() {
        let row = myPickerView.selectedRow(inComponent: 0);
        if row == 0 {
            akay()
        } else if row == 1 {
            aykut()
        } else if row == 2 {
            melis()
        } else if row == 3 {
            belkay()
        } else if row == 4 {
            can()
        } else if row == 5 {
            uzun()
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
        let params = ["fields": "id, first_name, last_name, name, email, picture,friends"]

        let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: params)
        let connection = FBSDKGraphRequestConnection()
        
        connection.add(graphRequest, completionHandler: { (connection, result, error) -> Void in
            if error == nil {
                print("1")
                // print(result!)
                // print("https://graph.facebook.com/10156204749600712/invitable_friends?access_token=\(FBSDKAccessToken.current().tokenString)")
                let data = result as! [String : Any]
                let first_name = data["first_name"] as? String
                let last_name = data["last_name"] as? String
                let email = data["email"] as? String
                let FBid = data["id"] as? String
                self.addMember(firstName: first_name!, surname: last_name!, email: email!, facebookID: FBid!)
            } else {
                print("Error Getting Friends \(error!)");
            }
        })
        connection.start()
    }
    
    @objc func addMember(firstName: String, surname: String, email: String, facebookID: String) {
        let json: [String: Any] = ["name": firstName,
                                   "surname": surname,
                                   "email": email,
                                   "facebookID": facebookID,
                                   "phoneModel":"\(UIDevice().type)",
                                   "region": Locale.current.regionCode!,
                                   "language":Locale.current.languageCode!,
                                   "releaseVersion": Bundle.main.releaseVersionNumber!,
                                   "buildVersion" : Bundle.main.buildVersionNumber!,
                                   "osVersion": UIDevice.current.systemVersion
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
