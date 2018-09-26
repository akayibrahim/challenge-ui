//
//  OtherControllers.swift
//  facebookfeed2
//
//  Created by Brian Voong on 2/27/16.
//  Copyright © 2016 letsbuildthatapp. All rights reserved.
//

import UIKit

class ActivitiesController: UITableViewController {
    @objc let cellId = "cellId"
    @objc let followCellId = "followCellId"
    @objc var activities = [Activities]()
    @objc var challengeRequestCount: Int = 0
    @objc var followerRequestCount: Int = 0
    @objc let group = DispatchGroup()
    @objc var currentPage : Int = 0
    @objc var nowMoreData: Bool = false
    @objc var goForward: Bool = false
    @objc var newFriendSuggestionCount: Int = 0
    @objc var challengeApproveCount: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Activities"
        tableView.register(ActivityCell.self, forCellReuseIdentifier: cellId)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: followCellId)
        tableView.tableFooterView = UIView()
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.sectionHeaderHeight = 0
        tableView?.showsVerticalScrollIndicator = false
        
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(self.onRefesh), for: UIControlEvents.valueChanged)
        tableView?.addSubview(refreshControl!)
        
        self.reloadPage()
    }

    @objc func getActivityCount() {
        let jsonURL = URL(string: getActivityCountURL + memberID + "&delete=true")!
        jsonURL.get { data, response, error in
            guard
                data != nil
                else {
                    if data != nil {
                        ServiceLocator.logErrorMessage(data: data!, chlId: "", sUrl: getActivityCountURL, inputs: "memberID=\(memberID)")
                    }
                    return
            }
            DispatchQueue.main.async {
                self.navigationController?.tabBarController?.tabBar.items?[3].badgeValue = nil
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if goForward {
            self.challengeRequestCount = 0
            self.reloadPage()
            goForward = false
        }
        self.playVisibleVideo()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let indexPaths = self.tableView.indexPathsForVisibleRows
        for indexPath in indexPaths! {
            if indexPath.section > 3 {
                let cell = self.tableView?.cellForRow(at: indexPath) as! ActivityCell
                if let player = cell.avPlayerLayer.player {
                    player.pause()
                }
            }
        }
    }
    
    @objc func onRefesh() {
        if (refreshControl?.isRefreshing)! {
            self.reloadPage()
            refreshControl?.endRefreshing()
        }
    }

    @objc func reloadPage() {
        if dummyServiceCall == false && Util.controlNetwork(){
            return
        }
        currentPage = 0
        fetchChallengeRequest()
        fetchEwFriendSuggestions(url: getSuggestionsForFollowingURL)
        fetchFollowerRequest()
        fetchChallengeApproves(url: getChallengeApprovesURL)
        self.group.wait()
        self.activities = [Activities]()
        if (refreshControl?.isRefreshing)! || goForward {
            self.tableView.reloadData()
        }
        self.tableView.showBlurLoader()
        self.loadActivities()
    }
    
    @objc func loadActivities() {
        if dummyServiceCall == false {
            if Util.controlNetwork() {
                return
            }
            fetchActivities()
            getActivityCount()
            return
        } else {
            self.activities = ServiceLocator.getActivitiesFromDummy(jsonFileName: "activities")
            return
        }
    }
    
    @objc func fetchChallengeApproves(url: String) {
        group.enter()
        URLSession.shared.dataTask(with: NSURL(string: url + memberID)! as URL, completionHandler: { (data, response, error) -> Void in
            if error == nil && data != nil {
                do {
                    if let postsArray = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [[String: AnyObject]] {
                        self.challengeApproveCount = postsArray.count
                    }
                    self.group.leave()
                } catch let err {
                    print(err)
                }
            }
        }).resume()
    }
    
    @objc func fetchEwFriendSuggestions(url: String) {
        group.enter()
        let jsonURL = URL(string: url + memberID)!
        jsonURL.get { data, response, error in
            guard
                let returnData = data,
                let postsArray = try? JSONSerialization.jsonObject(with: returnData, options: .mutableContainers) as? [[String: AnyObject]]
                else {
                    self.popupAlert(message: ServiceLocator.getErrorMessage(data: data!, chlId: "", sUrl: url, inputs: "memberId=\(memberID)"), willDelay: false)
                    return
            }
            self.newFriendSuggestionCount = postsArray != nil ? (postsArray?.count)! : 0
            self.group.leave()
        }
    }
    
    lazy var cellSizes: [IndexPath: CGFloat?] = [:]
    var isFetchingNextPage: Bool = false
    @objc func fetchActivities() {
        self.isFetchingNextPage = true
        DispatchQueue.global(qos: .userInitiated).async {
            let jsonURL = URL(string: getActivitiesURL + memberID + "&page=\(self.currentPage)")!
            jsonURL.get { data, response, error in
                guard
                    let returnData = data
                    else {
                        if data != nil {
                            self.popupAlert(message: ServiceLocator.getErrorMessage(data: data!, chlId: "", sUrl: getActivitiesURL, inputs: "memberID=\(memberID)"), willDelay: false)
                        }
                        return
                }
                
                    if let postsArray = try? JSONSerialization.jsonObject(with: returnData, options: .mutableContainers) as? [[String: AnyObject]] {
                    self.nowMoreData = postsArray?.count == 0 ? true : false
                    if let postsArray = postsArray {
                        var indexPaths = [IndexPath]()
                        for postDictionary in postsArray {
                            let activity = Activities()
                            activity.setValuesForKeys(postDictionary)
                            activity.provedWithImage = postDictionary["provedWithImage"] as? Bool
                            self.activities.append(activity)
                            let iPath = IndexPath(row:self.activities.count - 1, section: 4)
                            indexPaths.append(iPath)
                            DispatchQueue.main.async {
                                self.cellSizes[iPath] = self.calculateCellSize(iPath)
                            }
                            //self.insertItem(self.activities.count - 1, section: 2)
                        }
                        DispatchQueue.main.async {
                            self.tableView.removeBluerLoader()
                            self.tableView.tableFooterView = UIView()
                            self.tableView?.insertRows(at: indexPaths, with: .fade)
                            self.isFetchingNextPage = false
                        }
                    }
                }
            }
        }
    }
    
    func calculateCellSize(_ indexPath: IndexPath) -> CGFloat {
        if (indexPath.section != 4) && indexPath.row == 0 {
            return UIScreen.main.bounds.width * 1.2 / 10
        }
        if activities.count != 0 {
            if  let thinksAboutChallenge = activities[indexPath.row].content {
                let rect = NSString(string: thinksAboutChallenge).boundingRect(with: CGSize(width: activities[indexPath.row].type == "PROOF" ? view.frame.width * 7.6 / 10 : view.frame.width * 9.1 / 10, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14)], context: nil)
                return rect.height + heighForRow
            }
        }
        return heighForRow
    }
    
    func insertItem(_ row:Int, section: Int) {
        let indexPath = IndexPath(row:row, section: section)
        self.tableView.insertRows(at: [indexPath], with: .fade)
    }
        
    @objc func fetchChallengeRequest() {
        group.enter()
        let jsonURL = URL(string: getChallengeRequestURL + memberID)!
        jsonURL.get { data, response, error in
            guard
                let returnData = data,
                let postsArray = try? JSONSerialization.jsonObject(with: returnData, options: .mutableContainers) as? [[String: AnyObject]]
                else {
                    if data != nil {
                        self.popupAlert(message: ServiceLocator.getErrorMessage(data: data!, chlId: "", sUrl: getActivitiesURL, inputs: "memberID=\(memberID)"), willDelay: false)
                    }
                    return
            }
            self.challengeRequestCount = postsArray != nil ? (postsArray?.count)! : 0
            self.group.leave()
        }
    }
    
    @objc func fetchFollowerRequest() {
        group.enter()
        let jsonURL = URL(string: getFollowerRequestsURL + memberID)!
        jsonURL.get { data, response, error in
            guard
                let returnData = data,
                let postsArray = try? JSONSerialization.jsonObject(with: returnData, options: .mutableContainers) as? [[String: AnyObject]]
                else {
                    if data != nil {
                        self.popupAlert(message: ServiceLocator.getErrorMessage(data: data!, chlId: "", sUrl: getActivitiesURL, inputs: "memberID=\(memberID)"), willDelay: false)
                    }
                    return
            }
            self.followerRequestCount = postsArray != nil ? (postsArray?.count)! : 0
            self.group.leave()
        }
    }
    
    let spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let checkPoint = activities.count > 15 ? activities.count - 15 : 0
        let shouldLoadMore = indexPath.row >= checkPoint
        if shouldLoadMore && !nowMoreData && !dummyServiceCall && !isFetchingNextPage {
            currentPage += 1
            self.loadActivities()
            let lastSectionIndex = tableView.numberOfSections - 1
            let lastRowIndex = tableView.numberOfRows(inSection: lastSectionIndex) - 1
            if indexPath.section ==  lastSectionIndex && indexPath.row == lastRowIndex {
                // print("this is the last cell")
                spinner.startAnimating()
                spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))
                self.tableView.tableFooterView = spinner
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        if section == 1 {
            return challengeRequestCount != 0 ? 1 : 0
        }
        if section == 2 {
            return followerRequestCount != 0 ? 1 : 0
        }
        if section == 3 {
            return challengeApproveCount != 0 ? 1 : 0
        }
        return activities.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 && indexPath.row == 0 {
            let cell =  tableView.dequeueReusableCell(withIdentifier: followCellId, for: indexPath)
            let attributeText = NSMutableAttributedString(string: "Find Friends   ", attributes: nil)
            if newFriendSuggestionCount != 0 {
                let newSuggestionCountText = NSMutableAttributedString(string: "\u{2022} \(newFriendSuggestionCount) ", attributes: nil)
                attributeText.append(newSuggestionCountText)
            }
            attributeText.append(greaterThan)
            cell.textLabel?.attributedText = attributeText
            return cell
        } else if indexPath.section == 1 && indexPath.row == 0 {
            let cell =  tableView.dequeueReusableCell(withIdentifier: followCellId, for: indexPath)
            let attributeText = NSMutableAttributedString(string: "Challenge Requests    ", attributes: nil)
            if challengeRequestCount != 0 {
                let challengeRequestCountText = NSMutableAttributedString(string: "\u{2022} \(challengeRequestCount) ", attributes: nil)
                attributeText.append(challengeRequestCountText)
            }
            attributeText.append(greaterThan)
            cell.textLabel?.attributedText = attributeText
            return cell
        } else if indexPath.section == 2 && indexPath.row == 0 {
            let cell =  tableView.dequeueReusableCell(withIdentifier: followCellId, for: indexPath)
            let attributeText = NSMutableAttributedString(string: "Follower Requests    ", attributes: nil)
            if followerRequestCount != 0 {
                let followerRequestCountText = NSMutableAttributedString(string: "\u{2022} \(followerRequestCount) ", attributes: nil)
                attributeText.append(followerRequestCountText)
            }
            attributeText.append(greaterThan)
            cell.textLabel?.attributedText = attributeText
            return cell
        } else if indexPath.section == 3 && indexPath.row == 0 {
            let cell =  tableView.dequeueReusableCell(withIdentifier: followCellId, for: indexPath)
            let attributeText = NSMutableAttributedString(string: "Challenge Approves    ", attributes: nil)
            if challengeApproveCount != 0 {
                let followerRequestCountText = NSMutableAttributedString(string: "\u{2022} \(challengeApproveCount) ", attributes: nil)
                attributeText.append(followerRequestCountText)
            }
            attributeText.append(greaterThan)
            cell.textLabel?.attributedText = attributeText
            return cell
        } else if indexPath.section == 4 {
            let cell =  tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ActivityCell
            cell.layer.shouldRasterize = true
            cell.layer.rasterizationScale = UIScreen.main.scale
            if activities.count == 0 {
                return cell
            }
            DispatchQueue.main.async {
                cell.activity = self.activities[indexPath.row]
                
                let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.profileImageTapped(tapGestureRecognizer:)))
                cell.profileImageView.tag = indexPath.row
                cell.profileImageView.isUserInteractionEnabled = true
                cell.profileImageView.addGestureRecognizer(tapGestureRecognizer)
                
                let tapGestureRecognizerName = UITapGestureRecognizer(target: self, action: #selector(self.profileImageTappedName(tapGestureRecognizer:)))
                cell.contentText.tag = indexPath.row
                cell.contentText.isUserInteractionEnabled = true
                cell.contentText.addGestureRecognizer(tapGestureRecognizerName)
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            return cell
        }
        return UITableViewCell()
    }
    
    @objc func profileImageTappedName(tapGestureRecognizer: UITapGestureRecognizer) {
        let textview = tapGestureRecognizer.view as! UITextView
        let textRange = NSMakeRange(0, (activities[textview.tag].name?.count)!)
        if tapGestureRecognizer.didTapAttributedTextInTextView(label: textview, inRange: textRange) {
            openProfile(name: activities[textview.tag].name!, memberId: activities[textview.tag].fromMemberId!, memberFbId: activities[textview.tag].facebookID!)
        } else {
            openBackgroundOfActivity(indexPath: IndexPath(item: textview.tag, section: 0))
        }
    }
    
    @objc func profileImageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        openProfile(name: activities[tappedImage.tag].name!, memberId: activities[tappedImage.tag].fromMemberId!, memberFbId: activities[tappedImage.tag].facebookID!)
    }
    
    @objc let heighForRow : CGFloat = UIScreen.main.bounds.width * 1 / 10
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let size = cellSizes[indexPath] {
            return size!
        }
        return calculateCellSize(indexPath)
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        /*
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerId) as! RequestHeader
        header.nameLabel.text = "PEOPLE YOU MAY KNOW"
        return header
        */
        return nil
    }
    
    @objc var lastContentOffSet : CGFloat = 0
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 0 {
            followRequest()
        } else if indexPath.section == 1 && indexPath.row == 0 {
            challengeRequest()
        } else if indexPath.section == 2 && indexPath.row == 0 {
            followerRequest()
        } else if indexPath.section == 3 && indexPath.row == 0 {
            challengeApprove()
        } else {
            openBackgroundOfActivity(indexPath: indexPath)
        }
    }
    
    @objc func openBackgroundOfActivity(indexPath: IndexPath) {
        let type = activities[indexPath.row].type
        if type == comment {
            viewComments(challengeId: activities[indexPath.row].challengeId!)
        } else if type == proof {
            openExplorer(challengeId: activities[indexPath.row].challengeId!)
        } else if type == supportType {
            openExplorer(challengeId: activities[indexPath.row].challengeId!)
        } else if type == join {
            openExplorer(challengeId: activities[indexPath.row].challengeId!)
        } else if type == accept {
            openExplorer(challengeId: activities[indexPath.row].challengeId!)
        } else if type == following {
            // nothing
        } else if type == follower {
            // nothing
        } else if type == "CHALLENGE_APPROVE" {
            openExplorer(challengeId: activities[indexPath.row].challengeId!)
        }
    }
    
    @objc func openExplorer(challengeId: String) {
        let challengeController = FeedController(collectionViewLayout: UICollectionViewFlowLayout())
        challengeController.navigationItem.title = "Explorer"
        challengeController.explorer = true
        challengeController.explorerCurrentPage = 0
        challengeController.challengIdForTrendAndExplorer = challengeId
        challengeController.selectedTabIndex = self.tabBarController?.selectedIndex ?? 0
        challengeController.reloadChlPage()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.pushViewController(challengeController, animated: true)
    }
    
    @objc func viewComments(challengeId: String) {
        let commentsTable = CommentTableViewController()
        commentsTable.tableTitle = commentsTableTitle
        // TODO commentsTable.comments = self.comments        
        commentsTable.challengeId = challengeId
        commentsTable.hidesBottomBarWhenPushed = true
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.pushViewController(commentsTable, animated: true)
    }
    
    @objc func viewProofs(challengeId: String) {
        let proofsTable = ProofTableViewController()
        proofsTable.tableTitle = proofsTableTitle
        // TODO commentsTable.comments = self.comments
        proofsTable.challengeId = challengeId
        proofsTable.canJoin = false
        proofsTable.proofed = true
        proofsTable.hidesBottomBarWhenPushed = true
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.pushViewController(proofsTable, animated: true)
    }
    
    @objc func followRequest() {
        let followRequest = FollowRequestController()
        followRequest.hidesBottomBarWhenPushed = true
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.pushViewController(followRequest, animated: true)
    }
    
    @objc func challengeRequest() {
        let challengeRequest = ChallengeRequestController()
        goForward = true
        challengeRequest.hidesBottomBarWhenPushed = true
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.pushViewController(challengeRequest, animated: true)
    }
    
    @objc func followerRequest() {
        let followerRequest = FollowerRequestController()
        goForward = true
        followerRequest.hidesBottomBarWhenPushed = true
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.pushViewController(followerRequest, animated: true)
    }
    
    @objc func challengeApprove() {
        let challengeApproveCont = ChallengeResultApproveController()
        goForward = true
        challengeApproveCont.hidesBottomBarWhenPushed = true
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.pushViewController(challengeApproveCont, animated: true)
    }
    
    @objc func openProfile(name: String, memberId: String, memberFbId:String) {
        let profileController = FeedController(collectionViewLayout: UICollectionViewFlowLayout())
        getMemberInfo(memberId: memberId)
        group.wait()
        profileController.navigationItem.title = name
        profileController.memberIdForFriendProfile = memberId
        profileController.memberNameForFriendProfile = name
        profileController.memberFbIdForFriendProfile = memberFbId
        profileController.memberCountOfFollowerForFriendProfile = countOfFollowersForFriend
        profileController.memberCountOfFollowingForFriendProfile = countOfFollowingForFriend
        profileController.memberIsPrivateForFriendProfile = friendIsPrivate
        profileController.profile = true
        profileController.isProfileFriend = false
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.pushViewController(profileController, animated: true)
    }
    
    @objc var countOfFollowersForFriend = 0
    @objc var countOfFollowingForFriend = 0
    @objc var friendIsPrivate = false
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
    
    func playVisibleVideo() {
        for visIndex in (self.tableView.indexPathsForVisibleRows)! {
            if visIndex.section > 3 {
                if let cell = tableView?.cellForRow(at: visIndex) {
                    let feedCell = cell as! ActivityCell
                    if let player = feedCell.avPlayerLayer.player {
                        player.playImmediately(atRate: 1.0)
                    }
                }
            }
        }
    }
}
