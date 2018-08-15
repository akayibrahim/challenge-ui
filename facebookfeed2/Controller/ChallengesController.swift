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
    
let cellId = "cellId"
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
    @objc var challengIdForTrendAndExplorer: String?
    @objc var profile: Bool = false
    @objc var memberIdForFriendProfile: String?
    @objc var memberFbIdForFriendProfile: String?
    @objc var memberNameForFriendProfile: String?
    var memberCountOfFollowerForFriendProfile: Int?
    var memberCountOfFollowingForFriendProfile: Int?
    var memberIsPrivateForFriendProfile: Bool?
    @objc var isProfileFriend: Bool = false
    @objc var currentPage : Int = 0
    @objc var selfCurrentPage : Int = 0
    @objc var explorerCurrentPage : Int = 0
    @objc var nowMoreData: Bool = false
    @objc var challangeCount: String = "0"
    @objc var goForward: Bool = false
    var isFetchingNextPage = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if profile {
        } else if self.tabBarController?.selectedIndex == chanllengeIndex {
            navigationItem.title = challengeTitle
            refreshControl = UIRefreshControl()
            refreshControl.addTarget(self, action: #selector(self.onRefesh), for: UIControlEvents.valueChanged)
            collectionView?.addSubview(refreshControl)
        } else if self.tabBarController?.selectedIndex == profileIndex && !explorer {
            navigationItem.title = profileTitle
            selfRefreshControl = UIRefreshControl()
            selfRefreshControl.addTarget(self, action: #selector(self.onSelfRefesh), for: UIControlEvents.valueChanged)
            collectionView?.addSubview(selfRefreshControl)
        }
        collectionView?.alwaysBounceVertical = true
        
        if !(self.tabBarController?.selectedIndex == profileIndex && !self.profile && !explorer) {
            reloadChlPage()
        } else {
            reloadSelfPage()
        }
        
        collectionView?.backgroundColor = UIColor(white: 0.95, alpha: 1)
        collectionView?.register(FeedCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.register(FeedCell.self, forCellWithReuseIdentifier: "profile")
        collectionView?.register(FeedCell.self, forCellWithReuseIdentifier: "selfCellId")
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.register(ChallengeHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader , withReuseIdentifier: "someRandonIdentifierString")
        collectionView?.prefetchDataSource = self
        collectionView?.isPrefetchingEnabled = true
    }
    
    @objc func isTabIndex(_ index: Int) -> Bool {
        return self.tabBarController?.selectedIndex == index
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
        currentPage = 0
        self.posts = [Post]()
        self.collectionView?.reloadData()
        self.loadChallenges()
    }
    
    @objc func onSelfRefesh() {
        if selfRefreshControl.isRefreshing {
            reloadSelfPage()
            selfRefreshControl.endRefreshing()
        }
    }
    
    @objc func reloadSelfPage() {
        selfCurrentPage = 0
        self.posts = [Post]()
        self.donePosts = [Post]()
        self.notDonePosts = [Post]()
        self.collectionView?.reloadData()
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
                if (!self.memberIsPrivateForFriendProfile! || (self.memberIsPrivateForFriendProfile! && self.isProfileFriend)) && self.memberIdForFriendProfile != memberID {
                    self.fetchChallenges(url: getChallengesOfFriendURL + memberID + "&friendMemberId=" + self.memberIdForFriendProfile! + "&page=\(self.selfCurrentPage)", profile: true)
                    self.fetchChallengeSize(memberId: self.memberIdForFriendProfile!)
                } else if self.memberIdForFriendProfile == memberID {
                    self.fetchChallengeSize(memberId: memberID)
                    self.fetchChallenges(url: getChallengesOfMemberURL + memberID  + "&page=\(self.selfCurrentPage)", profile: true)
                }
                return
            } else if self.explorer {
                self.fetchChallenges(url: getExplorerChallengesURL + memberID + "&challengeId=" + self.challengIdForTrendAndExplorer! + "&addSimilarChallenges=false"  + "&page=\(self.explorerCurrentPage)", profile: false)
                return
            } else if self.tabBarController?.selectedIndex == trendsIndex {
                self.fetchChallenges(url: getExplorerChallengesURL + memberID + "&challengeId=" + self.challengIdForTrendAndExplorer! + "&addSimilarChallenges=true" + "&page=\(self.explorerCurrentPage)", profile: false)
                return
            } else if self.tabBarController?.selectedIndex == profileIndex {
                self.fetchChallengeSize(memberId: memberID)
                group.wait()
                self.fetchChallenges(url: getChallengesOfMemberURL + memberID  + "&page=\(self.selfCurrentPage)", profile: true)
                FacebookController().getMemberInfo(memberId: memberID)
                return
            } else if self.tabBarController?.selectedIndex == chanllengeIndex {
                self.getActivityCount()
                self.fetchChallenges(url: getChallengesURL + memberID + "&page=\(self.currentPage)", profile: false)
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
            } else if self.tabBarController?.selectedIndex == trendsIndex {
                self.posts = ServiceLocator.getChallengesFromDummy(jsonFileName: "getTrendChallenges")
            } else if self.tabBarController?.selectedIndex == profileIndex {
                self.donePosts = ServiceLocator.getOwnChallengesFromDummy(jsonFileName: "getOwnChallenges", done: true)
                self.notDonePosts = ServiceLocator.getOwnChallengesFromDummy(jsonFileName: "getOwnChallenges", done: false)
                self.posts = donePosts
                self.posts.append(contentsOf: notDonePosts)
            } else if self.tabBarController?.selectedIndex == chanllengeIndex {
                self.posts = ServiceLocator.getChallengesFromDummy(jsonFileName: "getChallenges")
            }
            self.collectionView?.reloadData()
        }
    }
    
    @objc func fetchChallenges(url: String, profile : Bool) {
        isFetchingNextPage = true
        let jsonURL = URL(string: url)!
        jsonURL.get { data, response, error in
            guard
                data != nil,
                let postsArray = try? JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [[String: AnyObject]]
                else {
                    if data != nil {
                        self.popupAlert(message: ServiceLocator.getErrorMessage(data: data!, chlId: "", sUrl: url, inputs: "memberID=\(memberID)"), willDelay: false)
                    }
                    return
            }
            //DispatchQueue.global(qos: .userInitiated).async {
            DispatchQueue.main.async {
                self.nowMoreData = postsArray?.count == 0 ? true : false
                if postsArray?.isEmpty == false {
                    for postDictionary in postsArray! {
                        let post = ServiceLocator.mappingOfPost(postDictionary: postDictionary)
                        self.posts.append(post)
                        if profile {
                            if post.done == true {
                                self.donePosts.append(post)
                                self.insertItem(self.donePosts.count - 1, section: 2)
                            } else {
                                self.notDonePosts.append(post)
                                self.insertItem(self.notDonePosts.count - 1, section: 1)
                            }
                        } else {
                            self.insertItem(self.posts.count - 1, section: 0)
                        }
                    }
                }
                self.isFetchingNextPage = false
                if profile { // }&& self.nowMoreData == false {
                    // self.collectionView?.reloadData()
                }
            }
            //}
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
            self.group.leave()
            DispatchQueue.main.async {
                self.challangeCount = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)! as String
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var reusableView : UICollectionReusableView? = nil
        if (self.tabBarController?.selectedIndex == profileIndex && !explorer) || profile {
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
        if (self.tabBarController?.selectedIndex == profileIndex && !explorer) || profile {
            if section == 0 {
                return CGSize(width: view.frame.width, height: 0)
            }
            return CGSize(width: view.frame.width, height: view.frame.width / 15)
        }
        return CGSize(width: 0, height: 0)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (self.tabBarController?.selectedIndex == profileIndex && !explorer) || profile {
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
        if (self.tabBarController?.selectedIndex == profileIndex && !explorer) || profile  {
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
                self.posts[forwardChange.index!.row].canJoin = forwardChange.joined
                self.posts[forwardChange.index!.row].joined = !forwardChange.joined!
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
                    self.posts[forwardChange.index!.row].done = forwardChange.homeWinner! || forwardChange.awayWinner!
                }
                self.collectionView?.reloadItems(at: [forwardChange.index!])
            }
        }
        DispatchQueue.main.async {
            let indexPaths = self.collectionView?.indexPathsForVisibleItems
            for indexPath in indexPaths! {
                self.playVideo(indexPath)
            }
            if !self.profile {
                if self.tabBarController?.selectedIndex == chanllengeIndex {
                    // self.reloadChlPage()
                } else if self.tabBarController?.selectedIndex == profileIndex && !self.explorer {
                    // self.reloadSelfPage()
                }
                if reloadProfile {
                    self.reloadSelfPage()
                    reloadProfile = false
                }
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let indexPaths = self.collectionView?.indexPathsForVisibleItems
        for indexPath in indexPaths! {
            let cell = self.collectionView?.cellForItem(at: indexPath) as! FeedCell
            if let player = cell.avPlayerLayer.player {
                player.pause()
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let cell = cell as! FeedCell
        if let player = cell.avPlayerLayer.player {
            player.pause()
        }
    }
    
    func playVideo(_ indexPath: IndexPath) {
        if let cellForIndex = self.collectionView?.cellForItem(at: indexPath) {
            let cell = cellForIndex as! FeedCell
            if (self.collectionView?.isRowCompletelyVisible(indexPath))! {
                if let player = cell.avPlayerLayer.player {
                    player.play()
                }
            } else {
                if let player = cell.avPlayerLayer.player {
                    player.pause()
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        let isChallenge = self.tabBarController?.selectedIndex == chanllengeIndex && !profile
        let isSelf = self.tabBarController?.selectedIndex == profileIndex
        let isTrend = self.tabBarController?.selectedIndex == trendsIndex && explorer
        let needsFetch = indexPaths.contains { $0.row >= self.posts.count - 1 }
        let needsFetchSelf = indexPaths.contains { $0.row >= self.notDonePosts.count - 1  || $0.row >= self.donePosts.count - 1 }
        if (isChallenge || isTrend) && needsFetch && !nowMoreData && !dummyServiceCall {
            if isChallenge {
                currentPage += 1
                self.loadChallenges()
            }
            if isTrend {
                explorerCurrentPage += 1
                self.loadChallenges()
            }
        }
        if isSelf && needsFetchSelf && !nowMoreData && !dummyServiceCall {
            if isSelf || memberIdForFriendProfile == memberID {
                selfCurrentPage += 1
                self.loadChallenges()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        /*
        let isChallenge = self.tabBarController?.selectedIndex == chanllengeIndex && !profile
        let isSelf = self.tabBarController?.selectedIndex == profileIndex
        let isTrend = self.tabBarController?.selectedIndex == trendsIndex && explorer
        let checkPoint = posts.count - 1
        var shouldLoadMore = checkPoint == indexPath.row
        if isSelf {
            let checkPoint1 = notDonePosts.count - 1
            let checkPoint2 = donePosts.count - 1
            shouldLoadMore = (checkPoint1 == indexPath.row) || (checkPoint2 == indexPath.row)
        }
        if (isChallenge || isSelf || isTrend) && shouldLoadMore && !nowMoreData && !dummyServiceCall {
            if isChallenge {
                currentPage += 1
                print("challenge:\(currentPage)")
            }
            if isSelf || memberIdForFriendProfile == memberID {
                selfCurrentPage += 1
                print("profile:\(selfCurrentPage)")
            }
            if isTrend {
                explorerCurrentPage += 1
                print("explorer:\(explorerCurrentPage)")
            }
            self.loadChallenges()
        }
     */
    }
    
    @objc func createProfile() -> ProfileCellView {
        let profileCell : ProfileCellView = ProfileCellView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width * 2.5 / 10), memberFbId: (profile ? memberFbIdForFriendProfile! : memberFbID) , name: (profile ? memberNameForFriendProfile! : memberName))
        if profile {
            profileCell.other.alpha = 0
            if memberIdForFriendProfile != memberID {
                if isProfileFriend {
                    profileCell.unfollow.alpha = 1
                } else {
                    profileCell.follow.alpha = 1
                }
                profileCell.follow.memberId = memberIdForFriendProfile
                profileCell.unfollow.memberId = memberIdForFriendProfile
                profileCell.follow.addTarget(self, action: #selector(self.followProfile), for: UIControlEvents.touchUpInside)
                profileCell.unfollow.addTarget(self, action: #selector(self.unFollowProfile), for: UIControlEvents.touchUpInside)
            } else {
                profileCell.other.alpha = 1
            }
            if memberIsPrivateForFriendProfile! && !isProfileFriend {
                profileCell.privateLabel.alpha = 1
            }
        }
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
        profileCell.challangeCount.text = challangeCount
        if !profile || (profile && !memberIsPrivateForFriendProfile!) || (profile && memberIsPrivateForFriendProfile! && isProfileFriend) {
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
        isProfileFriend = false
        collectionView?.reloadData()
    }
    
    @objc func followProfile(sender: subclasssedUIButton) {
        let url = followingFriendURL + "?memberId=" + memberID + "&friendMemberId=" + sender.memberId! + "&follow=true"
        followOrUnfollowFriend(url: url, isRemove: false)
        group.wait()
        isProfileFriend = true
        collectionView?.reloadData()
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
            self.loadChallenges()
            self.group.leave()
            if !isRemove {
                self.popupAlert(message: "Now Following!", willDelay: true)
            } else {
                self.popupAlert(message: "Removed!", willDelay: true)
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if (self.tabBarController?.selectedIndex == profileIndex && !explorer) || profile  {
            if indexPath.section == 0 && indexPath.row == 0 {
                let feedCellForProfile = collectionView.dequeueReusableCell(withReuseIdentifier: "profile", for: indexPath) as! FeedCell
                DispatchQueue.main.async {
                    feedCellForProfile.addSubview(self.createProfile())
                }
                return feedCellForProfile
            }
            let feedCellForSelf = collectionView.dequeueReusableCell(withReuseIdentifier: "selfCellId", for: indexPath) as! FeedCell
            feedCellForSelf.prepareForReuse()
            feedCellForSelf.feedController = self
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
        let feedCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! FeedCell
        if  self.posts.count == 0 {
            return feedCell
        }
        feedCell.feedController = self
        DispatchQueue.main.async {
            feedCell.layer.shouldRasterize = true
            feedCell.layer.rasterizationScale = UIScreen.main.scale
            feedCell.prepareForReuse()
            feedCell.post = self.posts[indexPath.item]
            self.addTargetToFeedCell(feedCell: feedCell, indexPath: indexPath)
            if !self.posts[indexPath.item].isComeFromSelf! {
                if (self.posts[indexPath.item].proofedByChallenger)! {
                    if !self.posts[indexPath.item].provedWithImage! {
                        self.imageEnable(feedCell, yes: false)
                        feedCell.avPlayerLayer.load(challengeId: self.posts[indexPath.item].id!, challengerId: self.posts[indexPath.item].challengerId!)
                    } else {
                        self.imageEnable(feedCell, yes: true)
                        feedCell.proofedMediaView.load(challengeId: self.posts[indexPath.item].id!, challengerId: self.posts[indexPath.item].challengerId!)
                    }
                }
            }
        }
        return feedCell
    }
    
    @objc func imageEnable(_ feedCell: FeedCell, yes: Bool) {
        feedCell.proofedVideoView.alpha = yes ? 0 : 1
        feedCell.volumeUpImageView.alpha = !yes && volume == 1 ? 1 : 0
        feedCell.volumeDownImageView.alpha = !yes && volume == 0 ? 1 : 0
        feedCell.proofedMediaView.alpha = yes ? 1 : 0
    }
    /*
     /*
     self.getTrendImage(challengeId: self.posts[indexPath.item].id!, challengerId: self.posts[indexPath.item].challengerId!)  {
     image in
     if image != nil {
     DispatchQueue.main.async {
     feedCell.proofedMediaView.image = image
     }
     }
     }
     
     let params = "?challengeId=\(self.posts[indexPath.item].id!)&memberId=\(self.posts[indexPath.item].challengerId!)"
     let url = URL(string: downloadImageURL + params)
     feedCell.proofedMediaView.af_setImage(withURL: url!)
     
     imageDownloader.download(URLRequest(url: url!)) { response in
     if response.result.value != nil {
     DispatchQueue.main.async {
     feedCell.proofedMediaView.image = response.result.value!
     }
     }
     }
     */
     
     // var video: Data?
     /*
     let params = "?challengeId=\(self.posts[indexPath.item].id!)&memberId=\(self.posts[indexPath.item].challengerId!)"
     let urlV = URL(string: downloadVideoURL + params)
     let tempUrl = FileManager.default.temporaryDirectory.appendingPathComponent("\(params).mov")
     let destination: DownloadRequest.DownloadFileDestination = { _, _ in return (tempUrl, [.removePreviousFile, .createIntermediateDirectories]) }
     Alamofire.download(urlV!, to: destination).responseData { (response) in
     print(tempUrl)
     switch response.result {
     case .failure( _):
     break;
     case .success( _):
     DispatchQueue.main.async {
     let avPlayer = AVPlayer.init()
     avPlayer.replaceCurrentItem(with: AVPlayerItem.init(url: tempUrl))
     avPlayer.volume = volume
     feedCell.avPlayerLayer.player = avPlayer
     feedCell.avPlayerLayer.player?.play()
     }
     break;
     }
     
     }
     
     self.getVideo(challengeId: self.posts[indexPath.item].id!, challengerId: self.posts[indexPath.item].challengerId!) {
     video in
     if let vid = video {
     DispatchQueue.main.async {
     let avPlayer = AVPlayer.init()
     avPlayer.replaceCurrentItem(with: AVPlayerItem.init(url: vid))
     avPlayer.volume = volume
     feedCell.avPlayerLayer.player = avPlayer
     feedCell.avPlayerLayer.player?.play()
     }
     }
     }
     */
     
    let imageDownloader = ImageDownloader(
        configuration: ImageDownloader.defaultURLSessionConfiguration(),
        downloadPrioritization: .fifo,
        maximumActiveDownloads: 8,
        imageCache: AutoPurgingImageCache(
            memoryCapacity: 3_000_000, // Memory in bytes
            preferredMemoryUsageAfterPurge: 3_000_000
        )
    )
    */
    @objc func changeVolume(gesture: UITapGestureRecognizer) {
        DispatchQueue.main.async {
            volume = volume.isEqual(to: 0) ? 1 : 0
            let defaults = UserDefaults.standard
            defaults.set(volume, forKey: "volume")
            defaults.synchronize()
            let index = IndexPath(item: (gesture.view?.tag)!, section : 0)
            let feedCell = self.collectionView?.cellForItem(at: index) as! FeedCell
            self.changeVolumeOfFeedCell(feedCell: feedCell, isSilentRing: false, silentRingSwitch: 0)
        }
    }
    
    @objc func changeVolumeOfFeedCell(feedCell : FeedCell, isSilentRing : Bool, silentRingSwitch : Int) {
        DispatchQueue.main.async {
            if !isSilentRing {
                if (feedCell.avPlayerLayer.player?.volume.isEqual(to: 0))! {
                    feedCell.avPlayerLayer.player?.volume = 1
                    self.changeVolumeUpDownView(feedCell: feedCell, silentRingSwitch: 1)
                } else {
                    feedCell.avPlayerLayer.player?.volume = 0
                    self.changeVolumeUpDownView(feedCell: feedCell, silentRingSwitch: 0)
                }
            } else {
                feedCell.avPlayerLayer.player?.volume = Float(silentRingSwitch)
                self.changeVolumeUpDownView(feedCell: feedCell, silentRingSwitch: silentRingSwitch )
            }
        }
    }
    
    @objc func changeVolumeUpDownView(feedCell : FeedCell, silentRingSwitch : Int) {
        if (feedCell.avPlayerLayer.player?.volume.isEqual(to: 1))! {
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
        feedCell.viewProofs.canJoin = feedCell.joinToChl.alpha == 1 ? true : false
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
        let tapGestureRecognizerOpenProfile = UITapGestureRecognizer(target: self, action: #selector(openProfileForImage(tapGestureRecognizer:)))
        image.isUserInteractionEnabled = true
        image.addGestureRecognizer(tapGestureRecognizerOpenProfile)
    }
    
    @objc func openProfileForImage(tapGestureRecognizer: UITapGestureRecognizer) {
        let tappedImage = tapGestureRecognizer.view as! subclasssedUIImageView
        if tappedImage.memberId != nil {
            openProfile(memberId: tappedImage.memberId!)
        }
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
        selectionTable.hidesBottomBarWhenPushed = true
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
        selectionTable.hidesBottomBarWhenPushed = true
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
        selectionTable.hidesBottomBarWhenPushed = true
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
        selectionTable.hidesBottomBarWhenPushed = true
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.pushViewController(selectionTable, animated: true)
    }
    
    @objc func updateProgress(_ sender: subclasssedUIButton) {
        if sender.type == PUBLIC {
            openProofScreen(challengeId: sender.challengeId!, proofed: sender.proofed!, canJoin: sender.canJoin!, proveCount: sender.count!, index: sender.tag)
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
                Util.addForwardChange(forwardChange: ForwardChange(index: IndexPath(item:sender.tag ,section: 1), forwardScreen: FRWRD_CHNG_SCR, homeWinner: false, goal: sender.goal != nil ? sender.goal! : "-", result: sender.homeScore != nil ? sender.homeScore! : "-"))
            }
            goForward = true
            updateProgress.hidesBottomBarWhenPushed = true
            self.navigationController?.setNavigationBarHidden(false, animated: false)
            self.navigationController?.pushViewController(updateProgress, animated: true)
        }
    }
    
    @objc func openOthers(sender: UIButton) {
        let other = OtherController()
        other.hidesBottomBarWhenPushed = true
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
        commentsTable.proofed = proofed
        commentsTable.canJoin = canJoin
        Util.addForwardChange(forwardChange: ForwardChange(index: IndexPath(item:index ,section: isTabIndex(profileIndex) && !explorer ? 1 : 0), forwardScreen: FRWRD_CHNG_PRV, viewProofsCount: proveCount, joined: canJoin, proved: proofed))
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
        let currentImage = feedCell.joinButton.currentImage
        if currentImage == UIImage(named: acceptedRed) {
            feedCell.joinButton.setImage(UIImage(named: acceptedBlack), for: .normal)
        } else {
            feedCell.joinButton.setImage(UIImage(named: acceptedRed), for: .normal)
            joinToChallengeService(challengeId: sender.challengeId!, feedCell: feedCell)
            self.posts[index.row].joined = true
            self.posts[index.row].canJoin = false
            self.collectionView?.reloadItems(at: [index])
        }
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
            } else {
                DispatchQueue.main.async { // Correct
                    feedCell.joinToChl.alpha = 0
                    feedCell.addProofs.alpha = 1
                }
            }
        }).resume()
    }

    @objc let screenSize = UIScreen.main.bounds
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if (self.tabBarController?.selectedIndex == profileIndex && !explorer) || profile {
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
                knownHeight += screenWidth / 2
            }
            knownHeight += (screenSize.width / 26) + (screenWidth * 0.575 / 10)
            if let thinksAboutChallenge = posts[indexPath.item].thinksAboutChallenge {
                // let rect = NSString(string: thinksAboutChallenge).boundingRect(with: CGSize(width: view.frame.width, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 12)], context: nil)
                return CGSize(width: view.frame.width, height: thinksAboutChallenge.heightOf(withConstrainedWidth: screenWidth * 4 / 5, font: UIFont.systemFont(ofSize: 12)) + knownHeight)
            }
        }
        return CGSize(width: view.frame.width, height: knownHeight)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        collectionView?.collectionViewLayout.invalidateLayout()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    @objc let zoomImageView = UIImageView()
    @objc let blackBackgroundView = UIView()
    @objc let navBarCoverView = UIView()
    @objc let tabBarCoverView = UIView()
    
    @objc var statusImageView: UIImageView?
    
    @objc func animateImageView(_ statusImageView: UIImageView) {
        self.statusImageView = statusImageView
        if let startingFrame = statusImageView.superview?.convert(statusImageView.frame, to: nil) {
            statusImageView.alpha = 0
            blackBackgroundView.frame = self.view.frame
            blackBackgroundView.backgroundColor = UIColor.black
            blackBackgroundView.alpha = 0
            view.addSubview(blackBackgroundView)
            navBarCoverView.frame = CGRect(x: 0, y: 0, width: 1000, height: 20 + 44)
            navBarCoverView.backgroundColor = UIColor.black
            navBarCoverView.alpha = 0
            if let keyWindow = UIApplication.shared.keyWindow {
                keyWindow.addSubview(navBarCoverView)
                tabBarCoverView.frame = CGRect(x: 0, y: keyWindow.frame.height - 49, width: 1000, height: 49)
                tabBarCoverView.backgroundColor = UIColor.black
                tabBarCoverView.alpha = 0
                keyWindow.addSubview(tabBarCoverView)
            }
            zoomImageView.backgroundColor = UIColor.red
            zoomImageView.frame = startingFrame
            zoomImageView.isUserInteractionEnabled = true
            zoomImageView.image = statusImageView.image
            zoomImageView.contentMode = .scaleAspectFill
            zoomImageView.clipsToBounds = true
            view.addSubview(zoomImageView)
            zoomImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(FeedController.zoomOut)))
            UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: { () -> Void in
                let height = (self.view.frame.width / startingFrame.width) * startingFrame.height
                let y = self.view.frame.height / 2 - height / 2
                self.zoomImageView.frame = CGRect(x: 0, y: y, width: self.view.frame.width, height: height)
                self.blackBackgroundView.alpha = 1
                self.navBarCoverView.alpha = 1
                self.tabBarCoverView.alpha = 1
                }, completion: nil)
        }
    }
    
    @objc func zoomOut() {
        if let startingFrame = statusImageView!.superview?.convert(statusImageView!.frame, to: nil) {
            
            UIView.animate(withDuration: 0.75, animations: { () -> Void in
                self.zoomImageView.frame = startingFrame
                
                self.blackBackgroundView.alpha = 0
                self.navBarCoverView.alpha = 0
                self.tabBarCoverView.alpha = 0
                
                }, completion: { (didComplete) -> Void in
                    self.zoomImageView.removeFromSuperview()
                    self.blackBackgroundView.removeFromSuperview()
                    self.navBarCoverView.removeFromSuperview()
                    self.tabBarCoverView.removeFromSuperview()
                    self.statusImageView?.alpha = 1
            })
            
        }
    }
    
    @objc var lastContentOffSet : CGFloat = 0
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if explorer {
            return
        }
        let visibleRect = CGRect(origin: (collectionView?.contentOffset)!, size: (collectionView?.bounds.size)!)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        let indexPath = collectionView?.indexPathForItem(at: visiblePoint)
        for visIndex in (self.collectionView?.indexPathsForVisibleItems)! {
            if visIndex != indexPath {
                if let cell = collectionView?.cellForItem(at: visIndex) {
                    let feedCell = cell as! FeedCell
                    if let player = feedCell.avPlayerLayer.player {
                        player.pause()
                    }
                }
            }
        }
        if let index = indexPath {
            if let cell = collectionView?.cellForItem(at: index) {
                let feedCell = cell as! FeedCell
                let frameSize: CGPoint = CGPoint(x: UIScreen.main.bounds.size.width * 0.5,y: UIScreen.main.bounds.size.height * 0.5)
                if feedCell.proofedVideoView.frame.contains(frameSize) && !self.posts[index.row].provedWithImage! {
                    if let player = feedCell.avPlayerLayer.player {
                        player.play()
                    }
                }
            }
        }
        if self.tabBarController?.selectedIndex == chanllengeIndex || self.tabBarController?.selectedIndex == profileIndex {
            if (scrollView.contentOffset.y >= 0 && self.lastContentOffSet < scrollView.contentOffset.y) || (scrollView.contentOffset.y > 0 && scrollView.isAtBottom) {
                // move down
                if self.tabBarController?.selectedIndex == chanllengeIndex {
                    chlScrollMoveDown = true
                    chlScrollMoveUp = false
                }
                if self.tabBarController?.selectedIndex == profileIndex {
                    prflScrollMoveDown = true
                    prflScrollMoveUp = false
                }
                if let status = UIApplication.shared.value(forKey: "statusBar") as? UIView {
                    status.backgroundColor = navAndTabColor
                }
                self.navigationController?.setNavigationBarHidden(true, animated: true)
            } else {
                // move up
                if self.tabBarController?.selectedIndex == chanllengeIndex {
                    chlScrollMoveDown = false
                    chlScrollMoveUp = true
                }
                if self.tabBarController?.selectedIndex == profileIndex {
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
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (self.tabBarController?.selectedIndex == profileIndex  && !explorer) || profile {
            if indexPath.section == 1 && notDonePosts.count != 0 {
                openExplorer(challengeId: notDonePosts[indexPath.row].id!)
            } else if indexPath.section == 2 && donePosts.count != 0 {
                openExplorer(challengeId: donePosts[indexPath.row].id!)
            }
        }
    }
    
    @objc func openExplorer(challengeId: String) {
        let challengeController = FeedController(collectionViewLayout: UICollectionViewFlowLayout())
        challengeController.navigationItem.title = "Explorer"
        challengeController.explorer = true
        challengeController.challengIdForTrendAndExplorer = challengeId        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.pushViewController(challengeController, animated: true)
    }
    
    @objc func openProfile(memberId: String) {
        let profileController = FeedController(collectionViewLayout: UICollectionViewFlowLayout())
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
        profileController.profile = true
        profileController.isProfileFriend = isProfileFriend        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.pushViewController(profileController, animated: true)
    }
    
    @objc var countOfFollowersForOpenProfile = 0
    @objc var countOfFollowingForOpenProfile = 0
    @objc var nameForOpenProfile = ""
    @objc var facebookIDForOpenProfile = ""
    @objc var friendIsPrivate = false
    @objc let group = DispatchGroup()
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
