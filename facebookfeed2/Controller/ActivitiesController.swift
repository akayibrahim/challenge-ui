//
//  OtherControllers.swift
//  facebookfeed2
//
//  Created by Brian Voong on 2/27/16.
//  Copyright © 2016 letsbuildthatapp. All rights reserved.
//

import UIKit

class ActivitiesController: UITableViewController {
    let cellId = "cellId"
    let followCellId = "followCellId"
    var activities = [Activities]()
    
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
        
        loadActivities()
    }

    func onRefesh() {
        self.loadActivities()
        self.tableView?.reloadData()
        refreshControl?.endRefreshing()
    }

    func loadActivities() {
        if dummyServiceCall == false {
            fetchActivities()
            return
        } else {
            self.activities = ServiceLocator.getActivitiesFromDummy(jsonFileName: "activities")
            return
        }
    }

    func fetchActivities() {
        URLSession.shared.dataTask(with: NSURL(string: getActivitiesURL + memberID)! as URL, completionHandler: { (data, response, error) -> Void in
            if error == nil && data != nil {
                do {
                    if let postsArray = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [[String: AnyObject]] {
                        self.activities = [Activities]()
                        for postDictionary in postsArray {
                            let activity = Activities()
                            activity.setValuesForKeys(postDictionary)
                            self.activities.append(activity)
                        }
                    }
                } catch let err {
                    print(err)
                }
            }
            DispatchQueue.main.async {
                self.tableView?.reloadData()
            }
        }).resume()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 || section == 1 {
            return 1
        }
        return activities.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 && indexPath.row == 0 {
            let cell =  tableView.dequeueReusableCell(withIdentifier: followCellId, for: indexPath)
            let attributeText = NSMutableAttributedString(string: "Find Friends   ", attributes: nil)
            attributeText.append(greaterThan)
            cell.textLabel?.attributedText = attributeText
            return cell
        } else if indexPath.section == 1 && indexPath.row == 0 {
            let cell =  tableView.dequeueReusableCell(withIdentifier: followCellId, for: indexPath)
            let attributeText = NSMutableAttributedString(string: "Challenge Requests   ", attributes: nil)
            attributeText.append(greaterThan)
            cell.textLabel?.attributedText = attributeText
            return cell
        } else if indexPath.section == 2 {
            let cell =  tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ActivityCell
            cell.activity = activities[indexPath.row]
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(profileImageTapped(tapGestureRecognizer:)))
            cell.profileImageView.tag = indexPath.row
            cell.profileImageView.isUserInteractionEnabled = true
            cell.profileImageView.addGestureRecognizer(tapGestureRecognizer)
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            return cell
        }
        return UITableViewCell()
    }
    
    func profileImageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        openProfile(name: activities[tappedImage.tag].name!, memberId: activities[tappedImage.tag].fromMemberId!, memberFbId: activities[tappedImage.tag].facebookID!)
    }
    
    let heighForRow : CGFloat = UIScreen.main.bounds.width * 1 / 10
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.section == 0 || indexPath.section == 1) && indexPath.row == 0 {
            return UIScreen.main.bounds.width * 1.2 / 10
        }
        if let thinksAboutChallenge = activities[indexPath.row].content {
            let rect = NSString(string: thinksAboutChallenge).boundingRect(with: CGSize(width: view.frame.width, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14)], context: nil)
            return rect.height + heighForRow
        }
        return heighForRow
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        /*
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerId) as! RequestHeader
        header.nameLabel.text = "PEOPLE YOU MAY KNOW"
        return header
        */
        return nil
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 0 {
            followRequest()
        } else if indexPath.section == 1 && indexPath.row == 0 {
            challengeRequest()
        } else {
            let type = activities[indexPath.row].type
            if type == comment {
                viewComments(challengeId: activities[indexPath.row].challengeId!)
            } else if type == proof {
                viewProofs(challengeId: activities[indexPath.row].challengeId!)
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
            }
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
    
    func viewComments(challengeId: String) {
        let commentsTable = CommentTableViewController()
        commentsTable.tableTitle = commentsTableTitle
        // TODO commentsTable.comments = self.comments        
        commentsTable.challengeId = challengeId
        commentsTable.hidesBottomBarWhenPushed = true
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.pushViewController(commentsTable, animated: true)
    }
    
    func viewProofs(challengeId: String) {
        let proofsTable = ProofTableViewController()
        proofsTable.tableTitle = commentsTableTitle
        // TODO commentsTable.comments = self.comments
        proofsTable.challengeId = challengeId
        proofsTable.hidesBottomBarWhenPushed = true
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.pushViewController(proofsTable, animated: true)
    }
    
    func followRequest() {
        let followRequest = FollowRequestController()
        followRequest.hidesBottomBarWhenPushed = true
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.pushViewController(followRequest, animated: true)
    }
    
    func challengeRequest() {
        let challengeRequest = ChallengeRequestController()
        challengeRequest.hidesBottomBarWhenPushed = true
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.pushViewController(challengeRequest, animated: true)
    }
    
    func openProfile(name: String, memberId: String, memberFbId:String) {
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
}
