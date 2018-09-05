//
//  OtherControllers.swift
//  facebookfeed2
//
//  Created by Brian Voong on 2/27/16.
//  Copyright © 2016 letsbuildthatapp. All rights reserved.
//

import UIKit

class FollowerRequestController: UITableViewController {
    
    @objc let cellId = "cellId"
    @objc let headerId = "headerId"
    @objc var followerRequest = [Friends]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorColor = UIColor.rgb(229, green: 231, blue: 235)
        tableView.sectionHeaderHeight = 26
        tableView.tableFooterView = UIView()
        navigationItem.title = "Follower Requests"
        tableView.register(FollowerRequestCell.self, forCellReuseIdentifier: cellId)
        tableView.register(RequestHeader.self, forHeaderFooterViewReuseIdentifier: headerId)
        
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(self.onRefesh), for: UIControlEvents.valueChanged)
        tableView?.addSubview(refreshControl!)
        
        loadFollowRequest()
    }
    
    @objc func onRefesh() {
        self.loadFollowRequest()
        self.tableView?.reloadData()
        refreshControl?.endRefreshing()
    }
    
    @objc func loadFollowRequest() {
        if dummyServiceCall == false {
            if Util.controlNetwork() {
                return
            }
            fetchData(url: getFollowerRequestsURL)
        } else {
            // self.challengeRequest = ServiceLocator.getChallengeRequestsFromDummy(jsonFileName: "challenge_request")
        }
    }
    
    @objc func fetchData(url: String) {
        URLSession.shared.dataTask(with: NSURL(string: url + memberID)! as URL, completionHandler: { (data, response, error) -> Void in
            if error == nil && data != nil {
                do {
                    if let postsArray = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [[String: AnyObject]] {
                        self.followerRequest = [Friends]()
                        for postDictionary in postsArray {
                            let friends = Friends()
                            friends.setValuesForKeys(postDictionary)
                            self.followerRequest.append(friends)
                        }
                    }
                } catch let err {
                    print(err)
                }
            }
            DispatchQueue.main.async {
                if self.followerRequest.count == 0 {
                    self.navigationController?.popViewController(animated: true)
                }
                self.tableView?.reloadData()
            }
        }).resume()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return followerRequest.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! FollowerRequestCell
        setImage(fbID: followerRequest[indexPath.row].facebookID!, imageView: cell.requestImageView, reset: false)
        cell.imageView?.backgroundColor = UIColor.black
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.confirmButton.memberId = followerRequest[indexPath.row].id
        cell.deleteButton.memberId = followerRequest[indexPath.row].id
        cell.confirmButton.addTarget(self, action: #selector(self.followFriend), for: UIControlEvents.touchUpInside)
        cell.deleteButton.addTarget(self, action: #selector(self.unFollowFriend), for: UIControlEvents.touchUpInside)
        cell.confirmButton.setTitle("Confirm", for: UIControlState())
        cell.deleteButton.setTitle("Delete", for: UIControlState())
        cell.nameLabel.text = "\(followerRequest[indexPath.row].name!) \(followerRequest[indexPath.row].surname!)"
        return cell
    }
    
    @objc func followFriend(sender: subclasssedUIButton) {
        let url = followingFriendURL + "?memberId=" + sender.memberId! + "&friendMemberId=" + memberID + "&follow=true"
        deleteOrFollowFriend(url: url, isDelete: false)
    }
    
    @objc func unFollowFriend(sender: subclasssedUIButton) {
        let url = deleteSuggestionURL + "?memberId=" + sender.memberId! + "&friendMemberId=" + memberID
        deleteOrFollowFriend(url: url, isDelete: true)
    }
    
    @objc func deleteOrFollowFriend(url: String, isDelete: Bool) {
        let jsonURL = URL(string: url)!
        jsonURL.get { data, response, error in
            guard
                data != nil
                else {
                    if data != nil {
                        self.popupAlert(message: ServiceLocator.getErrorMessage(data: data!, chlId: "", sUrl: url, inputs: "memberId=\(memberID)"), willDelay: false)
                    }
                    return
            }
            DispatchQueue.main.async {
                self.onRefesh()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.width * 2.4 / 10
    }
}
