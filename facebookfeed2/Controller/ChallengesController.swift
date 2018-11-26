//
//  ViewController.swift
//  chlfeed
//
//  Created by AKAY on 11/20/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import RxSwift
import CCBottomRefreshControl
import Crashlytics

var chlScrollMoveDown : Bool = false
var chlScrollMoveUp : Bool = false
var prflScrollMoveDown : Bool = false
var prflScrollMoveUp : Bool = false
var refreshControl : UIRefreshControl!
var selfRefreshControl : UIRefreshControl!

class SafeJsonObject: NSObject {
    
    override func setValue(_ value: Any?, forKey key: String) {
        let selectorString = "set\(key.uppercased().first!)\(String(key.dropFirst())):"
        let selector = Selector(selectorString)
        if responds(to: selector) {
            super.setValue(value, forKey: key)
        }
    }
    
}

class Feed: SafeJsonObject {
    @objc var feedUrl, title, link, author, type: String?
}

class FeedController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate, UICollectionViewDataSourcePrefetching {
    @objc var posts = [Post]()
    @objc var donePosts = [Post]()
    @objc var notDonePosts = [Post]()
    @objc var explorer : Bool = false
    @objc var trend : Bool = false
    @objc var challengIdForTrendAndExplorer: String?
    @objc var memberIdForExplorer: String?
    @objc var profile: Bool = false
    @objc var memberIdForFriendProfile: String?
    @objc var memberFbIdForFriendProfile: String?
    @objc var memberNameForFriendProfile: String?
    var memberCountOfFollowerForFriendProfile: Int?
    var memberCountOfFollowingForFriendProfile: Int?
    var memberIsPrivateForFriendProfile: Bool?
    @objc var isProfileFriend: Bool = false
    @objc var isProfileRequested: Bool = false
    @objc var currentPage : Int = 0
    @objc var selfCurrentPage : Int = 0
    @objc var explorerCurrentPage : Int = 0
    @objc var nowMoreData: Bool = false
    @objc var challangeCount: String = "0"
    @objc var goForward: Bool = false
    @objc var goForwardToSelection: Bool = false
    var isFetchingNextPage = false
    var selectedTabIndex : Int = 0
    var viewFramwWidth: CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Crashlytics.sharedInstance().crash()
        
        selectedTabIndex = self.tabBarController?.selectedIndex ?? selectedTabIndex
        viewFramwWidth = view.frame.width
        if !explorer && !trend {
            if selectedTabIndex != profileIndex && !self.profile {
                reloadChlPage()
                if let startApp = UserDefaults.standard.object(forKey: "startApp") {
                    let onStartApp = startApp as! Bool
                    if onStartApp {
                        let splash = SplashScreenController()
                        splash.hidesBottomBarWhenPushed = true
                        self.navigationController?.setNavigationBarHidden(true, animated: false)
                        navigationController?.pushViewController(splash, animated: false)
                    }
                }
            } else {
                reloadSelfPage()
            }
        }
        if !trend && !explorer {
            let bottomRefreshControl = UIRefreshControl()
            collectionView?.bottomRefreshControl = bottomRefreshControl
        }
        if profile {
        } else if selectedTabIndex == chanllengeIndex && !explorer && !trend {
            navigationItem.title = challengeTitle
            refreshControl = UIRefreshControl()
            refreshControl.addTarget(self, action: #selector(self.onRefesh), for: UIControlEvents.valueChanged)
            collectionView?.addSubview(refreshControl)
        } else if selectedTabIndex == profileIndex && !explorer {
            navigationItem.title = profileTitle
            selfRefreshControl = UIRefreshControl()
            selfRefreshControl.addTarget(self, action: #selector(self.onSelfRefesh), for: UIControlEvents.valueChanged)
            collectionView?.addSubview(selfRefreshControl)
        }
        
        collectionView?.backgroundColor = UIColor(white: 0.90, alpha: 1)
        collectionView?.alwaysBounceVertical = true
        
        collectionView?.register(FeedCell.self, forCellWithReuseIdentifier: "feedCellId")
        collectionView?.register(FeedCell.self, forCellWithReuseIdentifier: "profile")
        collectionView?.register(FeedCell.self, forCellWithReuseIdentifier: "selfCellId")
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.register(ChallengeHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader , withReuseIdentifier: "someRandonIdentifierString")
        collectionView?.prefetchDataSource = self
        collectionView?.isPrefetchingEnabled = true
        NotificationCenter.default.addObserver(self, selector:  #selector(self.appMovedToBackground), name:   Notification.Name.UIApplicationWillEnterForeground, object: nil)
    }
    
    @objc func appMovedToBackground() {
        if  (!goForward && self.tabBarController?.selectedIndex == chanllengeIndex)
            || (!goForward && self.tabBarController?.selectedIndex == selectedTabIndex && self.explorer)
            || (!goForward && self.tabBarController?.selectedIndex == selectedTabIndex && self.tabBarController?.selectedIndex == trendsIndex && self.trend) {
            self.playVisibleVideo()
        }
    }
    
    @objc func isTabIndex(_ index: Int) -> Bool {
        return selectedTabIndex == index
    }
    
    @objc func getActivityCount() {
        let jsonURL = URL(string: getActivityCountURL + memberID + "&delete=false")!
        jsonURL.get { data, response, error in
            guard
                let returnData = data
                else {
                    if data != nil {
                        ServiceLocator.logErrorMessage(data: data!, chlId: "", sUrl: getActivityCountURL, inputs: "memberID=\(memberID)")
                    }
                    return
            }
            DispatchQueue.main.async {
                let count = NSString(data: returnData, encoding: String.Encoding.utf8.rawValue)!
                if count != "0" {
                    self.navigationController?.tabBarController?.tabBar.items?[3].badgeValue = "\(count)"
                }
            }
        }
    }
    
    @objc func onRefesh() {
        if refreshControl.isRefreshing {
            reloadChlPage()
            refreshControl.endRefreshing()
        }
    }
    
    @objc func reloadChlPage() {
        self.currentPage = 0
        self.explorerCurrentPage = 0
        self.posts = [Post]()
        self.collectionView?.reloadData()
        self.collectionView?.numberOfItems(inSection: 0)
        self.collectionView?.showBlurLoader()
        self.loadChallenges()
    }
    
    @objc func onSelfRefesh() {
        if selfRefreshControl.isRefreshing {
            reloadSelfPage()
            selfRefreshControl.endRefreshing()
        }
    }
    
    @objc func reloadSelfPage() {
        self.selfCurrentPage = 0
        self.posts = [Post]()
        self.donePosts = [Post]()
        self.notDonePosts = [Post]()
        // self.collectionView?.reloadData()
        self.collectionView?.showBlurLoader()
        self.loadChallenges()
    }
    
    @objc func loadChallenges() {
        if dummyServiceCall == false {
            guard !isFetchingNextPage else { return }
            if Util.controlNetwork() {
                return
            }
            // Asynchronous Http call to your api url, using NSURLSession:
            if self.profile {
                getFriendInfo(memberIdForFriendProfile!)
                navigationItem.title = nameForOpenProfile
                if self.memberIdForFriendProfile != memberID {
                    self.fetchChallengeSize(memberId: self.memberIdForFriendProfile!)
                    self.fetchChallenges(url: getChallengesOfFriendURL + memberID + "&friendMemberId=" + self.memberIdForFriendProfile! + "&page=\(self.selfCurrentPage)", profile: true)
                } else if self.memberIdForFriendProfile == memberID {
                    self.fetchChallengeSize(memberId: memberID)
                    self.fetchChallenges(url: getChallengesOfMemberURL + memberID  + "&page=\(self.selfCurrentPage)", profile: true)
                }
                return
            } else if self.explorer {
                self.fetchChallenges(url: getExplorerChallengesURL + (self.memberIdForExplorer != nil ? self.memberIdForExplorer! : memberID) + "&challengeId=" + self.challengIdForTrendAndExplorer! + "&addSimilarChallenges=false"  + "&page=\(self.explorerCurrentPage)", profile: false)
                return
            } else if self.trend {
                self.fetchChallenges(url: getExplorerChallengesURL + memberID + "&challengeId=" + self.challengIdForTrendAndExplorer! + "&addSimilarChallenges=true" + "&page=\(self.explorerCurrentPage)", profile: false)
                return
            } else if selectedTabIndex == profileIndex {
                FacebookController().getMemberInfo(memberId: memberID)
                self.fetchChallengeSize(memberId: memberID)
                self.fetchChallenges(url: getChallengesOfMemberURL + memberID  + "&page=\(self.selfCurrentPage)", profile: true)                
                return
            } else if selectedTabIndex == chanllengeIndex {
                self.fetchChallenges(url: getChallengesURL + memberID + "&page=\(self.currentPage)", profile: false)
                self.getActivityCount()
                return
            }
        } else {
            if profile {
                self.donePosts = ServiceLocator.getOwnChallengesFromDummy(jsonFileName: "getOwnChallenges", done: true)
                self.notDonePosts = ServiceLocator.getOwnChallengesFromDummy(jsonFileName: "getOwnChallenges", done: false)
                self.posts = donePosts
                self.posts.append(contentsOf: notDonePosts)                
            } else if explorer {
                self.posts = ServiceLocator.getChallengesFromDummy(jsonFileName: "getTrendChallenges")
            } else if self.trend {
                self.posts = ServiceLocator.getChallengesFromDummy(jsonFileName: "getTrendChallenges")
            } else if selectedTabIndex == profileIndex {
                self.donePosts = ServiceLocator.getOwnChallengesFromDummy(jsonFileName: "getOwnChallenges", done: true)
                self.notDonePosts = ServiceLocator.getOwnChallengesFromDummy(jsonFileName: "getOwnChallenges", done: false)
                self.posts = donePosts
                self.posts.append(contentsOf: notDonePosts)
            } else if selectedTabIndex == chanllengeIndex {
                self.posts = ServiceLocator.getChallengesFromDummy(jsonFileName: "getChallenges")
            }
            self.collectionView?.reloadData()
        }
    }
    
    @objc func fetchChallenges(url: String, profile : Bool) {
        DispatchQueue.global(qos: .userInitiated).async {
        self.isFetchingNextPage = true
        let jsonURL = URL(string: url)!
        jsonURL.get { data, response, error in
            guard
                data != nil
                else {
                    if data != nil {
                        self.popupAlert(message: ServiceLocator.getErrorMessage(data: data!, chlId: "", sUrl: url, inputs: "memberID=\(memberID)"), willDelay: false)
                    }
                    return
            }
            DispatchQueue.main.async {
                self.collectionView?.removeBluerLoader()
                if let startApp = UserDefaults.standard.object(forKey: "startApp") {
                    let onStartApp = startApp as! Bool
                    if onStartApp {
                        self.navigationController?.popToRootViewController(animated: false)
                        let defaults = UserDefaults.standard
                        defaults.set(false, forKey: "startApp")
                        defaults.synchronize()
                    }
                }
            }
            if let postsArray = try? JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [[String: AnyObject]] {
                self.nowMoreData = postsArray?.count == 0 ? true : false
                if postsArray?.isEmpty == false {
                    var indexPaths = [IndexPath]()
                    for postDictionary in postsArray! {
                        let post = ServiceLocator.mappingOfPost(postDictionary: postDictionary)
                        if profile {
                            self.posts.append(post)
                            if post.done == true {
                                self.donePosts.append(post)
                            } else {
                                self.notDonePosts.append(post)
                            }
                        } else {
                            self.posts.append(post)
                            let iPath = IndexPath(row: self.posts.count - 1, section: 0)
                            indexPaths.append(iPath)
                            self.cellSizes[iPath] = self.calculateCellSize(iPath)
                        }
                    }
                    DispatchQueue.main.async {
                        // self.collectionView?.reloadData()
                        if profile || isLocal { // }&& self.nowMoreData == false {
                            self.collectionView?.reloadData()
                        } else {
                            self.collectionView?.insertItems(at: indexPaths)
                        }
                        self.collectionView?.bottomRefreshControl?.endRefreshing()
                    }
                }
                self.isFetchingNextPage = false
            }
        }
        }
    }
    
    func insertItem(_ row:Int, section: Int) {
        let indexPath = IndexPath(row:row, section: section)
        self.collectionView?.insertItems(at: [indexPath])
    }
    
    @objc func fetchChallengeSize(memberId: String) {
        group.enter()
        let jsonURL = URL(string: getChallengeSizeOfMemberURL + memberId)!
        jsonURL.get { data, response, error in
            guard
                data != nil
                else {
                    if data != nil {
                        self.popupAlert(message: ServiceLocator.getErrorMessage(data: data!, chlId: "", sUrl: getChallengeSizeOfMemberURL, inputs: "memberID=\(memberID)"), willDelay: false)
                    }
                    return
            }
            DispatchQueue.main.async {
                self.challangeCount = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)! as String
            }
            self.group.leave()
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var reusableView : UICollectionReusableView? = nil
        if (selectedTabIndex == profileIndex && !explorer) || profile {
            if kind == UICollectionElementKindSectionHeader {
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "someRandonIdentifierString", for: indexPath as IndexPath) as! ChallengeHeader
                if indexPath.section == 1 {
                    headerView.nameLabel.text = profileFirstHeader
                } else if indexPath.section == 2 {
                    headerView.nameLabel.text = profileSecondHeader
                }
                reusableView = headerView
            }
        }
        return reusableView!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if (selectedTabIndex == profileIndex && !explorer) || profile {
            if section == 0 {
                return CGSize(width: view.frame.width, height: 0)
            }
            return CGSize(width: view.frame.width, height: view.frame.width / 15)
        }
        return CGSize(width: 0, height: 0)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (selectedTabIndex == profileIndex && !explorer) || profile {
            if section == 0 {
                return 1
            } else if section == 1 {
                return notDonePosts.count
            } else if section == 2 {
                return donePosts.count
            }
        }
        return posts.count
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        if (selectedTabIndex == profileIndex && !explorer) || profile  {
            if notDonePosts.count == 0 && donePosts.count == 0 {
               return 1
            }
            return 3
        }
        return 1
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let forwardChange = Util.getForwardChange()
        if goForward && forwardChange.forwardScreen != "" {
            if forwardChange.forwardScreen == FRWRD_CHNG_CMMNT {
                self.posts[forwardChange.index!.row].countOfComments = forwardChange.viewCommentsCount as NSNumber?
                self.collectionView?.reloadItems(at: [forwardChange.index!])
            } else if forwardChange.forwardScreen == FRWRD_CHNG_PRV {
                self.posts[forwardChange.index!.row].countOfProofs = forwardChange.viewProofsCount as NSNumber?
                self.posts[forwardChange.index!.row].proofed = forwardChange.proved
                self.posts[forwardChange.index!.row].canJoin = forwardChange.canJoin
                self.posts[forwardChange.index!.row].joined = forwardChange.joined!
                self.collectionView?.reloadItems(at: [forwardChange.index!])
            } else if forwardChange.forwardScreen == FRWRD_CHNG_SCR {
                if self.posts[forwardChange.index!.row].type == SELF {
                    self.posts[forwardChange.index!.row].homeWin = forwardChange.homeWinner
                    self.posts[forwardChange.index!.row].goal = forwardChange.goal
                    self.posts[forwardChange.index!.row].result = forwardChange.result
                    self.posts[forwardChange.index!.row].done = forwardChange.homeWinner
                } else if self.posts[forwardChange.index!.row].type == PRIVATE {
                    self.posts[forwardChange.index!.row].homeWin = forwardChange.homeWinner
                    self.posts[forwardChange.index!.row].awayWin = forwardChange.awayWinner
                    self.posts[forwardChange.index!.row].firstTeamScore = forwardChange.homeScore
                    self.posts[forwardChange.index!.row].secondTeamScore = forwardChange.awayScore
                    if let homeWinner = forwardChange.homeWinner, let awayWinner = forwardChange.awayWinner {
                        self.posts[forwardChange.index!.row].done = homeWinner || awayWinner
                    }
                }
                self.collectionView?.reloadItems(at: [forwardChange.index!])
            }
        }
        goForward = false
        self.playVisibleVideo()
        if !self.profile {
            if self.selectedTabIndex == chanllengeIndex {
                // self.reloadChlPage()
            } else if self.selectedTabIndex == profileIndex && !self.explorer {
                // self.reloadSelfPage()
            }
            if reloadProfile {
                self.reloadSelfPage()
                reloadProfile = false
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let indexPaths = self.collectionView?.indexPathsForVisibleItems
        for indexPath in indexPaths! {
            let cell = self.collectionView?.cellForItem(at: indexPath) as! FeedCell
            if let player = cell.proofedVideoView.playerLayer.player {
                player.pause()
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        goForwardToSelection = false
    }
    
    override func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let cell = cell as! FeedCell
        if let player = cell.proofedVideoView.playerLayer.player {
            player.pause()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        let isTrend = self.trend
        let isChallenge = selectedTabIndex == chanllengeIndex && !profile && !isTrend
        let isSelf = (selectedTabIndex == profileIndex || self.profile) && !self.explorer
        let needsFetch = indexPaths.contains { $0.row >= self.posts.count - 9 }
        let needsFetchSelf = indexPaths.contains { $0.row >= self.notDonePosts.count - 9  || $0.row >= self.donePosts.count - 9 }
        if (isChallenge || isTrend) && needsFetch && !nowMoreData && !dummyServiceCall && !isFetchingNextPage {
            if isChallenge {
                currentPage += 1
                self.loadChallenges()
                if (self.collectionView?.isAtBottom)! && !nowMoreData && currentPage != 0 {
                    self.collectionView?.bottomRefreshControl?.beginRefreshingManually()
                }
            }
            if isTrend {
                explorerCurrentPage += 1
                self.loadChallenges()
            }
        }
        if isSelf && needsFetchSelf && !nowMoreData && !dummyServiceCall && !isFetchingNextPage {
            if isSelf || memberIdForFriendProfile == memberID {
                selfCurrentPage += 1
                self.loadChallenges()
                if (self.collectionView?.isAtBottom)! && !nowMoreData && selfCurrentPage != 0 {
                    self.collectionView?.bottomRefreshControl?.beginRefreshingManually()
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
    }
    
    func calculateCellSize(_ indexPath: IndexPath) -> CGSize {
        if (selectedTabIndex == profileIndex && !explorer) || profile {
            if indexPath.row == 0 && indexPath.section == 0 {
                return CGSize(width: view.frame.width, height: screenSize.width * 2.5 / 10)
            }
        }
        var knownHeight: CGFloat = (screenSize.width / 2) + (screenSize.width / 15) + (screenSize.width / 26)
        if posts.count == 0 {
            return CGSize(width: view.frame.width, height: knownHeight)
        }
        if posts[indexPath.item].isComeFromSelf == false {
            if posts[indexPath.item].active! {
                knownHeight += (screenSize.width / 5.3)
            } else {
                knownHeight += (screenWidth * 0.4 / 10)
            }
            if posts[indexPath.item].proofedByChallenger == true {
                knownHeight += screenWidth / 2 + screenSize.width * 0.4/15
            }
            knownHeight += (screenSize.width / 26) + (screenWidth * 0.9 / 10)
            if let thinksAboutChallenge = posts[indexPath.item].thinksAboutChallenge, let name = posts[indexPath.item].name {
                // let rect = NSString(string: thinksAboutChallenge).boundingRect(with: CGSize(width: view.frame.width, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 12)], context: nil)
                if posts[indexPath.item].proofedByChallenger == true {
                    knownHeight += screenWidth * 0.1 / 10
                }
                let thinks = "\(name): \(thinksAboutChallenge)"
                return CGSize(width: viewFramwWidth, height: thinks.heightOf(withConstrainedWidth: screenWidth * 4.5 / 5, font: UIFont.boldSystemFont(ofSize: 12)) + knownHeight)
            }
        }
        return CGSize(width: viewFramwWidth, height: knownHeight)
    }
    
    @objc func createProfile() -> ProfileCellView {
        if profile {
            group.wait()
            memberNameForFriendProfile = nameForOpenProfile
            memberFbIdForFriendProfile = facebookIDForOpenProfile
            memberCountOfFollowerForFriendProfile = countOfFollowersForOpenProfile
            memberCountOfFollowingForFriendProfile = countOfFollowingForOpenProfile
            memberIsPrivateForFriendProfile = friendIsPrivate
        }
        let profileCell : ProfileCellView = ProfileCellView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width * 2.5 / 10), memberFbId: (profile ? memberFbIdForFriendProfile! : memberFbID) , name: (profile ? memberNameForFriendProfile! : memberName))
        if profile {
            profileCell.other.alpha = 0
            if memberIdForFriendProfile != memberID {
                if isProfileFriend {
                    profileCell.unfollow.alpha = 1
                } else {
                    if isProfileRequested {
                        profileCell.requested.alpha = 1
                    } else {
                        profileCell.follow.alpha = 1
                    }
                }
                profileCell.follow.memberId = memberIdForFriendProfile
                profileCell.unfollow.memberId = memberIdForFriendProfile
                profileCell.follow.addTarget(self, action: #selector(self.followProfile), for: UIControlEvents.touchUpInside)
                profileCell.unfollow.addTarget(self, action: #selector(self.unFollowProfile), for: UIControlEvents.touchUpInside)
                if memberIsPrivateForFriendProfile! && !isProfileFriend {
                    profileCell.privateLabel.alpha = 1
                }
            } else {
                profileCell.other.alpha = 1
            }
        }
        // self.group.wait()
        profileCell.other.addTarget(self, action: #selector(self.openOthers), for: UIControlEvents.touchUpInside)
        profileCell.followersCount.text = "\((profile ? memberCountOfFollowerForFriendProfile : countOffollowers)!)"
        let followersCountTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleFollowersCountTap))
        profileCell.followersCount.isUserInteractionEnabled = true
        let followersLabelTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleFollowersCountTap))
        profileCell.followersLabel.isUserInteractionEnabled = true
        profileCell.followingCount.text = "\((profile ? memberCountOfFollowingForFriendProfile : countOffollowing)!)"
        let followingCountTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleFollowingCountTap))
        profileCell.followingCount.isUserInteractionEnabled = true
        let followingLabelTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleFollowingCountTap))
        profileCell.followingLabel.isUserInteractionEnabled = true
        let challengeTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleChallengeCountTap))
        profileCell.challangeCount.isUserInteractionEnabled = true
        profileCell.challangeCount.text = self.challangeCount
        if  !profile || (profile && !memberIsPrivateForFriendProfile!) || (profile && memberIsPrivateForFriendProfile! && isProfileFriend) ||
            memberIdForFriendProfile == memberID {
            profileCell.followersCount.addGestureRecognizer(followersCountTapGesture)
            profileCell.followersLabel.addGestureRecognizer(followersLabelTapGesture)
            profileCell.followingCount.addGestureRecognizer(followingCountTapGesture)
            profileCell.followingLabel.addGestureRecognizer(followingLabelTapGesture)
            profileCell.challangeCount.addGestureRecognizer(challengeTapGesture)
        } else {
            profileCell.followersCount.textColor = UIColor.gray
            profileCell.followersLabel.textColor = UIColor.gray
            profileCell.followingCount.textColor = UIColor.gray
            profileCell.followingLabel.textColor = UIColor.gray
            profileCell.challangeCount.textColor = UIColor.gray
            profileCell.challangeLabel.textColor = UIColor.gray
        }
        return profileCell
    }
    
    @objc func unFollowProfile(sender: subclasssedUIButton) {
        let url = followingFriendURL + "?memberId=" + memberID + "&friendMemberId=" + sender.memberId! + "&follow=false"
        followOrUnfollowFriend(url: url, isRemove: true)
        group.wait()
        reloadSelfPage()
    }
    
    @objc func followProfile(sender: subclasssedUIButton) {
        let url = followingFriendURL + "?memberId=" + memberID + "&friendMemberId=" + sender.memberId! + "&follow=true"
        followOrUnfollowFriend(url: url, isRemove: false)
        group.wait()
        reloadSelfPage()
    }
    
    @objc func followOrUnfollowFriend(url: String, isRemove: Bool) {
        group.enter()
        let jsonURL = URL(string: url)!
        jsonURL.get { data, response, error in
            guard
                data != nil
                else {
                    self.popupAlert(message: ServiceLocator.getErrorMessage(data: data!, chlId: "", sUrl: url, inputs: "memberId=\(memberID)"), willDelay: false)
                    return
            }
            self.group.leave()
            if self.memberIsPrivateForFriendProfile! && !isRemove {
                self.isProfileFriend = false
                self.popupAlert(message: "Requested!", willDelay: true)
            } else {
                if !isRemove {
                    self.isProfileFriend = true
                    self.popupAlert(message: "Now Following!", willDelay: true)
                } else {
                    self.isProfileFriend = false
                    self.popupAlert(message: "Stop Following!", willDelay: true)
                }
            }
        }
    }
    
    lazy var cellSizes: [IndexPath: CGSize?] = [:]
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        /*if cellSizes[indexPath] == nil {
         cellSizes[indexPath] = calculateCellSize(indexPath)
         }
         if cells[indexPath] == nil {
            cells[indexPath] = prepareCell(indexPath)
        }*/        
    }
    
    func prepareCell(_ indexPath: IndexPath) -> UICollectionViewCell {
        if (selectedTabIndex == profileIndex && !explorer) || profile  {
            if indexPath.section == 0 && indexPath.row == 0 {
                let feedCellForProfile = self.collectionView?.dequeueReusableCell(withReuseIdentifier: "profile", for: indexPath) as! FeedCell
                feedCellForProfile.addSubview(self.createProfile())
                return feedCellForProfile
            }
            let feedCellForSelf = self.collectionView?.dequeueReusableCell(withReuseIdentifier: "selfCellId", for: indexPath) as! FeedCell
            feedCellForSelf.layer.shouldRasterize = true
            feedCellForSelf.layer.rasterizationScale = UIScreen.main.scale
            if indexPath.section == 1 {
                if  self.notDonePosts.count == 0 {
                    return feedCellForSelf
                }
                feedCellForSelf.post = self.notDonePosts[indexPath.row]
                if !self.profile {
                    feedCellForSelf.updateProgress.type = self.notDonePosts[indexPath.row].type
                    feedCellForSelf.updateProgress.challengeId = self.notDonePosts[indexPath.row].id
                    feedCellForSelf.updateProgress.goal = self.notDonePosts[indexPath.row].goal
                    feedCellForSelf.updateProgress.proofed = self.notDonePosts[indexPath.row].proofed
                    feedCellForSelf.updateProgress.canJoin = self.notDonePosts[indexPath.row].canJoin
                    feedCellForSelf.updateProgress.tag = indexPath.row
                    if self.notDonePosts[indexPath.row].type == SELF {
                        feedCellForSelf.updateProgress.homeScore = self.notDonePosts[indexPath.row].result
                    } else if self.notDonePosts[indexPath.row].type == PRIVATE {
                        feedCellForSelf.updateProgress.homeScore = self.notDonePosts[indexPath.row].firstTeamScore
                        feedCellForSelf.updateProgress.awayScore = self.notDonePosts[indexPath.row].secondTeamScore
                    }
                    feedCellForSelf.updateProgress.addTarget(self, action: #selector(self.updateProgress), for: UIControlEvents.touchUpInside)
                } else {
                    feedCellForSelf.updateProgress.alpha = 0
                }
            } else if indexPath.section == 2 {
                if  self.donePosts.count == 0 {
                    return feedCellForSelf
                }
                feedCellForSelf.post = self.donePosts[indexPath.row]
            }
            return feedCellForSelf
        }
        let feedCell = self.collectionView?.dequeueReusableCell(withReuseIdentifier: "feedCellId", for: indexPath) as! FeedCell
        if  self.posts.count == 0 {
            return feedCell
        }
        feedCell.layer.shouldRasterize = true
        feedCell.layer.rasterizationScale = UIScreen.main.scale
        feedCell.isOpaque = true
        self.posts[indexPath.item].firstRow = indexPath == self.getVisibleIndex() ? true : false
        feedCell.post = self.posts[indexPath.item]
        self.addTargetToFeedCell(feedCell: feedCell, indexPath: indexPath)
        return feedCell
    }
    
    lazy var cells: [IndexPath: UICollectionViewCell?] = [:]
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        /*if let cells = cells[indexPath] {
            return cells!
        }*/
        return prepareCell(indexPath)
    }
    
    @objc func changeVolume(gesture: UITapGestureRecognizer) {
        DispatchQueue.main.async {
            volume = volume.isEqual(to: 0) ? 1 : 0
            let defaults = UserDefaults.standard
            defaults.set(volume, forKey: "volume")
            defaults.synchronize()
            for index in (self.collectionView?.indexPathsForVisibleItems)! {
                // let index = IndexPath(item: (gesture.view?.tag)!, section : 0)
                let feedCell = self.collectionView?.cellForItem(at: index) as! FeedCell
                self.changeVolumeOfFeedCell(feedCell: feedCell, isSilentRing: false, silentRingSwitch: 0)
            }
        }
    }
    
    @objc func changeVolumeOfFeedCell(feedCell : FeedCell, isSilentRing : Bool, silentRingSwitch : Int) {
        DispatchQueue.main.async {
            if let player = feedCell.proofedVideoView.playerLayer.player {
                if !isSilentRing {
                    if (player.volume.isEqual(to: 0)) {
                        player.volume = 1
                        self.changeVolumeUpDownView(feedCell: feedCell, silentRingSwitch: 1)
                    } else {
                        player.volume = 0
                        self.changeVolumeUpDownView(feedCell: feedCell, silentRingSwitch: 0)
                    }
                } else {
                    player.volume = Float(silentRingSwitch)
                    self.changeVolumeUpDownView(feedCell: feedCell, silentRingSwitch: silentRingSwitch )
                }
            }
        }
    }
    
    @objc func changeVolumeUpDownView(feedCell : FeedCell, silentRingSwitch : Int) {
        if (feedCell.proofedVideoView.playerLayer.player?.volume.isEqual(to: 1))! {
            feedCell.volumeUpImageView.alpha = 1
            feedCell.volumeDownImageView.alpha = 0
        } else {
            feedCell.volumeUpImageView.alpha = 0
            feedCell.volumeDownImageView.alpha = 1
        }
    }
    
    // var avPlayer : AVPlayer = AVPlayer.init()
    
    @objc func addTargetToFeedCell(feedCell: FeedCell, indexPath : IndexPath) {        
        if feedCell.post?.type == PUBLIC {
            feedCell.joinToChl.tag = indexPath.row
            feedCell.joinToChl.challengeId = posts[indexPath.item].id
            feedCell.joinToChl.addTarget(self, action: #selector(self.joinToChallenge), for: UIControlEvents.touchUpInside)
            feedCell.joinButton.tag = indexPath.row
            feedCell.joinButton.challengeId = posts[indexPath.item].id
            feedCell.joinButton.addTarget(self, action: #selector(self.joinToChallenge), for: UIControlEvents.touchUpInside)
        }
        feedCell.supportButton.tag = indexPath.row
        feedCell.supportButtonMatch.tag = indexPath.row
        feedCell.supportButton.challengeId = posts[indexPath.item].id
        feedCell.supportButtonMatch.challengeId = posts[indexPath.item].id
        feedCell.supportButton.addTarget(self, action: #selector(self.supportChallenge), for: UIControlEvents.touchUpInside)
        feedCell.supportButtonMatch.addTarget(self, action: #selector(self.supportChallengeMatch), for: UIControlEvents.touchUpInside)
        if feedCell.post?.type != SELF {
            if feedCell.post?.secondTeamCount == "0" {
                feedCell.firstOnePeopleImageView.contentMode = .scaleAspectFit
            } else if feedCell.post?.secondTeamCount == "1" {
                feedCell.firstOnePeopleImageView.contentMode = .scaleAspectFill
            }
        }
        feedCell.viewComments.challengeId = posts[indexPath.item].id
        feedCell.viewComments.memberId = posts[indexPath.item].challengerId
        feedCell.viewComments.tag = indexPath.row
        feedCell.viewProofs.challengeId = posts[indexPath.item].id
        feedCell.viewProofs.proofed = posts[indexPath.row].proofed
        feedCell.viewProofs.canJoin = feedCell.joinToChl.canJoin != nil ? feedCell.joinToChl.canJoin : false
        feedCell.viewProofs.tag = indexPath.row
        feedCell.addComments.challengeId = posts[indexPath.item].id
        feedCell.addComments.memberId = posts[indexPath.item].challengerId
        feedCell.addComments.tag = indexPath.row
        feedCell.addProofs.challengeId = posts[indexPath.item].id
        feedCell.addProofs.proofed = posts[indexPath.row].proofed
        feedCell.addProofs.tag = indexPath.row
        feedCell.addProofs.canJoin = feedCell.joinToChl.canJoin != nil ? feedCell.joinToChl.canJoin : false
        feedCell.viewComments.addTarget(self, action: #selector(self.viewComments), for: UIControlEvents.touchUpInside)
        feedCell.viewProofs.addTarget(self, action: #selector(self.viewProofs), for: UIControlEvents.touchUpInside)
        feedCell.addComments.addTarget(self, action: #selector(self.addComments), for: UIControlEvents.touchUpInside)
        feedCell.addProofs.addTarget(self, action: #selector(self.addProofs), for: UIControlEvents.touchUpInside)
        let volumeChangeGesture : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.changeVolume))
        volumeChangeGesture.numberOfTapsRequired = 1
        feedCell.proofedVideoView.tag = indexPath.row
        feedCell.proofedVideoView.isUserInteractionEnabled = true
        feedCell.proofedVideoView.addGestureRecognizer(volumeChangeGesture)
        if explorer {
            feedCell.others.alpha = 1
            feedCell.others.addTarget(self, action: #selector(self.deleteChallenge), for: UIControlEvents.touchUpInside)
            feedCell.others.challengeId = posts[indexPath.item].id
        }
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(profileImageTapped(tapGestureRecognizer:)))
        feedCell.challengerImageView.tag = indexPath.row
        feedCell.challengerImageView.isUserInteractionEnabled = true
        feedCell.challengerImageView.addGestureRecognizer(tapGestureRecognizer)
        let tapGestureRecognizerName = UITapGestureRecognizer(target: self, action: #selector(profileImageTappedName(tapGestureRecognizer:)))
        feedCell.nameAndStatusLabel.tag = indexPath.row
        feedCell.nameAndStatusLabel.isUserInteractionEnabled = true
        feedCell.nameAndStatusLabel.addGestureRecognizer(tapGestureRecognizerName)
        
        let tapGestureRecognizerSupportLabel = UITapGestureRecognizer(target: self, action: #selector(supportList(tapGestureRecognizer:)))
        feedCell.supportLabel.index = indexPath.row
        feedCell.supportLabel.isUserInteractionEnabled = true
        feedCell.supportLabel.addGestureRecognizer(tapGestureRecognizerSupportLabel)
        
        let tapGestureRecognizerSupportMatchLabel = UITapGestureRecognizer(target: self, action: #selector(supportMatchList(tapGestureRecognizer:)))
        feedCell.supportMatchLabel.index = indexPath.row
        feedCell.supportMatchLabel.isUserInteractionEnabled = true
        feedCell.supportMatchLabel.addGestureRecognizer(tapGestureRecognizerSupportMatchLabel)
        
        let tapGestureRecognizerHomeMore = UITapGestureRecognizer(target: self, action: #selector(homeMoreAttendances(tapGestureRecognizer:)))
        feedCell.moreFourChlrPeopleImageView.tag = indexPath.row
        feedCell.moreFourChlrPeopleImageView.isUserInteractionEnabled = true
        feedCell.moreFourChlrPeopleImageView.addGestureRecognizer(tapGestureRecognizerHomeMore)
        
        let tapGestureRecognizerAwayMore = UITapGestureRecognizer(target: self, action: #selector(awayMoreAttendances(tapGestureRecognizer:)))
        feedCell.moreFourPeopleImageView.tag = indexPath.row
        feedCell.moreFourPeopleImageView.isUserInteractionEnabled = true
        feedCell.moreFourPeopleImageView.addGestureRecognizer(tapGestureRecognizerAwayMore)
        
        addTargetToImageView(image:feedCell.firstOnePeopleImageView)
        addTargetToImageView(image:feedCell.firstTwoPeopleImageView)
        addTargetToImageView(image:feedCell.secondTwoPeopleImageView)
        addTargetToImageView(image:feedCell.firstThreePeopleImageView)
        addTargetToImageView(image:feedCell.secondThreePeopleImageView)
        addTargetToImageView(image:feedCell.thirdThreePeopleImageView)
        addTargetToImageView(image:feedCell.firstFourPeopleImageView)
        addTargetToImageView(image:feedCell.secondFourPeopleImageView)
        addTargetToImageView(image:feedCell.thirdFourPeopleImageView)
        addTargetToImageView(image:feedCell.firstOneChlrPeopleImageView)
        addTargetToImageView(image:feedCell.firstTwoChlrPeopleImageView)
        addTargetToImageView(image:feedCell.secondTwoChlrPeopleImageView)
        addTargetToImageView(image:feedCell.firstThreeChlrPeopleImageView)
        addTargetToImageView(image:feedCell.secondThreeChlrPeopleImageView)
        addTargetToImageView(image:feedCell.thirdThreeChlrPeopleImageView)
        addTargetToImageView(image:feedCell.firstFourChlrPeopleImageView)
        addTargetToImageView(image:feedCell.secondFourChlrPeopleImageView)
        addTargetToImageView(image:feedCell.thirdFourChlrPeopleImageView)
        
        /*let pinch = UIPinchGestureRecognizer(target: self, action: #selector(zoom))
        pinch.delegate = self
        feedCell.proofedMediaView.addGestureRecognizer(pinch)
        
        let myPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(pan)) //Update: July 18, 2016 for Xcode 7.3.1(Swift 2.2)
        myPanGestureRecognizer.delegate = self
        feedCell.proofedMediaView.addGestureRecognizer(myPanGestureRecognizer)
        feedCell.proofedMediaView.layer.zPosition = 1
        feedCell.proofedMediaView.tag = indexPath.row*/
        feedCell.proofedMediaView.setupZoomPinchGesture()
        feedCell.proofedMediaView.setupZoomPanGesture()
        /*
        if feedCell.post?.type == PUBLIC && (feedCell.post?.proofedByChallenger)! {
            let tapGestureRecognizerTwoFinger = UITapGestureRecognizer(target: self, action: #selector(twoFinger))
            tapGestureRecognizerTwoFinger.numberOfTapsRequired = 1
            feedCell.proofedMediaView.isUserInteractionEnabled = true
            feedCell.proofedMediaView.addGestureRecognizer(tapGestureRecognizerTwoFinger)
        }
         */
    }
    
    
    @objc var isZooming = false
    var originalImageCenter: CGPoint?
    @objc func pan(sender: UIPanGestureRecognizer) {
        let postImage = sender.view as! UIImageView
        if self.isZooming && sender.state == .began {
            self.originalImageCenter = postImage.center
        } else if self.isZooming && sender.state == .changed {
            let translation = sender.translation(in: postImage.superview)
            sender.view?.center = CGPoint(x: postImage.center.x + translation.x, y: postImage.center.y + translation.y)
            sender.setTranslation(CGPoint.zero, in: postImage.superview)
        }
    }
    
    var lastScale:CGFloat!
    @objc func zoom(sender:UIPinchGestureRecognizer) {
        let postImage = sender.view as! UIImageView
        if(sender.state == .began) {
            // Reset the last scale, necessary if there are multiple objects with different scales
            lastScale = sender.scale
            self.collectionView?.isScrollEnabled = false
        } else if (sender.state == .changed) {
            self.isZooming = true
            let currentScale = sender.view!.layer.value(forKeyPath:"transform.scale")! as! CGFloat
            // Constants to adjust the max/min values of zoom
            let kMaxScale:CGFloat = 2.5
            let kMinScale:CGFloat = 2.0
            var newScale = 1 -  (lastScale - sender.scale)
            newScale = min(newScale, kMaxScale / currentScale)
            newScale = max(newScale, kMinScale / currentScale)
            let transform = (sender.view?.transform)!.scaledBy(x: newScale, y: newScale);
            sender.view?.transform = transform
            lastScale = sender.scale  // Store the previous scale factor for the next pinch gesture call
        } else if sender.state == .ended || sender.state == .failed || sender.state == .cancelled {
            guard let center = self.originalImageCenter else {return}
            UIView.animate(withDuration: 0.3, animations: {
                postImage.transform = CGAffineTransform.identity
                postImage.center = center
            }, completion: { _ in
                self.isZooming = false
            })
            self.collectionView?.isScrollEnabled = true
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    @objc func addTargetToImageView(image: subclasssedUIImageView) {
        if image.memberId != nil {
            let tapGestureRecognizerOpenProfile = UITapGestureRecognizer(target: self, action: #selector(openProfileForImage))
            tapGestureRecognizerOpenProfile.numberOfTapsRequired = 1
            image.isUserInteractionEnabled = true
            image.addGestureRecognizer(tapGestureRecognizerOpenProfile)
        } else {
            /*
            let tapGestureRecognizerOpenProfile = UITapGestureRecognizer(target: self, action: #selector(twoFinger))
            tapGestureRecognizerOpenProfile.numberOfTapsRequired = 1
            image.isUserInteractionEnabled = true
            image.addGestureRecognizer(tapGestureRecognizerOpenProfile)
             */
        }
    }
    
    @objc func twoFinger(tapGestureRecognizer: UITapGestureRecognizer) {
        self.collectionView?.showTwoFinger()        
    }
    
    @objc func openProfileForImage(tapGestureRecognizer: UITapGestureRecognizer) {
        let tappedImage = tapGestureRecognizer.view as! subclasssedUIImageView
        openProfile(memberId: tappedImage.memberId!)
    }
    
    @objc func homeMoreAttendances(tapGestureRecognizer: UITapGestureRecognizer) {
        let tappedLabel = tapGestureRecognizer.view as! UIImageView
        openAttendanceList(index: tappedLabel.tag, firstTeam: true)
    }
    
    @objc func awayMoreAttendances(tapGestureRecognizer: UITapGestureRecognizer) {
        let tappedLabel = tapGestureRecognizer.view as! UIImageView
        openAttendanceList(index: tappedLabel.tag, firstTeam: false)
    }
    
    @objc func openAttendanceList(index: Int, firstTeam: Bool) {
        let selectionTable = SelectionTableViewController()
        selectionTable.tableTitle = "Attendance List"
        selectionTable.listMode = true
        selectionTable.isMoreAttendance = true
        selectionTable.challengeId = posts[index].id!
        selectionTable.firstTeam = firstTeam
        goForwardToSelection = true
        // selectionTable.hidesBottomBarWhenPushed = true
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.pushViewController(selectionTable, animated: true)
    }
    
    @objc func supportList(tapGestureRecognizer: UITapGestureRecognizer) {
        let tappedLabel = tapGestureRecognizer.view as! subclasssedUILabel
        openSupportList(index: tappedLabel.index!, firstTeam: true)
    }
    
    @objc func supportMatchList(tapGestureRecognizer: UITapGestureRecognizer) {
        let tappedLabel = tapGestureRecognizer.view as! subclasssedUILabel
        openSupportList(index: tappedLabel.index!, firstTeam: false)
    }
    
    @objc func openSupportList(index: Int, firstTeam: Bool) {
        let selectionTable = SelectionTableViewController()
        selectionTable.tableTitle = "Support List"
        selectionTable.listMode = true
        selectionTable.supportList = true
        selectionTable.challengeId = posts[index].id!
        if posts[index].type == PUBLIC {
            selectionTable.supportedMemberId = posts[index].challengerId!
        }
        selectionTable.firstTeam = firstTeam
        goForwardToSelection = true
        // selectionTable.hidesBottomBarWhenPushed = true
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.pushViewController(selectionTable, animated: true)
    }
    
    @objc func profileImageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        openProfile(memberId: posts[tappedImage.tag].challengerId!)
    }
    
    @objc func profileImageTappedName(tapGestureRecognizer: UITapGestureRecognizer) {
        let tappedImage = tapGestureRecognizer.view as! UILabel
        openProfile(memberId: posts[tappedImage.tag].challengerId!)
    }
    
    @objc func deleteChallenge(_ sender: subclasssedUIButton) {
        URLSession.shared.dataTask(with: NSURL(string: deleteChallengeURL + sender.challengeId!)! as URL, completionHandler: { (data, response, error) -> Void in
            if error == nil && data != nil {
            }
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
        }).resume()
    }
    
    @objc func handleChallengeCountTap(sender:UILabel){
        let firstChlRow = IndexPath(item: 0, section: 1)
        collectionView?.scrollToItem(at: firstChlRow, at: .top, animated: true)
    }
    
    @objc func handleFollowersCountTap(sender:UILabel){
        let selectionTable = SelectionTableViewController()
        selectionTable.tableTitle = "Followers"
        selectionTable.listMode = true
        selectionTable.isFollower = true
        selectionTable.profile = profile
        selectionTable.memberIdForFriendProfile = memberIdForFriendProfile
        // selectionTable.hidesBottomBarWhenPushed = true
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.pushViewController(selectionTable, animated: true)
    }
    
    @objc func handleFollowingCountTap(sender:UILabel){
        let selectionTable = SelectionTableViewController()
        selectionTable.tableTitle = "Following"
        selectionTable.listMode = true
        selectionTable.isFollowing = true
        selectionTable.profile = profile
        selectionTable.memberIdForFriendProfile = memberIdForFriendProfile
        // selectionTable.hidesBottomBarWhenPushed = true
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.pushViewController(selectionTable, animated: true)
    }
    
    @objc func updateProgress(_ sender: subclasssedUIButton) {
        if sender.type == PUBLIC {
            openProofScreen(challengeId: sender.challengeId!, proofed: sender.proofed!, canJoin: false, proveCount: sender.count!, index: sender.tag)
        } else {
            let updateProgress = UpdateProgressController()
            updateProgress.updateProgress = true
            updateProgress.challengeId = sender.challengeId
            updateProgress.challengeType = sender.type
            updateProgress.goal = sender.goal
            updateProgress.homeScore = sender.homeScore
            updateProgress.awayScore = sender.awayScore
            if sender.type == PRIVATE {
                updateProgress.homeScoreText.becomeFirstResponder()
                Util.addForwardChange(forwardChange: ForwardChange(index: IndexPath(item:sender.tag ,section: 1), forwardScreen: FRWRD_CHNG_SCR, homeWinner: false, awayWinner: false, homeScore: sender.homeScore!, awayScore: sender.awayScore!))
            } else {
                updateProgress.awayScoreText.becomeFirstResponder()
                Util.addForwardChange(forwardChange: ForwardChange(index: IndexPath(item:sender.tag ,section: 1), forwardScreen: FRWRD_CHNG_SCR, homeWinner: false, goal: sender.goal != nil ? sender.goal! : "-1", result: sender.homeScore != nil ? sender.homeScore! : "-1"))
            }
            goForward = true
            // updateProgress.hidesBottomBarWhenPushed = true
            self.navigationController?.setNavigationBarHidden(false, animated: false)
            self.navigationController?.pushViewController(updateProgress, animated: true)
        }
    }
    
    @objc func openOthers(sender: UIButton) {
        let other = OtherController()
        self.navigationController?.pushViewController(other, animated: true)
    }
    
    @objc func addComments(sender: subclasssedUIButton) {
        let commentsTable = CommentTableViewController()        
        commentsTable.tableTitle = commentsTableTitle
        // TODO commentsTable.comments = self.comments
        commentsTable.challengeId = sender.challengeId
        commentsTable.commentedMemberId = sender.memberId
        Util.addForwardChange(forwardChange: ForwardChange(index: IndexPath(item:sender.tag ,section: 0), forwardScreen: FRWRD_CHNG_CMMNT, viewCommentsCount: sender.count!))
        goForward = true
        commentsTable.textView.becomeFirstResponder()
        commentsTable.hidesBottomBarWhenPushed = true
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.pushViewController(commentsTable, animated: true)
    }
    
    @objc func viewComments(sender: subclasssedUIButton) {
        let commentsTable = CommentTableViewController()
        commentsTable.tableTitle = commentsTableTitle
        // TODO commentsTable.comments = self.comments
        commentsTable.challengeId = sender.challengeId
        commentsTable.commentedMemberId = sender.memberId
        Util.addForwardChange(forwardChange: ForwardChange(index: IndexPath(item:sender.tag ,section: 0), forwardScreen: FRWRD_CHNG_CMMNT, viewCommentsCount: sender.count!))
        goForward = true
        commentsTable.hidesBottomBarWhenPushed = true
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.pushViewController(commentsTable, animated: true)
    }
    
    @objc func addProofs(sender: subclasssedUIButton) {
        openProofScreen(challengeId: sender.challengeId!, proofed: sender.proofed!, canJoin: sender.canJoin!, proveCount: sender.count!, index: sender.tag)
    }
    
    @objc func openProofScreen(challengeId: String, proofed: Bool, canJoin: Bool, proveCount: Int, index: Int) {
        let commentsTable = ProofTableViewController()
        commentsTable.tableTitle = proofsTableTitle
        commentsTable.challengeId = challengeId
        commentsTable.done = posts[index].done!
        commentsTable.proofed = posts[index].done! ? false : proofed
        commentsTable.canJoin = posts[index].done! ? false : canJoin
        if isTabIndex(chanllengeIndex) || self.explorer || self.trend {
            commentsTable.joined = posts[index].done! ? false : posts[index].joined!
        } else if isTabIndex(profileIndex) {
            commentsTable.joined = notDonePosts[index].done! ? false : notDonePosts[index].joined!
        }
        commentsTable.activeIndex = IndexPath(item: 0, section: 0)
        Util.addForwardChange(forwardChange: ForwardChange(index: IndexPath(item:index ,section: isTabIndex(profileIndex) && !explorer ? 1 : 0), forwardScreen: FRWRD_CHNG_PRV, viewProofsCount: proveCount, joined: posts[index].done! ? false : posts[index].joined!, proved: posts[index].done! ? false : proofed, canJoin: posts[index].done! ? false : canJoin))
        goForward = true
        commentsTable.hidesBottomBarWhenPushed = true
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.pushViewController(commentsTable, animated: true)
    }
    
    @objc func viewProofs(sender: subclasssedUIButton) {
        openProofScreen(challengeId: sender.challengeId!, proofed: sender.proofed!, canJoin: sender.canJoin!, proveCount: sender.count!, index: sender.tag)
    }
    
    @objc func supportChallenge(sender: subclasssedUIButton) {
        let index = IndexPath(item: sender.tag, section: 0)
        let feedCell = collectionView?.cellForItem(at: index) as! FeedCell
        let currentImage = sender.currentImage
        if currentImage == UIImage(named:support) {
            sender.setImage(UIImage(named: supported), for: .normal)
            feedCell.supportLabel.alpha = 1
            if feedCell.supportButtonMatch.currentImage == UIImage(named: supported) {
                feedCell.supportButtonMatch.setImage(UIImage(named:support), for: .normal)
                let supportMatchCount : NSNumber = NSNumber(value: feedCell.supportMatchLabel.tag + (-1))
                feedCell.supportMatchLabel.text = "+\(supportMatchCount.getSuppportCountAsK())"
                feedCell.supportMatchLabel.tag = Int(truncating: supportMatchCount)
                if feedCell.supportMatchLabel.tag == 0 {
                    feedCell.supportMatchLabel.alpha = 0
                }
                self.posts[index.row].supportSecondTeam = false
                self.posts[index.row].secondTeamSupportCount = feedCell.supportMatchLabel.tag as NSNumber
            }
            supportChallengeService(support: true, challengeId: sender.challengeId!, feedCell: feedCell, isHome: true, index: index)
        } else {
            sender.setImage(UIImage(named: support), for: .normal)
            supportChallengeService(support: false, challengeId: sender.challengeId!, feedCell: feedCell, isHome: true, index: index)
        }
    }
    
    @objc func supportChallengeService(support:Bool, challengeId: String, feedCell: FeedCell, isHome: Bool, index: IndexPath) {
        var json: [String: Any] = ["challengeId": challengeId,
                                   "memberId": memberID
        ]
        if posts[index.row].type == PUBLIC {
            json["supportedMemberId"] = posts[index.row].challengerId
        }
        json["supportFirstTeam"] = isHome ? support : false
        json["supportSecondTeam"] = !isHome ? support : false
        let url = URL(string: supportChallengeURL)!
        let request = ServiceLocator.prepareRequest(url: url, json: json)
        URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                print(responseJSON)
                if responseJSON["message"] != nil {
                    self.popupAlert(message: responseJSON["message"] as! String, willDelay: false)
                }
            } else {
                DispatchQueue.main.async { // Correct
                    if isHome {
                        let supportCount : NSNumber = NSNumber(value: feedCell.supportLabel.tag + (support ? 1 : -1))
                        feedCell.supportLabel.text = "+\(supportCount.getSuppportCountAsK())"
                        feedCell.supportLabel.tag = Int(truncating: supportCount)
                        if feedCell.supportLabel.tag == 0 {
                            feedCell.supportLabel.alpha = 0
                        }
                        self.posts[index.row].supportFirstTeam = true
                        self.posts[index.row].firstTeamSupportCount = feedCell.supportLabel.tag as NSNumber
                    } else {
                        let supportMatchCount : NSNumber = NSNumber(value: feedCell.supportMatchLabel.tag + (support ? 1 : -1))
                        feedCell.supportMatchLabel.text = "+\(supportMatchCount.getSuppportCountAsK())"
                        feedCell.supportMatchLabel.tag = Int(truncating: supportMatchCount)
                        if feedCell.supportMatchLabel.tag == 0 {
                            feedCell.supportMatchLabel.alpha = 0
                        }
                        self.posts[index.row].supportSecondTeam = true
                        self.posts[index.row].secondTeamSupportCount = feedCell.supportMatchLabel.tag as NSNumber
                    }
                }
            }
        }).resume()
    }
    
    @objc func supportChallengeMatch(sender: subclasssedUIButton) {
        let index = IndexPath(item: sender.tag, section: 0)
        let feedCell = collectionView?.cellForItem(at: index) as! FeedCell
        let currentImage = sender.currentImage
        if currentImage == UIImage(named: support) {
            sender.setImage(UIImage(named: supported), for: .normal)
            feedCell.supportMatchLabel.alpha = 1
            if feedCell.supportButton.currentImage == UIImage(named: supported) {
                feedCell.supportButton.setImage(UIImage(named:support), for: .normal)
                let supportCount : NSNumber = NSNumber(value: feedCell.supportLabel.tag + (-1))
                feedCell.supportLabel.text = "+\(supportCount.getSuppportCountAsK())"
                feedCell.supportLabel.tag = Int(truncating: supportCount)
                if feedCell.supportLabel.tag == 0 {
                    feedCell.supportLabel.alpha = 0
                }
                self.posts[index.row].supportFirstTeam = false
                self.posts[index.row].firstTeamSupportCount = feedCell.supportLabel.tag as NSNumber
            }
            supportChallengeService(support: true, challengeId: sender.challengeId!, feedCell: feedCell, isHome: false, index: index)
        } else {
            sender.setImage(UIImage(named: support), for: .normal)
            supportChallengeService(support: false, challengeId: sender.challengeId!, feedCell: feedCell, isHome: false, index: index)
        }
    }
    
    @objc func joinToChallenge(sender: subclasssedUIButton) {
        let index = IndexPath(item: sender.tag, section: 0)
        let feedCell = collectionView?.cellForItem(at: index) as! FeedCell
        joinToChallengeService(challengeId: sender.challengeId!, feedCell: feedCell)
        self.posts[index.row].joined = true
        self.posts[index.row].canJoin = false
        self.collectionView?.reloadItems(at: [index])
    }
    
    @objc func joinToChallengeService(challengeId: String, feedCell: FeedCell) {
        let json: [String: Any] = ["challengeId": challengeId,
                                   "memberId": memberID,
                                   "join": true
        ]
        let url = URL(string: joinToChallengeURL)!
        let request = ServiceLocator.prepareRequest(url: url, json: json)
        URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                print(responseJSON)
                if responseJSON["message"] != nil {
                    self.popupAlert(message: responseJSON["message"] as! String, willDelay: false)
                }
            }
        }).resume()
    }

    @objc let screenSize = UIScreen.main.bounds
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let size = cellSizes[indexPath] {
            return size ?? UICollectionViewFlowLayoutAutomaticSize
        }
        return calculateCellSize(indexPath)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        // collectionView?.collectionViewLayout.invalidateLayout()
    }
    
    @objc var statusImageView: UIImageView?
    
    func getVisibleIndex() -> IndexPath {
        let visibleRect = CGRect(origin: (collectionView?.contentOffset)!, size: (collectionView?.bounds.size)!)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        let indexPath = collectionView?.indexPathForItem(at: visiblePoint)
        return indexPath != nil ? indexPath! : IndexPath(item:0,section:0)
    }
    
    func playVisibleVideo() {
        if !self.explorer && (selectedTabIndex == profileIndex || self.profile) {
            return
        }
        let indexPath = getVisibleIndex()
        for visIndex in (self.collectionView?.indexPathsForVisibleItems)! {
            if posts[visIndex.row].proofedByChallenger! && !posts[visIndex.row].provedWithImage! {
                if visIndex != indexPath {
                    if let cell = collectionView?.cellForItem(at: visIndex) {
                        let feedCell = cell as! FeedCell
                        if let player = feedCell.proofedVideoView.playerLayer.player {
                            player.seek(to: kCMTimeZero)
                            player.pause()
                        }
                    }
                } else {
                    if let cell = collectionView?.cellForItem(at: indexPath) {
                        let feedCell = cell as! FeedCell
                        let frameSize: CGPoint = CGPoint(x: UIScreen.main.bounds.size.width * 0.5,y: UIScreen.main.bounds.size.height * 0.5)
                        if feedCell.proofedVideoView.frame.contains(frameSize) && !self.posts[indexPath.row].provedWithImage! {
                            if let player = feedCell.proofedVideoView.playerLayer.player {
                                if player.rate == 0.0 {
                                    player.volume = volume
                                    player.playImmediately(atRate: 1.0)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    @objc var lastContentOffSet : CGFloat = 0
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if explorer || goForwardToSelection {
            return
        }
        if nowMoreData {
            self.collectionView?.bottomRefreshControl?.endRefreshing()
        }
        if selectedTabIndex == chanllengeIndex || selectedTabIndex == profileIndex {
            if (scrollView.contentOffset.y >= 0 && self.lastContentOffSet < scrollView.contentOffset.y) || (scrollView.contentOffset.y > 0 && scrollView.isAtBottom) {
                // move down
                if selectedTabIndex == chanllengeIndex {
                    chlScrollMoveDown = true
                    chlScrollMoveUp = false
                }
                if selectedTabIndex == profileIndex {
                    prflScrollMoveDown = true
                    prflScrollMoveUp = false
                }
                if let status = UIApplication.shared.value(forKey: "statusBar") as? UIView {
                    status.backgroundColor = navAndTabColor
                }
                self.navigationController?.setNavigationBarHidden(true, animated: true)
            } else {
                // move up
                if selectedTabIndex == chanllengeIndex {
                    chlScrollMoveDown = false
                    chlScrollMoveUp = true
                }
                if selectedTabIndex == profileIndex {
                    prflScrollMoveDown = false
                    prflScrollMoveUp = true
                }
                if let status = UIApplication.shared.value(forKey: "statusBar") as? UIView {
                    status.backgroundColor = nil
                }
                self.navigationController?.setNavigationBarHidden(false, animated: true)
            }
            self.lastContentOffSet = scrollView.contentOffset.y
        }
        playVisibleVideo()
    }
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
    }
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
    }
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (selectedTabIndex == profileIndex  && !explorer) || profile {
            if indexPath.section == 1 && notDonePosts.count != 0 {
                openExplorer(challengeId: notDonePosts[indexPath.row].id!)
            } else if indexPath.section == 2 && donePosts.count != 0 {
                openExplorer(challengeId: donePosts[indexPath.row].id!)
            }
        }
    }
    
    @objc lazy var challengeController: FeedController = {
        return FeedController(collectionViewLayout: UICollectionViewFlowLayout())
    }()
    
    @objc func openExplorer(challengeId: String) {
        challengeController.navigationItem.title = "Explorer"
        challengeController.explorer = true
        challengeController.challengIdForTrendAndExplorer = challengeId
        challengeController.explorerCurrentPage = 0
        challengeController.selectedTabIndex = self.tabBarController?.selectedIndex ?? 0
        challengeController.reloadChlPage()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.pushViewController(challengeController, animated: true)
    }
    
    @objc func openProfile(memberId: String) {
        let profileController = FeedController(collectionViewLayout: UICollectionViewFlowLayout())
        /*
        getMemberInfo(memberId: memberId)
        isMyFriend(friendMemberId: memberId)
        group.wait()
        profileController.navigationItem.title = nameForOpenProfile
        profileController.memberIdForFriendProfile = memberId
        profileController.memberNameForFriendProfile = nameForOpenProfile
        profileController.memberFbIdForFriendProfile = facebookIDForOpenProfile
        profileController.memberCountOfFollowerForFriendProfile = countOfFollowersForOpenProfile
        profileController.memberCountOfFollowingForFriendProfile = countOfFollowingForOpenProfile
        profileController.memberIsPrivateForFriendProfile = friendIsPrivate
        profileController.isProfileFriend = isProfileFriend
         */
        profileController.memberNameForFriendProfile = nil
        profileController.memberFbIdForFriendProfile = nil
        profileController.memberCountOfFollowerForFriendProfile = nil
        profileController.memberCountOfFollowingForFriendProfile = nil
        profileController.memberIsPrivateForFriendProfile = nil
        profileController.isProfileFriend = false
        profileController.memberIdForFriendProfile = memberId
        profileController.profile = true
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.pushViewController(profileController, animated: true)
    }
    
    @objc var countOfFollowersForOpenProfile = 0
    @objc var countOfFollowingForOpenProfile = 0
    @objc var nameForOpenProfile = ""
    @objc var facebookIDForOpenProfile = ""
    @objc var friendIsPrivate = false
    @objc let group = DispatchGroup()
    @objc func getFriendInfo(_ friendMemberId: String) {
        let jsonURL = URL(string: getFriendInfoURL + memberID + "&friendMemberId=" + friendMemberId)!
        group.enter()
        jsonURL.get { data, response, error in
            guard
                let returnData = data,
                let postOfMember = try? JSONSerialization.jsonObject(with: returnData, options: .mutableContainers) as? [String: AnyObject]
                else {
                    ServiceLocator.logErrorMessage(data: data!, chlId: "", sUrl: getMemberInfoURL, inputs: "friendMemberId=\(friendMemberId)")
                    return
            }
            if let post = postOfMember {
                self.countOfFollowersForOpenProfile = (post["followerCount"] as? Int)!
                self.countOfFollowingForOpenProfile = (post["followingCount"] as? Int)!
                self.nameForOpenProfile = "\((post["name"] as? String)!) \((post["surname"] as? String)!)"
                self.facebookIDForOpenProfile = (post["facebookID"] as? String)!
                self.friendIsPrivate = (post["privateMember"] as? Bool)!
                self.isProfileFriend = (post["myFriend"] as? Bool)!
                self.isProfileRequested = (post["requestFriend"] as? Bool)!
            }
            self.group.leave()
        }
    }
    
    @objc func getMemberInfo(memberId: String) {
        let jsonURL = URL(string: getMemberInfoURL + memberId)!
        group.enter()
        jsonURL.get { data, response, error in
            guard
                let returnData = data,
                let postOfMember = try? JSONSerialization.jsonObject(with: returnData, options: .mutableContainers) as? [String: AnyObject]
                else {
                    ServiceLocator.logErrorMessage(data: data!, chlId: "", sUrl: getMemberInfoURL, inputs: "memberID=\(memberId)")
                    return
            }
            if let post = postOfMember {
                self.countOfFollowersForOpenProfile = (post["followerCount"] as? Int)!
                self.countOfFollowingForOpenProfile = (post["followingCount"] as? Int)!
                self.nameForOpenProfile = "\((post["name"] as? String)!) \((post["surname"] as? String)!)"
                self.facebookIDForOpenProfile = (post["facebookID"] as? String)!
                self.friendIsPrivate = (post["privateMember"] as? Bool)!
            }
            self.group.leave()
        }
    }
    
    @objc func isMyFriend(friendMemberId: String) {
        let jsonURL = URL(string: isMyFriendURL + memberID + "&friendMemberId=" + friendMemberId)!
        group.enter()
        jsonURL.get { data, response, error in
            guard
                let returnData = data
                else {
                    ServiceLocator.logErrorMessage(data: data!, chlId: "", sUrl: isMyFriendURL, inputs: "memberID=\(memberID), friendMemberId=\(friendMemberId)")                    
                    return
            }
            self.group.leave()
            let isMyFriend = NSString(data: returnData, encoding: String.Encoding.utf8.rawValue)!
            self.isProfileFriend = (isMyFriend as String).toBool()
        }
    }
    
    @objc func isRequestedFriend(friendMemberId: String) {
        let jsonURL = URL(string: isRequestedFriendURL + memberID + "&friendMemberId=" + friendMemberId)!
        group.enter()
        jsonURL.get { data, response, error in
            guard
                let returnData = data
                else {
                    ServiceLocator.logErrorMessage(data: data!, chlId: "", sUrl: isMyFriendURL, inputs: "memberID=\(memberID), friendMemberId=\(friendMemberId)")
                    return
            }
            self.group.leave()
            let isRequested = NSString(data: returnData, encoding: String.Encoding.utf8.rawValue)!
            self.isProfileRequested = (isRequested as String).toBool()
        }
    }
}

class ChallengeHeader: UICollectionReusableView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "FRIEND REQUESTS"
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = UIColor(white: 0.4, alpha: 1)
        return label
    }()
    
    @objc let bottomBorderView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(229, green: 231, blue: 235)
        return view
    }()
    
    @objc func setupViews() {
        let contentGuide = self.readableContentGuide
        
        addSubview(nameLabel)
        addSubview(bottomBorderView)
        
        addTopAnchor(nameLabel, anchor: contentGuide.topAnchor, constant: 0)
        addLeadingAnchor(nameLabel, anchor: contentGuide.leadingAnchor, constant: 0)
        
        addTopAnchor(bottomBorderView, anchor: contentGuide.topAnchor, constant: 0)
        addLeadingAnchor(bottomBorderView, anchor: contentGuide.leadingAnchor, constant: 0)
        addHeightAnchor(bottomBorderView, multiplier: 0.5/10)
    }
    
}
