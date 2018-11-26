//
//  OtherControllers.swift
//  facebookfeed2
//
//  Created by Brian Voong on 2/27/16.
//  Copyright © 2016 letsbuildthatapp. All rights reserved.
//

import UIKit

class ChallengeResultApproveController: UITableViewController {
    
    @objc let cellId = "cellId"
    @objc let headerId = "headerId"
    @objc var challenges = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorColor = UIColor.rgb(229, green: 231, blue: 235)
        tableView.sectionHeaderHeight = 26
        tableView.tableFooterView = UIView()
        navigationItem.title = "Challenge Approves"
        tableView.register(ChallengeRequestCell.self, forCellReuseIdentifier: cellId)
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
            fetchData(url: getChallengeApprovesURL)
        } else {
            // self.challengeRequest = ServiceLocator.getChallengeRequestsFromDummy(jsonFileName: "challenge_request")
        }
    }
    
    @objc func fetchData(url: String) {
        URLSession.shared.dataTask(with: NSURL(string: url + memberID)! as URL, completionHandler: { (data, response, error) -> Void in
            if error == nil && data != nil {
                do {
                    if let postsArray = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [[String: AnyObject]] {
                        self.challenges = [Post]()
                        for postDictionary in postsArray {
                            let post = ServiceLocator.mappingOfPost(postDictionary: postDictionary)
                            self.challenges.append(post)
                        }
                    }
                } catch let err {
                    print(err)
                }
            }
            DispatchQueue.main.async {
                if self.challenges.count == 0 {
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
        return challenges.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ChallengeRequestCell
        setImage(fbID: challenges[indexPath.row].sendApproveFacebookId!, imageView: cell.requestImageView, reset: false)
        cell.imageView?.backgroundColor = UIColor.black
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.confirmButton.challengeId = challenges[indexPath.row].id
        cell.deleteButton.challengeId = challenges[indexPath.row].id
        cell.confirmButton.addTarget(self, action: #selector(self.acceptOrJoinChallenge), for: UIControlEvents.touchUpInside)
        cell.deleteButton.addTarget(self, action: #selector(self.rejectChallenge), for: UIControlEvents.touchUpInside)
        cell.nameLabel.text = "\(challenges[indexPath.row].sendApproveName!) request you for confirmation of challenge results."
        cell.confirmButton.setTitle("Confirm", for: UIControlState())
        cell.deleteButton.setTitle("Reject", for: UIControlState())
        return cell
    }
    
    @objc func acceptOrJoinChallenge(sender: subclasssedUIButton) {
        acceptChallengeService(challengeId: sender.challengeId!, accept: true)
    }
    
    @objc func rejectChallenge(sender: subclasssedUIButton) {
        acceptChallengeService(challengeId: sender.challengeId!, accept: false)
    }
    
    @objc func acceptChallengeService(challengeId: String, accept: Bool) {
        if Util.controlNetwork() {
            return
        }
        let url = URL(string: approveVersusURL + challengeId + "&memberId=\(memberID)&accept=\(accept)")!
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) -> Void in
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
                DispatchQueue.main.async {
                    self.onRefesh()
                }
            }
        }).resume()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.width * 2.4 / 10
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        openExplorer(challengeId: challenges[indexPath.row].id!)
    }
    
    @objc func openExplorer(challengeId: String) {
        let challengeController = FeedController(collectionViewLayout: UICollectionViewFlowLayout())
        challengeController.navigationItem.title = "Explorer"
        challengeController.explorer = true
        challengeController.explorerCurrentPage = 0
        challengeController.challengIdForTrendAndExplorer = challengeId
        challengeController.reloadChlPage()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.pushViewController(challengeController, animated: true)
    }
}
