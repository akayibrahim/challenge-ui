//
//  Util.swift
//  facebookfeed2
//
//  Created by iakay on 31.07.2018.
//  Copyright © 2018 challenge. All rights reserved.
//

import Foundation
import AVFoundation
import YPImagePicker
import Alamofire
import CoreTelephony // Make sure to import CoreTelephony

public class Util {
    static func addForwardChange(forwardChange: ForwardChange) {
        let defaults = UserDefaults.standard
        if defaults.object(forKey: "forwardChange") != nil {
            defaults.removeObject(forKey: "forwardChange")
        }
        let encodedData = NSKeyedArchiver.archivedData(withRootObject: forwardChange)
        defaults.set(encodedData, forKey: "forwardChange")
        defaults.synchronize()
    }
    
    static func getForwardChange() -> ForwardChange {
        let defaults = UserDefaults.standard
        if defaults.object(forKey: "forwardChange") != nil {
            let decoded = defaults.object(forKey: "forwardChange") as! Data
            let forwardChange = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! ForwardChange
            defaults.removeObject(forKey: "forwardChange")
            return forwardChange
        }
        return ForwardChange(index: IndexPath(item:0, section: 0), forwardScreen: "")
    }
    
    static func removeForwardChange() {
        let defaults = UserDefaults.standard
        if defaults.object(forKey: "forwardChange") != nil {
            defaults.removeObject(forKey: "forwardChange")
        }
    }
    
    static func conficOfYpImagePicker() -> YPImagePickerConfiguration {
        var config = YPImagePickerConfiguration()
        config.library.mediaType = .photoAndVideo
        config.library.onlySquare  = false
        config.onlySquareImagesFromCamera = true
        config.targetImageSize = .original
        config.usesFrontCamera = false
        config.showsFilters = true
        // config.filters = [YPFilterDescriptor(name: "Normal", filterName: ""),
        //               YPFilterDescriptor(name: "Mono", filterName: "CIPhotoEffectMono")]
        config.shouldSaveNewPicturesToAlbum = false
        config.video.compression =  AVAssetExportPresetMediumQuality
        config.albumName = "Challenge"
        config.screens = [.library, .photo, .video]
        config.startOnScreen = .library
        config.video.recordingTimeLimit = 20
        config.video.trimmerMaxDuration = 20
        config.video.libraryTimeLimit = 900
        config.showsCrop = .rectangle(ratio: (Double(screenWidth / (screenWidth * heightRatioOfMedia))))
        config.wordings.libraryTitle = "Gallery"
        config.hidesStatusBar = true
        // config.overlayView = myOverlayView
        config.library.maxNumberOfItems = 1
        config.library.minNumberOfItems = 1
        config.library.numberOfItemsInRow = 3
        config.library.spacingBetweenItems = 2
        config.isScrollToChangeModesEnabled = true
        return config
    }
    
    static func controlNetwork() -> Bool {
        if !isConnectedToNetwork() {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController = ConnectionProblemController()
            return true
        }
        return false
    }
    
    static func isConnectedToNetwork() -> Bool {
        if isLocal {
            return true
        }
        //print("wwan:\(NetworkReachabilityManager()!.isReachableOnWWAN)")
        //print("wifi:\(NetworkReachabilityManager()!.isReachableOnEthernetOrWiFi)")
        //print("lte:\(checkConnection())")
        let reachabilityManager = Alamofire.NetworkReachabilityManager(host: "www.google.com")
        return NetworkReachabilityManager()!.isReachable && (reachabilityManager?.isReachable)!
    }
    
    let constantValue = 8 // Don't change this
    static func checkConnection() -> Bool {
        let telephonyInfo = CTTelephonyNetworkInfo()
        let currentConnection = telephonyInfo.currentRadioAccessTechnology
        if (currentConnection == CTRadioAccessTechnologyLTE) { // Connected to LTE
            return true
        } else if(currentConnection == CTRadioAccessTechnologyEdge) { // Connected to EDGE
            return true
        } else if(currentConnection == CTRadioAccessTechnologyWCDMA){ // Connected to 3G
            return true
        }
        return false
    }
    
    static func addMemberToDefaults(memberId:String, facebookId: String, nameSurname: String) {
        let defaults = UserDefaults.standard
        defaults.set(memberId, forKey: memberIdKey)
        defaults.set(facebookId, forKey: facebookIdKey)
        defaults.set(nameSurname, forKey: nameSurnameKey)
        defaults.synchronize()
    }
    
    static func addToDefaults(key:String, value: Any) {
        let defaults = UserDefaults.standard
        defaults.set(value, forKey: key)
        defaults.synchronize()
    }
    
    static func removeFromDefaults(key:String) {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: key)
        defaults.synchronize()
    }
    
    static func getFromDefaults(key:String) -> Any? {        
        return UserDefaults.standard.object(forKey: key)
    }
    
    static func removeMemberFromDefaults() {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: memberIdKey)
        defaults.removeObject(forKey: facebookIdKey)
        defaults.removeObject(forKey: nameSurnameKey)
        defaults.synchronize()
    }
    
    static func getUserMemberId() -> Any? {
        let memberId = UserDefaults.standard.object(forKey: memberIdKey)
        return memberId
    }
    
    static func getUserFacebookId() -> Any? {
        let facebookId = UserDefaults.standard.object(forKey: facebookIdKey)
        return facebookId
    }
    
    static func getUserNameSurname() -> Any? {
        let nameSurname = UserDefaults.standard.object(forKey: nameSurnameKey)
        return nameSurname
    }
    
    static func getServerUrl() {
        if !UIDevice.current.isSimulator {
            let url = ServiceLocator.getParameterValue(SRVR_URL)
            defaultURL = url != PARAMETER_DEFAULT ? url : serverURL
        }
    }
    
    static func shareViaFriend(view: UIView) -> UIActivityViewController {
        let text = "https://itunes.apple.com/tr/app/challenge/id1441255418?mt=8"
        let textToShare = [ text ]
        let activity = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activity.popoverPresentationController?.sourceView = view
        activity.excludedActivityTypes = [] // [UIActivityType.airDrop, UIActivityType.postToFacebook]
        return activity
    }
}
