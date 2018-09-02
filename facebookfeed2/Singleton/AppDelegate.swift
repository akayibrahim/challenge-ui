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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    @objc var isCont: Bool = false
    @objc var splashTimer: Timer?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let defaults = UserDefaults.standard
        defaults.set(true, forKey: "startApp")
        defaults.synchronize()
        
        // window?.rootViewController = SplashScreenController()
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        if let vol = UserDefaults.standard.object(forKey: "volume") {
            volume = vol as! Float
        }
        
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
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
        return true
    }
    
    @objc func openApp() {
        let token = FBSDKAccessToken.current()
        if(token != nil) {
            if let memberId = UserDefaults.standard.object(forKey: "memberID") {
                if dummyServiceCall == false {
                    ServiceLocator.fetchFacebookFriends()
                    self.getMemberInfo(memberId: memberId as! String)
                    self.group.wait()
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
    
    @objc func splashScreenToMain() {
        window?.rootViewController = CustomTabBarController()
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
        
        let handled = FBSDKApplicationDelegate.sharedInstance().application(app, open: url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String?, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
        
        return handled
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
                    FBSDKLoginManager().logOut()
                    self.window?.rootViewController = FacebookController()
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

