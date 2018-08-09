//
//  GlobalVariables.swift
//  facebookfeed2
//
//  Created by iakay on 6.04.2018.
//  Copyright © 2018 challenge. All rights reserved.
//

import UIKit

var memberID = dummyServiceCall ? "5a81b0f0f8b8e43e70325d3d" : ""
var memberFbID = "" //10156204749600712" // dummy
var memberName = "" //Seher Can" // dummy
var countOffollowers: Int = 0
var countOffollowing: Int = 0

var defaultURL = UIDevice.current.isSimulator ?  "http://localhost:8080" : "http://107.22.156.149:8080"

// CONSTANTS
var dummyServiceCall : Bool = false
var isLocal: Bool = UIDevice.current.isSimulator
var SELF = "SELF"
var PUBLIC = "PUBLIC"
var PRIVATE = "PRIVATE"
var pagesBackColor : UIColor = UIColor.rgb(229, green: 231, blue: 235)
var profileIndex : Int = 4
var chanllengeIndex : Int = 0
var trendsIndex : Int = 1
var activityIndex : Int = 3
var navAndTabColor : UIColor = UIColor(red: 244/255, green: 0/255, blue: 9/255, alpha: 1)
var scoreColor : UIColor = UIColor(red: 194/255, green: 25/255, blue: 28/255, alpha: 1)
var blueColor : UIColor = UIColor(red: 51/255, green: 90/255, blue: 149/255, alpha: 1)
// UIColor(red: 244/255, green: 0/255, blue: 9/255, alpha: 1) coca-cola red
// UIColor(red: 51/255, green: 90/255, blue: 149/255, alpha: 1)
var screenWidth = UIScreen.main.bounds.width
var screenHeight = UIScreen.main.bounds.height
var globalHeight : CGFloat = 44
var volume : Float =  0
var fontMarkerFelt = "Marker Felt"
var teamCountZero = "0"
var teamCountOne = "1"
var teamCountTwo = "2"
var teamCountThree = "3"
var teamCountFour = "4"
var comment = "COMMENT"
var proof = "PROOF"
var supportType = "SUPPORT"
var following = "FOLLOWING"
var follower = "FOLLOWER"
var join = "JOIN"
var accept = "ACCEPT"
var commentCharacterLimit : Int = 400
var FRWRD_CHNG_CMMNT = "CMMNT"
var FRWRD_CHNG_PRV = "PRV"

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
var unknownImage = "unknownImage"

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
var joinToChlVar = "Join It"
var justMe = "Just Me"
var selectText = "Select"
var followButtonText = "Follow"
var customSubjectLabel = "Custom Subject"
var ok = "OK"
var greaterThan = NSMutableAttributedString(string: ">", attributes: [NSAttributedStringKey.font: UIFont(name: "EuphemiaUCAS", size: 18)!])
var proofedText = "PROVED"
var scoreForPrivate = "-"
var scoreForSelf = "of"

// URL's
var getChallengesURL = defaultURL + "/getChallenges?memberId="
var getChallengesOfMemberURL = defaultURL + "/getChallengesOfMember?memberId="
var getTrendChallengesURL = defaultURL + "/getTrendChallenges?memberId="
var getExplorerChallengesURL = defaultURL + "/getExplorerChallenges?memberId="
var addJoinChallengeURL = defaultURL + "/addJoinChallenge"
var addVersusChallengeURL = defaultURL + "/addVersusChallenge"
var addSelfChallengeURL = defaultURL + "/addSelfChallenge"
var getSubjectsURL = defaultURL + "/getSubjects"
var getSelfSubjectsURL = defaultURL + "/getSelfSubjects"
var commentToChallangeURL = defaultURL + "/commentToChallange"
var getCommentsURL = defaultURL + "/getComments?challengeId="
var supportChallengeURL = defaultURL + "/supportChallenge"
var joinToChallengeURL = defaultURL + "/joinToChallenge"
var getSuggestionsForFollowingURL = defaultURL + "/getSuggestionsForFollowing?memberId="
var getFollowingListURL = defaultURL + "/getFollowingList?memberId="
var getFollowerListURL = defaultURL + "/getFollowerList?memberId="
var followingFriendURL = defaultURL + "/followingFriend"
var deleteSuggestionURL = defaultURL + "/deleteSuggestion"
var updateProgressOrDoneForSelfURL = defaultURL + "/updateProgressOrDoneForSelf"
var updateResultsOfVersusURL = defaultURL + "/updateResultsOfVersus"
var uploadImageURL = defaultURL + "/uploadImage"
var downloadImageURL = defaultURL + "/downloadImage"
var downloadVideoURL = defaultURL + "/downloadVideo"
var getProofInfoListByChallengeURL = defaultURL + "/getProofInfoListByChallenge?challengeId="
var downloadProofImageByObjectIdURL = defaultURL + "/downloadProofImageByObjectId"
var addMemberURL = defaultURL + "/addMember"
var getMemberInfoURL = defaultURL + "/getMemberInfo?memberId="
var getActivitiesURL = defaultURL + "/getActivities?toMemberId="
var getChallengeRequestURL = defaultURL + "/getChallengeRequest?memberId="
var acceptOrRejectChlURL = defaultURL + "/acceptOrRejectChl"
var deleteChallengeURL = defaultURL + "/deleteChallenge?challengeId="
var errorLogURL = defaultURL + "/errorLog"
var isMyFriendURL = defaultURL + "/isMyFriend?memberId="
var getChallengesOfFriendURL = defaultURL + "/getChallengesOfFriend?memberId="
var getActivityCountURL = defaultURL + "/getActivityCount?memberId="
var searchFriendsURL = defaultURL + "/searchFriends?searchKey="
var getChallengeSizeOfMemberURL = defaultURL + "/getChallengeSizeOfMember?memberId="
var getSupportListURL = defaultURL + "/getSupportList?challengeId="
var getChallengerListURL = defaultURL + "/getChallengerList?challengeId="

struct INSTAGRAM_IDS {
    static let INSTAGRAM_AUTHURL = "https://api.instagram.com/oauth/authorize/"
    static let INSTAGRAM_CLIENT_ID = "4d8864aeac294021bb23f31874a23df1"
    static let INSTAGRAM_CLIENTSERCRET = "ecc368e3de66464a8c8beabc02d59696"
    static let INSTAGRAM_REDIRECT_URI = "http://www.iakay.com"
    static let INSTAGRAM_ACCESS_TOKEN = "access_token"
    static let INSTAGRAM_SCOPE = "public_content"
}
