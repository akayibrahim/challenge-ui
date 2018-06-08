//
//  GlobalVariables.swift
//  facebookfeed2
//
//  Created by iakay on 6.04.2018.
//  Copyright © 2018 challenge. All rights reserved.
//

import UIKit

//var memberFbID = "10156204749600712" // dummy
//var memberID = "5a81b0f0f8b8e43e70325d3d" // dummy
var memberFbID = "10156204749600712"
var memberID = "5b1a97bbcb353e79ca335a38"
var memberName = "İbrahim AKAY"
var countOffollowers = "126"
var countOffollowing = "198"

// CONSTANTS
var dummyServiceCall : Bool = false
var SELF = "SELF"
var PUBLIC = "PUBLIC"
var PRIVATE = "PRIVATE"
var pagesBackColor : UIColor = UIColor.rgb(229, green: 231, blue: 235)
var profileIndex : Int = 4
var chanllengeIndex : Int = 0
var trendsIndex : Int = 1
var navAndTabColor : UIColor = UIColor(red: 244/255, green: 0/255, blue: 9/255, alpha: 1)
var blueColor : UIColor = UIColor(red: 51/255, green: 90/255, blue: 149/255, alpha: 1)
// UIColor(red: 244/255, green: 0/255, blue: 9/255, alpha: 1) coca-cola red
// UIColor(red: 51/255, green: 90/255, blue: 149/255, alpha: 1)
var screenWidth = UIScreen.main.bounds.width
var globalHeight : CGFloat = 44
var volume : Float =  0
var fontMarkerFelt = "Marker Felt"
var teamCountZero = "0"
var teamCountOne = "1"
var teamCountTwo = "2"
var teamCountThree = "3"
var teamCountFour = "4"

// Assets Name
var supported = "supported"
var support = "support"
var acceptedRed = "acceptedRed"
var acceptedBlack = "acceptedBlack"
var unknown = "unknown"
var worldImage = "worldImage"
var more_icon = "more_icon"
var volumeUp = "volumeUp"
var volumeDown = "volumeDown"

// TITLES
var challengeTitle = "Challenge"
var profileTitle = "Profile"
var profileFirstHeader = "YOUR ACTIVE CHALLENGES"
var profileSecondHeader = "YOUR PAST CHALLENGES"
var commentsTableTitle = "Comments"
var proofsTableTitle = "Proofs"
var addChallengeTitle = "Add Challenge"

// BUTTON OR LABEL NAME
var supportText = "SUPPORT"
var viewAllComments = "View all 0 comments"
var viewAllProofs = "View all 0 proofs"
var addComents = "Add a comment.."
var addProofsVar = "Add a proof.."
var joinToChlVar = "Join To It"
var justMe = "Just Me"
var selectText = "Select"
var followButtonText = "Follow"
var customSubjectLabel = "Custom Subject"
var ok = "OK"
var greaterThan = NSMutableAttributedString(string: ">", attributes: [NSFontAttributeName: UIFont(name: "EuphemiaUCAS", size: 18)!])
var proofedText = "PROOFED"
var scoreForPrivate = " | SCORE | "

// URL's
var getChallengesURL = "http://localhost:8080/getChallenges?memberId="
var getChallengesOfMemberURL = "http://localhost:8080/getChallengesOfMember?memberId="
var getTrendChallengesURL = "http://localhost:8080/getTrendChallenges?memberId="
var addJoinChallengeURL = "http://localhost:8080/addJoinChallenge"
