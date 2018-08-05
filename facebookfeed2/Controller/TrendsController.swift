//
//  OtherControllers.swift
//  facebookfeed2
//
//  Created by Brian Voong on 2/27/16.
//  Copyright © 2016 letsbuildthatapp. All rights reserved.
//

import UIKit
import AVKit

class TrendsController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    let searchBar = UISearchBar()
    var trendRequest = [TrendRequest]()
    let cellId = "cellId"
    var refreshControl : UIRefreshControl!
    var currentPage : Int = 0
    var nowMoreData: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor =  UIColor.rgb(229, green: 231, blue: 235)
        searchBar.placeholder = "Search"
        searchBar.delegate = self
        searchBar.autocapitalizationType = UITextAutocapitalizationType.allCharacters
        
        self.navigationItem.titleView = searchBar
        collectionView!.register(TrendRequestCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.backgroundColor = UIColor(white: 0.95, alpha: 1)
        collectionView?.alwaysBounceVertical = true
        collectionView?.showsVerticalScrollIndicator = false

        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.onRefesh), for: UIControlEvents.valueChanged)
        collectionView?.addSubview(refreshControl)
        
        reloadPage()
        
        self.hideKeyboardWhenTappedAround()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBarCancelButton()
        onRefesh()
    }
    
    func searchBarCancelButton() {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked( _ searchBar: UISearchBar) {
        if dummyServiceCall == false {
            currentPage = 0
            self.trendRequest = [TrendRequest]()
            fetchTrendChallenges(key: searchBar.text!)
            return
        } else {
            searchDummy()
            return
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
    }
    
    func searchDummy() {
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
    }
    
    func onRefesh() {
        self.reloadPage()
        self.collectionView?.reloadData()
        refreshControl.endRefreshing()
    }
    
    func reloadPage() {
        currentPage = 0
        self.trendRequest = [TrendRequest]()
        self.loadTrends()
    }
    
    func loadTrends() {
        if dummyServiceCall == false {
            self.fetchTrendChallenges(key: "")
            return
        } else {
            self.trendRequest = ServiceLocator.getTrendChallengesFromDummy(jsonFileName: "trend_request")
            return
        }
    }
    
    func fetchTrendChallenges(key: String) {
        let urlStr = getTrendChallengesURL + memberID + "&subjectSearchKey=" + key + "&page=\(currentPage)"
        let urlStrWithPerm = urlStr.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        let url = NSURL(string: urlStrWithPerm!)!
        URLSession.shared.dataTask(with: url as URL, completionHandler: { (data, response, error) -> Void in
            if error == nil && data != nil {
                    do {
                        if let postsArray = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [[String: AnyObject]] {
                            self.nowMoreData = postsArray.count == 0 ? true : false
                            for postDictionary in postsArray {
                                let trend = TrendRequest()
                                trend.provedWithImage = postDictionary["provedWithImage"] as? Bool
                                trend.setValuesForKeys(postDictionary)
                                self.trendRequest.append(trend)
                                if trend.provedWithImage! {
                                    let url = URL(string: downloadImageURL + "?challengeId=\(trend.challengeId!)&memberId=\(trend.challengerId!)")
                                    ImageService.cacheImage(withURL: url!)
                                } else {
                                    let url = URL(string: downloadVideoURL + "?challengeId=\(trend.challengeId!)&memberId=\(trend.challengerId!)")
                                    VideoService.cacheImage(withURL: url!)
                                }
                            }
                            DispatchQueue.main.async {
                                self.collectionView?.reloadData()
                            }
                        }
                    } catch let err {
                        print(err)
                    }
            }
        }).resume()
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let checkPoint = trendRequest.count - 1
        let shouldLoadMore = checkPoint == indexPath.row
        if shouldLoadMore && !nowMoreData && !dummyServiceCall {
            currentPage += 1
            self.loadTrends()
        }
    }
    
    var downImage: UIImage?
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width, height: self.view.frame.width * 1.3 / 2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! TrendRequestCell
        cell.trendRequest = self.trendRequest[indexPath.row]
        if self.trendRequest[indexPath.row].provedWithImage! {
            //self.group.enter()
            getTrendImage(challengeId: self.trendRequest[indexPath.row].challengeId!, challengerId: self.trendRequest[indexPath.row].challengerId!)  {
                image in
                if image != nil {
                    cell.requestImageView.image = image
                    //self.group.leave()
                }
            }
            //self.group.wait()
        } else {
            // var video: Data?
            //self.group.enter()
            let params = "?challengeId=\(self.trendRequest[indexPath.row].challengeId!)&memberId=\(self.trendRequest[indexPath.row].challengerId!)"
            // let urlV = URL(string: downloadVideoURL + params)
            self.getVideo(challengeId: self.trendRequest[indexPath.item].challengeId!, challengerId: self.trendRequest[indexPath.item].challengerId!) {
                video in
                if let vid = video {
                    let url = vid.write(name: "\(params).mov")
                    let avPlayer = AVPlayer.init()
                    avPlayer.replaceCurrentItem(with: AVPlayerItem.init(url: url))
                    avPlayer.volume = volume
                    cell.avPlayerLayer.player = avPlayer
                    cell.avPlayerLayer.player?.play()
                    //self.group.leave()
                }
            }
            //self.group.wait()
            //let url = URL(fileURLWithPath:  + ".mov")
            cell.proofedVideoView.alpha = 1
            cell.volumeUpImageView.alpha = 0
            cell.volumeDownImageView.alpha = 1
        }
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.profileImageTapped(tapGestureRecognizer:)))
        cell.profileImageView.tag = indexPath.row
        cell.profileImageView.isUserInteractionEnabled = true
        cell.profileImageView.addGestureRecognizer(tapGestureRecognizer)
        let tapGestureRecognizerName = UITapGestureRecognizer(target: self, action: #selector(self.profileImageTappedName(tapGestureRecognizer:)))
        cell.nameLabel.tag = indexPath.row
        cell.nameLabel.isUserInteractionEnabled = true
        cell.nameLabel.addGestureRecognizer(tapGestureRecognizerName)
        return cell
    }
    
    // var avPlayer : AVPlayer = AVPlayer.init()

    func profileImageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        openProfile(name: trendRequest[tappedImage.tag].name!, memberId: trendRequest[tappedImage.tag].challengerId!, memberFbId: trendRequest[tappedImage.tag].prooferFbID!)
    }

    func profileImageTappedName(tapGestureRecognizer: UITapGestureRecognizer) {
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
    
    func openExplorer(challengeId: String) {
        let challengeController = FeedController(collectionViewLayout: UICollectionViewFlowLayout())
        challengeController.navigationItem.title = "Explorer"
        challengeController.hidesBottomBarWhenPushed = true
        challengeController.challengIdForTrendAndExplorer = challengeId
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.pushViewController(challengeController, animated: true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return trendRequest.count
    }
    
    var lastContentOffSet : CGFloat = 0
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (scrollView.contentOffset.y >= 0 && self.lastContentOffSet < scrollView.contentOffset.y) || (scrollView.contentOffset.y > 0 && scrollView.isAtBottom) {
            // move down
            if let status = UIApplication.shared.value(forKey: "statusBar") as? UIView {
                status.backgroundColor = navAndTabColor
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
    }
    
    func openProfile(name: String, memberId: String, memberFbId:String) {
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
    
    var countOfFollowersForFriend = 0
    var countOfFollowingForFriend = 0
    var friendIsPrivate = false
    let group = DispatchGroup()
    func getMemberInfo(memberId: String) {
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
    
    var isProfileFriend = false
    func isMyFriend(friendMemberId: String) {
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
}
