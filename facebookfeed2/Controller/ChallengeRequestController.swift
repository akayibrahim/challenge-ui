//
//  OtherControllers.swift
//  facebookfeed2
//
//  Created by Brian Voong on 2/27/16.
//  Copyright © 2016 letsbuildthatapp. All rights reserved.
//

import UIKit

class ChallengeRequestController: UITableViewController {
    
    let cellId = "cellId"
    let headerId = "headerId"
    var challengeRequest = [ChallengeRequest]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorColor = UIColor.rgb(229, green: 231, blue: 235)
        tableView.sectionHeaderHeight = 26
        tableView.tableFooterView = UIView()
        navigationItem.title = "Challenge Requests"
        tableView.register(ChallengeRequestCell.self, forCellReuseIdentifier: cellId)
        tableView.register(RequestHeader.self, forHeaderFooterViewReuseIdentifier: headerId)
        
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(self.onRefesh), for: UIControlEvents.valueChanged)
        tableView?.addSubview(refreshControl!)
        
        loadFollowRequest()
    }
    
    func onRefesh() {
        self.loadFollowRequest()
        self.tableView?.reloadData()
        refreshControl?.endRefreshing()
    }
    
    func loadFollowRequest() {
        if dummyServiceCall == false {
            fetchData(url: getChallengeRequestURL)
        } else {
            self.challengeRequest = ServiceLocator.getChallengeRequestsFromDummy(jsonFileName: "challenge_request")
        }
    }
    
    func fetchData(url: String) {
        URLSession.shared.dataTask(with: NSURL(string: url + memberID)! as URL, completionHandler: { (data, response, error) -> Void in
            if error == nil && data != nil {
                do {
                    if let postsArray = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [[String: AnyObject]] {
                        self.challengeRequest = [ChallengeRequest]()
                        for postDictionary in postsArray {
                            let challenge = ChallengeRequest()
                            challenge.setValuesForKeys(postDictionary)
                            self.challengeRequest.append(challenge)
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
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return challengeRequest.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ChallengeRequestCell
        setImage(fbID: challengeRequest[indexPath.row].facebookID!, imageView: cell.requestImageView, reset: false)
        cell.imageView?.backgroundColor = UIColor.black
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.confirmButton.challengeId = challengeRequest[indexPath.row].challengeId
        cell.deleteButton.challengeId = challengeRequest[indexPath.row].challengeId
        cell.confirmButton.addTarget(self, action: #selector(self.acceptOrJoinChallenge), for: UIControlEvents.touchUpInside)
        cell.deleteButton.addTarget(self, action: #selector(self.rejectChallenge), for: UIControlEvents.touchUpInside)
        if challengeRequest[indexPath.row].type == join {
            cell.nameLabel.text = "\(challengeRequest[indexPath.row].name!) \(challengeRequest[indexPath.row].surname!) request you for join to \(challengeRequest[indexPath.row].subject!) challenge."
            cell.confirmButton.setTitle("Join", for: UIControlState())
            cell.deleteButton.setTitle("Don't Join", for: UIControlState())
            cell.confirmButton.type = join
            cell.deleteButton.type = join
        } else if challengeRequest[indexPath.row].type == accept {
            cell.nameLabel.text = "\(challengeRequest[indexPath.row].name!) \(challengeRequest[indexPath.row].surname!) request you for accept to \(challengeRequest[indexPath.row].subject!) challenge."
            cell.confirmButton.setTitle("Accept", for: UIControlState())
            cell.deleteButton.setTitle("Reject", for: UIControlState())
            cell.confirmButton.type = accept
            cell.deleteButton.type = accept
        }
        return cell
    }
    
    func acceptOrJoinChallenge(sender: subclasssedUIButton) {
        if sender.type == accept {
            acceptChallengeService(challengeId: sender.challengeId!, accept: true)
        } else if sender.type == join {
            joinToChallengeService(challengeId: sender.challengeId!, join: true)
        }
    }
    
    func rejectChallenge(sender: subclasssedUIButton) {
        if sender.type == accept {
            acceptChallengeService(challengeId: sender.challengeId!, accept: false)
        } else if sender.type == join {
            joinToChallengeService(challengeId: sender.challengeId!, join: false)
        }
    }
    
    func acceptChallengeService(challengeId: String, accept: Bool) {
        let json: [String: Any] = ["challengeId": challengeId,
                                   "memberId": memberID,
                                   "accept": accept
        ]
        let url = URL(string: acceptOrRejectChlURL)!
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
                DispatchQueue.main.async {
                    self.onRefesh()
                }
            }
        }).resume()
    }
    
    func joinToChallengeService(challengeId: String, join: Bool) {
        let json: [String: Any] = ["challengeId": challengeId,
                                   "memberId": memberID,
                                   "join": join
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
                DispatchQueue.main.async {
                    self.onRefesh()
                }
            }
        }).resume()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.width * 2.4 / 10
    }
}
