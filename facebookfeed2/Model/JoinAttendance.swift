//
//  JoinAttendance.swift
//  facebookfeed2
//
//  Created by iakay on 5.03.2018.
//  Copyright © 2018 challenge. All rights reserved.
//

import UIKit

class JoinAttendance: SafeJsonObject {
    @objc var memberId: String?
    var join: Bool?
    var proof: Bool?
    @objc var FacebookID: String?
    
    @objc init(data: [String : AnyObject]) {
        self.memberId = data["memberId"] as? String ?? ""
        self.join = data["join"] as? Bool ?? false
        self.proof = data["proof"] as? Bool ?? false
        self.FacebookID = data["facebookID"] as? String ?? ""
    }
}
