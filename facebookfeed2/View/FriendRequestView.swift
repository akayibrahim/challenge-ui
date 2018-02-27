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
        button.setTitle("Confirm", for: UIControlState())
        button.setTitleColor(UIColor.white, for: UIControlState())
        button.backgroundColor = UIColor.rgb(87, green: 143, blue: 255)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 10)
        button.layer.cornerRadius = 2
        return button
    }()
    
    let deleteButton: UIButton = {
        let button = UIButton()
        button.setTitle("Delete", for: UIControlState())
        button.setTitleColor(UIColor(white: 0.3, alpha: 1), for: UIControlState())
        button.layer.cornerRadius = 2
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(white: 0.7, alpha: 1).cgColor
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 10)
        return button
    }()
    
    func setupViews() {
        addSubview(requestImageView)
        addSubview(nameLabel)
        addSubview(confirmButton)
        addSubview(deleteButton)
        
        addConstraintsWithFormat("H:|-16-[v0(52)]-8-[v1]|", views: requestImageView, nameLabel)
        
        addConstraintsWithFormat("V:|-4-[v0]-4-|", views: requestImageView)
        addConstraintsWithFormat("V:|-8-[v0]-8-[v1(24)]-8-|", views: nameLabel, confirmButton)
        
        addConstraintsWithFormat("H:|-76-[v0(80)]-8-[v1(80)]", views: confirmButton, deleteButton)
        
        addConstraintsWithFormat("V:[v0(24)]-8-|", views: deleteButton)
        
    }
    
}
