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
        config.usesFrontCamera = true
        config.showsFilters = true
        // config.filters = [YPFilterDescriptor(name: "Normal", filterName: ""),
        //               YPFilterDescriptor(name: "Mono", filterName: "CIPhotoEffectMono")]
        config.shouldSaveNewPicturesToAlbum = false
        config.video.compression =  AVAssetExportPresetMediumQuality
        config.albumName = "MyGreatAppName"
        config.screens = [.library, .photo, .video]
        config.startOnScreen = .library
        config.video.recordingTimeLimit = 20
        config.video.trimmerMaxDuration = 20
        // config.video.libraryTimeLimit = 20
        config.showsCrop = .rectangle(ratio: (Double(screenWidth / (screenWidth / 2))))
        config.wordings.libraryTitle = "Gallery"
        config.hidesStatusBar = true
        //config.overlayView = myOverlayView
        config.library.maxNumberOfItems = 1
        config.library.minNumberOfItems = 1
        config.library.numberOfItemsInRow = 3
        config.library.spacingBetweenItems = 2
        config.isScrollToChangeModesEnabled = false
        return config
    }
    
    static func controlNetwork() -> Bool {
        if !Reachability.isConnectedToNetwork() {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController = ConnectionProblemController()
            return true
        }
        return false
    }
}
