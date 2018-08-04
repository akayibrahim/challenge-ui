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
    var isCont: Bool = false
    var splashTimer: Timer?
    var customTabBarController: CustomTabBarController!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()

        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)

        
        if(FBSDKAccessToken.current() != nil) {
            if let memberId = UserDefaults.standard.object(forKey: "memberID") {
                if dummyServiceCall == false {
                    getMemberInfo(memberId: memberId as! String)
                    self.group.wait()
                } else {
                    isCont = true
                }
            }
        }
        
        if isCont {
            // preFetchChallenges(url: getChallengesURL + memberID + "&page=0", profile: false)
            customTabBarController = CustomTabBarController()
            preFetchTrendChallenges()
            window?.rootViewController = SplashScreenController()
            splashTimer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(splashScreenToMain), userInfo: nil, repeats: false)
        } else {             
            FBSDKLoginManager().logOut()
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
    
    func preFetchChallenges(url: String, profile : Bool) {
        let jsonURL = URL(string: url)!
        jsonURL.get { data, response, error in
            guard
                data != nil,
                let postsArray = try? JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [[String: AnyObject]]
                else {                    
                    return
            }
            DispatchQueue.global(qos: .background).async {
                if postsArray?.isEmpty == false {
                    for postDictionary in postsArray! {
                        let post = ServiceLocator.mappingOfPost(postDictionary: postDictionary)
                        let url = URL(string: downloadImageURL + "?challengeId=\(post.id!)&memberId=\(post.challengerId!)")
                        ImageService.cacheImage(withURL: url!)
                    }
                }
            }
        }
    }
    
    func preFetchTrendChallenges() {
        let urlStr = getTrendChallengesURL + memberID + "&subjectSearchKey=&page=0"
        let urlStrWithPerm = urlStr.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        let url = NSURL(string: urlStrWithPerm!)!
        URLSession.shared.dataTask(with: url as URL, completionHandler: { (data, response, error) -> Void in
            if error == nil && data != nil {
                do {
                    if let postsArray = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [[String: AnyObject]] {
                        DispatchQueue.global(qos: .background).async {
                            for postDictionary in postsArray {
                                let trend = TrendRequest()
                                trend.setValuesForKeys(postDictionary)
                                let url = URL(string: downloadImageURL + "?challengeId=\(trend.challengeId!)&memberId=\(trend.challengerId!)")
                                ImageService.cacheImage(withURL: url!)
                            }
                        }
                    }
                } catch let err {
                    print(err)
                }
            }
        }).resume()
    }
    
    func splashScreenToMain() {
        window?.rootViewController = customTabBarController
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
     let group = DispatchGroup()
    func getMemberInfo(memberId: String) {
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
                self.group.leave()
                memberFbID = facebookID
                memberID = (post["id"] as? String)!
                memberName = "\((post["name"] as? String)!) \((post["surname"] as? String)!)"
                countOffollowers = (post["followerCount"] as? Int)!
                countOffollowing = (post["followingCount"] as? Int)!
            }
        }
    }
}

