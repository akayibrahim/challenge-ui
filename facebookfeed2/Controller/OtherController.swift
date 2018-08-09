//
//  OtherController.swift
//  facebookfeed2
//
//  Created by iakay on 20.02.2018.
//  Copyright © 2018 challenge. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class OtherController: UITableViewController {
    @objc static let headerId = "headerId"
    @objc static let cellId = "cellId"
    @objc let screenSize = UIScreen.main.bounds
    @objc var logoutIndex : Int = 4
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: OtherController.cellId)
        tableView.register(RequestHeader.self, forHeaderFooterViewReuseIdentifier: OtherController.headerId)
        navigationItem.title = "Settings"
        tableView.tableFooterView = UIView()
        self.view.backgroundColor =  pagesBackColor
        tableView.separatorColor = pagesBackColor
        tableView.sectionHeaderHeight = 26
    }
    
    @objc var tableRowHeightHeight: CGFloat = 44
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // let cell =  tableView.dequeueReusableCell(withIdentifier: OtherController.cellId, for: indexPath)
        let frameOfCell : CGRect = CGRect(x: 0, y: 0, width: self.view.frame.width, height: tableRowHeightHeight)
        let cell = OtherViewCell(frame: frameOfCell, cellRow: indexPath.row)
        cell.imageView?.backgroundColor = UIColor.black
        if indexPath.row == 3 {
            cell.backgroundColor = pagesBackColor
        }
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            settings()
        } else if indexPath.row == 1 {
            privacy()
        } else if indexPath.row == 2 {
            support()
        } else if indexPath.row == 3 {
        } else if indexPath.row == logoutIndex {
            logout()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableRowHeightHeight
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: OtherController.headerId) as? RequestHeader
        header?.nameLabel.text = ""
        /*
         if section == 0 {
         header.nameLabel.text = "FRIEND REQUESTS"
         } else {
         header.nameLabel.text = "PEOPLE YOU MAY KNOW"
         }
         */
        return header
    }
    
    @objc lazy var loginManager: FBSDKLoginManager = {
        return FBSDKLoginManager()
    }()
    
    @objc func logout() {
        if Util.controlNetwork() {
            return
        }
        FBSDKLoginManager().logOut()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = FacebookController()
    }
    
    @objc func settings() {
    }
    
    @objc func privacy() {
    }
    
    @objc func support() {
    }
}

