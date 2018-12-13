//
//  UIFontExtension.swift
//  facebookfeed2
//
//  Created by iakay on 11.05.2018.
//  Copyright © 2018 challenge. All rights reserved.
//

import UIKit

extension UITableViewController
{
    @objc func setImage(fbID: String?, imageView: UIImageView, reset : Bool) {
        if (fbID != nil && fbID == "") || fbID == nil {
            setImage(name: unknown, imageView: imageView)
        } else if reset && fbID != memberFbID {
            setImage(name: unknown, imageView: imageView)
        } else if let peoplefbID = fbID {            
            let url = URL(string: !peoplefbID.contains("google") ? "https://graph.facebook.com/\(peoplefbID)/picture?type=large&return_ssl_resources=1" : peoplefbID)
            imageView.load(url: url!)
        }
    }
    
    override func setImage(name: String?, imageView: UIImageView) {
        if let peopleImage = name {
            imageView.image = UIImage(named: peopleImage)
        }
    }    
}

extension UITableView {
    
    public var boundsWithoutInset: CGRect {
        var boundsWithoutInset = bounds
        boundsWithoutInset.origin.y += contentInset.top
        boundsWithoutInset.size.height -= contentInset.top + contentInset.bottom
        return boundsWithoutInset
    }
    
    public func isRowCompletelyVisible(at indexPath: IndexPath) -> Bool {
        let rect = rectForRow(at: indexPath)
        return boundsWithoutInset.contains(rect)
    }
    
    func setEmptyActivitiesMessage() -> UIButton {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height * 0.8/1))
        
        let messageLabel = UILabel()
        messageLabel.text = "No Activities Yet"
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
        
        let inviteButton: UIButton = FeedCell.buttonForTitleWithBorder("Invite Friends", imageName: "")
        inviteButton.layer.backgroundColor = UIColor.red.cgColor
        inviteButton.setTitleColor(UIColor.white, for: UIControlState())
        inviteButton.layer.borderWidth = 0
        view.addSubview(inviteButton)
        self.addBottomAnchor(inviteButton, anchor: view.bottomAnchor, constant: -(screenWidth * 0.1 / 1))
        self.addCenterXAnchor(inviteButton, anchor: view.centerXAnchor, constant: 0)
        self.addWidthAnchor(inviteButton, multiplier: 0.5 / 1)
        self.addHeightAnchor(inviteButton, multiplier: 0.1 / 1)
        
        self.tableFooterView = view
        return inviteButton
    }
    
    func restore() {
        self.tableFooterView = UIView()
    }
}
