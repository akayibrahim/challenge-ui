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
    var proofs = [Proofs]()
    var commentCellView = CommentCellView()
    var comment : Bool = false
    var proof : Bool = false
    
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
        var thinksAboutChl : String!
        if comment {
            thinksAboutChl = comments[indexPath.item].comment
        } else if proof {
            thinksAboutChl = proofs[indexPath.item].comment
        }
        if let thinksAboutChallenge = thinksAboutChl {
            let rect = NSString(string: thinksAboutChallenge).boundingRect(with: CGSize(width: view.frame.width, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 12)], context: nil)
            return rect.height + heighForRow
        }
        return heighForRow
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if comment {
            return comments.count
        } else if proof {
            return proofs.count
        }
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath as IndexPath) as! CommentCellView
        let frameOfCell : CGRect = CGRect(x: 0, y: 0, width: self.view.frame.width, height: heighForRow)
        let cell = CommentCellView(frame: frameOfCell, cellRow: indexPath.row)
        if comment {
            let commentAtt = NSMutableAttributedString(string: "\(String(describing: comments[indexPath.row].name!)): ", attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 12)])
            let nameAtt = NSMutableAttributedString(string: "\(String(describing: comments[indexPath.row].comment!))", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 12)])
            commentAtt.append(nameAtt)
            cell.thinksAboutChallengeView.attributedText = commentAtt
        } else if proof {
            let commentAtt = NSMutableAttributedString(string: "\(String(describing: proofs[indexPath.row].name!)): ", attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 12)])
            let nameAtt = NSMutableAttributedString(string: "\(String(describing: proofs[indexPath.row].comment!))", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 12)])
            commentAtt.append(nameAtt)
            cell.thinksAboutChallengeView.attributedText = commentAtt
        }
        // cell.profileImageView = setIma
        return cell
    }
}
