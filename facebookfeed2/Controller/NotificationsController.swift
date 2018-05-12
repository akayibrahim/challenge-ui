//
//  OtherControllers.swift
//  facebookfeed2
//
//  Created by Brian Voong on 2/27/16.
//  Copyright © 2016 letsbuildthatapp. All rights reserved.
//

import UIKit

class NotificationsController: UITableViewController {
    let cellId = "cellId"
    let followCellId = "followCellId"
    var notifications = [Notifications]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Activities"
        tableView.register(NotificationCell.self, forCellReuseIdentifier: cellId)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: followCellId)
        tableView.tableFooterView = UIView()
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.sectionHeaderHeight = 0
        tableView?.showsVerticalScrollIndicator = false
        
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(self.onRefesh), for: UIControlEvents.valueChanged)
        tableView?.addSubview(refreshControl!)
        
        loadNotifications()
    }

    func onRefesh() {
        self.loadNotifications()
        self.tableView?.reloadData()
        refreshControl?.endRefreshing()
    }

    func loadNotifications() {
        if let path = Bundle.main.path(forResource: "notifications", ofType: "json") {
            do {
                let data = try(Data(contentsOf: URL(fileURLWithPath: path), options: NSData.ReadingOptions.mappedIfSafe))
                let jsonDictionary = try(JSONSerialization.jsonObject(with: data, options: .mutableContainers)) as? [String: Any]
                if let postsArray = jsonDictionary?["posts"] as? [[String: AnyObject]] {
                    self.notifications = [Notifications]()
                    for postDictionary in postsArray {
                        let notification = Notifications()
                        notification.setValuesForKeys(postDictionary)
                        self.notifications.append(notification)
                    }
                }
            } catch let err {
                print(err)
            }
        }
    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return notifications.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 && indexPath.row == 0 {
            let cell =  tableView.dequeueReusableCell(withIdentifier: followCellId, for: indexPath)
            let attributeText = NSMutableAttributedString(string: "Following Requests   ", attributes: nil)
            attributeText.append(greaterThan)
            cell.textLabel?.attributedText = attributeText
            return cell
        } else if indexPath.section == 1 {
            let cell =  tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! NotificationCell
            cell.notification = notifications[indexPath.row]
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            return cell
        }
        return UITableViewCell()
    }
    
    let heighForRow : CGFloat = UIScreen.main.bounds.width * 1 / 10
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 && indexPath.row == 0 {
            return UIScreen.main.bounds.width * 1.2 / 10
        }
        if let thinksAboutChallenge = notifications[indexPath.row].content {
            let rect = NSString(string: thinksAboutChallenge).boundingRect(with: CGSize(width: view.frame.width, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14)], context: nil)
            return rect.height + heighForRow
        }
        return heighForRow
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        /*
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerId) as! RequestHeader
        header.nameLabel.text = "PEOPLE YOU MAY KNOW"
        return header
        */
        return nil
    }
    
    var lastContentOffSet : CGFloat = 0
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (scrollView.contentOffset.y >= 0 && self.lastContentOffSet < scrollView.contentOffset.y) || (scrollView.contentOffset.y > 0 && scrollView.isAtBottom) {
            // move down
            if let status = UIApplication.shared.value(forKey: "statusBar") as? UIView {
                status.backgroundColor = navAndTabColor
            }
            self.navigationController?.setNavigationBarHidden(true, animated: true)
        } else {
            // move up
            if let status = UIApplication.shared.value(forKey: "statusBar") as? UIView {
                status.backgroundColor = nil
            }
            self.navigationController?.setNavigationBarHidden(false, animated: true)
        }
        self.lastContentOffSet = scrollView.contentOffset.y
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            followRequest()
        }
    }
    
    func followRequest() {
        let followRequest = FollowRequestController()
        followRequest.hidesBottomBarWhenPushed = true
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.pushViewController(followRequest, animated: true)
    }
}
