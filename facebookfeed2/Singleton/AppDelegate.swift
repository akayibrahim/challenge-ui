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
import UserNotifications
import Siren

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate, UNUserNotificationCenterDelegate {
    var window: UIWindow?
    @objc var isCont: Bool = false
    @objc var splashTimer: Timer?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // window?.rootViewController = SplashScreenController()
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        if ServiceLocator.isParameterOpen(GUIDE_OPEN) {
            // Util.removeFromDefaults(key: guide)
            if Util.getFromDefaults(key: guide) == nil {
                Util.addToDefaults(key: guide, value: true)
            }
        }
        Util.addToDefaults(key: startApp, value: true)
        
        if let vol = Util.getFromDefaults(key: "volume") {
            volume = vol as! Float
        }
        
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        GIDSignIn.sharedInstance().clientID = "241509157224-cbdshgv4f08i9vvo6hclidic4gr94i3r.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().delegate = self
        
        if !Util.controlNetwork() {
            Util.getServerUrl()
            openApp()
        }
        
        UINavigationBar.appearance().barTintColor = navAndTabColor
        // UIFont(name: "BodoniSvtyTwoITCTT-Bold", size: 24)!
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.font: UIFont(descriptor: .init(), size: 20), NSAttributedStringKey.foregroundColor: UIColor.white]
        
        UITabBar.appearance().tintColor = navAndTabColor
        
        let barButtonColor  = UIBarButtonItem.appearance()
        barButtonColor.tintColor = UIColor.white
        
        // application.statusBarStyle = .lightContent
        playAudioWithOther()
        
        registerForPushNotifications()
        
        setupSiren()
        
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
        //let token = FBSDKAccessToken.current()
        //if(token != nil || GIDSignIn.sharedInstance().hasAuthInKeychain()) {
        if Util.getUserMemberId() != nil {
            isCont = true
            memberID = Util.getUserMemberId() as! String
            memberFbID = Util.getUserFacebookId() as! String
            memberName = Util.getUserNameSurname() as! String
                /*
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
                 */
        }
        //}
        
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
            var gender = ""
            let idToken = user.authentication.accessToken
            let url = URL(string: "https://www.googleapis.com/oauth2/v3/userinfo?access_token=\(idToken!)")
            let session = URLSession.shared
            session.dataTask(with:  url!, completionHandler:  {(data, response, error) -> Void in
                do {
                    let userData = try JSONSerialization.jsonObject(with: data!, options:[]) as? [String:AnyObject]
                    gender = userData!["gender"] as! String
                    self.group.leave()
                    // let locale = userData!["locale"] as! String
                } catch {
                    NSLog("Account Information could not be loaded")
                }
            }).resume()
            group.wait()
            self.addMember(firstName: givenName!, surname: familyName!, email: email!, facebookID: imageUrlAbsString, gender: gender)
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
    
    @objc func addMember(firstName: String, surname: String, email: String, facebookID: String, gender: String) {
        group.enter()
        let deviceNotifyToken = UserDefaults.standard.object(forKey: "DeviceToken")
        let json: [String: Any] = [ "name": firstName,
                                    "surname": surname,
                                    "email": email,
                                    "facebookID": facebookID,
                                    "phoneModel":"\(UIDevice().type)",
                                    "region": Locale.current.regionCode!,
                                    "language":Locale.current.languageCode!,
                                    "releaseVersion": Bundle.main.releaseVersionNumber!,
                                    "buildVersion" : Bundle.main.buildVersionNumber!,
                                    "osVersion": UIDevice.current.systemVersion,
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
                    DispatchQueue.main.async {
                        let idOfMember = NSString(data: data, encoding: String.Encoding.utf8.rawValue)!
                        memberID = idOfMember as String
                        memberFbID = facebookID
                        memberName = "\(firstName) \(surname)"
                        Util.addMemberToDefaults(memberId: memberID, facebookId: memberFbID, nameSurname: memberName)
                    }
                    self.group.leave()
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
        Siren.shared.checkVersion(checkType: .immediately)
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        FBSDKAppEvents.activateApp()
        Siren.shared.checkVersion(checkType: .immediately)
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
    
    func registerForPushNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
            (granted, error) in
            print("Permission granted: \(granted)")
            UNUserNotificationCenter.current().delegate = self
            guard granted else { return }
            self.getNotificationSettings()
        }
    }
    
    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            print("Notification settings: \(settings)")
            guard settings.authorizationStatus == .authorized else { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data -> String in
            return String(format: "%02.2hhx", data)
        }
        if UserDefaults.standard.object(forKey: "DeviceToken") == nil {
            let token = tokenParts.joined()
            if let memberId = Util.getUserMemberId() {
                let jsonURL = URL(string: updateWithDeviceTokenURL + memberID + "&deviceToken=" + token)!
                jsonURL.get { data, response, error in
                    guard
                        data != nil
                        else {
                            if data != nil {
                                let error = ServiceLocator.getErrorMessage(data: data!, chlId: "", sUrl: updateWithDeviceTokenURL, inputs: "memberID=\(memberId)")
                                print(error)
                            }
                            return
                    }
                }
            }
            let defaults = UserDefaults.standard
            defaults.set(token, forKey: "DeviceToken")
            defaults.synchronize()
            print("Device Token: \(token)")
        }
    }
    
    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
    }
    
    func setupSiren() {
        if ServiceLocator.isParameterOpen(FORCE_UPDATE) {
            return
        }
        let siren = Siren.shared
        // Optional
        siren.delegate = self
        
        // Optional
        siren.debugEnabled = true
        Siren.shared.forceLanguageLocalization = Siren.LanguageType.english
        // Optional - Change the name of your app. Useful if you have a long app name and want to display a shortened version in the update dialog (e.g., the UIAlertController).
        //        siren.appName = "Test App Name"
        // Optional - Change the various UIAlertController and UIAlertAction messaging. One or more values can be changes. If only a subset of values are changed, the defaults with which Siren comes with will be used.
        //        siren.alertMessaging = SirenAlertMessaging(updateTitle: NSAttributedString(string: "New Fancy Title"),
        //                                                   updateMessage: NSAttributedString(string: "New message goes here!"),
        //                                                   updateButtonMessage: NSAttributedString(string: "Update Now, Plz!?"),
        //                                                   nextTimeButtonMessage: NSAttributedString(string: "OK, next time it is!"),
        //                                                   skipVersionButtonMessage: NSAttributedString(string: "Please don't push skip, please don't!"))
        // Optional - Defaults to .Option
        siren.alertType = .force // or .force, .skip, .none
        // Optional - Can set differentiated Alerts for Major, Minor, Patch, and Revision Updates (Must be called AFTER siren.alertType, if you are using siren.alertType)
        siren.majorUpdateAlertType = .force
        siren.minorUpdateAlertType = .force
        siren.patchUpdateAlertType = .force
        siren.revisionUpdateAlertType = .force
        
        // Optional - Sets all messages to appear in Russian. Siren supports many other languages, not just English and Russian.
        //        siren.forceLanguageLocalization = .russian
        // Optional - Set this variable if your app is not available in the U.S. App Store. List of codes: https://developer.apple.com/library/content/documentation/LanguagesUtilities/Conceptual/iTunesConnect_Guide/Chapters/AppStoreTerritories.html
        //        siren.countryCode = ""
        // Optional - Set this variable if you would only like to show an alert if your app has been available on the store for a few days.
        // This default value is set to 1 to avoid this issue: https://github.com/ArtSabintsev/Siren#words-of-caution
        // To show the update immediately after Apple has updated their JSON, set this value to 0. Not recommended due to aforementioned reason in https://github.com/ArtSabintsev/Siren#words-of-caution.
        siren.showAlertAfterCurrentVersionHasBeenReleasedForDays = 0
        
        // Optional (Only do this if you don't call checkVersion in didBecomeActive)
        //        siren.checkVersion(checkType: .immediately)
    }
}

extension AppDelegate: SirenDelegate
{
    func sirenDidShowUpdateDialog(alertType: Siren.AlertType) {
        print(#function, alertType)
    }
    
    func sirenUserDidCancel() {
        print(#function)
    }
    
    func sirenUserDidSkipVersion() {
        print(#function)
    }
    
    func sirenUserDidLaunchAppStore() {
        print(#function)
    }
    
    func sirenDidFailVersionCheck(error: Error) {
        print(#function, error)
    }
    
    func sirenLatestVersionInstalled() {
        print(#function, "Latest version of app is installed")
    }
    
    func sirenNetworkCallDidReturnWithNewVersionInformation(lookupModel: SirenLookupModel) {
        print(#function, "\(lookupModel)")
    }
    
    // This delegate method is only hit when alertType is initialized to .none
    func sirenDidDetectNewVersionWithoutAlert(title: String, message: String, updateType: UpdateType) {
        print(#function, "\n\(title)\n\(message).\nRelease type: \(updateType.rawValue.capitalized)")
    }
}

