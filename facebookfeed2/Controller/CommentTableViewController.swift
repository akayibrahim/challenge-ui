//
//  SelectionTableViewController.swift
//  facebookfeed2
//
//  Created by iakay on 27.03.2018.
//  Copyright © 2018 challenge. All rights reserved.
//

import UIKit

class CommentTableViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    let screenSize = UIScreen.main.bounds
    var tableTitle : String!
    var tableView : UITableView!
    var comments = [Comments]()
    var commentCellView = CommentCellView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height), style: UITableViewStyle.plain)
        self.tableView.register(CommentCellView.self, forCellReuseIdentifier: "LabelCell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.addSubview(commentCellView)
        self.view.addSubview(tableView)
        navigationItem.title = tableTitle
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    let heighForRow : CGFloat = UIScreen.main.bounds.width * 0.9 / 10
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let thinksAboutChallenge = comments[indexPath.item].comment {
            let rect = NSString(string: thinksAboutChallenge).boundingRect(with: CGSize(width: view.frame.width, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 12)], context: nil)
            return rect.height + heighForRow
        }
        return heighForRow
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath as IndexPath) as! CommentCellView
        let frameOfCell : CGRect = CGRect(x: 0, y: 0, width: self.view.frame.width, height: heighForRow)
        let cell = CommentCellView(frame: frameOfCell, cellRow: indexPath.row)
        let commentAtt = NSMutableAttributedString(string: "\(String(describing: comments[indexPath.row].name!)): ", attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 12)])
        let nameAtt = NSMutableAttributedString(string: "\(String(describing: comments[indexPath.row].comment!))", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 12)])
        commentAtt.append(nameAtt)
        cell.thinksAboutChallengeView.attributedText = commentAtt
        // cell.profileImageView = setIma
        return cell
    }
}
