//
//  FriendRequestView.swift
//  facebookfeed2
//
//  Created by iakay on 26.02.2018.
//  Copyright © 2018 challenge. All rights reserved.
//

import UIKit

class FriendRequestCell: UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Sample Name"
        label.font = UIFont.boldSystemFont(ofSize: 12)
        return label
    }()
    
    @objc let requestImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = UIColor.blue
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    @objc let confirmButton: subclasssedUIButton = {
        let button = subclasssedUIButton()
        button.setTitle(followButtonText, for: UIControlState())
        button.setTitleColor(UIColor.white, for: UIControlState())
        button.backgroundColor = UIColor.rgb(87, green: 143, blue: 255)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 10)
        button.layer.cornerRadius = 2
        return button
    }()
    
    @objc let deleteButton: subclasssedUIButton = {
        let button = subclasssedUIButton()
        button.setTitle("Remove", for: UIControlState())
        button.setTitleColor(UIColor(white: 0.3, alpha: 1), for: UIControlState())
        button.layer.cornerRadius = 2
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(white: 0.7, alpha: 1).cgColor
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 10)
        return button
    }()
    
    @objc func setupViews() {
        let contentGuide = self.readableContentGuide
        backgroundColor = feedBackColor
        addSubview(requestImageView)
        addSubview(nameLabel)
        addSubview(confirmButton)
        addSubview(deleteButton)
        
        addTopAnchor(requestImageView, anchor: contentGuide.topAnchor, constant: 0)
        addLeadingAnchor(requestImageView, anchor: contentGuide.leadingAnchor, constant: 0)
        addWidthAnchor(requestImageView, multiplier: 1.5/10)
        addHeightAnchor(requestImageView, multiplier: 1.5/10)
        
        nameLabel.backgroundColor = UIColor(white: 1, alpha: 0)
        addTopAnchor(nameLabel, anchor: contentGuide.topAnchor, constant: 0)
        addLeadingAnchor(nameLabel, anchor: requestImageView.trailingAnchor, constant: 10)
        
        addTopAnchor(confirmButton, anchor: nameLabel.bottomAnchor, constant: 10)
        addLeadingAnchor(confirmButton, anchor: requestImageView.trailingAnchor, constant: 10)
        addWidthAnchor(confirmButton, multiplier: 2.3/10)
        addHeightAnchor(confirmButton, multiplier: 0.8/10)
        
        addTopAnchor(deleteButton, anchor: nameLabel.bottomAnchor, constant: 10)
        addLeadingAnchor(deleteButton, anchor: confirmButton.trailingAnchor, constant: 10)
        addWidthAnchor(deleteButton, multiplier: 2.3/10)
        addHeightAnchor(deleteButton, multiplier: 0.8/10)
        
        /*
        addConstraintsWithFormat("H:|-16-[v0(52)]-8-[v1]|", views: requestImageView, nameLabel)
        
        addConstraintsWithFormat("V:|-4-[v0]-4-|", views: requestImageView)
        addConstraintsWithFormat("V:|-8-[v0]-8-[v1(24)]-8-|", views: nameLabel, confirmButton)
        
        addConstraintsWithFormat("H:|-76-[v0(80)]-8-[v1(80)]", views: confirmButton, deleteButton)
        
        addConstraintsWithFormat("V:[v0(24)]-8-|", views: deleteButton)
        */
    }
    
}
