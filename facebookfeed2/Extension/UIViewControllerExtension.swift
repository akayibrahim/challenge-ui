//
//  UIFontExtension.swift
//  facebookfeed2
//
//  Created by iakay on 11.05.2018.
//  Copyright © 2018 challenge. All rights reserved.
//

import UIKit
import AVFoundation

extension UICollectionView {
    public func isRowCompletelyVisible(_ indexPath: IndexPath) -> Bool {
        let rect = self.collectionViewLayout.layoutAttributesForItem(at: indexPath)?.frame
        let completelyVisible = self.bounds.contains(rect!)
        return completelyVisible
    }
    
    func reloadData(completion: @escaping ()->()) {
        UIView.animate(withDuration: 0, animations: { self.reloadData() })
        { _ in completion() }
    }
    
    func setEmptyProfileMessage() -> [UIButton] {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        
        let messageLabel = UILabel()
        messageLabel.text = "No Challenges Yet\n\n Tab on the add(+) to share\n your first challenge."
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 5;
        messageLabel.textAlignment = .center;
        messageLabel.font = UIFont.boldSystemFont(ofSize: 18)
        messageLabel.sizeToFit()
        
        view.addSubview(messageLabel)
        self.addCenterYAnchor(messageLabel, anchor: view.centerYAnchor, constant: 0)
        self.addCenterXAnchor(messageLabel, anchor: view.centerXAnchor, constant: 0)
        self.addWidthAnchor(messageLabel, multiplier: 1)
        self.addHeightAnchor(messageLabel, multiplier: 1/3)
        
        let findButton: UIButton = FeedCell.buttonForTitleWithBorder("Find Friends", imageName: "")
        findButton.layer.backgroundColor = UIColor.blue.cgColor
        findButton.setTitleColor(UIColor.white, for: UIControlState())
        findButton.layer.borderWidth = 0
        view.addSubview(findButton)
        self.addBottomAnchor(findButton, anchor: view.bottomAnchor, constant: -(screenWidth * 0.1 / 1))
        self.addCenterXAnchor(findButton, anchor: view.centerXAnchor, constant: -(screenWidth * 0.24 / 1))
        self.addWidthAnchor(findButton, multiplier: 0.4 / 1)
        self.addHeightAnchor(findButton, multiplier: 0.1 / 1)
        
        let inviteButton: UIButton = FeedCell.buttonForTitleWithBorder("Invite Friends", imageName: "")
        inviteButton.layer.backgroundColor = UIColor.red.cgColor
        inviteButton.setTitleColor(UIColor.white, for: UIControlState())
        inviteButton.layer.borderWidth = 0
        view.addSubview(inviteButton)
        self.addBottomAnchor(inviteButton, anchor: view.bottomAnchor, constant: -(screenWidth * 0.1 / 1))
        self.addCenterXAnchor(inviteButton, anchor: view.centerXAnchor, constant: (screenWidth * 0.24 / 1))
        self.addWidthAnchor(inviteButton, multiplier: 0.4 / 1)
        self.addHeightAnchor(inviteButton, multiplier: 0.1 / 1)
        
        self.backgroundView = view
        var buttons = [UIButton]()
        buttons.append(findButton)
        buttons.append(inviteButton)
        return buttons
    }
    
    func setEmptyOtherProfileMessage() {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        
        let messageLabel = UILabel()
        messageLabel.text = "No Challenges Yet\n\n Tab on the add(+) to share\n your first challenge with your friend."
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 5;
        messageLabel.textAlignment = .center;
        messageLabel.font = UIFont.boldSystemFont(ofSize: 18)
        messageLabel.sizeToFit()
        
        view.addSubview(messageLabel)
        self.addCenterYAnchor(messageLabel, anchor: view.centerYAnchor, constant: 0)
        self.addCenterXAnchor(messageLabel, anchor: view.centerXAnchor, constant: 0)
        self.addWidthAnchor(messageLabel, multiplier: 1)
        self.addHeightAnchor(messageLabel, multiplier: 1/3)
        
        self.backgroundView = view
    }
    
    func restore() {
        self.backgroundView = nil
    }
}

extension UIViewController
{
    var topbarHeight: CGFloat {
        return UIApplication.shared.statusBarFrame.size.height +
            (self.navigationController?.navigationBar.frame.height ?? 0.0)
    }
    
    @objc func setImage(fbID: String?, imageView: UIImageView) {
        if (fbID != nil && fbID == "") || fbID == nil {
            setImage(name: unknown, imageView: imageView)
        } else if let peoplefbID = fbID {
            let url = URL(string: !peoplefbID.contains("google") ? "https://graph.facebook.com/\(peoplefbID)/picture?type=large&return_ssl_resources=1" : peoplefbID)
            imageView.load(url: url!)            
        }
    }
    
    @objc func getTrendImage(challengeId: String, challengerId: String, completion: @escaping (_ image:UIImage?)->()) {
        if dummyServiceCall == false {
            let url = URL(string: downloadImageURL + "?challengeId=\(challengeId)&memberId=\(challengerId)")
            if let urlOfImage = url {                
                ImageService.getImage(withURL: urlOfImage) { image in
                    if image != nil {
                        DispatchQueue.main.async {
                            completion(image)
                        }
                    }
                }
            }
        }
    }
    
    @objc func getVideo(challengeId: String, challengerId: String, completion: @escaping (_ video:URL?)->()) {
        if dummyServiceCall == false {
            let url = URL(string: downloadVideoURL + "?challengeId=\(challengeId)&memberId=\(challengerId)")
            if let urlOfImage = url {
                VideoService.getVideo(withURL: urlOfImage, completion: { (videoData) in
                    if let video = videoData {
                        DispatchQueue.main.async {
                            completion(video as URL)
                        }
                    }
                })
            }
        } else {
            // self.setImage(name: unknownImage, imageView: imageView)
        }
    }
    
    @objc func getProofImageByObjectId(imageView: UIImageView, objectId: String, completion: @escaping (_ image:UIImage?)->()) {
        let url = URL(string: downloadProofImageByObjectIdURL + "?objectId=\(objectId)")
        if let urlOfImage = url {
            ImageService.getImage(withURL: urlOfImage) { image in
                if image != nil {
                    DispatchQueue.main.async {
                        completion(image)
                    }
                }
            }
        }
    }
    
    @objc func setImage(name: String?, imageView: UIImageView) {
        if let peopleImage = name {
            imageView.image = UIImage(named: peopleImage)
        }
    }
    
    @objc func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UITableViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func popupAlert(message: String, willDelay: Bool) {
        DispatchQueue.main.async {
            let selectAlert: UIAlertController = UIAlertController(title: nil, message: message, preferredStyle: UIAlertControllerStyle.alert)
            if !willDelay {
                selectAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            }
            self.present(selectAlert, animated: true, completion: nil)
            if willDelay {
                let when = DispatchTime.now() + 1
                DispatchQueue.main.asyncAfter(deadline: when){
                    // your code with delay
                    selectAlert.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
}

extension UIViewController: UITextViewDelegate {
    public func textViewDidChange(_ textView: UITextView) {
        let size = CGSize(width: textView.frame.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        textView.constraints.forEach{ (constraint) in
            if constraint.firstAttribute == .height {
                constraint.constant = estimatedSize.height                
            }
        }
    }
}
