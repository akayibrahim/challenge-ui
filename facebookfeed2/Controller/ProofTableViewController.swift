//
//  SelectionTableViewController.swift
//  facebookfeed2
//
//  Created by iakay on 27.03.2018.
//  Copyright © 2018 challenge. All rights reserved.
//

import UIKit
import AVKit
import YPImagePicker

class ProofTableViewController : UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIGestureRecognizerDelegate {
    @objc let screenSize = UIScreen.main.bounds
    @objc var tableTitle : String!
    @objc var tableView : UITableView!
    @objc var proofs = [Prove]()
    @objc var proofCellView = ProofCellView()
    @objc var bottomConstraint: NSLayoutConstraint?
    @objc var heightOfCommentView : CGFloat = 50
    @objc var challengeId : String!
    @objc var refreshControl : UIRefreshControl!
    @objc var currentPage : Int = 0
    @objc var nowMoreData: Bool = false
    @objc var proofed: Bool = false
    @objc var canJoin: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height), style: UITableViewStyle.plain)
        self.tableView.register(ProofCellView.self, forCellReuseIdentifier: "ProofCell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        tableView.tableFooterView = UIView()
        self.view.addSubview(tableView)
        navigationItem.title = tableTitle
        view.addSubview(messageInputContainerView)
        messageInputContainerView.widthAnchor.constraint(equalToConstant: screenWidth).isActive = true
        messageInputContainerView.heightAnchor.constraint(equalToConstant: heightOfCommentView).isActive = true
        messageInputContainerView.translatesAutoresizingMaskIntoConstraints = false
        bottomConstraint = NSLayoutConstraint(item: messageInputContainerView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
        view.addConstraint(bottomConstraint!)
        messageInputContainerView.alpha = 0
        if canJoin {
            let joinButton = UIBarButtonItem(title: "Join", style: UIBarButtonItemStyle.plain, target: self, action: #selector(joinChallenge))
            navigationItem.rightBarButtonItem = joinButton
        } else if !proofed {
            messageInputContainerView.alpha = 1
            setupInputComponents()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        self.hideKeyboardWhenTappedAround()
        loadChallenges()
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.onRefresh), for: UIControlEvents.valueChanged)
        tableView?.addSubview(refreshControl)
        
        if self.tabBarController?.selectedIndex == profileIndex {
            Util.removeForwardChange();
        }
    }
    
    @objc func joinChallenge() {
        if Util.controlNetwork() {
            return
        }
        joinToChallengeService(challengeId: challengeId)
    }
    
    @objc func joinToChallengeService(challengeId: String) {
        let json: [String: Any] = ["challengeId": challengeId,
                                   "memberId": memberID,
                                   "join": true
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
                DispatchQueue.main.async { // Correct
                    self.messageInputContainerView.alpha = 1
                    self.setupInputComponents()
                    self.navigationItem.rightBarButtonItem = nil
                    let forwardChange = Util.getForwardChange();
                    Util.addForwardChange(forwardChange: ForwardChange(index: forwardChange.index!, forwardScreen: forwardChange.forwardScreen!, viewProofsCount: forwardChange.viewProofsCount!, joined: false, proved: forwardChange.proved!))
                }
            }
        }).resume()
    }
    
    @objc func loadChallenges() {
        if dummyServiceCall == false {
            if Util.controlNetwork() {
                return
            }
            self.fetchData(url: getProofInfoListByChallengeURL)
        } else {
            self.proofs = ServiceLocator.getProofsFromDummy(jsonFileName: "comments")
        }
    }
    
    @objc func onRefresh() {
        reloadPage()
        refreshControl.endRefreshing()
    }
    
    @objc func reloadPage() {
        currentPage = 0
        self.proofs = [Prove]()
        self.loadChallenges()
    }
    
    @objc func fetchData(url: String) {
        let jsonURL = URL(string: url + self.challengeId + "&page=\(currentPage)")!
        jsonURL.get { data, response, error in
            guard
                let returnData = data,
                let postsArray = try? JSONSerialization.jsonObject(with: returnData, options: .mutableContainers) as? [[String: AnyObject]]
                else {
                    self.popupAlert(message: ServiceLocator.getErrorMessage(data: data!, chlId: self.challengeId, sUrl: url, inputs: "challengeId=\(self.challengeId)"), willDelay: false)
                    return
            }
            self.nowMoreData = postsArray?.count == 0 ? true : false
            for postDictionary in postsArray! {
                let proof = Prove()
                proof.provedWithImage = postDictionary["provedWithImage"] as? Bool
                proof.setValuesForKeys(postDictionary)
                self.proofs.append(proof)
            }
            DispatchQueue.main.async {
                if self.nowMoreData == false {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    @objc func handleKeyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let keyboardFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
            let isKeyboardShowing = notification.name == NSNotification.Name.UIKeyboardWillShow
            bottomConstraint?.constant = isKeyboardShowing ? -keyboardFrame!.height : 0
            UIView.animate(withDuration: 0, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                self.view.layoutIfNeeded()
            }, completion: { (completed) in
                if isKeyboardShowing {
                    let indexPath = IndexPath(item: self.proofs.count - 1, section: 0)
                    self.tableView?.scrollToRow(at: indexPath as IndexPath, at: .bottom, animated: true)
                }
            })
        }
    }
    
    @objc let messageInputContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    
    @objc let inputTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Add a proof..."
        return textField
    }()
    
    @objc let sendButton: UIButton = {
        let button = UIButton(type: UIButtonType.system)
        button.setTitle("Send", for: .normal)
        let titleColor = UIColor(red: 0, green: 137/255, blue: 249/255, alpha: 1)
        button.setTitleColor(titleColor, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        return button
    }()
    
    @objc let proofImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = UIColor.blue
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    @objc let profileImageView: UIImageView = FeedCell().profileImageView
    @objc let addProofBtn = FeedCell.subClasssButtonForTitle("Add your proof..", imageName: "")
    
    private func setupInputComponents() {
        let topBorderView = UIView()
        topBorderView.backgroundColor = UIColor(white: 1, alpha: 0.5)
        topBorderView.layer.borderColor = UIColor.gray.cgColor
        topBorderView.layer.borderWidth = 0.25
        
        messageInputContainerView.addSubview(topBorderView)
        messageInputContainerView.addSubview(profileImageView)
        messageInputContainerView.addSubview(addProofBtn)
        messageInputContainerView.addSubview(proofImageView)
        messageInputContainerView.addSubview(sendButton)
        
        topBorderView.widthAnchor.constraint(equalToConstant: screenWidth).isActive = true
        topBorderView.heightAnchor.constraint(equalToConstant: heightOfCommentView).isActive = true
        topBorderView.bottomAnchor.constraint(equalTo: messageInputContainerView.bottomAnchor, constant: 0).isActive = true
        topBorderView.translatesAutoresizingMaskIntoConstraints = false
        
        profileImageView.centerYAnchor.constraint(equalTo: topBorderView.centerYAnchor).isActive = true
        profileImageView.leadingAnchor.constraint(equalTo: topBorderView.leadingAnchor, constant : screenWidth * 0.2 / 10).isActive = true
        setImage(fbID: memberFbID, imageView: profileImageView)
        profileImageView.layer.cornerRadius = screenWidth * 1.1 / 10 / 2
        profileImageView.widthAnchor.constraint(equalToConstant: screenWidth * 1.1 / 10).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: screenWidth * 1.1 / 10).isActive = true
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        
        addProofBtn.centerYAnchor.constraint(equalTo: topBorderView.centerYAnchor).isActive = true
        addProofBtn.leadingAnchor.constraint(equalTo: topBorderView.leadingAnchor, constant : (screenWidth * 1.7 / 10)).isActive = true
        addProofBtn.widthAnchor.constraint(equalToConstant: screenWidth * 4 / 10).isActive = true
        addProofBtn.heightAnchor.constraint(equalToConstant: screenWidth * 0.9 / 10).isActive = true
        addProofBtn.translatesAutoresizingMaskIntoConstraints = false
        addProofBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        addProofBtn.setTitleColor(UIColor.white, for: UIControlState())
        addProofBtn.layer.backgroundColor = navAndTabColor.cgColor
        addProofBtn.layer.cornerRadius = 5.0
        addProofBtn.clipsToBounds = true
        addProofBtn.addTarget(self, action: #selector(self.addProof), for: UIControlEvents.touchUpInside)
        addProofBtn.titleLabel?.adjustsFontSizeToFitWidth = true
        
        proofImageView.centerYAnchor.constraint(equalTo: topBorderView.centerYAnchor).isActive = true
        proofImageView.trailingAnchor.constraint(equalTo: topBorderView.trailingAnchor, constant : -(screenWidth * 1.8 / 10)).isActive = true
        proofImageView.widthAnchor.constraint(equalToConstant: screenWidth * 2 / 10).isActive = true
        proofImageView.heightAnchor.constraint(equalToConstant: screenWidth * 1 / 10).isActive = true
        proofImageView.translatesAutoresizingMaskIntoConstraints = false
        proofImageView.alpha = 0
        
        sendButton.centerYAnchor.constraint(equalTo: topBorderView.centerYAnchor).isActive = true
        sendButton.trailingAnchor.constraint(equalTo: topBorderView.trailingAnchor, constant : -(screenWidth * 0.2 / 10)).isActive = true
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.widthAnchor.constraint(equalToConstant: screenWidth * 1.5 / 10).isActive = true
        sendButton.heightAnchor.constraint(equalToConstant: globalHeight).isActive = true
        sendButton.addTarget(self, action: #selector(self.sendProof), for: UIControlEvents.touchUpInside)
    }
    
    @objc func addProof() {
        imagePickerForProofUpload()
    }
    
    @objc var videoURL: NSURL?
    @objc var isImg: Bool = true
    @objc let imagePickerController = UIImagePickerController()
    @objc func imagePickerForProofUpload() {
        let picker = YPImagePicker(configuration: Util.conficOfYpImagePicker())
        picker.didFinishPicking { [unowned picker] items, cancelled in
            for item in items {
                switch item {
                case .photo(let photo):
                    self.proofImageView.image = photo.modifiedImage
                    self.proofImageView.alpha = 1
                    self.isImg = true
                case .video(let video):
                    self.videoURL = video.url as NSURL
                    self.proofImageView.image = video.thumbnail
                    self.proofImageView.alpha = 1
                    self.isImg = false
                }
            }
            picker.dismiss(animated: true, completion: nil)
        }
        present(picker, animated: true, completion: nil)
        /*imagePickerController.delegate = self
        imagePickerController.sourceType = UIImagePickerControllerSourceType.savedPhotosAlbum
        imagePickerController.allowsEditing = false
        self.present(imagePickerController, animated: true, completion: nil)*/
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            proofImageView.image = pickedImage
            proofImageView.alpha = 1
        }
        dismiss(animated: true, completion: nil)
    }
    
    @objc func sendProof() {
        if Util.controlNetwork() {
            return
        }
        if proofImageView.image == nil {
            popupAlert(message: "You have to add your prove first.", willDelay: false)
            return
        }
        let parameters = ["challengeId": challengeId as String, "memberId": memberID as String]
        let urlOfUpload = URL(string: uploadImageURL)!
        var requestOfUpload: URLRequest?
        if self.isImg {
            requestOfUpload = ServiceLocator.prepareRequestForMedia(url: urlOfUpload, parameters: parameters, image: self.proofImageView.image!)
        } else {
            requestOfUpload = ServiceLocator.prepareRequestForVideo(url: urlOfUpload, parameters: parameters, videoUrl: videoURL!)
        }
        group.enter()
        self.sendButton.alpha = 0
        URLSession.shared.dataTask(with: requestOfUpload!, completionHandler: { (data, response, error) -> Void in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    self.group.leave()
                    self.reloadPage()
                    let forwardChange = Util.getForwardChange();
                    if forwardChange.forwardScreen != "" {
                        Util.addForwardChange(forwardChange: ForwardChange(index: forwardChange.index!, forwardScreen: forwardChange.forwardScreen!, viewProofsCount: forwardChange.viewProofsCount! + 1, joined: forwardChange.joined!, proved: true))
                    }
                    self.group.wait()
                    self.popupAlert(message: "ADDED!", willDelay: true)
                } else {
                    let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
                    if let responseJSON = responseJSON as? [String: Any] {
                        print(responseJSON)
                        if responseJSON["message"] != nil {
                            self.popupAlert(message: responseJSON["message"] as! String, willDelay: false)
                            self.sendButton.alpha = 1
                            return
                        }
                    }
                }
            }
        }).resume()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let checkPoint = proofs.count - 1
        let shouldLoadMore = checkPoint == indexPath.row
        if shouldLoadMore && !nowMoreData && !dummyServiceCall {
            currentPage += 1
            self.loadChallenges()
        }
    }
    
    @objc let heighForRow : CGFloat = (screenWidth * 0.7 / 10) + (screenWidth / 2) + (screenWidth * 0.1 / 2)
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return heighForRow
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return proofs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProofCell", for: indexPath as IndexPath) as! ProofCellView
        // let frameOfCell : CGRect = CGRect(x: 0, y: 0, width: self.view.frame.width, height: heighForRow)
        // let cell = ProofCellView(frame: frameOfCell, cellRow: indexPath.row)
        if self.proofs.count == 0 {
            return cell
        }
        DispatchQueue.main.async {
            let nameAtt = NSMutableAttributedString(string: "\(String(describing: self.proofs[indexPath.row].name!))", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14)])
            cell.thinksAboutChallengeView.attributedText = nameAtt
            let fbID = self.proofs[indexPath.item].fbID
            self.setImage(fbID: fbID, imageView: cell.profileImageView)
            if let proofObjectId = self.proofs[indexPath.item].proofObjectId {
                if self.proofs[indexPath.item].provedWithImage! {
                    self.getProofImageByObjectId(imageView: cell.proofImageView, objectId: proofObjectId) {
                        image in
                        if image != nil {
                            cell.proofImageView.image = image
                            cell.proofImageView.alpha = 1
                        }
                    }
                } else {
                    // var video: Data?
                    //self.group.enter()
                    // let params = "?challengeId=\(self.challengeId!)&memberId=\(self.proofs[indexPath.row].memberId!)"
                    // let urlV = URL(string: downloadVideoURL + params)
                    self.getVideo(challengeId: self.challengeId!, challengerId: self.proofs[indexPath.item].memberId!) {
                        video in
                        if let vid = video {
                            let avPlayer = AVPlayer.init()
                            avPlayer.replaceCurrentItem(with: AVPlayerItem.init(url: vid))
                            avPlayer.volume = volume
                            cell.avPlayerLayer.player = avPlayer
                            cell.avPlayerLayer.player?.play()
                            //self.group.leave()
                        }
                    }
                    //self.group.wait()
                    //let url = URL(fileURLWithPath:  + ".mov")
                    cell.proofedVideoView.alpha = 1
                    cell.volumeUpImageView.alpha = 0
                    cell.volumeDownImageView.alpha = 1
                }
            }
        }
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(profileImageTapped(tapGestureRecognizer:)))
        cell.profileImageView.tag = indexPath.row
        cell.profileImageView.isUserInteractionEnabled = true
        cell.profileImageView.addGestureRecognizer(tapGestureRecognizer)
        
        let tapGestureRecognizerName = UITapGestureRecognizer(target: self, action: #selector(profileImageTappedName(tapGestureRecognizer:)))
        cell.thinksAboutChallengeView.tag = indexPath.row
        cell.thinksAboutChallengeView.isUserInteractionEnabled = true
        cell.thinksAboutChallengeView.addGestureRecognizer(tapGestureRecognizerName)
        
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(zoom))
        pinch.delegate = self
        cell.proofImageView.isUserInteractionEnabled = true
        cell.proofImageView.addGestureRecognizer(pinch)
        
        let myPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(pan)) //Update: July 18, 2016 for Xcode 7.3.1(Swift 2.2)
        myPanGestureRecognizer.delegate = self
        cell.proofImageView.addGestureRecognizer(myPanGestureRecognizer)
        cell.proofImageView.layer.zPosition = 1
        
        return cell
    }
    
    // var avPlayer : AVPlayer = AVPlayer.init()
    @objc var isZooming = false
    var originalImageCenter: CGPoint?
    @objc func pan(sender: UIPanGestureRecognizer) {
        if self.isZooming && sender.state == .began {
            self.originalImageCenter = sender.view?.center
        } else if self.isZooming && sender.state == .changed {
            let translation = sender.translation(in: sender.view)
            // note: 'view' is optional and need to be unwrapped
            if !((sender.view?.frame.minX)! <= CGFloat(-32) && (sender.view?.frame.maxX)! >= self.view.frame.maxX + 32) {
            }
            sender.view!.center = CGPoint(x: sender.view!.center.x + translation.x, y: sender.view!.center.y + translation.y)
            sender.setTranslation(CGPoint.zero, in: self.view.superview)
        }
    }
    
    var lastScale:CGFloat!
    @objc func zoom(sender:UIPinchGestureRecognizer) {
        let postImage = sender.view as! UIImageView
        if(sender.state == .began) {
            // Reset the last scale, necessary if there are multiple objects with different scales
            lastScale = sender.scale
            self.tableView?.isScrollEnabled = false
        } else if (sender.state == .changed) {
            self.isZooming = true
            let currentScale = sender.view!.layer.value(forKeyPath:"transform.scale")! as! CGFloat
            // Constants to adjust the max/min values of zoom
            let kMaxScale:CGFloat = 2.5
            let kMinScale:CGFloat = 2.0
            var newScale = 1 -  (lastScale - sender.scale)
            newScale = min(newScale, kMaxScale / currentScale)
            newScale = max(newScale, kMinScale / currentScale)
            let transform = (sender.view?.transform)!.scaledBy(x: newScale, y: newScale);
            sender.view?.transform = transform
            lastScale = sender.scale  // Store the previous scale factor for the next pinch gesture call
        } else if sender.state == .ended || sender.state == .failed || sender.state == .cancelled {
            guard let center = self.originalImageCenter else {return}
            UIView.animate(withDuration: 0.3, animations: {
                postImage.transform = CGAffineTransform.identity
                postImage.center = center
            }, completion: { _ in
                self.isZooming = false
            })
            self.tableView?.isScrollEnabled = true
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    @objc func profileImageTappedName(tapGestureRecognizer: UITapGestureRecognizer) {
        let tappedImage = tapGestureRecognizer.view as! UITextView
        openProfile(name: proofs[tappedImage.tag].name!, memberId: proofs[tappedImage.tag].memberId!, memberFbId: proofs[tappedImage.tag].fbID!)
    }
    
    @objc func profileImageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        openProfile(name: proofs[tappedImage.tag].name!, memberId: proofs[tappedImage.tag].memberId!, memberFbId: proofs[tappedImage.tag].fbID!)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 44
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // scrollView.keyboardDismissMode = .interactive
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
                    ServiceLocator.logErrorMessage(data: data!, chlId: "", sUrl: getMemberInfoURL, inputs: "memberID=\(memberId)")                    
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
