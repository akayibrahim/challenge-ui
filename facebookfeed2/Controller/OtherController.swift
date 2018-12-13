//
//  OtherController.swift
//  facebookfeed2
//
//  Created by iakay on 20.02.2018.
//  Copyright © 2018 challenge. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import GoogleSignIn

class OtherController: UITableViewController, UIWebViewDelegate{
    @objc static let headerId = "headerId"
    @objc static let cellId = "cellId"
    @objc let screenSize = UIScreen.main.bounds
    @objc var logoutIndex : Int = 5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: OtherController.cellId)
        tableView.register(RequestHeader.self, forHeaderFooterViewReuseIdentifier: OtherController.headerId)
        navigationItem.title = "Settings"
        tableView.tableFooterView = UIView()
        self.view.backgroundColor =  pagesBackColor
        tableView.separatorColor = pagesBackColor
        tableView.sectionHeaderHeight = 26
        webView.delegate = self
    }
    
    @objc var tableRowHeightHeight: CGFloat = 44
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // let cell =  tableView.dequeueReusableCell(withIdentifier: OtherController.cellId, for: indexPath)
        let frameOfCell : CGRect = CGRect(x: 0, y: 0, width: self.view.frame.width, height: tableRowHeightHeight)
        let cell = OtherViewCell(frame: frameOfCell, cellRow: indexPath.row)
        cell.imageView?.backgroundColor = UIColor.black
        if indexPath.row == 4 {
            cell.backgroundColor = pagesBackColor
        }
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            settingsAndPrivacy()
        } else if indexPath.row == 1 {
            support()
        } else if indexPath.row == 2 {
            shareViaFriend()
        } else if indexPath.row == 3 {
            let guideAlert: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
            guideAlert.view.addSubview(guideAlert.view.getGuideView(0))
            guideAlert.addAction(UIAlertAction(title: "Let's Challenge", style: .default, handler: nil))
            let height:NSLayoutConstraint = NSLayoutConstraint(item: guideAlert.view, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: self.view.frame.height)
            guideAlert.view.addConstraint(height);
            self.present(guideAlert, animated: true, completion: nil)
        } else if indexPath.row == 4 {
        } else if indexPath.row == logoutIndex {
            logout()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableRowHeightHeight
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
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
        GIDSignIn.sharedInstance().signOut()
        Util.removeMemberFromDefaults()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = FacebookController()
    }
    
    @objc func settingsAndPrivacy() {
        let actionsheet = UIAlertController(title: "", message: "Settings & Privacy", preferredStyle :.actionSheet)
        actionsheet.addAction(UIAlertAction(title: "Change account as \(privateAccount ? "public" : "private")?", style: .default, handler: {(action: UIAlertAction) in
            self.changeAccountPrivacy(!privateAccount)
        }))
        actionsheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(actionsheet, animated: true, completion: nil)
    }
    
    @objc func changeAccountPrivacy(_ toPrivate: Bool) {
        let jsonURL = URL(string: changeAccountPrivacyURL + memberID + "&toPrivate=\(toPrivate)")!
        jsonURL.get { data, response, error in
            guard
                data != nil
                else {
                    if data != nil {
                        ServiceLocator.logErrorMessage(data: data!, chlId: "", sUrl: getActivityCountURL, inputs: "memberID=\(memberID)")
                    }
                    return
            }
            privateAccount = toPrivate
        }
    }
    
    let webView:UIWebView = UIWebView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
    @objc func support() {
        do {
            guard let filePath = Bundle.main.path(forResource: "termsofuse", ofType: "html")
                else {
                    // File Error
                    print ("File reading error")
                    return
            }
            
            let contents =  try String(contentsOfFile: filePath, encoding: .utf8)
            let baseUrl = URL(fileURLWithPath: filePath)
            webView.loadHTMLString(contents as String, baseURL: baseUrl)
            self.view.addSubview(webView)
        }
        catch {
            print ("File HTML error")
        }
    }
    
    @objc func shareViaFriend() {
        self.present(Util.shareViaFriend(view: self.view), animated:  true, completion: nil)
    }
}
