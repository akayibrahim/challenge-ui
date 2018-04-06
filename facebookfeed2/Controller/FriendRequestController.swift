//
//  OtherControllers.swift
//  facebookfeed2
//
//  Created by Brian Voong on 2/27/16.
//  Copyright © 2016 letsbuildthatapp. All rights reserved.
//

import UIKit

class FriendRequestsController: UITableViewController {
    
    static let cellId = "cellId"
    static let headerId = "headerId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Follow Requests"
 
        tableView.separatorColor = UIColor.rgb(229, green: 231, blue: 235)
        tableView.sectionHeaderHeight = 26
        
        tableView.register(FriendRequestCell.self, forCellReuseIdentifier: FriendRequestsController.cellId)
        tableView.register(RequestHeader.self, forHeaderFooterViewReuseIdentifier: FriendRequestsController.headerId)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: FriendRequestsController.cellId, for: indexPath) as! FriendRequestCell
        
        if indexPath.row % 3 == 0 {
            cell.nameLabel.text = "Mark Zuckerberg"
            cell.requestImageView.image = UIImage(named: "zuckprofile")
        } else if indexPath.row % 3 == 1 {
            cell.nameLabel.text = "Steve Jobs"
            cell.requestImageView.image = UIImage(named: "gandhi_profile")
        } else {
            cell.nameLabel.text = "Mahatma Gandhi"
            cell.requestImageView.image = UIImage(named: "gandhi_profile")
        }
        
        cell.imageView?.backgroundColor = UIColor.black
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.width * 3.3 / 10
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: FriendRequestsController.headerId) as! RequestHeader
        header.nameLabel.text = "PEOPLE YOU MAY KNOW"
        /*
        if section == 0 {
            header.nameLabel.text = "FRIEND REQUESTS"
        } else {
            header.nameLabel.text = "PEOPLE YOU MAY KNOW"
        }
        */
        return header
    }
    
}

class RequestHeader: UITableViewHeaderFooterView {
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "FRIEND REQUESTS"
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = UIColor(white: 0.4, alpha: 1)
        return label
    }()
    
    let bottomBorderView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(229, green: 231, blue: 235)
        return view
    }()
    
    func setupViews() {
        let contentGuide = self.readableContentGuide
        
        addSubview(nameLabel)
        addSubview(bottomBorderView)
        
        addTopAnchor(nameLabel, anchor: contentGuide.topAnchor, constant: 0)
        addLeadingAnchor(nameLabel, anchor: contentGuide.leadingAnchor, constant: 0)
        
        addTopAnchor(bottomBorderView, anchor: contentGuide.topAnchor, constant: 0)
        addLeadingAnchor(bottomBorderView, anchor: contentGuide.leadingAnchor, constant: 0)
        addHeightAnchor(bottomBorderView, multiplier: 0.5/10)
    }
    
}
