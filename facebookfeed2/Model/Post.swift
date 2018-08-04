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
    var thinksAboutChallenge: String?
    var countOfComments: NSNumber?
    var untilDateStr: NSString?
    var type: String?
    var subject: String?
    var done : Bool?
    var isComeFromSelf : Bool?
    var firstTeamCount : String?
    var secondTeamCount : String?
    var challengerFBId : String?
    var challengerId : String?
    @nonobjc var versusAttendanceList = [VersusAttendance]()
    @nonobjc var joinAttendanceList = [JoinAttendance]()
    var supportFirstTeam : Bool?
    var supportSecondTeam : Bool?
    var firstTeamSupportCount : NSNumber?
    var secondTeamSupportCount : NSNumber?
    var countOfProofs: NSNumber?
    var insertTime : String?
    var status : String?
    var firstTeamScore : String?
    var secondTeamScore : String?
    var proofed: Bool?
    var active: Bool?
    var proofedByChallenger: Bool?
    var goal: String?
    var result: String?
    var canJoin: Bool?
    var joined: Bool?
    var homeWin: Bool?
    var awayWin: Bool?
    var provedWithImage: Bool?
    var rejectedByAllAttendance: Bool?
}
