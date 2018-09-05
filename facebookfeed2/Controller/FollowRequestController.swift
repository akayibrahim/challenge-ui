//
//  OtherControllers.swift
//  facebookfeed2
//
//  Created by Brian Voong on 2/27/16.
//  Copyright © 2016 letsbuildthatapp. All rights reserved.
//

import UIKit

class FollowRequestController: UITableViewController, UISearchBarDelegate {
    
    @objc let cellId = "cellId"
    @objc let headerId = "headerId"
    @objc var friendRequest = [SuggestionFriends]()
    @objc let searchBar = UISearchBar()
    @objc var search : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.placeholder = "Search"
        searchBar.delegate = self
        self.navigationItem.titleView = searchBar
        
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
        
        self.hideKeyboardWhenTappedAround()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
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
            searchFriends(key: searchBar.text!)
            return
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        onRefesh()
    }
    
    @objc func searchFriends(key: String) {
        let jsonURL = URL(string: searchFriendsURL + key + "&memberId=\(memberID)")!
        jsonURL.get { data, response, error in
            guard
                let returnData = data,
                let postsArray = try? JSONSerialization.jsonObject(with: returnData, options: .mutableContainers) as? [[String: AnyObject]]
                else {
                    self.popupAlert(message: ServiceLocator.getErrorMessage(data: data!, chlId: "", sUrl: searchFriendsURL, inputs: "memberId=\(memberID)"), willDelay: false)
                    return
            }
            DispatchQueue.main.async {
                self.friendRequest = [SuggestionFriends]()
                for postDictionary in postsArray! {
                    let friend = SuggestionFriends()                    
                    friend.setValuesForKeys(postDictionary)
                    self.friendRequest.append(friend)
                }
                self.search = true
                self.tableView?.reloadData()
            }
        }
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
            fetchData(url: getSuggestionsForFollowingURL)
        } else {
            self.friendRequest = ServiceLocator.getSuggestionFriendsFromDummy(jsonFileName: "friend_request")
        }
    }
    
    @objc func fetchData(url: String) {
        let jsonURL = URL(string: url + memberID)!
        jsonURL.get { data, response, error in
            guard
                let returnData = data,
                let postsArray = try? JSONSerialization.jsonObject(with: returnData, options: .mutableContainers) as? [[String: AnyObject]]
                else {
                    self.popupAlert(message: ServiceLocator.getErrorMessage(data: data!, chlId: "", sUrl: url, inputs: "memberId=\(memberID)"), willDelay: false)
                    return
            }
            DispatchQueue.main.async {
                self.friendRequest = [SuggestionFriends]()
                for postDictionary in postsArray! {
                    let friend = SuggestionFriends()
                    friend.setValuesForKeys(postDictionary)
                    self.friendRequest.append(friend)
                }
                self.search = false
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
        cell.deleteButton.alpha = search ? 0 : 1
        cell.confirmButton.addTarget(self, action: #selector(self.followFriend), for: UIControlEvents.touchUpInside)
        cell.deleteButton.addTarget(self, action: #selector(self.unFollowFriend), for: UIControlEvents.touchUpInside)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        openProfile(name: "\(friendRequest[indexPath.row].name!) \(friendRequest[indexPath.row].surname!)", memberId: friendRequest[indexPath.row].id!, memberFbId: friendRequest[indexPath.row].facebookID!)
    }
    
    @objc func followFriend(sender: subclasssedUIButton) {
        let url = followingFriendURL + "?memberId=" + memberID + "&friendMemberId=" + sender.memberId! + "&follow=true"
        deleteOrFollowFriend(url: url, isDelete: false)
    }
    
    @objc func unFollowFriend(sender: subclasssedUIButton) {
        let url = deleteSuggestionURL + "?memberId=" + memberID + "&friendMemberId=" + sender.memberId!
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
                if !isDelete {
                    self.popupAlert(message: "Now Following!", willDelay: true)
                } else {
                    self.popupAlert(message: "Removed!", willDelay: true)
                }
            }
        }
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
                    if data != nil {
                        ServiceLocator.logErrorMessage(data: data!, chlId: "", sUrl: getMemberInfoURL, inputs: "memberID=\(memberId)")
                    }
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

class RequestHeader: UITableViewHeaderFooterView {
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
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
