//
//  SelectionTableViewController.swift
//  facebookfeed2
//
//  Created by iakay on 27.03.2018.
//  Copyright © 2018 challenge. All rights reserved.
//

import UIKit

class CommentTableViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    @objc let screenSize = UIScreen.main.bounds
    @objc var tableTitle : String!
    @objc var tableView : UITableView!
    @objc var comments = [Comments]()
    @objc var commentCellView = CommentCellView()
    @objc var bottomConstraint: NSLayoutConstraint?
    @objc var heightOfCommentView : CGFloat = 50
    @objc var challengeId : String!
    @objc var refreshControl : UIRefreshControl!
    @objc var commentedMemberId: String!
    @objc var currentPage : Int = 0
    @objc var nowMoreData: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height), style: UITableViewStyle.plain)
        self.tableView.register(CommentCellView.self, forCellReuseIdentifier: "LabelCell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        tableView.tableFooterView = UIView()        
        self.view.addSubview(tableView)
        navigationItem.title = tableTitle
        view.addSubview(messageInputContainerView)
        messageInputContainerView.widthAnchor.constraint(equalToConstant: screenWidth).isActive = true
        messageInputContainerView.heightAnchor.constraint(equalToConstant: heightOfCommentView + 10).isActive = true
        messageInputContainerView.translatesAutoresizingMaskIntoConstraints = false
        bottomConstraint = NSLayoutConstraint(item: messageInputContainerView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
        view.addConstraint(bottomConstraint!)
        setupInputComponents()        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        self.hideKeyboardWhenTappedAround()
        self.textView.delegate = self
        loadChallenges()
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.onRefresh), for: UIControlEvents.valueChanged)
        tableView?.addSubview(refreshControl)
    }
    
    @objc func loadChallenges() {
        if dummyServiceCall == false {
            fetchData(url: getCommentsURL)
        } else {
            self.comments = ServiceLocator.getCommentFromDummy(jsonFileName: "comments")
        }
    }
    
    @objc func onRefresh() {
        reloadPage()
        refreshControl.endRefreshing()
    }
    
    @objc func reloadPage() {
        currentPage = 0
        self.comments = [Comments]()
        self.loadChallenges()
    }
    
    @objc func fetchData(url: String) {
        let jsonURL = URL(string: url + self.challengeId + "&page=\(currentPage)")!
        jsonURL.get { data, response, error in
            guard
                let returnData = data,
                let postsArray = try? JSONSerialization.jsonObject(with: returnData, options: .mutableContainers) as? [[String: AnyObject]]
                else {
                    if data != nil {
                        self.popupAlert(message: ServiceLocator.getErrorMessage(data: data!, chlId: self.challengeId, sUrl: url, inputs: "challengeId=\(self.challengeId)"), willDelay: false)
                    }
                    return
            }
            self.nowMoreData = postsArray?.count == 0 ? true : false
            DispatchQueue.main.async {
                for postDictionary in postsArray! {
                    let comment = Comments()
                    comment.setValuesForKeys(postDictionary)
                    self.comments.append(comment)
                }
                self.tableView?.reloadData()
                self.scrollToLastRow()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let checkPoint = comments.count - 1
        let shouldLoadMore = checkPoint == indexPath.row
        if shouldLoadMore && !nowMoreData && !dummyServiceCall {
            currentPage += 1
            self.loadChallenges()
        }
    }
    
    @objc var tableBottomHeight : CGFloat = 0
    @objc func handleKeyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let keyboardFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
            let isKeyboardShowing = notification.name == NSNotification.Name.UIKeyboardWillShow
            bottomConstraint?.constant = isKeyboardShowing ? -keyboardFrame!.height : 0
            self.tableView.frame.size.height = (keyboardFrame?.origin.y)! - (self.textView.frame.height + 10)
            if !isKeyboardShowing {
            }
            tableBottomHeight = (keyboardFrame?.origin.y)!
            self.scrollToLastRow()
            
            /*
            UIView.animate(withDuration: 0, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                self.view.layoutIfNeeded()
            }, completion: { (completed) in
             
            })
             */
        }
    }
    
    override func textViewDidChange(_ textView: UITextView) {
        let size = CGSize(width: textView.frame.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        textView.constraints.forEach{ (constraint) in
            if constraint.firstAttribute == .height {
                constraint.constant = estimatedSize.height
                self.tableView.frame.size.height = tableBottomHeight - 10 - estimatedSize.height
            }
        }
    }
    
    @objc func scrollToLastRow() {
        if self.comments.count != 0 {
            let indexPath = IndexPath(item: self.comments.count - 1, section: 0)
            self.tableView?.scrollToRow(at: indexPath as IndexPath, at: .bottom, animated: true)
        }
    }
    
    @objc let messageInputContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    
    @objc let sendButton: UIButton = {
        let button = UIButton(type: UIButtonType.system)
        button.setTitle("Send", for: .normal)
        let titleColor = UIColor(red: 0, green: 137/255, blue: 249/255, alpha: 1)
        button.setTitleColor(titleColor, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        return button
    }()
    
    @objc let profileImageView: UIImageView = FeedCell().profileImageView
    
    private func setupInputComponents() {
        profileImageView.removeFromSuperview()
        textView.removeFromSuperview()
        sendButton.removeFromSuperview()
        
        messageInputContainerView.addSubview(profileImageView)
        messageInputContainerView.addSubview(textView)
        messageInputContainerView.addSubview(sendButton)
        
        // profileImageView.centerYAnchor.constraint(equalTo: messageInputContainerView.centerYAnchor).isActive = true
        profileImageView.bottomAnchor.constraint(equalTo: textView.bottomAnchor, constant: 0).isActive = true
        profileImageView.leadingAnchor.constraint(equalTo: messageInputContainerView.leadingAnchor, constant : screenWidth * 0.2 / 10).isActive = true
        setImage(fbID: memberFbID, imageView: profileImageView)
        profileImageView.layer.cornerRadius = screenWidth * 1.1 / 10 / 2
        profileImageView.widthAnchor.constraint(equalToConstant: screenWidth * 1.1 / 10).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: screenWidth * 1.1 / 10).isActive = true
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        
        // textView.centerYAnchor.constraint(equalTo: topBorderView.centerYAnchor).isActive = true
        textView.bottomAnchor.constraint(equalTo: messageInputContainerView.bottomAnchor, constant: -(screenWidth * 0.2 / 10)).isActive = true
        textView.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant : screenWidth * 0.2 / 10).isActive = true
        textView.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant : screenWidth * 0 / 10).isActive = true
        // textView.widthAnchor.constraint(equalToConstant: screenWidth * 6.8 / 10).isActive = true
        textView.heightAnchor.constraint(equalToConstant: heightOfCommentView - 10).isActive = true
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        sendButton.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor).isActive = true
        sendButton.trailingAnchor.constraint(equalTo: messageInputContainerView.trailingAnchor, constant : -(screenWidth * 0.2 / 10)).isActive = true
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.widthAnchor.constraint(equalToConstant: screenWidth * 1.5 / 10).isActive = true
        sendButton.heightAnchor.constraint(equalToConstant: globalHeight).isActive = true
        sendButton.addTarget(self, action: #selector(self.addComment), for: UIControlEvents.touchUpInside)
    }
    
    @objc func addComment() {
        if textView.text == addComents {
            self.popupAlert(message: "Please enter your comment!", willDelay: false)
        }
        var json: [String: Any] = ["challengeId": self.challengeId,
                                   "memberId": memberID,
                                   "commentedMemberId": commentedMemberId
        ]
        json["comment"] = self.textView.text
        let url = URL(string: commentToChallangeURL)!
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
            }
            // self.popupAlert(message: "Comment Added!", willDelay: true)
            DispatchQueue.main.async {
                self.refreshControl.beginRefreshingManually()
                self.onRefresh()
                self.setupInputComponents()
                self.setTextViewToDefault()
                self.scrollToLastRow()
                let forwardChange = Util.getForwardChange();
                Util.addForwardChange(forwardChange: ForwardChange(index: forwardChange.index!, forwardScreen: forwardChange.forwardScreen!, viewCommentsCount: forwardChange.viewCommentsCount! + 1))
            }
        }).resume()
    }
    
    @objc let heighForRow : CGFloat = UIScreen.main.bounds.width * 0.9 / 10
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let thinksAboutChl = comments[indexPath.item].comment
        if let thinksAboutChallenge = thinksAboutChl {
            let rect = NSString(string: thinksAboutChallenge).boundingRect(with: CGSize(width: view.frame.width, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12)], context: nil)
            return rect.height + heighForRow
        }
        return heighForRow
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath as IndexPath) as! CommentCellView
        // let frameOfCell : CGRect = CGRect(x: 0, y: 0, width: self.view.frame.width, height: heighForRow)
        // let cell = CommentCellView(frame: frameOfCell, cellRow: indexPath.row)
        let fbID = comments[indexPath.item].fbID
        cell.thinksAboutChallengeView.attributedText = getCommentText(indexPath: indexPath)
        setImage(fbID: fbID, imageView: cell.profileImageView)
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(profileImageTapped(tapGestureRecognizer:)))
        cell.profileImageView.tag = indexPath.row
        cell.profileImageView.isUserInteractionEnabled = true
        cell.profileImageView.addGestureRecognizer(tapGestureRecognizer)
        
        let tapGestureRecognizerName = UITapGestureRecognizer(target: self, action: #selector(profileImageTappedName(tapGestureRecognizer:)))
        cell.thinksAboutChallengeView.tag = indexPath.row
        cell.thinksAboutChallengeView.isUserInteractionEnabled = true
        cell.thinksAboutChallengeView.addGestureRecognizer(tapGestureRecognizerName)
        return cell
    }
    
    @objc func getCommentText(indexPath:IndexPath) -> NSMutableAttributedString {
        let commentAtt = NSMutableAttributedString(string: "\(String(describing: comments[indexPath.row].name!)): ", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 12)])
        let nameAtt = NSMutableAttributedString(string: "\(String(describing: comments[indexPath.row].comment!))", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12)])
        commentAtt.append(nameAtt)
        return commentAtt
    }
    
    @objc func profileImageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        openProfile(name: comments[tappedImage.tag].name!, memberId: comments[tappedImage.tag].memberId!, memberFbId: comments[tappedImage.tag].fbID!)
    }
    
    @objc func profileImageTappedName(tapGestureRecognizer: UITapGestureRecognizer) {
        let textview = tapGestureRecognizer.view as! UITextView
        let textRange = NSMakeRange(0, (comments[textview.tag].name?.count)!)
        if tapGestureRecognizer.didTapAttributedTextInTextView(label: textview, inRange: textRange) {
            openProfile(name: comments[textview.tag].name!, memberId: comments[textview.tag].memberId!, memberFbId: comments[textview.tag].fbID!)
        }
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 44
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return textView.text.count + (text.count - range.length) <= commentCharacterLimit
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // scrollView.keyboardDismissMode = .interactive
    }
 
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
 
    @objc func setTextViewToDefault() {
        self.textView.text = addComents
        self.textView.textColor = UIColor.lightGray
    }
    
    @objc let textView: UITextView = {
        let textView = UITextView()
        textView.textColor = UIColor.lightGray
        textView.text = addComents
        textView.isScrollEnabled = false
        // textView.showsVerticalScrollIndicator = false
        // textView.font = UIFont.systemFont(ofSize: 16)
        textView.font = UIFont.preferredFont(forTextStyle: .headline)
        // textView.alwaysBounceHorizontal = true
        textView.layer.borderColor = UIColor (red:204.0/255.0, green:204.0/255.0, blue:204.0/255.0, alpha:1.0).cgColor;
        textView.layer.borderWidth = 1.0;
        textView.layer.cornerRadius = 5.0;
        return textView
    }()
    
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
