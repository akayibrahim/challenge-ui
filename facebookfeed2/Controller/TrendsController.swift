//
//  OtherControllers.swift
//  facebookfeed2
//
//  Created by Brian Voong on 2/27/16.
//  Copyright © 2016 letsbuildthatapp. All rights reserved.
//

import UIKit
import AVKit

class TrendsController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UISearchBarDelegate, UICollectionViewDataSourcePrefetching {
    @objc let searchBar = UISearchBar()
    @objc var trendRequest = [TrendRequest]()
    @objc let cellId = "cellId"
    @objc var refreshControl : UIRefreshControl!
    @objc var currentPage : Int = 0
    @objc var nowMoreData: Bool = false
    var goForward: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor =  UIColor.rgb(229, green: 231, blue: 235)
        searchBar.placeholder = "Search"
        searchBar.delegate = self
        searchBar.autocapitalizationType = UITextAutocapitalizationType.allCharacters                
        searchBar.setTextFieldColor(color: UIColor.gray.withAlphaComponent(0.1))
        
        self.navigationItem.titleView = searchBar
        collectionView!.register(TrendRequestCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.backgroundColor = UIColor(white: 1, alpha: 1)
        collectionView?.alwaysBounceVertical = true
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.prefetchDataSource = self
        collectionView?.isPrefetchingEnabled = true
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.onRefesh), for: UIControlEvents.valueChanged)
        collectionView?.addSubview(refreshControl)
        
        reloadPage()
        self.navigationController?.hidesBarsOnSwipe = true
        self.hideKeyboardWhenTappedAround()
        NotificationCenter.default.addObserver(self, selector:  #selector(self.appMovedToBackground), name:   Notification.Name.UIApplicationWillEnterForeground, object: nil)
        
        let layout = collectionView!.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.minimumLineSpacing = 30
    }
    
    @objc func appMovedToBackground() {
        if self.tabBarController?.selectedIndex == trendsIndex {
            self.playVisibleVideo()
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
        let cancelButton = searchBar.value(forKeyPath: "cancelButton") as? UIButton
        cancelButton?.tintColor = UIColor.black
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBarCancelButton()
        onRefesh()
    }
    
    @objc func searchBarCancelButton() {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked( _ searchBar: UISearchBar) {
        if dummyServiceCall == false {
            currentPage = 0
            self.trendRequest = [TrendRequest]()
            self.collectionView?.reloadData()
            fetchTrendChallenges(key: searchBar.text!)
            return
        } else {
            searchDummy()
            return
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
    }
    
    @objc func searchDummy() {
        if let path = Bundle.main.path(forResource: "trend_request_1", ofType: "json") {
            do {
                let data = try(Data(contentsOf: URL(fileURLWithPath: path), options: NSData.ReadingOptions.mappedIfSafe))
                let jsonDictionary = try(JSONSerialization.jsonObject(with: data, options: .mutableContainers)) as? [String: Any]
                if let postsArray = jsonDictionary?["posts"] as? [[String: AnyObject]] {
                    self.trendRequest = [TrendRequest]()
                    for postDictionary in postsArray {
                        let trendReq = TrendRequest()
                        trendReq.setValuesForKeys(postDictionary)
                        self.trendRequest.append(trendReq)
                    }
                }
            } catch let err {
                print(err)
            }
        }
        self.collectionView?.reloadData()
        searchBar.resignFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let forwardChange = Util.getForwardChange()
        if goForward && forwardChange.forwardScreen != "" {
            if forwardChange.forwardScreen == FRWRD_CHNG_TREND {
                self.trendRequest[forwardChange.index!.item].canJoin = false
                self.collectionView?.reloadItems(at: [forwardChange.index!])
            }
        }
        goForward = false
        playVisibleVideo()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let indexPaths = self.collectionView?.indexPathsForVisibleItems
        for indexPath in indexPaths! {
            let cell = self.collectionView?.cellForItem(at: indexPath) as! TrendRequestCell
            if let player = cell.proofedVideoView.playerLayer.player {
                player.pause()
            }
        }
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    @objc func onRefesh() {
        self.reloadPage()
        refreshControl.endRefreshing()
    }
    
    @objc func reloadPage() {
        searchBar.text = ""
        currentPage = 0
        self.trendRequest = [TrendRequest]()
        self.collectionView?.reloadData()
        self.collectionView?.numberOfItems(inSection: 0)
        self.collectionView?.showBlurLoader()
        self.loadTrends()
    }
    
    @objc func loadTrends() {
        if dummyServiceCall == false {
            if Util.controlNetwork() {
                return
            }
            self.fetchTrendChallenges(key: "")
            return
        } else {
            self.trendRequest = ServiceLocator.getTrendChallengesFromDummy(jsonFileName: "trend_request")
            return
        }
    }
    
    @objc func fetchTrendChallenges(key: String) {
        DispatchQueue.global(qos: .userInitiated).async {
        let urlStr = getTrendChallengesURL + memberID + "&subjectSearchKey=" + key + "&page=\(self.currentPage)"
        let urlStrWithPerm = urlStr.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        let url = NSURL(string: urlStrWithPerm!)!
        URLSession.shared.dataTask(with: url as URL, completionHandler: { (data, response, error) -> Void in
            if error == nil && data != nil {
                    do {
                        if let postsArray = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [[String: AnyObject]] {
                            self.nowMoreData = postsArray.count == 0 ? true : false
                            var indexPaths = [IndexPath]()
                            for postDictionary in postsArray {
                                let trend = TrendRequest()
                                trend.provedWithImage = postDictionary["provedWithImage"] as? Bool
                                trend.wide = postDictionary["wide"] as? Bool
                                trend.canJoin = postDictionary["canJoin"] as? Bool
                                trend.setValuesForKeys(postDictionary)
                                self.trendRequest.append(trend)
                                indexPaths.append(IndexPath(row: self.trendRequest.count - 1, section: 0))
                            }
                            if self.nowMoreData == false {
                                DispatchQueue.main.async {
                                    self.collectionView?.removeBluerLoader()
                                    //self.collectionView?.reloadData()
                                    self.collectionView?.insertItems(at: indexPaths)
                                }
                            }
                        }
                        self.collectionView?.removeBluerLoader()
                    } catch let err {
                        print(err)
                    }
            }
        }).resume()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        let needsFetch = indexPaths.contains { $0.row >= self.trendRequest.count - 1 }
        if needsFetch && !nowMoreData && !dummyServiceCall {
            currentPage += 1
            self.loadTrends()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        /*let checkPoint = trendRequest.count - 1
        let shouldLoadMore = checkPoint == indexPath.row
        if shouldLoadMore && !nowMoreData && !dummyServiceCall {
            currentPage += 1
            self.loadTrends()
        }*/
    }
    
    @objc var downImage: UIImage?
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width, height: (screenWidth * 0.3 / 2)
            + (screenWidth * (self.trendRequest[indexPath.row].wide! ? heightRatioOfWideMedia : heightRatioOfMedia)))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! TrendRequestCell
        cell.layer.shouldRasterize = true
        cell.layer.rasterizationScale = UIScreen.main.scale
        if trendRequest.count == 0 {
            return cell
        }
        DispatchQueue.main.async {
            cell.layer.shouldRasterize = true
            cell.layer.rasterizationScale = UIScreen.main.scale
            cell.prepareForReuse()
            cell.trendRequest = self.trendRequest[indexPath.row]
            if self.trendRequest[indexPath.row].provedWithImage! {
                cell.requestImageView.load(challengeId: self.trendRequest[indexPath.row].challengeId!, challengerId: self.trendRequest[indexPath.row].challengerId!)
                self.imageEnable(cell, yes: true)
            } else {
                let willPlay = indexPath.row == 0 || indexPath.row == 1 ? true : false
                cell.proofedVideoView.showDarkLoader()
                cell.proofedVideoView.playerLayer.loadWithZeroVolume(challengeId: self.trendRequest[indexPath.item].challengeId!, challengerId: self.trendRequest[indexPath.item].challengerId!, play: willPlay, completion: { () in
                    cell.proofedVideoView.removeBluerLoader()
                })
                self.imageEnable(cell, yes: false)
            }
        }
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.profileImageTapped(tapGestureRecognizer:)))
        cell.profileImageView.tag = indexPath.row
        cell.profileImageView.isUserInteractionEnabled = true
        cell.profileImageView.addGestureRecognizer(tapGestureRecognizer)
        let tapGestureRecognizerName = UITapGestureRecognizer(target: self, action: #selector(self.profileImageTappedName(tapGestureRecognizer:)))
        cell.nameLabel.tag = indexPath.row
        cell.nameLabel.isUserInteractionEnabled = true
        cell.nameLabel.addGestureRecognizer(tapGestureRecognizerName)
        cell.joinToChl.tag = indexPath.row
        cell.joinToChl.challengeId = trendRequest[indexPath.item].challengeId
        cell.joinToChl.addTarget(self, action: #selector(self.joinToChallenge), for: UIControlEvents.touchUpInside)
        return cell
    }
    
    @objc func imageEnable(_ feedCell: TrendRequestCell, yes: Bool) {
        feedCell.proofedVideoView.alpha = yes ? 0 : 1
        feedCell.volumeUpImageView.alpha = yes ? 0 : 0
        feedCell.volumeDownImageView.alpha = yes ? 0 : 1
        feedCell.requestImageView.alpha = yes ? 1 : 0
    }
    // var avPlayer : AVPlayer = AVPlayer.init()

    @objc func profileImageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        openProfile(name: trendRequest[tappedImage.tag].name!, memberId: trendRequest[tappedImage.tag].challengerId!, memberFbId: trendRequest[tappedImage.tag].prooferFbID!)
    }

    @objc func profileImageTappedName(tapGestureRecognizer: UITapGestureRecognizer) {
        let tappedImage = tapGestureRecognizer.view as! UILabel        
        let textRange = NSMakeRange(0, (trendRequest[tappedImage.tag].name?.count)!)
        if tapGestureRecognizer.didTapAttributedTextInLabel(label: tappedImage, inRange: textRange) {
            openProfile(name: trendRequest[tappedImage.tag].name!, memberId: trendRequest[tappedImage.tag].challengerId!, memberFbId: trendRequest[tappedImage.tag].prooferFbID!)
        } else {
            openExplorer(challengeId: trendRequest[tappedImage.tag].challengeId!)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        openExplorer(challengeId: trendRequest[indexPath.row].challengeId!)
    }
    
    @objc lazy var challengeController: FeedController = {
        return FeedController(collectionViewLayout: UICollectionViewFlowLayout())
    }()
    
    @objc func openExplorer(challengeId: String) {
        challengeController.navigationItem.title = "Explorer"        
        challengeController.challengIdForTrendAndExplorer = challengeId
        challengeController.trend = true
        challengeController.explorerCurrentPage = 0
        challengeController.selectedTabIndex = self.tabBarController?.selectedIndex ?? 0
        challengeController.reloadChlPage()
        // challengeController.hidesBottomBarWhenPushed = true
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.pushViewController(challengeController, animated: true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return trendRequest.count
    }
    
    @objc var lastContentOffSet : CGFloat = 0
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.statusBarVisibility(navigationController?.isNavigationBarHidden ?? false)
        /*
        if (scrollView.contentOffset.y >= 0 && self.lastContentOffSet < scrollView.contentOffset.y) || (scrollView.contentOffset.y > 0 && scrollView.isAtBottom) {
            // move down
            if let status = UIApplication.shared.value(forKey: "statusBar") as? UIView {
                status.backgroundColor = statusBarColor
            }
            self.navigationController?.setNavigationBarHidden(true, animated: true)
        } else {
            // move up
            if let status = UIApplication.shared.value(forKey: "statusBar") as? UIView {
                status.backgroundColor = nil
            }
            self.navigationController?.setNavigationBarHidden(false, animated: true)
        }
        self.lastContentOffSet = scrollView.contentOffset.y
        */
        playVisibleVideo()
    }
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
    }
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
    }
    
    @objc func openProfile(name: String, memberId: String, memberFbId:String) {
        let profileController = FeedController(collectionViewLayout: UICollectionViewFlowLayout())
        getMemberInfo(memberId: memberId)
        isMyFriend(friendMemberId: memberId)
        group.wait()
        profileController.navigationItem.title = name
        profileController.memberIdForFriendProfile = memberId
        profileController.memberNameForFriendProfile = name
        profileController.memberFbIdForFriendProfile = memberFbId
        profileController.memberCountOfFollowerForFriendProfile = countOfFollowersForFriend
        profileController.memberCountOfFollowingForFriendProfile = countOfFollowingForFriend
        profileController.memberIsPrivateForFriendProfile = friendIsPrivate
        profileController.profile = true
        profileController.isProfileFriend = isProfileFriend
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.pushViewController(profileController, animated: true)
    }
    
    @objc var countOfFollowersForFriend = 0
    @objc var countOfFollowingForFriend = 0
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
                    let error = ServiceLocator.getErrorMessage(data: data!, chlId: "", sUrl: getMemberInfoURL, inputs: "memberID=\(memberId)")
                    print(error)
                    return
            }
            self.group.leave()
            if let post = postOfMember {
                self.countOfFollowersForFriend = (post["followerCount"] as? Int)!
                self.countOfFollowingForFriend = (post["followingCount"] as? Int)!
                self.friendIsPrivate = (post["privateMember"] as? Bool)!
            }
        }
    }
    
    @objc var isProfileFriend = false
    @objc func isMyFriend(friendMemberId: String) {
        let jsonURL = URL(string: isMyFriendURL + memberID + "&friendMemberId=" + friendMemberId)!
        group.enter()
        jsonURL.get { data, response, error in
            guard
                let returnData = data
                else {
                    let error = ServiceLocator.getErrorMessage(data: data!, chlId: "", sUrl: isMyFriendURL, inputs: "memberID=\(memberID), friendMemberId=\(friendMemberId)")
                    print(error)
                    return
            }
            self.group.leave()
            let isMyFriend = NSString(data: returnData, encoding: String.Encoding.utf8.rawValue)!
            self.isProfileFriend = (isMyFriend as String).toBool()
        }
    }
    
    func getVisibleIndex() -> IndexPath {
        let visibleRect = CGRect(origin: (collectionView?.contentOffset)!, size: (collectionView?.bounds.size)!)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        let indexPath = collectionView?.indexPathForItem(at: visiblePoint)
        return indexPath != nil ? indexPath! : IndexPath(item:0,section:0)
    }
    
    func playVisibleVideo() {
        let indexPath = getVisibleIndex()
        for visIndex in (self.collectionView?.indexPathsForVisibleItems)! {
            if !trendRequest[visIndex.row].provedWithImage! {
                if visIndex != indexPath && visIndex.row != trendRequest.count - 1 && indexPath.row + 1 != visIndex.row && indexPath.row - 1 != visIndex.row {
                    if let cell = collectionView?.cellForItem(at: visIndex) {
                        let feedCell = cell as! TrendRequestCell
                        if !self.trendRequest[visIndex.row].provedWithImage! {
                            if let player = feedCell.proofedVideoView.playerLayer.player {
                                player.seek(to: kCMTimeZero)
                                player.pause()
                            }
                        }
                    }
                } else {
                    if let cell = collectionView?.cellForItem(at: visIndex) {
                        let feedCell = cell as! TrendRequestCell
                        if !self.trendRequest[visIndex.row].provedWithImage! {
                            if let player = feedCell.proofedVideoView.playerLayer.player {
                                if player.rate == 0.0 {
                                    player.playImmediately(atRate: 1.0)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    @objc func joinToChallenge(sender: subclasssedUIButton) {
        let index = IndexPath(item: sender.tag, section: 0)
        let feedCell = collectionView?.cellForItem(at: index) as! TrendRequestCell
        joinToChallengeService(challengeId: sender.challengeId!, feedCell: feedCell)
        openProofScreen(challengeId: trendRequest[sender.tag].challengeId!, index: sender.tag)
    }
    
    @objc func joinToChallengeService(challengeId: String, feedCell: TrendRequestCell) {
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
    
    @objc func openProofScreen(challengeId: String, index: Int) {
        let commentsTable = ProofTableViewController()
        commentsTable.tableTitle = trendRequest[index].subject!
        commentsTable.challengeId = challengeId
        let section = 0
        let screen = FRWRD_CHNG_TREND
        commentsTable.joined = true
        commentsTable.proofed = false
        commentsTable.canJoin = false
        commentsTable.done = false
        commentsTable.activeIndex = IndexPath(item: index, section: 0)
        Util.addForwardChange(forwardChange: ForwardChange(index: IndexPath(item:index ,section: section), forwardScreen: screen, viewProofsCount: 0, joined: commentsTable.joined, proved: commentsTable.proofed, canJoin: commentsTable.canJoin))
        goForward = true
        commentsTable.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(commentsTable, animated: true)
    }
}
