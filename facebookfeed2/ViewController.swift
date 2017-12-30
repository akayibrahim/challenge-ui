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
    var chlDate: String?
    var untilDate: String?
    var type: String?
    var challengerImageName: String?
    var joinButton: String?
    var subject: String?
    var secondChallengerImageName: String?
    var firstPeopleImage: String?
    var secondPeopleImage: String?
    var thirdPeopleImage: String?
    var firstChlrPeopleImage: String?
    var secondChlrPeopleImage: String?
    var thirdChlrPeopleImage: String?
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

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
                        post.setValuesForKeys(postDictionary)
                        self.posts.append(post)
                    }

                }
                
            } catch let err {
                print(err)
            }
            
        }
        
        navigationItem.title = "CHL"
        
        collectionView?.alwaysBounceVertical = true
        
        collectionView?.backgroundColor = UIColor(white: 0.95, alpha: 1)
        
        collectionView?.register(FeedCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let feedCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! FeedCell
        
        feedCell.post = posts[indexPath.item]
        feedCell.feedController = self
        
        return feedCell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if let thinksAboutChallenge = posts[indexPath.item].thinksAboutChallenge {
            
            let rect = NSString(string: thinksAboutChallenge).boundingRect(with: CGSize(width: view.frame.width, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 10)], context: nil)
            
            let knownHeight: CGFloat = 8 + 20 + 4 + 150 + 1 + 1 + 1 + 4 + 25 + 4
            
            return CGSize(width: view.frame.width, height: rect.height + knownHeight + 12)
        }
        
        return CGSize(width: view.frame.width, height: 500)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        collectionView?.collectionViewLayout.invalidateLayout()
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

class FeedCell: UICollectionViewCell {
    
    var feedController: FeedController?
    
    func animate() {
        feedController?.animateImageView(statusImageView)
    }
    
    var post: Post? {
        didSet {
            if let type = post?.type {
                if type == "SELF" {
                    setupViewsSelf()
                }
                if type == "PRIVATE" {
                    setupViewsVersus("4")
                }
                if type == "PUBLIC" {
                    setupViewsJoin("4")
                }
            }
            if let name = post?.name {
                let attributedText = NSMutableAttributedString(string: "\(name)", attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 12)])
                nameLabel.attributedText = attributedText
            }
            if let thinksAboutChallenge = post?.thinksAboutChallenge {
                thinksAboutChallengeView.text = thinksAboutChallenge
            }
            if let profileImagename = post?.profileImageName {
                profileImageView.image = UIImage(named: profileImagename)
            }
            if let challengerImageName = post?.challengerImageName {
                challengerImageView.image = UIImage(named: challengerImageName)
            }
            worldImageView.image = UIImage(named: "worldImage")
            if let untilDate = post?.untilDate {
                untilDateLabel.text = "UNTIL \(untilDate)"
            }
            vsImageView.image = UIImage(named: "vs")
            if let subject = post?.subject {
                subjectImageView.image = UIImage(named: subject)
            }
            if let countOfComments = post?.countOfComments, let countOfLike = post?.countOfLike {
                countOfLikeAndCommentLabel.text = "\(countOfLike) Likes \(countOfComments) Comments"
            }
            if let secondChallengerImageName = post?.secondChallengerImageName {
                secondChallengerImageView.image = UIImage(named: secondChallengerImageName)
            }
            goalLabel.text = "GOAL"
            goalValueLabel.text = "10"
            if let firstPeopleImage = post?.firstPeopleImage {
                firstPeopleImageView.image = UIImage(named: firstPeopleImage)
            }
            if let secondPeopleImage = post?.secondPeopleImage {
                secondPeopleImageView.image = UIImage(named: secondPeopleImage)
            }
            if let thirdPeopleImage = post?.thirdPeopleImage {
                thirdPeopleImageView.image = UIImage(named: thirdPeopleImage)
            }
            morePeopleImageView.image = UIImage(named: "more_icon")
            if let firstChlrPeopleImage = post?.firstChlrPeopleImage {
                firstChlrPeopleImageView.image = UIImage(named: firstChlrPeopleImage)
            }
            if let secondChlrPeopleImage = post?.secondChlrPeopleImage {
                secondChlrPeopleImageView.image = UIImage(named: secondChlrPeopleImage)
            }
            if let thirdChlrPeopleImage = post?.thirdChlrPeopleImage {
                thirdChlrPeopleImageView.image = UIImage(named: thirdChlrPeopleImage)
            }
            moreChlrPeopleImageView.image = UIImage(named: "more_icon")
            leftSupportImageView.image = UIImage(named: "leftSupport")
            rightSupportImageView.image = UIImage(named: "rightSupport")
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViewsJoin(_ peopleCount: String) {
        shareAddViews()
        middleView.addSubview(joinButton)
        shareHorizantalViews()
        addConstraintsWithFormat("V:|-8-[v0(20)]-4-[v1(150)]-1-[v2]-1-[v3(1)]-4-[v4(25)]-4-|", views: profileImageView, view, thinksAboutChallengeView, dividerLineView, likeButton)
        shareVerticalViews()
        firstChallenger()
        middleView.addSubview(subjectImageView)
        middleView.addConstraintsWithFormat("H:|-10-[v0(70)]-10-|", views: subjectImageView)
        middleView.addConstraintsWithFormat("H:|-15-[v0]-15-|", views: joinButton)
        middleView.addConstraintsWithFormat("V:|-15-[v0(30)]-5-[v1(50)]-5-[v2(20)]-3-|", views: vsImageView, subjectImageView, joinButton)
        
        if peopleCount == "0" {
            challengeToWorld()
        } else if peopleCount == "1" {
            // it is versus actuallly, so for one people it can not be join chl
        } else if peopleCount == "2" {
            challengeToTwoPeople()
            view.addConstraintsWithFormat("H:|-5-[v0(90)]-20-[v1(90)]-20-[v2(90)]-5-|", views: challengerImageView, middleView, peopleView)
        } else if peopleCount == "3" {
            challengeToThreePeople()
            view.addConstraintsWithFormat("H:|-5-[v0(90)]-20-[v1(90)]-20-[v2(90)]-5-|", views: challengerImageView, middleView, peopleView)
        } else if peopleCount == "4" {
            challengeToMorePeople()
            view.addConstraintsWithFormat("H:|-5-[v0(90)]-20-[v1(90)]-20-[v2(90)]-5-|", views: challengerImageView, middleView, peopleView)
        }
    }
    
    func setupViewsSelf() {
        shareAddViews()
        shareHorizantalViews()
        addConstraintsWithFormat("V:|-8-[v0(20)]-4-[v1(150)]-1-[v2]-1-[v3(1)]-4-[v4(25)]-4-|", views: profileImageView, view, thinksAboutChallengeView, dividerLineView, likeButton)
        shareVerticalViews()
        firstChallenger()
        middleView.addSubview(goalView)
        middleView.addConstraintsWithFormat("V:|-15-[v0(30)]-5-[v1(50)]-28-|", views: vsImageView, goalView)
        middleView.addConstraintsWithFormat("H:|-10-[v0(70)]-10-|", views: goalView)
        goalView.addSubview(goalLabel)
        goalView.addSubview(goalValueLabel)
        goalView.addConstraintsWithFormat("H:|-13-[v0]-11-|", views: goalLabel)
        goalView.addConstraintsWithFormat("H:|-12-[v0]-12-|", views: goalValueLabel)
        goalView.addConstraintsWithFormat("V:|-4-[v0]-1-[v1]-4-|", views: goalLabel, goalValueLabel)

        
        subjectImageView.contentMode = .scaleAspectFill
        view.addSubview(subjectImageView)
        view.addConstraintsWithFormat("H:|-5-[v0(90)]-20-[v1(90)]-20-[v2(90)]-5-|", views: challengerImageView, middleView, subjectImageView)
        view.addConstraintsWithFormat("V:|-4-[v0(140)]-4-|", views: subjectImageView)
    }
    
    func setupViewsVersus(_ peopleCount: String) {
        shareAddViews()
        shareHorizantalViews()
        addConstraintsWithFormat("V:|-8-[v0(20)]-4-[v1(150)]-1-[v2]-1-[v3(1)]-4-[v4(25)]-4-|", views: profileImageView, view, thinksAboutChallengeView, dividerLineView, likeButton)
        shareVerticalViews()
        
        middleView.addSubview(subjectImageView)
        middleView.addSubview(leftSupportImageView)
        middleView.addSubview(supportButton)
        supportButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 6)
        supportButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0)
        middleView.addSubview(rightSupportImageView)
        middleView.addConstraintsWithFormat("H:|-10-[v0(70)]-10-|", views: subjectImageView)
        middleView.addConstraintsWithFormat("H:|-5-[v0(20)]-3-[v1(30)]-2-[v2(20)]-5-|", views: leftSupportImageView, supportButton, rightSupportImageView)
        middleView.addConstraintsWithFormat("V:|-15-[v0(30)]-5-[v1(50)]-5-[v2(20)]-3-|", views: vsImageView, subjectImageView, leftSupportImageView)
        middleView.addConstraintsWithFormat("V:[v0(20)]-3-|", views: supportButton)
        middleView.addConstraintsWithFormat("V:[v0(20)]-3-|", views: rightSupportImageView)
        
        if peopleCount == "1" {
            firstChallenger()
            secondChallenger()
            view.addConstraintsWithFormat("H:|-5-[v0(90)]-20-[v1(90)]-20-[v2(90)]-5-|", views: challengerImageView, middleView, secondChallengerImageView)
        } else if peopleCount == "2" {
            challengeFromTwoPeople()
            challengeToTwoPeople()
            view.addConstraintsWithFormat("H:|-5-[v0(90)]-20-[v1(90)]-20-[v2(90)]-5-|", views: chlrPeopleView, middleView, peopleView)
        } else if peopleCount == "3" {
            challengeFromThreePeople()
            challengeToThreePeople()
            view.addConstraintsWithFormat("H:|-5-[v0(90)]-20-[v1(90)]-20-[v2(90)]-5-|", views: chlrPeopleView, middleView, peopleView)
        } else if peopleCount == "4" {
            challengeFromMorePeople()
            challengeToMorePeople()
            view.addConstraintsWithFormat("H:|-5-[v0(90)]-20-[v1(90)]-20-[v2(90)]-5-|", views: chlrPeopleView, middleView, peopleView)
        }
    }
    
    func secondChallenger() {
        view.addSubview(secondChallengerImageView)
        view.addConstraintsWithFormat("V:|-4-[v0(140)]-4-|", views: secondChallengerImageView)
    }
    
    func firstChallenger() {
        view.addSubview(challengerImageView)
        view.addConstraintsWithFormat("V:|-4-[v0(140)]-4-|", views: challengerImageView)
    }
    
    func challengeToWorld() {
        view.addSubview(worldImageView)
        view.addConstraintsWithFormat("H:|-5-[v0(90)]-20-[v1(90)]-20-[v2(90)]-5-|", views: challengerImageView, middleView, worldImageView)
        view.addConstraintsWithFormat("V:|-4-[v0(140)]-4-|", views: worldImageView)
    }
    
    func challengeToTwoPeople() {
        view.addSubview(peopleView)
        view.addConstraintsWithFormat("V:|-4-[v0(140)]-4-|", views: peopleView)
        
        peopleView.addSubview(firstPeopleImageView)
        peopleView.addConstraintsWithFormat("H:|-5-[v0]-5-|", views: firstPeopleImageView)
        peopleView.addSubview(secondPeopleImageView)
        peopleView.addConstraintsWithFormat("H:|-5-[v0]-5-|", views: secondPeopleImageView)
        peopleView.addConstraintsWithFormat("V:|[v0(69)]-2-[v1(69)]|", views: firstPeopleImageView, secondPeopleImageView)
    }
    
    func challengeToThreePeople() {
        view.addSubview(peopleView)
        view.addConstraintsWithFormat("V:|-4-[v0(140)]-4-|", views: peopleView)
        
        peopleView.addSubview(firstPeopleImageView)
        peopleView.addSubview(thirdPeopleImageView)
        peopleView.addConstraintsWithFormat("H:|-5-[v0(37)]-2-[v1(37)]-5-|", views: firstPeopleImageView, thirdPeopleImageView)
        peopleView.addSubview(secondPeopleImageView)
        peopleView.addConstraintsWithFormat("H:|-5-[v0]-5-|", views: secondPeopleImageView)
        peopleView.addConstraintsWithFormat("V:|[v0(69)]-2-[v1(69)]|", views: firstPeopleImageView, secondPeopleImageView)
        peopleView.addConstraintsWithFormat("V:|[v0(69)]|", views: thirdPeopleImageView)
    }
    
    func challengeToMorePeople() {
        view.addSubview(peopleView)
        view.addConstraintsWithFormat("V:|-4-[v0(140)]-4-|", views: peopleView)
        
        peopleView.addSubview(firstPeopleImageView)
        peopleView.addSubview(thirdPeopleImageView)
        peopleView.addConstraintsWithFormat("H:|-5-[v0(37)]-2-[v1(37)]-5-|", views: firstPeopleImageView, thirdPeopleImageView)
        peopleView.addSubview(secondPeopleImageView)
        peopleView.addSubview(morePeopleImageView)
        peopleView.addConstraintsWithFormat("H:|-5-[v0(37)]-2-[v1(37)]-5-|", views: secondPeopleImageView, morePeopleImageView)
        peopleView.addConstraintsWithFormat("V:|[v0(69)]-2-[v1(69)]|", views: firstPeopleImageView, secondPeopleImageView)
        peopleView.addConstraintsWithFormat("V:|[v0(69)]|", views: thirdPeopleImageView)
        peopleView.addConstraintsWithFormat("V:[v0(69)]|", views: morePeopleImageView)
    }
    
    func challengeFromTwoPeople() {
        view.addSubview(chlrPeopleView)
        view.addConstraintsWithFormat("V:|-4-[v0(140)]-4-|", views: chlrPeopleView)
        
        chlrPeopleView.addSubview(firstChlrPeopleImageView)
        chlrPeopleView.addConstraintsWithFormat("H:|-5-[v0]-5-|", views: firstChlrPeopleImageView)
        chlrPeopleView.addSubview(secondChlrPeopleImageView)
        chlrPeopleView.addConstraintsWithFormat("H:|-5-[v0]-5-|", views: secondChlrPeopleImageView)
        chlrPeopleView.addConstraintsWithFormat("V:|[v0(69)]-2-[v1(69)]|", views: firstChlrPeopleImageView, secondChlrPeopleImageView)
    }
    
    func challengeFromThreePeople() {
        view.addSubview(chlrPeopleView)
        view.addConstraintsWithFormat("V:|-4-[v0(140)]-4-|", views: chlrPeopleView)
        
        chlrPeopleView.addSubview(firstChlrPeopleImageView)
        chlrPeopleView.addSubview(thirdChlrPeopleImageView)
        chlrPeopleView.addConstraintsWithFormat("H:|-5-[v0(37)]-2-[v1(37)]-5-|", views: firstChlrPeopleImageView, thirdChlrPeopleImageView)
        chlrPeopleView.addSubview(secondChlrPeopleImageView)
        chlrPeopleView.addConstraintsWithFormat("H:|-5-[v0]-5-|", views: secondChlrPeopleImageView)
        chlrPeopleView.addConstraintsWithFormat("V:|[v0(69)]-2-[v1(69)]|", views: firstChlrPeopleImageView, secondChlrPeopleImageView)
        chlrPeopleView.addConstraintsWithFormat("V:|[v0(69)]|", views: thirdChlrPeopleImageView)
    }
    
    func challengeFromMorePeople() {
        view.addSubview(chlrPeopleView)
        view.addConstraintsWithFormat("V:|-4-[v0(140)]-4-|", views: chlrPeopleView)
        
        chlrPeopleView.addSubview(firstChlrPeopleImageView)
        chlrPeopleView.addSubview(thirdChlrPeopleImageView)
        chlrPeopleView.addConstraintsWithFormat("H:|-5-[v0(37)]-2-[v1(37)]-5-|", views: firstChlrPeopleImageView, thirdChlrPeopleImageView)
        chlrPeopleView.addSubview(secondChlrPeopleImageView)
        chlrPeopleView.addSubview(moreChlrPeopleImageView)
        chlrPeopleView.addConstraintsWithFormat("H:|-5-[v0(37)]-2-[v1(37)]-5-|", views: secondChlrPeopleImageView, moreChlrPeopleImageView)
        chlrPeopleView.addConstraintsWithFormat("V:|[v0(69)]-2-[v1(69)]|", views: firstChlrPeopleImageView, secondChlrPeopleImageView)
        chlrPeopleView.addConstraintsWithFormat("V:|[v0(69)]|", views: thirdChlrPeopleImageView)
        chlrPeopleView.addConstraintsWithFormat("V:[v0(69)]|", views: moreChlrPeopleImageView)
    }
    
    func shareAddViews() {
        backgroundColor = UIColor.white

        addSubview(nameLabel)
        addSubview(profileImageView)
        addSubview(thinksAboutChallengeView)
        addSubview(view)
        
        view.addSubview(middleView)
        
        middleView.addSubview(vsImageView)
        
        addSubview(untilDateLabel)
        addSubview(dividerLineView)
        
        addSubview(likeButton)
        addSubview(commentButton)
        addSubview(shareButton)
        addSubview(countOfLikeAndCommentLabel)
    }
    
    func shareHorizantalViews() {
        statusImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(FeedCell.animate as (FeedCell) -> () -> ())))
        addConstraintsWithFormat("H:|-8-[v0(20)]-8-[v1][v2]-8-|", views: profileImageView, nameLabel, untilDateLabel)
        addConstraintsWithFormat("H:|-4-[v0]-4-|", views: thinksAboutChallengeView)
        addConstraintsWithFormat("H:|[v0]|", views: view)
        
        middleView.addConstraintsWithFormat("H:|-12-[v0]-8-|", views: vsImageView)
        addConstraintsWithFormat("H:|-12-[v0]-12-|", views: dividerLineView)
        
        addConstraintsWithFormat("H:|-4-[v0(30)]-2-[v1(30)]-2-[v2(30)][v3]-5-|", views: likeButton, commentButton, shareButton, countOfLikeAndCommentLabel)
    }
    
    func shareVerticalViews() {
        addConstraintsWithFormat("V:|-10-[v0]", views: nameLabel)
        addConstraintsWithFormat("V:|-14-[v0]", views: untilDateLabel)
        view.addConstraintsWithFormat("V:|-4-[v0(140)]-4-|", views: middleView)
        
        addConstraintsWithFormat("V:[v0(25)]-4-|", views: commentButton)
        addConstraintsWithFormat("V:[v0(25)]-4-|", views: shareButton)
        addConstraintsWithFormat("V:[v0(25)]-4-|", views: countOfLikeAndCommentLabel)
        
    }
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        return label
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = imageView.frame.size.width / 2
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let thinksAboutChallengeView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 10)
        textView.textAlignment = NSTextAlignment.center
        textView.textColor = UIColor.gray
        textView.isScrollEnabled = false
        textView.textContainer.lineBreakMode = NSLineBreakMode.byWordWrapping
        return textView
    }()
    
    let statusImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    let countOfLikeAndCommentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 8)
        label.textAlignment = NSTextAlignment.right;
        return label
    }()
    
    let dividerLineView: UIView = {
        let view = UIView()
        // view.backgroundColor = UIColor.red
        view.layer.cornerRadius = 1.5
        view.layer.masksToBounds = true
        view.layer.borderWidth = 0.1
        view.layer.borderColor = UIColor.gray.cgColor
        return view
    }()
    
    let likeButton = FeedCell.buttonForTitle("", imageName: "like")
    let commentButton: UIButton = FeedCell.buttonForTitle("", imageName: "comment")
    let shareButton: UIButton = FeedCell.buttonForTitle("", imageName: "share")
    
    static func buttonForTitle(_ title: String, imageName: String) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: UIControlState())
        button.setTitleColor(UIColor.rgb(143, green: 150, blue: 163), for: UIControlState())
        
        button.setImage(UIImage(named: imageName), for: UIControlState())
        button.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0)
        
        button.titleLabel?.font = UIFont.systemFont(ofSize: 10)
        button.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        
        return button
    }
    
    static func buttonForTitleWithBorder(_ title: String, imageName: String) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: UIControlState())
        button.setTitleColor(UIColor.rgb(143, green: 150, blue: 163), for: UIControlState())
        
        button.setImage(UIImage(named: imageName), for: UIControlState())
        button.titleEdgeInsets = UIEdgeInsetsMake(8, 0, 8, 0)
        
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 10)
        button.layer.borderColor = UIColor.gray.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 3.0
        button.clipsToBounds = true
        
        return button
    }
    
    let challengerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 4.0
        imageView.layer.masksToBounds = true
        //imageView.isUserInteractionEnabled = true
        //imageView.backgroundColor=UIColor.red
        return imageView
    }()
    
    let secondChallengerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 4.0
        imageView.layer.masksToBounds = true
        //imageView.isUserInteractionEnabled = true
        //imageView.backgroundColor=UIColor.red
        return imageView
    }()
    
    let firstPeopleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 4.0
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    let secondPeopleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 4.0
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    let thirdPeopleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 4.0
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    let morePeopleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 4.0
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    let firstChlrPeopleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 4.0
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    let secondChlrPeopleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 4.0
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    let thirdChlrPeopleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 4.0
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    let moreChlrPeopleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 4.0
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    let vsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        //imageView.layer.masksToBounds = true
        //imageView.isUserInteractionEnabled = true
        //imageView.backgroundColor=UIColor.blue
        imageView.semanticContentAttribute = .forceRightToLeft
        return imageView
    }()
    
    let worldImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 4.0
        imageView.layer.masksToBounds = true
        //imageView.isUserInteractionEnabled = true
        //imageView.backgroundColor=UIColor.yellow
        return imageView
    }()
    
    let subjectImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 4.0
        imageView.layer.masksToBounds = true
        //imageView.isUserInteractionEnabled = true
        //imageView.backgroundColor=UIColor.yellow
        return imageView
    }()
    
    let leftSupportImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    let rightSupportImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    let view: UIView = {
        let view = UIView()
        // view.backgroundColor=UIColor.gray
        view.layer.cornerRadius = 1.5
        view.layer.masksToBounds = true
        view.layer.borderWidth = 0.1
        view.layer.borderColor = UIColor.gray.cgColor
        return view
    }()
    
    let middleView: UIView = {
        let view = UIView()
        view.backgroundColor=UIColor.white
        return view
    }()
    
    let goalView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        view.layer.cornerRadius = 4.0
        view.layer.masksToBounds = true
        return view
    }()
    
    let peopleView: UIView = {
        let view = UIView()
        view.backgroundColor=UIColor.white
        return view
    }()
    
    let chlrPeopleView: UIView = {
        let view = UIView()
        view.backgroundColor=UIColor.white
        return view
    }()
    
    let untilDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 8)
        label.textAlignment = .center
        label.textColor = UIColor.gray
        // label.backgroundColor=UIColor.red
        return label
    }()
    
    let goalLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 9)
        label.textAlignment = .center
        label.textColor = UIColor.white
        // label.backgroundColor=UIColor.red
        return label
    }()
    
    let goalValueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.shadowColor = UIColor.black
        // label.backgroundColor=UIColor.red
        return label
    }()
    
    let joinButton = FeedCell.buttonForTitleWithBorder("Join", imageName: "Join")
    let supportButton = FeedCell.buttonForTitleWithBorder("Support", imageName: "Support")
}

extension UIColor {
    
    static func rgb(_ red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
    
}

extension UIView {
    
    func addConstraintsWithFormat(_ format: String, views: UIView...) {
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            viewsDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
    }
    
}



