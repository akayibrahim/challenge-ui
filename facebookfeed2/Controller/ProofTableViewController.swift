//
//  SelectionTableViewController.swift
//  facebookfeed2
//
//  Created by iakay on 27.03.2018.
//  Copyright © 2018 challenge. All rights reserved.
//

import UIKit

class ProofTableViewController : UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    let screenSize = UIScreen.main.bounds
    var tableTitle : String!
    var tableView : UITableView!
    var proofs = [Proofs]()
    var proofCellView = ProofCellView()
    var bottomConstraint: NSLayoutConstraint?
    var heightOfCommentView : CGFloat = 50
    var challengeId : String!
    var refreshControl : UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height), style: UITableViewStyle.plain)
        self.tableView.register(CommentCellView.self, forCellReuseIdentifier: "LabelCell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.addSubview(proofCellView)
        self.view.addSubview(tableView)
        navigationItem.title = tableTitle
        view.addSubview(messageInputContainerView)
        messageInputContainerView.widthAnchor.constraint(equalToConstant: screenWidth).isActive = true
        messageInputContainerView.heightAnchor.constraint(equalToConstant: heightOfCommentView).isActive = true
        messageInputContainerView.translatesAutoresizingMaskIntoConstraints = false
        bottomConstraint = NSLayoutConstraint(item: messageInputContainerView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
        view.addConstraint(bottomConstraint!)
        setupInputComponents()        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        self.hideKeyboardWhenTappedAround()
        loadChallenges()
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.onRefresh), for: UIControlEvents.valueChanged)
        tableView?.addSubview(refreshControl)
    }
    
    func loadChallenges() {
        if dummyServiceCall == false {
            fetchData(url: getProofInfoListByChallengeURL)
        } else {
            self.proofs = ServiceLocator.getProofsFromDummy(jsonFileName: "comments")
        }
    }
    
    func onRefresh() {
        loadChallenges()
        refreshControl.endRefreshing()
    }
    
    func fetchData(url: String) {
        let jsonURL = URL(string: url + self.challengeId)!
        jsonURL.get { data, response, error in
            guard
                let returnData = data,
                let postsArray = try? JSONSerialization.jsonObject(with: returnData, options: .mutableContainers) as? [[String: AnyObject]]
                else {
                    self.popupAlert(message: ServiceLocator.getErrorMessage(data: data!), willDelay: false)
                    return
            }
            DispatchQueue.main.async {
                self.proofs = [Proofs]()
                for postDictionary in postsArray! {
                    let proof = Proofs()
                    proof.setValuesForKeys(postDictionary)
                    self.proofs.append(proof)
                }
                self.tableView?.reloadData()
            }
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let fixedWidth = textView.frame.size.width
        textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        var newFrame = textView.frame
        newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
        textView.frame = newFrame
    }
    
    func handleKeyboardNotification(notification: NSNotification) {
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
    
    let messageInputContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    
    let inputTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Add a proof..."
        return textField
    }()
    
    let sendButton: UIButton = {
        let button = UIButton(type: UIButtonType.system)
        button.setTitle("Send", for: .normal)
        let titleColor = UIColor(red: 0, green: 137/255, blue: 249/255, alpha: 1)
        button.setTitleColor(titleColor, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        return button
    }()
    
    let proofImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = UIColor.blue
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    let profileImageView: UIImageView = FeedCell().profileImageView
    let addProofBtn = FeedCell.subClasssButtonForTitle("Add your proof..", imageName: "")
    
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
    
    func addProof() {
        imagePickerForProofUpload()
    }
    
    let imagePickerController = UIImagePickerController()
    func imagePickerForProofUpload() {
        imagePickerController.delegate = self
        imagePickerController.sourceType = UIImagePickerControllerSourceType.savedPhotosAlbum
        imagePickerController.allowsEditing = false
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            proofImageView.image = pickedImage
            proofImageView.alpha = 1
        }
        dismiss(animated: true, completion: nil)
    }
    
    func sendProof() {
        if proofImageView.image == nil {
            popupAlert(message: "You have to add your poor first.", willDelay: false)
            return
        }
        let parameters = ["challengeId": challengeId as String, "memberId": memberID as String]
        let urlOfUpload = URL(string: uploadImageURL)!
        let requestOfUpload = ServiceLocator.prepareRequestForMedia(url: urlOfUpload, parameters: parameters, image: self.proofImageView.image!)
        
        URLSession.shared.dataTask(with: requestOfUpload, completionHandler: { (data, response, error) -> Void in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    self.popupAlert(message: "Your Proof Added!", willDelay: true)
                } else {
                    let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
                    if let responseJSON = responseJSON as? [String: Any] {
                        print(responseJSON)
                        if responseJSON["message"] != nil {
                            self.popupAlert(message: responseJSON["message"] as! String, willDelay: false)
                            return
                        }
                    }
                }
            }
        }).resume()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    let heighForRow : CGFloat = (screenWidth * 0.7 / 10) + (screenWidth / 2) + (screenWidth * 0.1 / 2)
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return heighForRow
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return proofs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath as IndexPath) as! CommentCellView
        let frameOfCell : CGRect = CGRect(x: 0, y: 0, width: self.view.frame.width, height: heighForRow)
        let cell = ProofCellView(frame: frameOfCell, cellRow: indexPath.row)
        let nameAtt = NSMutableAttributedString(string: "\(String(describing: proofs[indexPath.row].name!))", attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14)])
        cell.thinksAboutChallengeView.attributedText = nameAtt
        let fbID = proofs[indexPath.item].fbID
        setImage(fbID: fbID, imageView: cell.profileImageView)
        getProofImageByObjectId(imageView: cell.proofImageView, objectId: proofs[indexPath.item].proofObjectId!)
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 44
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // scrollView.keyboardDismissMode = .interactive
    }
}
