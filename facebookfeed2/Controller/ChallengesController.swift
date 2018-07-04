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
    
let cellId = "cellId"
var chlScrollMoveDown : Bool = false
var chlScrollMoveUp : Bool = false
var prflScrollMoveDown : Bool = false
var prflScrollMoveUp : Bool = false
var refreshControl : UIRefreshControl!
var selfRefreshControl : UIRefreshControl!

class SafeJsonObject: NSObject {
    
    override func setValue(_ value: Any?, forKey key: String) {
        let selectorString = "set\(key.uppercased().characters.first!)\(String(key.characters.dropFirst())):"
        let selector = Selector(selectorString)
        if responds(to: selector) {
            super.setValue(value, forKey: key)
        }
    }
    
}

class Feed: SafeJsonObject {
    var feedUrl, title, link, author, type: String?
}

class FeedController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    	
    var posts = [Post]()
    var donePosts = [Post]()
    var notDonePosts = [Post]()
    var explorer : Bool = false
    var challengIdForTrendAndExplorer: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.tabBarController?.selectedIndex == chanllengeIndex {
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
        
        loadChallenges()
        
        collectionView?.backgroundColor = UIColor(white: 0.95, alpha: 1)
        collectionView?.register(FeedCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.register(FeedCell.self, forCellWithReuseIdentifier: "profile")
        collectionView?.register(FeedCell.self, forCellWithReuseIdentifier: "selfCellId")
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.register(ChallengeHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader , withReuseIdentifier: "someRandonIdentifierString")
    }
    
    func onRefesh() {
        self.loadChallenges()
        refreshControl.endRefreshing()
    }
    
    func onSelfRefesh() {
        self.loadChallenges()
        selfRefreshControl.endRefreshing()
    }
    
    func loadChallenges() {
        if dummyServiceCall == false {
            // Asynchronous Http call to your api url, using NSURLSession:
            if explorer {
                fetchChallenges(url: getExplorerChallengesURL + memberID + "&challengeId=" + challengIdForTrendAndExplorer! + "&addSimilarChallanges=false", profile: false)
                return
            } else if self.tabBarController?.selectedIndex == trendsIndex {
                fetchChallenges(url: getExplorerChallengesURL + memberID + "&challengeId=" + challengIdForTrendAndExplorer! + "&addSimilarChallanges=true", profile: false)
                return
            } else if self.tabBarController?.selectedIndex == profileIndex {
                fetchChallenges(url: getChallengesOfMemberURL + memberID, profile: true)
                return
            } else if self.tabBarController?.selectedIndex == chanllengeIndex {
                fetchChallenges(url: getChallengesURL + memberID, profile: false)
                return
            }
        } else {
            if explorer {
                self.posts = ServiceLocator.getChallengesFromDummy(jsonFileName: "getTrendChallenges")
                return
            } else if self.tabBarController?.selectedIndex == trendsIndex {
                self.posts = ServiceLocator.getChallengesFromDummy(jsonFileName: "getTrendChallenges")
                return
            } else if self.tabBarController?.selectedIndex == profileIndex {
                self.donePosts = ServiceLocator.getOwnChallengesFromDummy(jsonFileName: "getOwnChallenges", done: true)
                self.notDonePosts = ServiceLocator.getOwnChallengesFromDummy(jsonFileName: "getOwnChallenges", done: false)
                self.posts = donePosts
                self.posts.append(contentsOf: notDonePosts)
                return
            } else if self.tabBarController?.selectedIndex == chanllengeIndex {
                self.posts = ServiceLocator.getChallengesFromDummy(jsonFileName: "getChallenges")
                return
            }
            self.collectionView?.reloadData()
        }
    }
    
    func fetchChallenges(url: String, profile : Bool) {
        URLSession.shared.dataTask(with: NSURL(string: url)! as URL, completionHandler: { (data, response, error) -> Void in
            if error == nil && data != nil {
                do {
                    if let postsArray = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [[String: AnyObject]] {
                        self.posts = [Post]()
                        self.donePosts = [Post]()
                        self.notDonePosts = [Post]()
                        for postDictionary in postsArray {
                            let post = ServiceLocator.mappingOfPost(postDictionary: postDictionary)
                            self.posts.append(post)
                            if profile {
                                if post.done == true {
                                    self.donePosts.append(post)
                                } else {
                                    self.notDonePosts.append(post)
                                }
                            }
                        }
                    }
                } catch let err {
                    print(err)
                }
            }
            DispatchQueue.main.async {
                self.collectionView?.reloadData()
            }
        }).resume()
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var reusableView : UICollectionReusableView? = nil
        if self.tabBarController?.selectedIndex == profileIndex && !explorer {
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
        if self.tabBarController?.selectedIndex == profileIndex && !explorer {
            if section == 0 {
                return CGSize(width: view.frame.width, height: 0)
            }
            return CGSize(width: view.frame.width, height: view.frame.width / 15)
        }
        return CGSize(width: 0, height: 0)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.tabBarController?.selectedIndex == profileIndex && !explorer  {
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
        if self.tabBarController?.selectedIndex == profileIndex && !explorer  {
            return 3
        }
        return 1
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //Correct the nav bar state unwinding from segues
        if self.tabBarController?.selectedIndex == chanllengeIndex || self.tabBarController?.selectedIndex == profileIndex {
            // self.navigationController?.setNavigationBarHidden(false, animated: true)
        }
        let indexPaths = collectionView?.indexPathsForVisibleItems
        DispatchQueue.main.async {
            for indexPath in indexPaths! {
                let cell = self.collectionView?.cellForItem(at: indexPath) as! FeedCell
                cell.avPlayerLayer.player?.play()
            }
            self.loadChallenges()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        DispatchQueue.main.async {
            let indexPaths = self.collectionView?.indexPathsForVisibleItems
            for indexPath in indexPaths! {
                let cell = self.collectionView?.cellForItem(at: indexPath) as! FeedCell
                if let player = cell.avPlayerLayer.player {
                    player.pause()
                }
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
    }
    
    func createProfile() -> ProfileCellView{
        let profileCell : ProfileCellView = ProfileCellView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width * 2.5 / 10))
        profileCell.other.addTarget(self, action: #selector(self.openOthers), for: UIControlEvents.touchUpInside)
        profileCell.followersCount.text = "\(countOffollowers)"
        let followersCountTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleFollowersCountTap))
        profileCell.followersCount.isUserInteractionEnabled = true
        profileCell.followersCount.addGestureRecognizer(followersCountTapGesture)
        let followersLabelTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleFollowersCountTap))
        profileCell.followersLabel.isUserInteractionEnabled = true
        profileCell.followersLabel.addGestureRecognizer(followersLabelTapGesture)
        profileCell.followingCount.text = "\(countOffollowing)"
        let followingCountTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleFollowingCountTap))
        profileCell.followingCount.isUserInteractionEnabled = true
        profileCell.followingCount.addGestureRecognizer(followingCountTapGesture)
        let followingLabelTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleFollowingCountTap))
        profileCell.followingLabel.isUserInteractionEnabled = true
        profileCell.followingLabel.addGestureRecognizer(followingLabelTapGesture)
        let challengeTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleChallengeCountTap))
        profileCell.challangeCount.isUserInteractionEnabled = true
        profileCell.challangeCount.addGestureRecognizer(challengeTapGesture)
        profileCell.challangeCount.text = "\(self.notDonePosts.count + self.donePosts.count)"
        return profileCell
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if self.tabBarController?.selectedIndex == profileIndex  && !self.explorer  {
            if indexPath.section == 0 && indexPath.row == 0 {
                let feedCellForProfile = collectionView.dequeueReusableCell(withReuseIdentifier: "profile", for: indexPath) as! FeedCell
                let profileCell = createProfile()
                feedCellForProfile.addSubview(profileCell)
                return feedCellForProfile
            }
            let feedCellForSelf = collectionView.dequeueReusableCell(withReuseIdentifier: "selfCellId", for: indexPath) as! FeedCell
            feedCellForSelf.prepareForReuse()
            feedCellForSelf.feedController = self
            if indexPath.section == 1 {
                feedCellForSelf.post = notDonePosts[indexPath.row]
                feedCellForSelf.updateProgress.type = notDonePosts[indexPath.row].type
                feedCellForSelf.updateProgress.challengeId = notDonePosts[indexPath.row].id
                feedCellForSelf.updateProgress.addTarget(self, action: #selector(self.updateProgress), for: UIControlEvents.touchUpInside)
            } else if indexPath.section == 2 {
                feedCellForSelf.post = donePosts[indexPath.row]
            }
            return feedCellForSelf
        }
        let feedCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! FeedCell
        feedCell.layer.shouldRasterize = true
        feedCell.layer.rasterizationScale = UIScreen.main.scale
        feedCell.prepareForReuse()
        feedCell.feedController = self
        feedCell.post = posts[indexPath.item]
        addTargetToFeedCell(feedCell: feedCell, indexPath: indexPath)
        DispatchQueue.main.async {
            self.avPlayer = AVPlayer.init()
            feedCell.avPlayerLayer.player = self.avPlayer
            if (feedCell.post?.proofed)! {
                /**
                var url : URL
                if feedCell.post?.secondTeamCount == "0" {
                    url = URL(string: "https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4")!;
                } else {
                    url = URL(string: "http://techslides.com/demos/sample-videos/small.mp4")!;
                }
                self.avPlayer.replaceCurrentItem(with: AVPlayerItem(url: url))
                self.avPlayer.volume = volume
                feedCell.avPlayerLayer.player = self.avPlayer
                feedCell.avPlayerLayer.player?.play()
                 */
                feedCell.proofedVideoView.alpha = 0
                feedCell.volumeUpImageView.alpha = 0
                feedCell.volumeDownImageView.alpha = 0
                feedCell.proofedMediaView.alpha = 1                
                self.getTrendImage(imageView: feedCell.proofedMediaView, challengeId: self.posts[indexPath.item].id!)
            }
        }
        return feedCell
    }
    
    func changeVolume(gesture: UITapGestureRecognizer) {
        DispatchQueue.main.async {
            let index = IndexPath(item: (gesture.view?.tag)!, section : 0)
            let feedCell = self.collectionView?.cellForItem(at: index) as! FeedCell
            self.changeVolumeOfFeedCell(feedCell: feedCell, isSilentRing: false, silentRingSwitch: 0)
        }
    }
    
    func changeVolumeOfFeedCell(feedCell : FeedCell, isSilentRing : Bool, silentRingSwitch : Int) {
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
    
    func changeVolumeUpDownView(feedCell : FeedCell, silentRingSwitch : Int) {
        if (feedCell.avPlayerLayer.player?.volume.isEqual(to: 1))! {
            feedCell.volumeUpImageView.alpha = 1
            feedCell.volumeDownImageView.alpha = 0
        } else {
            feedCell.volumeUpImageView.alpha = 0
            feedCell.volumeDownImageView.alpha = 1
        }
    }
    
    var avPlayer : AVPlayer = AVPlayer.init()
    
    func addTargetToFeedCell(feedCell: FeedCell, indexPath : IndexPath) {        
        if feedCell.post?.type == PUBLIC {
            feedCell.joinToChl.tag = indexPath.row
            feedCell.joinToChl.challengeId = posts[indexPath.item].id
            feedCell.joinToChl.addTarget(self, action: #selector(self.joinToChallenge), for: UIControlEvents.touchUpInside)
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
        feedCell.viewProofs.challengeId = posts[indexPath.item].id
        feedCell.addComments.challengeId = posts[indexPath.item].id
        feedCell.addProofs.challengeId = posts[indexPath.item].id
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
    }
    
    func deleteChallenge(_ sender: subclasssedUIButton) {
        URLSession.shared.dataTask(with: NSURL(string: deleteChallengeURL + sender.challengeId!)! as URL, completionHandler: { (data, response, error) -> Void in
            if error == nil && data != nil {
            }
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
        }).resume()
    }
    
    func handleChallengeCountTap(sender:UILabel){
        let firstChlRow = IndexPath(item: 0, section: 1)
        collectionView?.scrollToItem(at: firstChlRow, at: .top, animated: true)
    }
    
    func handleFollowersCountTap(sender:UILabel){
        let selectionTable = SelectionTableViewController()
        selectionTable.tableTitle = "Followers"
        selectionTable.listMode = true
        selectionTable.isFollower = true
        selectionTable.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(selectionTable, animated: true)
    }
    
    func handleFollowingCountTap(sender:UILabel){
        let selectionTable = SelectionTableViewController()
        selectionTable.tableTitle = "Following"
        selectionTable.listMode = true
        selectionTable.isFollowing = true
        selectionTable.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(selectionTable, animated: true)
    }
    
    func updateProgress(_ sender: subclasssedUIButton) {
        let updateProgress = UpdateProgressController()
        updateProgress.updateProgress = true
        updateProgress.challengeId = sender.challengeId
        updateProgress.challengeType = sender.type
        updateProgress.hidesBottomBarWhenPushed = true
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.pushViewController(updateProgress, animated: true)
    }
    
    func openOthers(sender: UIButton) {
        let other = OtherController()
        other.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(other, animated: true)
    }
    
    func addComments(sender: subclasssedUIButton) {
        let commentsTable = CommentTableViewController()        
        commentsTable.tableTitle = commentsTableTitle
        // TODO commentsTable.comments = self.comments
        commentsTable.challengeId = sender.challengeId
        commentsTable.textView.becomeFirstResponder()
        commentsTable.hidesBottomBarWhenPushed = true
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.pushViewController(commentsTable, animated: true)
    }
    
    func viewComments(sender: subclasssedUIButton) {
        let commentsTable = CommentTableViewController()
        commentsTable.tableTitle = commentsTableTitle
        // TODO commentsTable.comments = self.comments
        commentsTable.challengeId = sender.challengeId
        commentsTable.hidesBottomBarWhenPushed = true
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.pushViewController(commentsTable, animated: true)
    }
    
    func addProofs(sender: subclasssedUIButton) {
        let commentsTable = ProofTableViewController()
        commentsTable.tableTitle = proofsTableTitle
        commentsTable.challengeId = sender.challengeId
        commentsTable.hidesBottomBarWhenPushed = true
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.pushViewController(commentsTable, animated: true)
    }
    
    func viewProofs(sender: subclasssedUIButton) {
        let commentsTable = ProofTableViewController()
        commentsTable.tableTitle = proofsTableTitle
        commentsTable.challengeId = sender.challengeId
        commentsTable.hidesBottomBarWhenPushed = true
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.pushViewController(commentsTable, animated: true)
    }
    
    func supportChallenge(sender: subclasssedUIButton) {
        let index = IndexPath(item: sender.tag, section: 0)
        let feedCell = collectionView?.cellForItem(at: index) as! FeedCell
        let currentImage = sender.currentImage
        if currentImage == UIImage(named:support) {
            sender.setImage(UIImage(named: supported), for: .normal)
            if feedCell.supportButtonMatch.currentImage == UIImage(named: supported) {
                feedCell.supportButtonMatch.setImage(UIImage(named:support), for: .normal)
                feedCell.supportMatchLabel.text = "+\(feedCell.supportMatchLabel.tag + (-1))"
                feedCell.supportMatchLabel.tag = Int(feedCell.supportMatchLabel.tag + (-1))
            }
            supportChallengeService(support: true, challengeId: sender.challengeId!, feedCell: feedCell, isHome: true)
        } else {
            sender.setImage(UIImage(named: support), for: .normal)
            supportChallengeService(support: false, challengeId: sender.challengeId!, feedCell: feedCell, isHome: true)
        }
    }
    
    func supportChallengeService(support:Bool, challengeId: String, feedCell: FeedCell, isHome: Bool) {
        var json: [String: Any] = ["challengeId": challengeId,
                                   "memberId": memberID
        ]
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
                        feedCell.supportLabel.text = "+\(feedCell.supportLabel.tag + (support ? 1 : -1))"
                        feedCell.supportLabel.tag = Int(feedCell.supportLabel.tag + (support ? 1 : -1))
                    } else {
                        feedCell.supportMatchLabel.text = "+\(feedCell.supportMatchLabel.tag + (support ? 1 : -1))"
                        feedCell.supportMatchLabel.tag = Int(feedCell.supportMatchLabel.tag + (support ? 1 : -1))
                    }
                }
            }
        }).resume()
    }
    
    func supportChallengeMatch(sender: subclasssedUIButton) {
        let index = IndexPath(item: sender.tag, section: 0)
        let feedCell = collectionView?.cellForItem(at: index) as! FeedCell
        let currentImage = sender.currentImage
        if currentImage == UIImage(named: support) {
            sender.setImage(UIImage(named: supported), for: .normal)
            if feedCell.supportButton.currentImage == UIImage(named: supported) {
                feedCell.supportButton.setImage(UIImage(named:support), for: .normal)
                feedCell.supportLabel.text = "+\(feedCell.supportLabel.tag + (-1))"
                feedCell.supportLabel.tag = Int(feedCell.supportLabel.tag + (-1))
            }
            supportChallengeService(support: true, challengeId: sender.challengeId!, feedCell: feedCell, isHome: false)
        } else {
            sender.setImage(UIImage(named: support), for: .normal)
            supportChallengeService(support: false, challengeId: sender.challengeId!, feedCell: feedCell, isHome: false)
        }
    }
    
    func joinToChallenge(sender: subclasssedUIButton) {
        let index = IndexPath(item: sender.tag, section: 0)
        let feedCell = collectionView?.cellForItem(at: index) as! FeedCell
        let currentImage = feedCell.joinButton.currentImage
        if currentImage == UIImage(named: acceptedRed) {
            feedCell.joinButton.setImage(UIImage(named: acceptedBlack), for: .normal)
        } else {
            feedCell.joinButton.setImage(UIImage(named: acceptedRed), for: .normal)
            joinToChallengeService(challengeId: sender.challengeId!, feedCell: feedCell)
        }
    }
    
    func joinToChallengeService(challengeId: String, feedCell: FeedCell) {
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

    let screenSize = UIScreen.main.bounds
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if self.tabBarController?.selectedIndex == profileIndex && !explorer {
            if indexPath.row == 0 && indexPath.section == 0 {
                return CGSize(width: view.frame.width, height: screenSize.width * 2.5 / 10)
            }
        }
        var knownHeight: CGFloat = (screenSize.width / 2) + (screenSize.width / 15) + (screenSize.width / 26)
        if posts[indexPath.item].isComeFromSelf == false {
            knownHeight += (screenSize.width / 26) + (screenSize.width / 5) + (screenWidth * 0.575 / 10)
            if posts[indexPath.item].proofed == true {
                knownHeight += screenWidth / 2
            }
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
    
    let zoomImageView = UIImageView()
    let blackBackgroundView = UIView()
    let navBarCoverView = UIView()
    let tabBarCoverView = UIView()
    
    var statusImageView: UIImageView?
    
    func animateImageView(_ statusImageView: UIImageView) {
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
    
    func zoomOut() {
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
    
    var lastContentOffSet : CGFloat = 0
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if explorer {
            return
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
        if self.tabBarController?.selectedIndex == profileIndex  && !explorer {
            openExplorer(challengeId: posts[indexPath.row].id!)
        }
    }
    
    func openExplorer(challengeId: String) {
        let challengeController = FeedController(collectionViewLayout: UICollectionViewFlowLayout())
        challengeController.navigationItem.title = "Explorer"
        challengeController.explorer = true
        challengeController.challengIdForTrendAndExplorer = challengeId
        challengeController.hidesBottomBarWhenPushed = true
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.pushViewController(challengeController, animated: true)
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
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "FRIEND REQUESTS"
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = UIColor(white: 0.4, alpha: 1)
        return label
    }()
    
    let bottomBorderView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(229, green: 231, blue: 235)
        return view
    }()
    
    func setupViews() {
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
