//
//  VersusAttendance.swift
//  facebookfeed2
//
//  Created by iakay on 5.03.2018.
//  Copyright © 2018 challenge. All rights reserved.
//

import UIKit

class VersusAttendance: SafeJsonObject {
    @objc var memberId: String?
    var accept: Bool?
    var firstTeamMember: Bool?
    var secondTeamMember: Bool?
    @objc var FacebookID: String?
    
    @objc init(data: [String : AnyObject]) {
        self.memberId = data["memberId"] as? String ?? ""
        self.accept = data["accept"] as? Bool ?? false
        self.firstTeamMember = data["firstTeamMember"] as? Bool ?? false
        self.secondTeamMember = data["secondTeamMember"] as? Bool ?? false
        self.FacebookID = data["facebookID"] as? String ?? ""
    }
}
