//
//  Post.swift
//  facebookfeed2
//
//  Created by iakay on 5.03.2018.
//  Copyright © 2018 challenge. All rights reserved.
//

import UIKit

class Post: SafeJsonObject {
    @objc var id: String?
    @objc var name: String?
    @objc var thinksAboutChallenge: String?
    @objc var countOfComments: NSNumber?
    @objc var untilDateStr: NSString?
    @objc var type: String?
    @objc var subject: String?
    var done : Bool?
    var isComeFromSelf : Bool?
    @objc var firstTeamCount : String?
    @objc var secondTeamCount : String?
    @objc var challengerFBId : String?
    @objc var challengerId : String?
    @nonobjc var versusAttendanceList = [VersusAttendance]()
    @nonobjc var joinAttendanceList = [JoinAttendance]()
    var supportFirstTeam : Bool?
    var supportSecondTeam : Bool?
    @objc var firstTeamSupportCount : NSNumber?
    @objc var secondTeamSupportCount : NSNumber?
    @objc var countOfProofs: NSNumber?
    @objc var insertTime : String?
    @objc var status : String?
    @objc var firstTeamScore : String?
    @objc var secondTeamScore : String?
    var proofed: Bool?
    var active: Bool?
    var proofedByChallenger: Bool?
    @objc var goal: String?
    @objc var result: String?
    var canJoin: Bool?
    var joined: Bool?
    var homeWin: Bool?
    var awayWin: Bool?
    var provedWithImage: Bool?
    var rejectedByAllAttendance: Bool?
    var timesUp: Bool?
    var firstRow: Bool = false
    @objc var sendingApproveMemberId: String?
    @objc var sendApproveName: String?
    @objc var sendApproveFacebookId: String?
    var waitForApprove: Bool?
    var scoreRejected: Bool?
    @objc var scoreRejectName: String?
    @objc var visibility: NSNumber?
}
