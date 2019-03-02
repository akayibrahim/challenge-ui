//
//  SelectionTableViewController.swift
//  facebookfeed2
//
//  Created by iakay on 27.03.2018.
//  Copyright © 2018 challenge. All rights reserved.
//

import UIKit

class SelectionTableViewController : UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    @objc let screenSize = UIScreen.main.bounds
    var items = [SelectedItems]()
    var unfilteredItems = [SelectedItems]()
    @objc var tableTitle : String!
    @objc var tableView : UITableView!
    @objc var popIndexPath : IndexPath!
    var otherSideCount : Int!
    var segmentIndex : Int!
    @objc var switchCustomeSubject : Bool = false
    @objc var listMode : Bool = false
    @objc var isFollower : Bool = false
    @objc var followers = [Followers]()
    @objc var unfilteredFollowers = [Followers]()
    @objc var isFollowing : Bool = false
    @objc var following = [Following]()
    @objc var unfilteredFollowing = [Following]()
    @objc var labelCell = "labelCell"
    @objc var followCell = "followCell"
    @objc var profile: Bool = false
    @objc var memberIdForFriendProfile: String?
    var isProfileFriend: Bool?
    @objc var searchBar = UISearchBar()
    @objc var subjects = [Subject]()
    @objc var self_subjects = [Subject]()
    var leftSide = [SelectedItems]()
    var rightSide = [SelectedItems]()
    @objc var friends = [Friends]()
    @objc var supportList: Bool = false
    @objc var challengeId: String?
    @objc var supportedMemberId: String?
    var firstTeam: Bool?
    @objc var listOfSupports = [Support]()
    @objc var unfilteredSupports = [Support]()
    @objc var isMoreAttendance: Bool = false
    @objc var attendanceList = [Attendance]()
    @objc var unfilteredAttendanceList = [Attendance]()
    @objc var bottomConstraint: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView = UITableView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height), style: UITableViewStyle.plain)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        searchBar.delegate = self
        self.customeSubjectText.delegate = self
        navigationItem.titleView = searchBar
        tableView.tableFooterView = UIView()
        self.view.addSubview(tableView)
        navigationItem.title = tableTitle  
        self.view.backgroundColor = UIColor.white
        self.tableView.keyboardDismissMode = .onDrag
        if !isSelf() && !listMode && popIndexPath.row == subjectIndex {
            self.tableView.frame.size.height = screenSize.height - (globalHeight + 10)
            view.addSubview(customSubjectView)
            customSubjectView.widthAnchor.constraint(equalToConstant: screenWidth).isActive = true
            customSubjectView.heightAnchor.constraint(equalToConstant: globalHeight + 10).isActive = true
            customSubjectView.translatesAutoresizingMaskIntoConstraints = false
            bottomConstraint = NSLayoutConstraint(item: customSubjectView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: -5)
            view.addConstraint(bottomConstraint!)
            prepareCustomSubjectView()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        self.hideKeyboardWhenTappedAround()
        
        reload()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    func prepareCustomSubjectView() {
        customeSubjectText.removeFromSuperview()
        saveButton.removeFromSuperview()
        
        // customSubjectView.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: globalHeight)
        customSubjectView.addSubview(customeSubjectText)
        customSubjectView.addSubview(saveButton)
        
        customeSubjectText.text = enterCustomSubject
        customeSubjectText.bottomAnchor.constraint(equalTo: customSubjectView.bottomAnchor, constant: -(screenWidth * 0.2 / 10)).isActive = true
        customeSubjectText.leadingAnchor.constraint(equalTo: customSubjectView.leadingAnchor, constant : screenWidth * 0.2 / 10).isActive = true
        customeSubjectText.trailingAnchor.constraint(equalTo: saveButton.leadingAnchor, constant : -(screenWidth * 0.2 / 10)).isActive = true
        customeSubjectText.heightAnchor.constraint(equalToConstant: globalHeight - 5).isActive = true
        customeSubjectText.translatesAutoresizingMaskIntoConstraints = false
        customeSubjectText.autocapitalizationType = .allCharacters
        
        saveButton.bottomAnchor.constraint(equalTo: customSubjectView.bottomAnchor, constant: -(screenWidth * 0.2 / 10)).isActive = true
        saveButton.widthAnchor.constraint(equalToConstant: globalHeight * 1.5).isActive = true
        saveButton.heightAnchor.constraint(equalToConstant: globalHeight - 5).isActive = true
        saveButton.trailingAnchor.constraint(equalTo: customSubjectView.trailingAnchor, constant : -(screenWidth * 0.2 / 10)).isActive = true
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.addTarget(self, action: #selector(self.save), for: UIControlEvents.touchUpInside)
        saveButton.backgroundColor = navAndTabColor
        saveButton.layer.borderWidth = 0
        saveButton.setTitleColor(UIColor.white, for: UIControlState())
    }
    
    @objc func handleKeyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let keyboardFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
            let isKeyboardShowing = notification.name == NSNotification.Name.UIKeyboardWillShow
            bottomConstraint?.constant = isKeyboardShowing ? -keyboardFrame!.height : -5
            self.tableView.frame.size.height = (keyboardFrame?.origin.y)! - (self.customSubjectView.frame.height + 10)
            if !isKeyboardShowing {
            }
        }
    }
    
    @objc let customSubjectView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    
    @objc func reload() {
        if Util.controlNetwork() {
            return
        }
        searchBar.text = ""
        if !listMode {
            self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: labelCell)
            if popIndexPath == leftSideIndex || popIndexPath == rightSideIndex {
                tableView.allowsMultipleSelection = true
                navigationItem.rightBarButtonItem = self.editButtonItem
                let rightButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(self.showEditing))
                rightButton.tintColor = UIColor.black
                navigationItem.rightBarButtonItem = rightButton
                if dummyServiceCall == false {
                    fetchData(url: getFollowingListURL + memberID, type: "FRIENDS")
                    group.wait()
                    unfilteredItems = items
                    self.tableView?.reloadData()
                } else {
                    self.friends = ServiceLocator.getFriendsFromDummy(jsonFileName: "friends")
                }
            } else if popIndexPath.row == subjectIndex {
                if dummyServiceCall == false {
                    if !isSelf() {
                        fetchData(url: getSubjectsURL, type: "SUBJECT")
                    } else {
                        fetchData(url: getSelfSubjectsURL, type: "SELF_SUBJECT")
                    }
                    group.wait()
                    unfilteredItems = items
                    self.tableView?.reloadData()
                } else {
                    self.subjects = ServiceLocator.getSubjectFromDummy(jsonFileName: "subject")
                    self.self_subjects = ServiceLocator.getSubjectFromDummy(jsonFileName: "self_subject")
                }
            }
        } else {
            self.tableView.register(FollowCellView.self, forCellReuseIdentifier: followCell)
            if isFollower {
                loadFollowers()
            }
            if isFollowing {
                loadFollowings()
            }
            if supportList {
                loadSupportList()
            }
            if isMoreAttendance {
                loadMoreAttendance()
            }
        }
    }
    
    @objc func fetchData(url: String, type: String) {
        group.enter()
        let jsonURL = URL(string: url)!
        jsonURL.get { data, response, error in
            guard
                let returnData = data,
                let postsArray = try? JSONSerialization.jsonObject(with: returnData, options: .mutableContainers) as? [[String: AnyObject]]
                else {
                    if data != nil {
                        self.popupAlert(message: ServiceLocator.getErrorMessage(data: data!, chlId: "", sUrl: url, inputs: ""), willDelay: false)
                    }
                    return
            }
            if type == "FRIENDS" {
                self.friends = [Friends]()
            } else if type == "SELF_SUBJECT" {
                self.self_subjects = [Subject]()
            } else {
                self.subjects = [Subject]()
            }
            for postDictionary in postsArray! {
                if type == "SUBJECT" {
                    let subject = Subject()
                    subject.setValuesForKeys(postDictionary)
                    self.subjects.append(subject)
                } else if type == "SELF_SUBJECT" {
                    let subject = Subject()
                    subject.setValuesForKeys(postDictionary)
                    self.self_subjects.append(subject)
                } else if type == "FRIENDS" {
                    let friend = Friends()
                    friend.setValuesForKeys(postDictionary)
                    self.friends.append(friend)
                }
            }
            self.fillItems(type: type)
            self.group.leave()
        }
    }
    
    @objc func fillItems(type: String) {
        var selItems = [SelectedItems]()
        if type == "SUBJECT" {
            for subj in self.subjects {
                let selItem = SelectedItems()
                selItem.name = subj.name
                selItems.append(selItem)
            }
        } else if type == "SELF_SUBJECT" {
            for subj in self.self_subjects {
                let selItem = SelectedItems()
                selItem.name = subj.name
                selItems.append(selItem)
            }
        } else if type == "FRIENDS" {
            for fri in self.friends {
                let selItem = SelectedItems()
                selItem.name = "\(fri.name!) \(fri.surname!)"
                selItem.id = fri.id
                selItem.fbId = fri.facebookID
                if popIndexPath == leftSideIndex {
                    if getIDs(side: self.leftSide).contains(selItem.id) {
                        selItem.selected = true
                    }
                    if !getIDs(side: self.rightSide).contains(selItem.id) {
                        selItems.append(selItem)
                    }
                } else if popIndexPath == rightSideIndex {
                    if getIDs(side: self.rightSide).contains(selItem.id) {
                        selItem.selected = true
                    }
                    if !getIDs(side: self.leftSide).contains(selItem.id) {
                        selItems.append(selItem)
                    }
                }
                
            }
            if popIndexPath == leftSideIndex {
                selItems.append(getMember())
            }
            if !isPublic() {
                if popIndexPath == leftSideIndex {
                    otherSideCount = rightSide.count
                } else {
                    otherSideCount = leftSide.count
                }
            } else {
                otherSideCount = -1
            }
        }
        self.items = selItems
    }
    
    func getMember() -> SelectedItems {
        let selItem = SelectedItems()
        selItem.name = memberName
        selItem.id = memberID
        selItem.fbId = memberFbID
        selItem.selected = true
        selItem.user = true
        return selItem
    }
    
    func getIDs(side: [SelectedItems]) -> [String] {
        var ids : [String] = []
        for si in side {
            ids.append(si.id)
        }
        return ids
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !listMode {
            let uppercasedText = searchText.uppercased()
            items = searchText.isEmpty ? unfilteredItems : items.filter { item -> Bool in
                return item.name.uppercased().hasPrefix(uppercasedText)
            }
        } else {
            if isFollower {
                let uppercasedText = searchText.uppercased()
                followers = searchText.isEmpty ? unfilteredFollowers : followers.filter { item -> Bool in
                    return (item.name?.uppercased().hasPrefix(uppercasedText))!
                }
            }
            if isFollowing {
                let uppercasedText = searchText.uppercased()
                following = searchText.isEmpty ? unfilteredFollowing : following.filter { item -> Bool in
                    return (item.name?.uppercased().hasPrefix(uppercasedText))!
                }
            }
            if supportList {
                let uppercasedText = searchText.uppercased()
                listOfSupports = searchText.isEmpty ? unfilteredSupports : listOfSupports.filter { item -> Bool in
                    return (item.name?.uppercased().hasPrefix(uppercasedText))!
                }
            }
            if isMoreAttendance {
                let uppercasedText = searchText.uppercased()
                attendanceList = searchText.isEmpty ? unfilteredAttendanceList : attendanceList.filter { item -> Bool in
                    return (item.name?.uppercased().hasPrefix(uppercasedText))!
                }
            }
        }
        tableView.reloadData()
    }
    
    @objc func loadFollowings() {
        if dummyServiceCall == false {
            fetchFollowingsData(url: getFollowingListURL)
        } else {
            self.following = ServiceLocator.getFollowingsFromDummy(jsonFileName: "following")
            self.unfilteredFollowing = self.following
        }
    }
    
    @objc func loadMoreAttendance() {
        if dummyServiceCall == false {
            fetchMoreAttendances(url: getChallengerListURL)
        }
    }
    
    @objc func fetchMoreAttendances(url: String) {
        let jsonURL = URL(string: url + challengeId! + "&memberId=\(memberID)&firstTeam=\(firstTeam!)")!
        jsonURL.get { data, response, error in
            guard
                let returnData = data,
                let postsArray = try? JSONSerialization.jsonObject(with: returnData, options: .mutableContainers) as? [[String: AnyObject]]
                else {
                    if data != nil {
                        self.popupAlert(message: ServiceLocator.getErrorMessage(data: data!, chlId: "", sUrl: url, inputs: "memberId=\(memberID)"), willDelay: false)
                    }
                    return
            }
            DispatchQueue.main.async {
                self.attendanceList = [Attendance]()
                for postDictionary in postsArray! {
                    let attendance = Attendance()
                    attendance.followed = postDictionary["followed"] as? Bool
                    attendance.setValuesForKeys(postDictionary)
                    self.attendanceList.append(attendance)
                }
                self.unfilteredAttendanceList = self.attendanceList
                self.tableView?.reloadData()
            }
        }
    }
    
    @objc func loadSupportList() {
        if dummyServiceCall == false {
            fetchSupportList(url: getSupportListURL)
        }
    }
    
    @objc func fetchSupportList(url: String) {
        let jsonURL = URL(string: url + challengeId! + "&memberId=\(memberID)&supportedMemberId=\((supportedMemberId == nil ? "" : supportedMemberId)!)&firstTeam=\(firstTeam!)")!
        jsonURL.get { data, response, error in
            guard
                let returnData = data,
                let postsArray = try? JSONSerialization.jsonObject(with: returnData, options: .mutableContainers) as? [[String: AnyObject]]
                else {
                    if data != nil {
                        self.popupAlert(message: ServiceLocator.getErrorMessage(data: data!, chlId: "", sUrl: url, inputs: "memberId=\(memberID)"), willDelay: false)
                    }
                    return
            }
            DispatchQueue.main.async {
                self.listOfSupports = [Support]()
                for postDictionary in postsArray! {
                    let support = Support()
                    support.followed = postDictionary["followed"] as? Bool
                    support.setValuesForKeys(postDictionary)
                    self.listOfSupports.append(support)
                }
                self.unfilteredSupports = self.listOfSupports
                self.tableView?.reloadData()
            }
        }
    }
    
    @objc func loadFollowers() {
        if dummyServiceCall == false {
            fetchFollowersData(url: getFollowerListURL)
        } else {
            self.followers = ServiceLocator.getFollowersFromDummy(jsonFileName: "followers")
            self.unfilteredFollowers = self.followers
        }
    }
    
    @objc func fetchFollowingsData(url: String) {
        let jsonURL = URL(string: url + (profile ? memberIdForFriendProfile! : memberID))!
        jsonURL.get { data, response, error in
            guard
                let returnData = data,
                let postsArray = try? JSONSerialization.jsonObject(with: returnData, options: .mutableContainers) as? [[String: AnyObject]]
                else {
                    if data != nil {
                        self.popupAlert(message: ServiceLocator.getErrorMessage(data: data!, chlId: "", sUrl: url, inputs: "memberId=\(memberID)"), willDelay: false)
                    }
                    return
            }
            DispatchQueue.main.async {
                self.following = [Following]()
                for postDictionary in postsArray! {
                    let following = Following()
                    following.setValuesForKeys(postDictionary)
                    self.following.append(following)
                }
                self.unfilteredFollowing = self.following
                self.tableView?.reloadData()
            }
        }
    }
    
    @objc func fetchFollowersData(url: String) {
        let jsonURL = URL(string: url + (profile ? memberIdForFriendProfile! : memberID))!
        jsonURL.get { data, response, error in
            guard
                let returnData = data,
                let postsArray = try? JSONSerialization.jsonObject(with: returnData, options: .mutableContainers) as? [[String: AnyObject]]
                else {
                    if data != nil {
                        self.popupAlert(message: ServiceLocator.getErrorMessage(data: data!, chlId: "", sUrl: url, inputs: "memberID=\(memberID)"), willDelay: false)
                    }
                    return
            }
            DispatchQueue.main.async {
                self.followers = [Followers]()
                for postDictionary in postsArray! {
                    let follower = Followers()
                    follower.setValuesForKeys(postDictionary)
                    self.followers.append(follower)
                }
                self.unfilteredFollowers = self.followers
                self.tableView?.reloadData()
            }
        }
    }
    
    @objc func keyboardWasShown (notification: NSNotification) {
        var info = notification.userInfo
        let keyboardFrame = (info![UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
        
        tableView.contentInset = UIEdgeInsetsMake(0, 0, (keyboardFrame?.height)!, 0)
        tableView.scrollIndicatorInsets = tableView.contentInset
    }
    
    @objc func keyboardWillBeHidden (notification: NSNotification) {
        tableView.contentInset = UIEdgeInsets.zero
        tableView.scrollIndicatorInsets = UIEdgeInsets.zero
    }
    
    @objc func showEditing() {
        if let controller = navigationController?.viewController(class: AddChallengeController.self) {
            if tableView.indexPathsForSelectedRows == nil {
                let selectAlert: UIAlertController = UIAlertController(title: "Alert", message: "You have to select at least one person!", preferredStyle: UIAlertControllerStyle.alert)
                selectAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(selectAlert, animated: true, completion: nil)
                return
            }
            let indexPath : [IndexPath] = tableView.indexPathsForSelectedRows!
            var selItems = [SelectedItems]()
            for index in indexPath {
                let selItem = SelectedItems()
                selItem.name = items[index.row].name
                selItem.id = items[index.row].id
                selItem.fbId = items[index.row].fbId
                selItems.append(selItem)
            }
            if otherSideCount != -1 && otherSideCount != 0 && selItems.count != otherSideCount {
                let selectAlert: UIAlertController = UIAlertController(title: "Alert", message: "You select \(otherSideCount!) people at the other side, you have to select same count. So if you you choose different count, you have to select again at the other side.", preferredStyle: UIAlertControllerStyle.alert)
                selectAlert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
                selectAlert.addAction(UIAlertAction(title: "Continue", style: UIAlertActionStyle.default, handler: {
                    action in
                        controller.updateCell(result: selItems, popIndexPath: self.popIndexPath)
                        self.navigationController?.popViewController(animated: true)
                }))
                self.present(selectAlert, animated: true, completion: nil)
                return
            }
            controller.updateCell(result: selItems, popIndexPath: popIndexPath)
        }
        navigationController?.popViewController(animated: true)
    }
    
    @objc func isHome() -> Bool {
        return popIndexPath != nil ? popIndexPath == leftSideIndex : false
    }
    
    @objc func isAway() -> Bool {
        return popIndexPath == rightSideIndex
    }
    
    @objc func isSubject() -> Bool {
        return popIndexPath == subjectIndexPath
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if isHome() {
            if items[indexPath.row].user {
                tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !listMode {
            if popIndexPath.row == subjectIndex {
                /*if (indexPath.row == (items.count + 2)) {
                    // nothing
                } else if (indexPath.row == (items.count + 1)) {
                    switchCustomeSubject = !switchCustomeSubject
                    let customSubjectIndex = IndexPath(item: items.count + 2, section: 0)
                    tableView.reloadRows(at: [customSubjectIndex], with: .fade)
                    tableView.scrollToRow(at: customSubjectIndex, at: UITableViewScrollPosition.bottom, animated: true)
                    customeSubjectText.becomeFirstResponder()
                } else */
                if (indexPath.row == items.count) {
                    // nothing
                } else {
                    updateAndPopViewController(subjectName: items[indexPath.row].name)
                }
            }
        } else {
            if isFollower {
                self.openProfile(name: "\(followers[indexPath.row].name!) \(followers[indexPath.row].surname!)", memberId: followers[indexPath.row].id!, memberFbId: followers[indexPath.row].facebookID!)
            } else if isFollowing {
                self.openProfile(name: "\(following[indexPath.row].name!) \(following[indexPath.row].surname!)", memberId: following[indexPath.row].id!, memberFbId: following[indexPath.row].facebookID!)
            } else if supportList {
                self.openProfile(name: "\(listOfSupports[indexPath.row].name!) \(listOfSupports[indexPath.row].surname!)", memberId: listOfSupports[indexPath.row].memberId!, memberFbId: listOfSupports[indexPath.row].facebookId!)
            } else if isMoreAttendance {
                self.openProfile(name: "\(attendanceList[indexPath.row].name!) \(attendanceList[indexPath.row].surname!)", memberId: attendanceList[indexPath.row].memberId!, memberFbId: attendanceList[indexPath.row].facebookId!)
            }
        }
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
        profileController.isProfileFriend = isProfileFriend!
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
    
    @objc func isMyFriend(friendMemberId: String) {
        let jsonURL = URL(string: isMyFriendURL + memberID + "&friendMemberId=" + friendMemberId)!
        group.enter()
        jsonURL.get { data, response, error in
            guard
                let returnData = data
                else {
                    if data != nil {
                        ServiceLocator.logErrorMessage(data: data!, chlId: "", sUrl: isMyFriendURL, inputs: "memberID=\(memberID), friendMemberId=\(friendMemberId)")
                    }
                    return
            }
            let isMyFriend = NSString(data: returnData, encoding: String.Encoding.utf8.rawValue)!
            self.isProfileFriend = (isMyFriend as String).toBool()
            self.group.leave()
        }
    }
    
    @objc func updateAndPopViewController(subjectName : String) {
        if let controller = navigationController?.viewController(class: AddChallengeController.self) {
            var selItems = [SelectedItems]()
            let selItem = SelectedItems()
            selItem.name = subjectName
            selItems.append(selItem)
            controller.updateCell(result: selItems, popIndexPath: popIndexPath)
        }
        navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if !listMode {
            /*if (indexPath.row == (items.count + 2)) {
                if !switchCustomeSubject {
                    return 0
                }
            }*/
        }
        return 44
    }
    
    @objc func isSelf() -> Bool {
        return segmentIndex == 2
    }
    
    @objc func isPrivate() -> Bool {
        return segmentIndex == 1
    }
    
    @objc func isPublic() -> Bool {
        return segmentIndex == 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !listMode {
            if ((popIndexPath.row == 3 || popIndexPath.row == 4) || (popIndexPath.row == 2 && isSelf())) {
                return items.count
            } else {
                return items.count
            }
        } else {
            if isFollower {
                return followers.count
            } else if isFollowing {
                return following.count
            } else if supportList {
                return listOfSupports.count
            } else if isMoreAttendance {
                return attendanceList.count
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if !listMode {
            let cell = tableView.dequeueReusableCell(withIdentifier: labelCell, for: indexPath as IndexPath)
            if ((popIndexPath.row == 3 || popIndexPath.row == 4) || (popIndexPath.row == 2 && isSelf())) {
                cell.textLabel?.text = items[indexPath.row].name
                if items[indexPath.row].selected {                    
                    tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
                }
            } else {
                /*if (indexPath.row == (items.count + 2)) {
                    cell.addSubview(prepareCustomSubjectView())
                    cell.isHidden = !switchCustomeSubject
                } else if (indexPath.row == (items.count + 1)) {
                    cell.textLabel?.text = customSubjectLabel
                } else */
                if (indexPath.row == items.count) {
                    cell.backgroundColor = pagesBackColor
                    cell.selectionStyle = UITableViewCellSelectionStyle.none
                } else {
                    cell.textLabel?.text = items[indexPath.row].name
                }
            }
            return cell
        } else {
            let frameOfCell : CGRect = CGRect(x: 0, y: 0, width: self.view.frame.width, height: globalHeight)
            let cell = FollowCellView(frame: frameOfCell)
            if isFollower {
                setImage(fbID: followers[indexPath.row].facebookID, imageView: cell.profileImageView)
                cell.thinksAboutChallengeView.text = "\(followers[indexPath.row].name!) \(followers[indexPath.row].surname!)"
            } else if isFollowing {
                setImage(fbID: following[indexPath.row].facebookID, imageView: cell.profileImageView)
                cell.thinksAboutChallengeView.text = "\(following[indexPath.row].name!) \(following[indexPath.row].surname!)"
            } else if supportList {
                setImage(fbID: listOfSupports[indexPath.row].facebookId, imageView: cell.profileImageView)
                cell.thinksAboutChallengeView.text = "\(listOfSupports[indexPath.row].name!) \(listOfSupports[indexPath.row].surname!)"
                cell.followButton.alpha = listOfSupports[indexPath.row].followed! ? 0 : 1
                cell.followButton.memberId = listOfSupports[indexPath.row].memberId
            } else if isMoreAttendance {
                setImage(fbID: attendanceList[indexPath.row].facebookId, imageView: cell.profileImageView)
                cell.thinksAboutChallengeView.text = "\(attendanceList[indexPath.row].name!) \(attendanceList[indexPath.row].surname!)"
                cell.followButton.alpha = attendanceList[indexPath.row].followed! ? 0 : 1
                cell.followButton.memberId = attendanceList[indexPath.row].memberId
            }
            cell.followButton.addTarget(self, action: #selector(self.follow), for: UIControlEvents.touchUpInside)
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            return cell
        }
    }
    
    @objc func follow(sender: subclasssedUIButton) {
        let url = followingFriendURL + "?memberId=" + memberID + "&friendMemberId=" + sender.memberId! + "&follow=true"
        followFriend(url: url)
    }
    
    @objc func followFriend(url: String) {
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
                self.reload()
                //self.popupAlert(message: "Now Following!", willDelay: true)
            }
        }
    }
    
    @objc func save() {
        if customeSubjectText.text! == enterCustomSubject {
            self.popupAlert(message: "Enter a subject!", willDelay: false)
            return
        }
        updateAndPopViewController(subjectName: customeSubjectText.text!)
    }
    
    @objc let customeSubjectText: UITextView = CommentTableViewController().textView
    @objc let saveButton = FeedCell.buttonForTitleWithBorder("Save", imageName: "")
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            setTextViewToDefault()
        }
    }
    
    let enterCustomSubject = "Enter Custom Subject"
    @objc func setTextViewToDefault() {
        self.customeSubjectText.text = enterCustomSubject
        self.customeSubjectText.textColor = UIColor.lightGray
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return textView.text.count + (text.count - range.length) <= 25
    }
}
