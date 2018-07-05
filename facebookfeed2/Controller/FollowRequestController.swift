//
//  OtherControllers.swift
//  facebookfeed2
//
//  Created by Brian Voong on 2/27/16.
//  Copyright © 2016 letsbuildthatapp. All rights reserved.
//

import UIKit

class FollowRequestController: UITableViewController {
    
    let cellId = "cellId"
    let headerId = "headerId"
    var friendRequest = [SuggestionFriends]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorColor = UIColor.rgb(229, green: 231, blue: 235)
        tableView.sectionHeaderHeight = 26
        tableView.tableFooterView = UIView()
        navigationItem.title = "Find Friends"
        tableView.register(FriendRequestCell.self, forCellReuseIdentifier: cellId)
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
            fetchData(url: getSuggestionsForFollowingURL)
        } else {
            self.friendRequest = ServiceLocator.getSuggestionFriendsFromDummy(jsonFileName: "friend_request")
        }
    }
    
    func fetchData(url: String) {
        let jsonURL = URL(string: url + memberID)!
        jsonURL.get { data, response, error in
            guard
                let returnData = data,
                let postsArray = try? JSONSerialization.jsonObject(with: returnData, options: .mutableContainers) as? [[String: AnyObject]]
                else {
                    self.popupAlert(message: ServiceLocator.getErrorMessage(data: data!), willDelay: false)
                    return
            }
            DispatchQueue.main.async {
                self.friendRequest = [SuggestionFriends]()
                for postDictionary in postsArray! {
                    let friend = SuggestionFriends()
                    friend.setValuesForKeys(postDictionary)
                    self.friendRequest.append(friend)
                }
                self.tableView?.reloadData()
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendRequest.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! FriendRequestCell
        cell.nameLabel.text = "\(friendRequest[indexPath.row].name!) \(friendRequest[indexPath.row].surname!)"
        setImage(fbID: friendRequest[indexPath.row].facebookID!, imageView: cell.requestImageView, reset: false)
        cell.imageView?.backgroundColor = UIColor.black
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.confirmButton.memberId = friendRequest[indexPath.row].id
        cell.deleteButton.memberId = friendRequest[indexPath.row].id
        cell.confirmButton.addTarget(self, action: #selector(self.followFriend), for: UIControlEvents.touchUpInside)
        cell.deleteButton.addTarget(self, action: #selector(self.unFollowFriend), for: UIControlEvents.touchUpInside)
        return cell
    }
    
    func followFriend(sender: subclasssedUIButton) {
        let url = followingFriendURL + "?memberId=" + memberID + "&friendMemberId=" + sender.memberId! + "&follow=true"
        deleteOrFollowFriend(url: url, isDelete: false, friendMemberId: sender.memberId!)
    }
    
    func unFollowFriend(sender: subclasssedUIButton) {
        let url = deleteSuggestionURL + "?memberId=" + memberID + "&friendMemberId=" + sender.memberId!
        deleteOrFollowFriend(url: url, isDelete: true, friendMemberId: sender.memberId!)
    }
    
    func deleteOrFollowFriend(url: String, isDelete: Bool, friendMemberId: String) {
        URLSession.shared.dataTask(with: NSURL(string: url)! as URL, completionHandler: { (data, response, error) -> Void in
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
            DispatchQueue.main.async {
                self.onRefesh()
                if !isDelete {
                    self.popupAlert(message: "Start To Following!", willDelay: true)
                } else {
                    self.popupAlert(message: "Removed!", willDelay: true)
                }
            }
        }).resume()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.width * 1.9 / 10
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerId) as! RequestHeader
        header.nameLabel.text = "PEOPLE YOU MAY KNOW"
        /*
        if section == 0 {
            header.nameLabel.text = "FRIEND REQUESTS"
        } else {
            header.nameLabel.text = "PEOPLE YOU MAY KNOW"
        }
        */
        return header
    }
    
}

class RequestHeader: UITableViewHeaderFooterView {
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
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
