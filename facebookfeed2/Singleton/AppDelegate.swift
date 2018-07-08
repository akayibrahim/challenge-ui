//
//  AppDelegate.swift
//  chlfeed
//
//  Created by Akay on 11/20/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import MediaPlayer
import AudioToolbox
import FBSDKLoginKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()

        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)

        if(FBSDKAccessToken.current() != nil) {
        // if (true) {
            if let memberId = UserDefaults.standard.object(forKey: "memberID") {
                memberID = memberId as! String
                getMemberInfo(memberId: memberID)                
                window?.rootViewController = CustomTabBarController()
            } else {
                FBSDKLoginManager().logOut()
                window?.rootViewController = FacebookController()
            }
        } else {
            window?.rootViewController = FacebookController()
        }
        
        UINavigationBar.appearance().barTintColor = navAndTabColor
        UINavigationBar.appearance().titleTextAttributes = [NSFontAttributeName: UIFont(name: "BodoniSvtyTwoITCTT-Bold", size: 24)!, NSForegroundColorAttributeName: UIColor.white]
        
        UITabBar.appearance().tintColor = navAndTabColor
        
        let barButtonColor  = UIBarButtonItem.appearance()
        barButtonColor.tintColor = UIColor.white
        
        application.statusBarStyle = .lightContent
        playAudioWithOther()
        return true
    }
    
    func playAudioWithOther() {
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
        
        let handled = FBSDKApplicationDelegate.sharedInstance().application(app, open: url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String!, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
        
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
    
    func getMemberInfo(memberId: String) {
        let url = URL(string: getMemberInfoURL + memberId)!
        URLSession.shared.dataTask(with: url as URL, completionHandler: { (data, response, error) -> Void in
            if error == nil && data != nil {
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 200 {
                        do {
                            if let post = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [String: Any] {
                                memberFbID = (post["facebookID"] as? String)!
                                memberName = "\((post["name"] as? String)!) \((post["surname"] as? String)!)"
                                countOffollowers = (post["followerCount"] as? Int)!
                                countOffollowing = (post["followingCount"] as? Int)!
                            }
                        } catch let err {
                            print(err)
                        }
                    } else {
                        let error = ServiceLocator.getErrorMessage(data: data!, chlId: "", sUrl: getMemberInfoURL, inputs: "memberID:\(memberId)")
                        print(error)
                        // TODO self.popupAlert(message: error, willDelay: false)
                    }
                }
            }
        }).resume()
    }
}

