//
//  SelectionTableViewController.swift
//  facebookfeed2
//
//  Created by iakay on 27.03.2018.
//  Copyright © 2018 challenge. All rights reserved.
//

import UIKit

class CommentTableViewController : UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate {
    let screenSize = UIScreen.main.bounds
    var tableTitle : String!
    var tableView : UITableView!
    var comments = [Comments]()
    var proofs = [Proofs]()
    var commentCellView = CommentCellView()
    var comment : Bool = false
    var proof : Bool = false    
    var bottomConstraint: NSLayoutConstraint?
    var heightOfCommentView : CGFloat = 50
    var challengeId : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height), style: UITableViewStyle.plain)
        self.tableView.register(CommentCellView.self, forCellReuseIdentifier: "LabelCell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.addSubview(commentCellView)
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
        self.textView.delegate = self
        if proof {
            textView.text = "Add a proof..."
        }
        
        if let path = Bundle.main.path(forResource: "comments", ofType: "json") {
            do {
                let data = try(Data(contentsOf: URL(fileURLWithPath: path), options: NSData.ReadingOptions.mappedIfSafe))
                let jsonDictionary = try(JSONSerialization.jsonObject(with: data, options: .mutableContainers)) as? [String: Any]
                if let postsArray = jsonDictionary?["posts"] as? [[String: AnyObject]] {
                    self.comments = [Comments]()
                    self.proofs = [Proofs]()
                    for postDictionary in postsArray {
                        let comment = Comments()
                        let proof = Proofs()
                        comment.setValuesForKeys(postDictionary)
                        self.comments.append(comment)
                        proof.setValuesForKeys(postDictionary)
                        self.proofs.append(proof)
                    }
                }
            } catch let err {
                print(err)
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
                    var indexPath : IndexPath
                    if self.proof {
                        indexPath = IndexPath(item: self.proofs.count - 1, section: 0)
                    } else {
                        indexPath = IndexPath(item: self.comments.count - 1, section: 0)
                    }
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
        textField.placeholder = "Add a comment..."
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
    
    let profileImageView: UIImageView = FeedCell().profileImageView
    
    private func setupInputComponents() {
        let topBorderView = UIView()
        topBorderView.backgroundColor = UIColor(white: 1, alpha: 0.5)
        topBorderView.layer.borderColor = UIColor.gray.cgColor
        topBorderView.layer.borderWidth = 0.25
        
        messageInputContainerView.addSubview(topBorderView)
        messageInputContainerView.addSubview(profileImageView)
        messageInputContainerView.addSubview(textView)
        messageInputContainerView.addSubview(sendButton)
        
        topBorderView.widthAnchor.constraint(equalToConstant: screenWidth).isActive = true
        topBorderView.heightAnchor.constraint(equalToConstant: heightOfCommentView).isActive = true
        topBorderView.bottomAnchor.constraint(equalTo: messageInputContainerView.bottomAnchor, constant: 0).isActive = true
        topBorderView.translatesAutoresizingMaskIntoConstraints = false
        
        profileImageView.centerYAnchor.constraint(equalTo: topBorderView.centerYAnchor).isActive = true
        profileImageView.leadingAnchor.constraint(equalTo: topBorderView.leadingAnchor, constant : screenWidth * 0.2 / 10).isActive = true
        setImage(fbID: memberID, imageView: profileImageView)
        profileImageView.layer.cornerRadius = screenWidth * 1.1 / 10 / 2
        profileImageView.widthAnchor.constraint(equalToConstant: screenWidth * 1.1 / 10).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: screenWidth * 1.1 / 10).isActive = true
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        
        textView.centerYAnchor.constraint(equalTo: topBorderView.centerYAnchor).isActive = true
        textView.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant : screenWidth * 0.2 / 10).isActive = true
        textView.widthAnchor.constraint(equalToConstant: screenWidth * 6.8 / 10).isActive = true
        textView.heightAnchor.constraint(equalToConstant: heightOfCommentView - 10).isActive = true
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        sendButton.centerYAnchor.constraint(equalTo: topBorderView.centerYAnchor).isActive = true
        sendButton.trailingAnchor.constraint(equalTo: topBorderView.trailingAnchor, constant : -(screenWidth * 0.2 / 10)).isActive = true
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.widthAnchor.constraint(equalToConstant: screenWidth * 1.5 / 10).isActive = true
        sendButton.heightAnchor.constraint(equalToConstant: globalHeight).isActive = true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    let heighForRow : CGFloat = UIScreen.main.bounds.width * 0.9 / 10
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var thinksAboutChl : String!
        if comment {
            thinksAboutChl = comments[indexPath.item].comment
        } else if proof {
            thinksAboutChl = proofs[indexPath.item].comment
        }
        if let thinksAboutChallenge = thinksAboutChl {
            let rect = NSString(string: thinksAboutChallenge).boundingRect(with: CGSize(width: view.frame.width, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 12)], context: nil)
            return rect.height + heighForRow
        }
        return heighForRow
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if comment {
            return comments.count
        } else if proof {
            return proofs.count
        }
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath as IndexPath) as! CommentCellView
        let frameOfCell : CGRect = CGRect(x: 0, y: 0, width: self.view.frame.width, height: heighForRow)
        let cell = CommentCellView(frame: frameOfCell, cellRow: indexPath.row)
        var fbID : String!
        if comment {
            let commentAtt = NSMutableAttributedString(string: "\(String(describing: comments[indexPath.row].name!)): ", attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 12)])
            let nameAtt = NSMutableAttributedString(string: "\(String(describing: comments[indexPath.row].comment!))", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 12)])
            commentAtt.append(nameAtt)
            cell.thinksAboutChallengeView.attributedText = commentAtt
            fbID = comments[indexPath.item].fbID
        } else if proof {
            let commentAtt = NSMutableAttributedString(string: "\(String(describing: proofs[indexPath.row].name!)): ", attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 12)])
            let nameAtt = NSMutableAttributedString(string: "\(String(describing: proofs[indexPath.row].comment!))", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 12)])
            commentAtt.append(nameAtt)
            cell.thinksAboutChallengeView.attributedText = commentAtt
            fbID = proofs[indexPath.item].fbID
        }
        setImage(fbID: fbID, imageView: cell.profileImageView)        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 44
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
            if proof {
                textView.text = "Add a proof..."
            } else {
                textView.text = "Add a comment..."
            }
            textView.textColor = UIColor.lightGray
        }
    }
 
    let textView: UITextView = {
        let textView = UITextView()
        textView.textColor = UIColor.lightGray
        textView.text = "Add a comment..."
        textView.isScrollEnabled = true
        textView.showsVerticalScrollIndicator = false
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.alwaysBounceHorizontal = true
        textView.layer.borderColor = UIColor (red:204.0/255.0, green:204.0/255.0, blue:204.0/255.0, alpha:1.0).cgColor;
        textView.layer.borderWidth = 1.0;
        textView.layer.cornerRadius = 5.0;
        return textView
    }()
}
