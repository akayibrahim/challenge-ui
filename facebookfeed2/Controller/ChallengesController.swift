//
//  ViewController.swift
//  chlfeed
//
//  Created by AKAY on 11/20/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit

let cellId = "cellId"

class Post: SafeJsonObject {
    var name: String?
    var profileImageName: String?
    var thinksAboutChallenge: String?
    var countOfLike: NSNumber?
    var countOfComments: NSNumber?
    var chlDate: NSDate?
    var untilDate: NSDate?
    var untilDateStr: NSString?
    var type: String?
    var subject: String?
    var done : Bool?
    var countOfJoins : NSNumber?
    var firstTeamCount : String?
    var secondTeamCount : String?
    var challengerFBId : String?
    @nonobjc var versusAttendanceList = [VersusAttendance]()
    @nonobjc var joinAttendanceList = [JoinAttendance]()
}

class VersusAttendance: SafeJsonObject {
    var memberId: String?
    var accept: Bool?
    var firstTeamMember: Bool?
    var secondTeamMember: Bool?
    var FacebookID: String?
    
    init(data: [String : AnyObject]) {
        self.memberId = data["memberId"] as? String ?? ""
        self.accept = data["accept"] as? Bool ?? false
        self.firstTeamMember = data["firstTeamMember"] as? Bool ?? false
        self.secondTeamMember = data["secondTeamMember"] as? Bool ?? false
        self.FacebookID = data["facebookID"] as? String ?? ""
    }
}

class JoinAttendance: SafeJsonObject {
    var memberId: String?
    var join: Bool?
    var proof: Bool?
    var challenger: Bool?
    var FacebookID: String?
    
    init(data: [String : AnyObject]) {
        self.memberId = data["memberId"] as? String ?? ""
        self.join = data["join"] as? Bool ?? false
        self.proof = data["proof"] as? Bool ?? false
        self.challenger = data["challenger"] as? Bool ?? false
        self.FacebookID = data["facebookID"] as? String ?? ""
    }
}

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
                            self.posts.append(post)
                        }
                    }
                } catch let err {
                    print(err)
                }
            } else {
                print(error)
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
            self.fetchData()
        } else {
            //        let samplePost = Post()
            //        samplePost.performSelector(Selector("setName:"), withObject: "my name")
            if let path = Bundle.main.path(forResource: "all_posts", ofType: "json") {
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
                            self.posts.append(post)
                            self.view.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
                        }
                    }
                } catch let err {
                    print(err)
                }
            }
        }
        navigationItem.title = "CHALLENGE"
        collectionView?.alwaysBounceVertical = true
        collectionView?.backgroundColor = UIColor(white: 0.95, alpha: 1)
        collectionView?.register(FeedCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.showsVerticalScrollIndicator = false

    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let feedCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! FeedCell
        feedCell.prepareForReuse()
        feedCell.post = posts[indexPath.item]
        feedCell.feedController = self
        return feedCell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenSize = UIScreen.main.bounds
        let knownHeight: CGFloat = (screenSize.width / 2) + (screenSize.width / 15) + (screenSize.width / 15) + 10

        if let thinksAboutChallenge = posts[indexPath.item].thinksAboutChallenge {
            let rect = NSString(string: thinksAboutChallenge).boundingRect(with: CGSize(width: view.frame.width, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 12)], context: nil)
            return CGSize(width: view.frame.width, height: rect.height + knownHeight + 20)
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


