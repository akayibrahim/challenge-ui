//
//  SelectionTableViewController.swift
//  facebookfeed2
//
//  Created by iakay on 27.03.2018.
//  Copyright © 2018 challenge. All rights reserved.
//

import UIKit

class SelectionTableViewController : UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    let screenSize = UIScreen.main.bounds
    var items = [SelectedItems]()
    var unfilteredItems = [SelectedItems]()
    var tableTitle : String!
    var tableView : UITableView!
    var popIndexPath : IndexPath!
    var otherSideCount : Int!
    var segmentIndex : Int!
    var switchCustomeSubject : Bool = false
    var listMode : Bool = false
    var isFollower : Bool = false
    var followers = [Followers]()
    var unfilteredFollowers = [Followers]()
    var isFollowing : Bool = false
    var following = [Following]()
    var unfilteredFollowing = [Following]()
    var labelCell = "labelCell"
    var followCell = "followCell"
    var profile: Bool = false
    var memberIdForFriendProfile: String?
    var isProfileFriend: Bool?
    var searchBar = UISearchBar()
    var subjects = [Subject]()
    var self_subjects = [Subject]()
    var leftSide = [SelectedItems]()
    var rightSide = [SelectedItems]()
    var friends = [Friends]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView = UITableView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height), style: UITableViewStyle.plain)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        searchBar.delegate = self
        self.customeSubjectText.delegate = self as UITextFieldDelegate
        navigationItem.titleView = searchBar
        unfilteredItems = items
        tableView.tableFooterView = UIView()
        self.view.addSubview(tableView)
        navigationItem.title = tableTitle  
        
        if !listMode {
            self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: labelCell)
            if popIndexPath == leftSideIndex || popIndexPath == rightSideIndex {
                tableView.allowsMultipleSelection = true
                navigationItem.rightBarButtonItem = self.editButtonItem
                let rightButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(self.showEditing))
                rightButton.tintColor = UIColor.white
                navigationItem.rightBarButtonItem = rightButton
                if dummyServiceCall == false {
                    fetchData(url: getFollowingListURL + memberID, type: "FRIENDS")
                } else {
                    self.friends = ServiceLocator.getFriendsFromDummy(jsonFileName: "friends")
                }
            } else if popIndexPath.row == subjectIndex {
                if dummyServiceCall == false {
                    if segmentIndex != 2 {
                        fetchData(url: getSubjectsURL, type: "SUBJECT")
                    } else {
                        fetchData(url: getSelfSubjectsURL, type: "SELF_SUBJECT")
                    }
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
        }
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        self.hideKeyboardWhenTappedAround()
    }
    
    func fetchData(url: String, type: String) {
        let jsonURL = URL(string: url)!
        jsonURL.get { data, response, error in
            guard
                let returnData = data,
                let postsArray = try? JSONSerialization.jsonObject(with: returnData, options: .mutableContainers) as? [[String: AnyObject]]
                else {
                    self.popupAlert(message: ServiceLocator.getErrorMessage(data: data!, chlId: "", sUrl: url, inputs: ""), willDelay: false)
                    return
            }
            DispatchQueue.main.async {
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
                self.tableView?.reloadData()
            }
        }
    }
    
    func fillItems(type: String) {
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
        }
        tableView.reloadData()
    }
    
    func loadFollowings() {
        if dummyServiceCall == false {
            fetchFollowingsData(url: getFollowingListURL)
        } else {
            self.following = ServiceLocator.getFollowingsFromDummy(jsonFileName: "following")
            self.unfilteredFollowing = self.following
        }
    }
    
    func loadFollowers() {
        if dummyServiceCall == false {
            fetchFollowersData(url: getFollowerListURL)
        } else {
            self.followers = ServiceLocator.getFollowersFromDummy(jsonFileName: "followers")
            self.unfilteredFollowers = self.followers
        }
    }
    
    func fetchFollowingsData(url: String) {
        let jsonURL = URL(string: url + (profile ? memberIdForFriendProfile! : memberID))!
        jsonURL.get { data, response, error in
            guard
                let returnData = data,
                let postsArray = try? JSONSerialization.jsonObject(with: returnData, options: .mutableContainers) as? [[String: AnyObject]]
                else {
                    self.popupAlert(message: ServiceLocator.getErrorMessage(data: data!, chlId: "", sUrl: url, inputs: "memberId=\(memberID)"), willDelay: false)
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
    
    func fetchFollowersData(url: String) {
        let jsonURL = URL(string: url + (profile ? memberIdForFriendProfile! : memberID))!
        jsonURL.get { data, response, error in
            guard
                let returnData = data,
                let postsArray = try? JSONSerialization.jsonObject(with: returnData, options: .mutableContainers) as? [[String: AnyObject]]
                else {
                    self.popupAlert(message: ServiceLocator.getErrorMessage(data: data!, chlId: "", sUrl: url, inputs: "memberID=\(memberID)"), willDelay: false)
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
    
    func keyboardWasShown (notification: NSNotification) {
        var info = notification.userInfo
        let keyboardFrame = (info![UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
        
        tableView.contentInset = UIEdgeInsetsMake(0, 0, (keyboardFrame?.height)!, 0)
        tableView.scrollIndicatorInsets = tableView.contentInset
    }
    
    func keyboardWillBeHidden (notification: NSNotification) {
        tableView.contentInset = UIEdgeInsets.zero
        tableView.scrollIndicatorInsets = UIEdgeInsets.zero
    }
    
    func showEditing() {
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
    
    func isHome() -> Bool {
        return popIndexPath != nil ? popIndexPath == leftSideIndex : false
    }
    
    func isAway() -> Bool {
        return popIndexPath == rightSideIndex
    }
    
    func isSubject() -> Bool {
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
            if popIndexPath.row == 2 {
                if (indexPath.row == (items.count + 2)) {
                    // nothing
                } else if (indexPath.row == (items.count + 1)) {
                    switchCustomeSubject = !switchCustomeSubject
                    let customSubjectIndex = IndexPath(item: items.count + 2, section: 0)
                    tableView.reloadRows(at: [customSubjectIndex], with: .fade)
                    customeSubjectText.becomeFirstResponder()
                    tableView.scrollToRow(at: customSubjectIndex, at: UITableViewScrollPosition.bottom, animated: true)
                } else if (indexPath.row == items.count) {
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
            }
        }
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
    
    func updateAndPopViewController(subjectName : String) {
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
            if (indexPath.row == (items.count + 2)) {
                if !switchCustomeSubject {
                    return 0
                }
            }
        }
        return 44
    }
    
    func isSelf() -> Bool {
        return segmentIndex == 2
    }
    
    func isPrivate() -> Bool {
        return segmentIndex == 0
    }
    
    func isPublic() -> Bool {
        return segmentIndex == 1 || segmentIndex == 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !listMode {
            if ((popIndexPath.row == 3 || popIndexPath.row == 4) || (popIndexPath.row == 2 && isSelf())) {
                return items.count
            } else {
                return items.count + 3
            }
        } else {
            if isFollower {
                return followers.count
            } else if isFollowing {
                return following.count
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
                if (indexPath.row == (items.count + 2)) {
                    let view = UIView()
                    view.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: globalHeight)
                    view.addSubview(customeSubjectText)
                    customeSubjectText.frame = CGRect(x: 0, y: 0, width: view.frame.width * 4 / 5, height: globalHeight)
                    customeSubjectText.placeholder = "Enter custom subject..."
                    customeSubjectText.autocapitalizationType = .allCharacters
                    view.addSubview(saveButton)
                    saveButton.frame = CGRect(x: view.frame.width * 4 / 5, y: 0, width: view.frame.width * 1 / 5, height: globalHeight)
                    saveButton.addTarget(self, action: #selector(self.save), for: UIControlEvents.touchUpInside)
                    saveButton.backgroundColor = navAndTabColor
                    saveButton.layer.borderWidth = 0
                    saveButton.setTitleColor(UIColor.white, for: UIControlState())
                    cell.addSubview(view)
                    cell.isHidden = !switchCustomeSubject
                } else if (indexPath.row == (items.count + 1)) {
                    cell.textLabel?.text = customSubjectLabel
                } else if (indexPath.row == items.count) {
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
            }
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            return cell
        }
    }
    
    func save() {
        updateAndPopViewController(subjectName: customeSubjectText.text!)
    }
    
    let customeSubjectText: UITextField = UpdateProgressController.textField()
    let saveButton = FeedCell.buttonForTitleWithBorder("Save", imageName: "")
}
