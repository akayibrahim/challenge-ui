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
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Sample Name"
        label.font = UIFont.boldSystemFont(ofSize: 12)
        return label
    }()
    
    let requestImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = UIColor.blue
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    let confirmButton: UIButton = {
        let button = UIButton()
        button.setTitle("Follow", for: UIControlState())
        button.setTitleColor(UIColor.white, for: UIControlState())
        button.backgroundColor = UIColor.rgb(87, green: 143, blue: 255)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 10)
        button.layer.cornerRadius = 2
        return button
    }()
    
    let deleteButton: UIButton = {
        let button = UIButton()
        button.setTitle("Remove", for: UIControlState())
        button.setTitleColor(UIColor(white: 0.3, alpha: 1), for: UIControlState())
        button.layer.cornerRadius = 2
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(white: 0.7, alpha: 1).cgColor
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 10)
        return button
    }()
    
    func setupViews() {
        let contentGuide = self.readableContentGuide
        addSubview(requestImageView)
        addSubview(nameLabel)
        addSubview(confirmButton)
        addSubview(deleteButton)
        
        addTopAnchor(requestImageView, anchor: contentGuide.topAnchor, constant: 0)
        addLeadingAnchor(requestImageView, anchor: contentGuide.leadingAnchor, constant: 0)
        addWidthAnchor(requestImageView, multiplier: 2/10)
        addHeightAnchor(requestImageView, multiplier: 3/10)
        
        addTopAnchor(nameLabel, anchor: contentGuide.topAnchor, constant: 5)
        addLeadingAnchor(nameLabel, anchor: requestImageView.trailingAnchor, constant: 5)
        
        addTopAnchor(confirmButton, anchor: nameLabel.bottomAnchor, constant: 10)
        addLeadingAnchor(confirmButton, anchor: requestImageView.trailingAnchor, constant: 10)
        addWidthAnchor(confirmButton, multiplier: 2.3/10)
        addHeightAnchor(confirmButton, multiplier: 0.8/10)
        
        addTopAnchor(deleteButton, anchor: confirmButton.bottomAnchor, constant: 5)
        addLeadingAnchor(deleteButton, anchor: requestImageView.trailingAnchor, constant: 10)
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
