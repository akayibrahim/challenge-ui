//
//  OtherController.swift
//  facebookfeed2
//
//  Created by iakay on 20.02.2018.
//  Copyright © 2018 challenge. All rights reserved.
//

import UIKit

class OtherController: UITableViewController {
    static let headerId = "headerId"
    static let cellId = "cellId"
    let screenSize = UIScreen.main.bounds
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: OtherController.cellId)
        tableView.register(RequestHeader.self, forHeaderFooterViewReuseIdentifier: OtherController.headerId)
        navigationItem.title = "Settings"
        tableView.tableFooterView = UIView()
        self.view.backgroundColor =  UIColor.rgb(229, green: 231, blue: 235)
        tableView.separatorColor = UIColor.rgb(229, green: 231, blue: 235)
        tableView.sectionHeaderHeight = 26
    }
    
    var tableRowHeightHeight: CGFloat = 44
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // let cell =  tableView.dequeueReusableCell(withIdentifier: OtherController.cellId, for: indexPath)
        let frameOfCell : CGRect = CGRect(x: 0, y: 0, width: self.view.frame.width, height: tableRowHeightHeight)
        let cell = OtherViewCell(frame: frameOfCell, cellRow: indexPath.row)
        cell.imageView?.backgroundColor = UIColor.black
        if indexPath.row == 3 {
            cell.backgroundColor = pagesBackColor
            cell.selectionStyle = UITableViewCellSelectionStyle.none
        }
        return cell
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
}

