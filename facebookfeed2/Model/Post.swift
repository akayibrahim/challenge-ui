//
//  Post.swift
//  facebookfeed2
//
//  Created by iakay on 5.03.2018.
//  Copyright © 2018 challenge. All rights reserved.
//

import UIKit

class Post: SafeJsonObject {
    var id: String?
    var name: String?
    var profileImageName: String?
    var thinksAboutChallenge: String?
    var countOfLike: NSNumber?
    var countOfComments: NSNumber?
    var chlDate: NSDate?
    var untilDate: NSDate?
    var untilDateStr: NSString?
    var type: String?
    var subject: String?
    var done : Bool?
    var isComeFromSelf : Bool?
    var countOfJoins : NSNumber?
    var firstTeamCount : String?
    var secondTeamCount : String?
    var challengerFBId : String?
    @nonobjc var versusAttendanceList = [VersusAttendance]()
    @nonobjc var joinAttendanceList = [JoinAttendance]()
    var amILike : Bool?
    var supportFirstTeam : Bool?
    var supportSecondTeam : Bool?
    var firstTeamSupportCount : NSNumber?
    var secondTeamSupportCount : NSNumber?
    var countOfProofs: NSNumber?
    var insertTime : String?
    var status : String?
}
