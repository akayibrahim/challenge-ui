//
//  Util.swift
//  facebookfeed2
//
//  Created by iakay on 31.07.2018.
//  Copyright © 2018 challenge. All rights reserved.
//

import Foundation

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
}
