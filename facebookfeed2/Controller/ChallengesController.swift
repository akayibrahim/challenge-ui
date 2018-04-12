//
//  ViewController.swift
//  chlfeed
//
//  Created by AKAY on 11/20/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit

let cellId = "cellId"

class SafeJsonObject: NSObject {
    
    override func setValue(_ value: Any?, forKey key: String) {
        let selectorString = "set\(key.uppercased().characters.first!)\(String(key.characters.dropFirst())):"
        let selector = Selector(selectorString)
        if responds(to: selector) {
            super.setValue(value, forKey: key)
        }
    }
    
}

class Feed: SafeJsonObject {
    var feedUrl, title, link, author, type: String?
}

class FeedController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    	
    var posts = [Post]()
    var donePosts = [Post]()
    var notDonePosts = [Post]()
    var comments = [Comments]()
    
    func fetchData() {
        URLSession.shared.dataTask(with: NSURL(string: "http://localhost:8080/getChallenges?memberId=5a81b0f0f8b8e43e70325d3d")! as URL, completionHandler: { (data, response, error) -> Void in
            // Check if data was received successfully
            if error == nil && data != nil {
                do {
                    // Convert NSData to Dictionary where keys are of type String, and values are of any type
                    // Access specific key with value of type String
                    // let str = json!["key"] as! String
                    if let postsArray = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [[String: Any]] {
                        self.posts = [Post]()
                        for postDictionary in postsArray {
                            let post = Post()
                            post.versusAttendanceList = [VersusAttendance]()
                            if let verAttenLis = postDictionary["versusAttendanceList"] as? [[String: AnyObject]] {
                                for versus in verAttenLis {
                                    let versusAtten = VersusAttendance(data: versus)
                                    post.versusAttendanceList.append(versusAtten)
                                }
                            }
                            post.joinAttendanceList = [JoinAttendance]()
                            if let joinAttenLis = postDictionary["joinAttendanceList"] as? [[String: AnyObject]] {
                                for join in joinAttenLis {
                                    let joinAtten = JoinAttendance(data: join)
                                    post.joinAttendanceList.append(joinAtten)
                                }
                            }
                            post.setValuesForKeys(postDictionary)
                            post.done = postDictionary["done"] as? Bool
                            post.isComeFromSelf = postDictionary["isComeFromSelf"] as? Bool
                            post.amILike = postDictionary["amILike"] as? Bool
                            post.supportFirstTeam = postDictionary["supportFirstTeam"] as? Bool
                            post.supportSecondTeam = postDictionary["supportSecondTeam"] as? Bool
                            self.posts.append(post)
                        }
                    }
                } catch let err {
                    print(err)
                }
            }
            DispatchQueue.main.async {
                self.collectionView?.reloadData()
            }
        }).resume()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let httpCall: Bool = false
        if httpCall == true {
            // Asynchronous Http call to your api url, using NSURLSession:
            // http://ip.jsontest.com
            // http://localhost:8080/getChallenges?memberId=5a81b0f0f8b8e43e70325d3d
            // self.fetchData()
        } else {
            //        let samplePost = Post()
            //        samplePost.performSelector(Selector("setName:"), withObject: "my name")
            var jsonFileName = "own_posts"
            if self.tabBarController?.selectedIndex == 0 {
                jsonFileName = "all_posts"
            }
            if let path = Bundle.main.path(forResource: jsonFileName, ofType: "json") {
                do {
                    let data = try(Data(contentsOf: URL(fileURLWithPath: path), options: NSData.ReadingOptions.mappedIfSafe))
                    let jsonDictionary = try(JSONSerialization.jsonObject(with: data, options: .mutableContainers)) as? [String: Any]
                    if let postsArray = jsonDictionary?["posts"] as? [[String: AnyObject]] {
                        self.posts = [Post]()
                        for postDictionary in postsArray {
                            let post = Post()
                            post.versusAttendanceList = [VersusAttendance]()
                            if let verAttenLis = postDictionary["versusAttendanceList"] as? [[String: AnyObject]] {
                                for versus in verAttenLis {
                                    let versusAtten = VersusAttendance(data: versus)
                                    post.versusAttendanceList.append(versusAtten)
                                }
                            }
                            post.joinAttendanceList = [JoinAttendance]()
                            if let joinAttenLis = postDictionary["joinAttendanceList"] as? [[String: AnyObject]] {
                                for join in joinAttenLis {
                                    let joinAtten = JoinAttendance(data: join)
                                    post.joinAttendanceList.append(joinAtten)
                                }
                            }
                            post.setValuesForKeys(postDictionary)
                            post.done = postDictionary["done"] as? Bool
                            post.isComeFromSelf = postDictionary["isComeFromSelf"] as? Bool
                            post.amILike = postDictionary["amILike"] as? Bool
                            post.supportFirstTeam = postDictionary["supportFirstTeam"] as? Bool
                            post.supportSecondTeam = postDictionary["supportSecondTeam"] as? Bool
                            self.posts.append(post)
                            if post.done == true {
                                self.donePosts.append(post)
                            } else {
                                self.notDonePosts.append(post)
                            }
                            self.view.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
                        }
                    }
                } catch let err {
                    print(err)
                }
            }
        }
        if let path = Bundle.main.path(forResource: "comments", ofType: "json") {
            do {
                let data = try(Data(contentsOf: URL(fileURLWithPath: path), options: NSData.ReadingOptions.mappedIfSafe))
                let jsonDictionary = try(JSONSerialization.jsonObject(with: data, options: .mutableContainers)) as? [String: Any]
                if let postsArray = jsonDictionary?["posts"] as? [[String: AnyObject]] {
                    self.comments = [Comments]()
                    for postDictionary in postsArray {
                        let comment = Comments()
                        comment.setValuesForKeys(postDictionary)
                        self.comments.append(comment)
                    }
                }
            } catch let err {
                print(err)
            }
        }
        if self.tabBarController?.selectedIndex == 0 {
            navigationItem.title = "Challenge"
        } else if self.tabBarController?.selectedIndex == 3 {
            navigationItem.title = "Profile"
        }
        collectionView?.alwaysBounceVertical = true
        collectionView?.backgroundColor = UIColor(white: 0.95, alpha: 1)
        collectionView?.register(FeedCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.register(FeedCell.self, forCellWithReuseIdentifier: "profile")
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.register(ChallengeHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader , withReuseIdentifier: "someRandonIdentifierString")
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var reusableView : UICollectionReusableView? = nil
        if self.tabBarController?.selectedIndex == 3 {
            if kind == UICollectionElementKindSectionHeader {
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "someRandonIdentifierString", for: indexPath as IndexPath) as! ChallengeHeader
                if indexPath.section == 1 {
                    headerView.nameLabel.text = "YOUR ACTIVE CHALLENGES"
                } else if indexPath.section == 2 {
                    headerView.nameLabel.text = "YOUR PAST CHALLENGES"
                }
                reusableView = headerView
            }
        }
        return reusableView!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if self.tabBarController?.selectedIndex == 3 {
            if section == 0 {
                return CGSize(width: view.frame.width, height: 0)
            }
            return CGSize(width: view.frame.width, height: view.frame.width / 15)
        }
        return CGSize(width: 0, height: 0)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.tabBarController?.selectedIndex == 3 {
            if section == 0 {
                return 1
            } else if section == 1 {
                return donePosts.count
            } else if section == 2 {
                return notDonePosts.count
            }
        }
        return posts.count
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        if self.tabBarController?.selectedIndex == 3 {
            return 3
        }
        return 1
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //Correct the nav bar state unwinding from segues
        if self.tabBarController?.selectedIndex == 0  {
            self.navigationController?.hidesBarsOnSwipe = true
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var feedCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! FeedCell
        if self.tabBarController?.selectedIndex == 3  {
            if indexPath.section == 0 && indexPath.row == 0 {
                feedCell = collectionView.dequeueReusableCell(withReuseIdentifier: "profile", for: indexPath) as! FeedCell
                let profileCell : ProfileCellView = ProfileCellView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width * 2.5 / 10))
                profileCell.other.addTarget(self, action: #selector(self.openOthers), for: UIControlEvents.touchUpInside)
                feedCell.addSubview(profileCell)
                return feedCell
            }
            if indexPath.section == 1 {
                feedCell.post = donePosts[indexPath.row]
            } else if indexPath.section == 2 {
                feedCell.post = notDonePosts[indexPath.row]
            }
        } else {
            feedCell.post = posts[indexPath.row]
        }
        feedCell.prepareForReuse()
        feedCell.post = posts[indexPath.item]
        feedCell.feedController = self
        if feedCell.post?.type == "SELF" {
            feedCell.likeButton.tag = indexPath.row
            feedCell.likeButton.addTarget(self, action: #selector(self.likeSelfs), for: UIControlEvents.touchUpInside)
        } else if feedCell.post?.type == "PUBLIC" {
            feedCell.joinButton.tag = indexPath.row
            feedCell.joinButton.addTarget(self, action: #selector(self.acceptChallenge), for: UIControlEvents.touchUpInside)
        } else if feedCell.post?.type == "PRIVATE" {
            feedCell.supportButton.tag = indexPath.row
            feedCell.supportButtonMatch.tag = indexPath.row
            feedCell.supportButton.addTarget(self, action: #selector(self.supportChallenge), for: UIControlEvents.touchUpInside)
            feedCell.supportButtonMatch.addTarget(self, action: #selector(self.supportChallengeMatch), for: UIControlEvents.touchUpInside)
        }
        feedCell.viewComments.addTarget(self, action: #selector(self.viewComments), for: UIControlEvents.touchUpInside)
        feedCell.viewProofs.addTarget(self, action: #selector(self.viewProofs), for: UIControlEvents.touchUpInside)
        feedCell.addComments.addTarget(self, action: #selector(self.addComments), for: UIControlEvents.touchUpInside)
        feedCell.addProofs.addTarget(self, action: #selector(self.addProofs), for: UIControlEvents.touchUpInside)
        return feedCell
    }
    
    func openOthers(sender: UIButton) {
        let other = OtherController()
        self.navigationController?.pushViewController(other, animated: true)
    }
    
    func addComments(sender: UIButton) {
        let commentsTable = CommentTableViewController()        
        commentsTable.tableTitle = "Comments"
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.hidesBarsOnSwipe = false
        self.navigationController?.pushViewController(commentsTable, animated: true)
    }
    
    func addProofs(sender: UIButton) {
        let commentsTable = CommentTableViewController()
        commentsTable.tableTitle = "Proofs"
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.hidesBarsOnSwipe = false
        self.navigationController?.pushViewController(commentsTable, animated: true)
    }
    
    func viewComments(sender: UIButton) {
        let commentsTable = CommentTableViewController()
        commentsTable.tableTitle = "Comments"
        commentsTable.comments = self.comments
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.hidesBarsOnSwipe = false
        self.navigationController?.pushViewController(commentsTable, animated: true)
    }
    
    func viewProofs(sender: UIButton) {
        let commentsTable = CommentTableViewController()
        commentsTable.tableTitle = "Proofs"
        commentsTable.comments = self.comments
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.hidesBarsOnSwipe = false
        self.navigationController?.pushViewController(commentsTable, animated: true)
    }
    
    func supportChallenge(sender: UIButton) {
        let index = IndexPath(item: sender.tag, section: 0)
        let feedCcell = collectionView?.cellForItem(at: index) as! FeedCell
        let currentImage = sender.currentImage
        if currentImage == UIImage(named:"leftArrow") {
            sender.setImage(UIImage(named:"rightArrow"), for: .normal)
            feedCcell.supportButtonMatch.setImage(UIImage(named:"leftArrow"), for: .normal)
        } else {
            sender.setImage(UIImage(named:"leftArrow"), for: .normal)
        }
    }
    
    func supportChallengeMatch(sender: UIButton) {
        let index = IndexPath(item: sender.tag, section: 0)
        let feedCcell = collectionView?.cellForItem(at: index) as! FeedCell
        let currentImage = sender.currentImage
        if currentImage == UIImage(named:"leftArrow") {
            sender.setImage(UIImage(named:"rightArrow"), for: .normal)
            feedCcell.supportButton.setImage(UIImage(named:"leftArrow"), for: .normal)
        } else {
            sender.setImage(UIImage(named:"leftArrow"), for: .normal)
        }
    }
    
    func likeSelfs(sender: UIButton) {
        let currentImage = sender.currentImage
        if currentImage == UIImage(named:"like") {
            sender.setImage(UIImage(named:"likeRed"), for: .normal)
        } else {
            sender.setImage(UIImage(named:"like"), for: .normal)
        }
    }
    
    func acceptChallenge(sender: UIButton) {
        let currentImage = sender.currentImage
        if currentImage == UIImage(named:"acceptedRed") {
            sender.setImage(UIImage(named:"acceptedBlack"), for: .normal)
        } else {
            sender.setImage(UIImage(named:"acceptedRed"), for: .normal)
        }
    }

    let screenSize = UIScreen.main.bounds
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if self.tabBarController?.selectedIndex == 3  {
            if indexPath.row == 0 && indexPath.section == 0 {
                return CGSize(width: view.frame.width, height: screenSize.width * 2.5 / 10)
            }
        }
        var knownHeight: CGFloat = (screenSize.width / 2) + (screenSize.width / 15) + (screenSize.width / 26)
        if posts[indexPath.item].isComeFromSelf == false {
            knownHeight += (screenSize.width / 26) + (screenSize.width / 5)
            if let thinksAboutChallenge = posts[indexPath.item].thinksAboutChallenge {
                let rect = NSString(string: thinksAboutChallenge).boundingRect(with: CGSize(width: view.frame.width, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 12)], context: nil)
                return CGSize(width: view.frame.width, height: rect.height + knownHeight)
            }
        }
        return CGSize(width: view.frame.width, height: knownHeight)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        collectionView?.collectionViewLayout.invalidateLayout()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    let zoomImageView = UIImageView()
    let blackBackgroundView = UIView()
    let navBarCoverView = UIView()
    let tabBarCoverView = UIView()
    
    var statusImageView: UIImageView?
    
    func animateImageView(_ statusImageView: UIImageView) {
        self.statusImageView = statusImageView
        if let startingFrame = statusImageView.superview?.convert(statusImageView.frame, to: nil) {
            statusImageView.alpha = 0
            blackBackgroundView.frame = self.view.frame
            blackBackgroundView.backgroundColor = UIColor.black
            blackBackgroundView.alpha = 0
            view.addSubview(blackBackgroundView)
            navBarCoverView.frame = CGRect(x: 0, y: 0, width: 1000, height: 20 + 44)
            navBarCoverView.backgroundColor = UIColor.black
            navBarCoverView.alpha = 0
            if let keyWindow = UIApplication.shared.keyWindow {
                keyWindow.addSubview(navBarCoverView)
                tabBarCoverView.frame = CGRect(x: 0, y: keyWindow.frame.height - 49, width: 1000, height: 49)
                tabBarCoverView.backgroundColor = UIColor.black
                tabBarCoverView.alpha = 0
                keyWindow.addSubview(tabBarCoverView)
            }
            zoomImageView.backgroundColor = UIColor.red
            zoomImageView.frame = startingFrame
            zoomImageView.isUserInteractionEnabled = true
            zoomImageView.image = statusImageView.image
            zoomImageView.contentMode = .scaleAspectFill
            zoomImageView.clipsToBounds = true
            view.addSubview(zoomImageView)
            zoomImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(FeedController.zoomOut)))
            UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: { () -> Void in
                let height = (self.view.frame.width / startingFrame.width) * startingFrame.height
                let y = self.view.frame.height / 2 - height / 2
                self.zoomImageView.frame = CGRect(x: 0, y: y, width: self.view.frame.width, height: height)
                self.blackBackgroundView.alpha = 1
                self.navBarCoverView.alpha = 1
                self.tabBarCoverView.alpha = 1
                }, completion: nil)
        }
    }
    
    func zoomOut() {
        if let startingFrame = statusImageView!.superview?.convert(statusImageView!.frame, to: nil) {
            
            UIView.animate(withDuration: 0.75, animations: { () -> Void in
                self.zoomImageView.frame = startingFrame
                
                self.blackBackgroundView.alpha = 0
                self.navBarCoverView.alpha = 0
                self.tabBarCoverView.alpha = 0
                
                }, completion: { (didComplete) -> Void in
                    self.zoomImageView.removeFromSuperview()
                    self.blackBackgroundView.removeFromSuperview()
                    self.navBarCoverView.removeFromSuperview()
                    self.tabBarCoverView.removeFromSuperview()
                    self.statusImageView?.alpha = 1
            })
            
        }
    }
    
}

class ChallengeHeader: UICollectionReusableView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
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

extension UICollectionViewController
{
    func setImage(fbID: String?, imageView: UIImageView) {
        if let peoplefbID = fbID {
            let url = URL(string: "https://graph.facebook.com/\(peoplefbID)/picture?type=large&return_ssl_resources=1")
            ImageService.getImage(withURL: url!) { image in
                if image != nil {
                    imageView.image = image
                } else {
                    self.setImage(name: "unknown", imageView: imageView)
                }
            }
            //let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
            // imageView.image = UIImage(data: data!)
            // imageView.image = UIImage(named: peopleImage)
        }
    }
    
    func setImage(name: String?, imageView: UIImageView) {
        if let peopleImage = name {
            imageView.image = UIImage(named: peopleImage)
        }
    }
}
