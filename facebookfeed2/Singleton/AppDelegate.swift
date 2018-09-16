//
//  AppDelegate.swift
//  chlfeed
//
//  Created by Akay on 11/20/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import MediaPlayer
import AudioToolbox
import GoogleSignIn
import Fabric
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {
    var window: UIWindow?
    @objc var isCont: Bool = false
    @objc var splashTimer: Timer?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // window?.rootViewController = SplashScreenController()
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        let defaults = UserDefaults.standard
        defaults.set(true, forKey: "startApp")
        defaults.synchronize()
        
        if let vol = UserDefaults.standard.object(forKey: "volume") {
            volume = vol as! Float
        }
        
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        GIDSignIn.sharedInstance().clientID = "241509157224-cbdshgv4f08i9vvo6hclidic4gr94i3r.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().delegate = self
        
        if !Reachability.isConnectedToNetwork() {
            window?.rootViewController = ConnectionProblemController()
        } else {
            openApp()
        }
        
        UINavigationBar.appearance().barTintColor = navAndTabColor
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.font: UIFont(name: "BodoniSvtyTwoITCTT-Bold", size: 24)!, NSAttributedStringKey.foregroundColor: UIColor.white]
        
        UITabBar.appearance().tintColor = navAndTabColor
        
        let barButtonColor  = UIBarButtonItem.appearance()
        barButtonColor.tintColor = UIColor.white
        
        application.statusBarStyle = .lightContent
        playAudioWithOther()
        
        Fabric.with([Crashlytics.self])
        self.logUser()

        return true
    }
    
    func logUser() {
        // TODO: Use the current user's information
        // You can call any combination of these three methods
        Crashlytics.sharedInstance().setUserEmail("that_see@hotmail.com")
        // Crashlytics.sharedInstance().setUserIdentifier("12345")
        // Crashlytics.sharedInstance().setUserName("iakay")
    }

    @objc func openApp() {
        let token = FBSDKAccessToken.current()
        if(token != nil || GIDSignIn.sharedInstance().hasAuthInKeychain()) {
            if let memberId = UserDefaults.standard.object(forKey: "memberID") {
                if dummyServiceCall == false {
                    self.getMemberInfo(memberId: memberId as! String)
                    let waitResult = self.group.wait(timeout: .now() + 15)
                    if waitResult == .timedOut {
                        window?.rootViewController = ConnectionProblemController()
                        return
                    }
                    ServiceLocator.fetchFacebookFriends()
                } else {
                    isCont = true
                }
            }
        }
        
        if isCont {
            window?.rootViewController = CustomTabBarController()
            // splashTimer = Timer.scheduledTimer(timeInterval: 0.0, target: self, selector: #selector(splashScreenToMain), userInfo: nil, repeats: false)
        } else {
            FBSDKLoginManager().logOut()
            window?.rootViewController = FacebookController()
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print("\(error.localizedDescription)")
        } else {
            self.group.enter()
            // let userId = user.userID                  // For client-side use only!
            // let idToken = user.authentication.idToken // Safe to send to the server
            // let fullName = user.profile.name
            let givenName = user.profile.givenName
            let familyName = user.profile.familyName
            let email = user.profile.email
            var imageUrlAbsString : String = ""
            if user.profile.hasImage {
                let imageUrl = signIn.currentUser.profile.imageURL(withDimension: 200)
                imageUrlAbsString = (imageUrl?.absoluteString)!
                // print(" image url: ", imageUrlAbsString!)
            }
            // print("userid:\(userId!), idToken:\(idToken!), fullName:\(fullName!), givenName:\(givenName!), familyName:\(familyName!), email:\(email!)")
            self.addMember(firstName: givenName!, surname: familyName!, email: email!, facebookID: imageUrlAbsString)
            if GIDSignIn.sharedInstance().hasAuthInKeychain() {
                window?.rootViewController = SplashScreenController()
                splashTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(splashScreenToMain), userInfo: nil, repeats: false)
            }
        }
    }
    
    @objc func splashScreenToMain() {
        group.wait()
        window?.rootViewController = CustomTabBarController()
    }
    
    @objc func addMember(firstName: String, surname: String, email: String, facebookID: String) {        
        let json: [String: Any] = ["name": firstName,
                                   "surname": surname,
                                   "email": email,
                                   "facebookID": facebookID,
                                   "phoneModel":"\(UIDevice().type)",
            "region": Locale.current.regionCode!,
            "language":Locale.current.languageCode!
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
                    self.group.leave()
                    let error = ServiceLocator.getErrorMessage(data: data, chlId: "", sUrl: addMemberURL, inputs: "name:\(firstName), surname: \(surname), email:\(email), facebookID:\(facebookID), phoneModel:\(UIDevice().type), region:\(Locale.current.regionCode!), language:\(Locale.current.languageCode!)")
                    let alert = UIAlertController(title: "Error", message: error, preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    self.window?.rootViewController?.present(alert, animated: true, completion: nil)
                }
            }
        }).resume()
    }
    
    @objc func playAudioWithOther() {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, with: AVAudioSessionCategoryOptions.mixWithOthers)
            do {
                try AVAudioSession.sharedInstance().setActive(true)
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        let facebookDidHandle = FBSDKApplicationDelegate.sharedInstance().application(app, open: url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String?, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
        let googleDidHandle = GIDSignIn.sharedInstance().handle(url as URL?,
                                         sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,
                                         annotation: options[UIApplicationOpenURLOptionsKey.annotation])
        return facebookDidHandle || googleDidHandle
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        FBSDKAppEvents.activateApp()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
     @objc let group = DispatchGroup()
    @objc func getMemberInfo(memberId: String) {
        group.enter()
        let jsonURL = URL(string: getMemberInfoURL + memberId)!
        jsonURL.get { data, response, error in
            guard
                let returnData = data,
                let postOfMember = try? JSONSerialization.jsonObject(with: returnData, options: .mutableContainers) as? [String: AnyObject]
                else {
                    if data != nil {
                        let error = ServiceLocator.getErrorMessage(data: data!, chlId: "", sUrl: getMemberInfoURL, inputs: "memberID=\(memberId)")
                        print(error)
                    } else {
                        self.group.leave()
                    }
                    return
            }
            if let post = postOfMember {
                guard let facebookID = post["facebookID"] as? String else {
                    //FBSDKLoginManager().logOut()
                    //self.window?.rootViewController = FacebookController()
                    return
                }
                self.isCont = true
                memberFbID = facebookID
                memberID = (post["id"] as? String)!
                memberName = "\((post["name"] as? String)!) \((post["surname"] as? String)!)"
                countOffollowers = (post["followerCount"] as? Int)!
                countOffollowing = (post["followingCount"] as? Int)!
                self.group.leave()
            }
        }
    }
}

