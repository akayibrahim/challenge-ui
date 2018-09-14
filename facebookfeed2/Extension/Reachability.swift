//
//  Reachability.swift
//  facebookfeed2
//
//  Created by iakay on 8.08.2018.
//  Copyright © 2018 challenge. All rights reserved.
//

import UIKit
import SystemConfiguration
import Foundation

let groupReachability = DispatchGroup()
var connectivityOfHost = false
public class Reachability {
    
    class func isConnectedToNetwork() -> Bool {
        if isLocal {
            return true
        }
        connectivityOfHost = false
        testHostConnectivity()
        
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }
        
        /* Only Working for WIFI
         let isReachable = flags == .reachable
         let needsConnection = flags == .connectionRequired
         
         return isReachable && !needsConnection
         */
        
        // Working for Cellular and WIFI
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        let ret = (isReachable && !needsConnection) && !connectivityOfHost
        
        return ret
        
    }
    
    class func testHostConnectivity() {
        let jsonURL = URL(string: testHostConnectivityURL)!
        jsonURL.get { data, response, error in
            if error != nil {
                if (error?.isConnectivityError)! {
                    connectivityOfHost = true
                }
            }
        }
        /*
        let waitResult = groupReachability.wait(timeout: .now() + 10)
        if waitResult == .timedOut {
            testHostConnectivity = true
        }
         */
    }
    
    class func isConnectedToInternet() -> Bool {
        let hostname = "google.com"
        //let hostinfo = gethostbyname(hostname)
        let hostinfo = gethostbyname2(hostname, AF_INET6)//AF_INET6
        if hostinfo != nil {
            return true // internet available
        }
        return false // no internet
    }
}
