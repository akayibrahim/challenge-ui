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
    var subject: String?
    var challengerImageName: String?
    var secondChallengerImageName: String?
    var firstPeopleImage: String?
    var secondPeopleImage: String?
    var thirdPeopleImage: String?
    var firstChlrPeopleImage: String?
    var secondChlrPeopleImage: String?
    var thirdChlrPeopleImage: String?
    var done : String?
    var countOfJoins : NSNumber?
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
            
            let rect = NSString(string: thinksAboutChallenge).boundingRect(with: CGSize(width: view.frame.width, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14)], context: nil)
            
            let knownHeight: CGFloat = 8 + 20 + 2 + 1 + 2 + 150 + 2 + 1 + 2 + 1 + 1 + 4 + 25 + 4 + 20
            
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
                let attributedText = NSMutableAttributedString(string: "\(name)", attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14)])
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
            if let subject = post?.subject {
                subjectImageView.image = UIImage(named: subject)
            }
            if let countOfComments = post?.countOfComments, let countOfLike = post?.countOfLike {
                countOfLikeAndCommentLabel.text = "\(countOfLike) Likes \(countOfComments) Comments "
            }
            if post?.type == "PUBLIC" {
                if let countOfJoins = post?.countOfJoins {
                    countOfLikeAndCommentLabel.text?.append(" \(countOfJoins) Joins ")
                }
            }
            if let secondChallengerImageName = post?.secondChallengerImageName {
                secondChallengerImageView.image = UIImage(named: secondChallengerImageName)
            }
            if let firstPeopleImage = post?.firstPeopleImage {
                firstPeopleImageView.image = UIImage(named: firstPeopleImage)
            }
            if let secondPeopleImage = post?.secondPeopleImage {
                secondPeopleImageView.image = UIImage(named: secondPeopleImage)
            }
            if let thirdPeopleImage = post?.thirdPeopleImage {
                thirdPeopleImageView.image = UIImage(named: thirdPeopleImage)
            }
            if let firstChlrPeopleImage = post?.firstChlrPeopleImage {
                firstChlrPeopleImageView.image = UIImage(named: firstChlrPeopleImage)
            }
            if let secondChlrPeopleImage = post?.secondChlrPeopleImage {
                secondChlrPeopleImageView.image = UIImage(named: secondChlrPeopleImage)
            }
            if let thirdChlrPeopleImage = post?.thirdChlrPeopleImage {
                thirdChlrPeopleImageView.image = UIImage(named: thirdChlrPeopleImage)
            }
            if let untilDate = post?.untilDate {
                untilDateLabel.text = "\(untilDate)"
            }
            worldImageView.image = UIImage(named: "worldImage")
            vsImageView.image = UIImage(named: "vs")
            morePeopleImageView.image = UIImage(named: "more_icon")
            morePeopleImageView.contentMode = .scaleAspectFit
            moreChlrPeopleImageView.image = UIImage(named: "more_icon")
            moreChlrPeopleImageView.contentMode = .scaleAspectFit
            goalLabel.text = "GOAL: 10"
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViewsJoin(_ peopleCount: String) {
        backgroundColor = UIColor.white
        let contentGuide = self.readableContentGuide
        let topMiddleLeftGuide = UILayoutGuide()
        addLayoutGuide(topMiddleLeftGuide)
        addSubview(profileImageView)
        addSubview(nameLabel)
        addSubview(goalLabel)
        profileImageView.topAnchor.constraint(equalTo: contentGuide.topAnchor).isActive = true
        profileImageView.leadingAnchor.constraint(equalTo: contentGuide.leadingAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalTo: contentGuide.widthAnchor, multiplier: 1/10).isActive = true
        profileImageView.heightAnchor.constraint(equalTo: contentGuide.widthAnchor, multiplier: 1/10).isActive = true
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        
        topMiddleLeftGuide.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 8.0).isActive = true
        
        nameLabel.topAnchor.constraint(equalTo: profileImageView.topAnchor, constant: 8).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: topMiddleLeftGuide.trailingAnchor).isActive = true
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        goalLabel.topAnchor.constraint(equalTo: profileImageView.topAnchor, constant: 8).isActive = true
        goalLabel.trailingAnchor.constraint(equalTo: contentGuide.trailingAnchor).isActive = true
        goalLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let centerMiddleLeftGuide = UILayoutGuide()
        let centerMiddleRightGuide = UILayoutGuide()
        addLayoutGuide(centerMiddleLeftGuide)
        addLayoutGuide(centerMiddleRightGuide)
        addSubview(challengerImageView)
        addSubview(vsImageView)
        addSubview(subjectImageView)
        addSubview(worldImageView)
        
        challengerImageView.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 4).isActive = true
        challengerImageView.leadingAnchor.constraint(equalTo: contentGuide.leadingAnchor).isActive = true
        challengerImageView.trailingAnchor.constraint(equalTo: centerMiddleLeftGuide.leadingAnchor).isActive = true
        challengerImageView.widthAnchor.constraint(equalTo: contentGuide.widthAnchor, multiplier: 1/3).isActive = true
        challengerImageView.centerYAnchor.constraint(equalTo: contentGuide.centerYAnchor).isActive = true
        challengerImageView.translatesAutoresizingMaskIntoConstraints = false
        
        let middleTopGuide = UILayoutGuide()
        let middleCenterGuide = UILayoutGuide()
        let middleBottomGuide = UILayoutGuide()
        addLayoutGuide(middleTopGuide)
        addLayoutGuide(middleCenterGuide)
        addLayoutGuide(middleBottomGuide)
        
        middleTopGuide.heightAnchor.constraint(equalTo: challengerImageView.heightAnchor, multiplier: 1/9).isActive = true
        middleCenterGuide.heightAnchor.constraint(equalTo: challengerImageView.heightAnchor, multiplier: 1/9).isActive = true
        middleBottomGuide.heightAnchor.constraint(equalTo: challengerImageView.heightAnchor, multiplier: 1/9).isActive = true
        
        middleTopGuide.topAnchor.constraint(equalTo: challengerImageView.topAnchor).isActive = true
        vsImageView.leadingAnchor.constraint(equalTo: challengerImageView.trailingAnchor).isActive = true
        vsImageView.trailingAnchor.constraint(equalTo: worldImageView.leadingAnchor).isActive = true
        vsImageView.heightAnchor.constraint(equalTo: challengerImageView.heightAnchor, multiplier: 1/3).isActive = true
        vsImageView.topAnchor.constraint(equalTo: middleTopGuide.bottomAnchor).isActive = true
        vsImageView.translatesAutoresizingMaskIntoConstraints = false
        middleCenterGuide.topAnchor.constraint(equalTo: vsImageView.bottomAnchor).isActive = true
        subjectImageView.leadingAnchor.constraint(equalTo: challengerImageView.trailingAnchor).isActive = true
        subjectImageView.trailingAnchor.constraint(equalTo: worldImageView.leadingAnchor).isActive = true
        subjectImageView.heightAnchor.constraint(equalTo: challengerImageView.heightAnchor, multiplier: 1/3).isActive = true
        subjectImageView.topAnchor.constraint(equalTo: middleCenterGuide.bottomAnchor).isActive = true
        subjectImageView.translatesAutoresizingMaskIntoConstraints = false
        middleBottomGuide.topAnchor.constraint(equalTo: subjectImageView.bottomAnchor).isActive = true
        
        worldImageView.leadingAnchor.constraint(equalTo: centerMiddleRightGuide.trailingAnchor).isActive = true
        worldImageView.trailingAnchor.constraint(equalTo: contentGuide.trailingAnchor).isActive = true
        worldImageView.widthAnchor.constraint(equalTo: contentGuide.widthAnchor, multiplier: 1/3).isActive = true
        worldImageView.centerYAnchor.constraint(equalTo: challengerImageView.centerYAnchor).isActive = true
        worldImageView.translatesAutoresizingMaskIntoConstraints = false
        
        let bottomMiddleLeftGuide = UILayoutGuide()
        let bottomMiddleRightGuide = UILayoutGuide()
        addLayoutGuide(bottomMiddleLeftGuide)
        addLayoutGuide(bottomMiddleRightGuide)
        addSubview(likeButton)
        addSubview(commentButton)
        addSubview(shareButton)
        addSubview(countOfLikeAndCommentLabel)
        
        likeButton.bottomAnchor.constraint(equalTo: contentGuide.bottomAnchor).isActive = true
        likeButton.leadingAnchor.constraint(equalTo: contentGuide.leadingAnchor).isActive = true
        likeButton.widthAnchor.constraint(equalTo: contentGuide.widthAnchor, multiplier: 1/12).isActive = true
        likeButton.heightAnchor.constraint(equalTo: contentGuide.widthAnchor, multiplier: 1/12).isActive = true
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        bottomMiddleLeftGuide.leadingAnchor.constraint(equalTo: likeButton.trailingAnchor, constant: 8.0).isActive = true
        
        commentButton.bottomAnchor.constraint(equalTo: contentGuide.bottomAnchor).isActive = true
        commentButton.leadingAnchor.constraint(equalTo: bottomMiddleLeftGuide.leadingAnchor).isActive = true
        commentButton.widthAnchor.constraint(equalTo: contentGuide.widthAnchor, multiplier: 1/12).isActive = true
        commentButton.heightAnchor.constraint(equalTo: contentGuide.widthAnchor, multiplier: 1/12).isActive = true
        commentButton.translatesAutoresizingMaskIntoConstraints = false
        bottomMiddleRightGuide.leadingAnchor.constraint(equalTo: commentButton.trailingAnchor, constant: 8.0).isActive = true
        
        shareButton.bottomAnchor.constraint(equalTo: contentGuide.bottomAnchor).isActive = true
        shareButton.leadingAnchor.constraint(equalTo: bottomMiddleRightGuide.leadingAnchor).isActive = true
        shareButton.widthAnchor.constraint(equalTo: contentGuide.widthAnchor, multiplier: 1/12).isActive = true
        shareButton.heightAnchor.constraint(equalTo: contentGuide.widthAnchor, multiplier: 1/12).isActive = true
        shareButton.translatesAutoresizingMaskIntoConstraints = false
        
        countOfLikeAndCommentLabel.bottomAnchor.constraint(equalTo: contentGuide.bottomAnchor, constant: -5).isActive = true
        countOfLikeAndCommentLabel.trailingAnchor.constraint(equalTo: contentGuide.trailingAnchor).isActive = true
        countOfLikeAndCommentLabel.translatesAutoresizingMaskIntoConstraints = false
        
        /**
        shareAddViews()
        shareHorizantalViews()
        shareVerticalViews()
        setChallenger(challengerImageView)
        addSubjectViewAndButtonToMiidle(joinButton)
        if peopleCount == "0" {
            setChallenger(worldImageView)
            setHorizantalViewConstraint(challengerImageView, secondView :worldImageView)
        } else if peopleCount == "1" {
            // it is versus actuallly, so for one people it can not be join chl
        } else if peopleCount == "2" {
            challengeForTwoPeople(peopleView, firstPerson: firstPeopleImageView, secondPerson: secondPeopleImageView)
            setHorizantalViewConstraint(challengerImageView, secondView :peopleView)
        } else if peopleCount == "3" {
            challengeForThreePeople(peopleView, firstPerson: firstPeopleImageView, secondPerson: secondPeopleImageView, thirdPerson: thirdPeopleImageView)
            setHorizantalViewConstraint(challengerImageView, secondView :peopleView)
        } else if peopleCount == "4" {
            challengeForMorePeople(peopleView, firstPerson: firstPeopleImageView, secondPerson: secondPeopleImageView, thirdPerson: thirdPeopleImageView, morePerson: moreChlrPeopleImageView)
            setHorizantalViewConstraint(challengerImageView, secondView :peopleView)
        }*/
    }
    
    func setupViewsSelf() {
        shareAddViews()
        shareHorizantalViews()
        shareVerticalViews()
        setChallenger(challengerImageView)
        middleView.addSubview(goalLabel)
        middleView.addConstraintsWithFormat("V:|-15-[v0(30)]-1-[v1(17)]-40-|", views: vsImageView, goalLabel)
        middleView.addConstraintsWithFormat("H:|-10-[v0(70)]-10-|", views: goalLabel)
        
        subjectImageView.contentMode = .scaleAspectFill
        setChallenger(subjectImageView)
        setHorizantalViewConstraint(challengerImageView, secondView :subjectImageView)
    }
    
    func setupViewsVersus(_ peopleCount: String) {
        shareAddViews()
        shareHorizantalViews()
        shareVerticalViews()
        addSubjectViewAndButtonToMiidle(supportButton)
        if peopleCount == "1" {
            setChallenger(challengerImageView)
            setChallenger(secondChallengerImageView)
            setHorizantalViewConstraint(challengerImageView, secondView :secondChallengerImageView)
        } else if peopleCount == "2" {
            challengeForTwoPeople(chlrPeopleView, firstPerson: firstChlrPeopleImageView, secondPerson: secondChlrPeopleImageView)
            challengeForTwoPeople(peopleView, firstPerson: firstPeopleImageView, secondPerson: secondPeopleImageView)
            setHorizantalViewConstraint(chlrPeopleView, secondView :peopleView)
        } else if peopleCount == "3" {
            challengeForThreePeople(chlrPeopleView, firstPerson: firstChlrPeopleImageView, secondPerson: secondChlrPeopleImageView, thirdPerson: thirdChlrPeopleImageView)
            challengeForThreePeople(peopleView, firstPerson: firstPeopleImageView, secondPerson: secondPeopleImageView, thirdPerson: thirdPeopleImageView)
            setHorizantalViewConstraint(chlrPeopleView, secondView :peopleView)
        } else if peopleCount == "4" {
            challengeForMorePeople(chlrPeopleView, firstPerson: firstChlrPeopleImageView, secondPerson: secondChlrPeopleImageView, thirdPerson: thirdChlrPeopleImageView, morePerson: moreChlrPeopleImageView)
            challengeForMorePeople(peopleView, firstPerson: firstPeopleImageView, secondPerson: secondPeopleImageView, thirdPerson: thirdPeopleImageView, morePerson: morePeopleImageView)
            setHorizantalViewConstraint(chlrPeopleView, secondView :peopleView)
        }
    }
    
    func addSubjectViewAndButtonToMiidle(_ button: UIButton) {
        middleView.addSubview(subjectImageView)
        middleView.addSubview(button)
        middleView.addConstraintsWithFormat("H:|-10-[v0(70)]-10-|", views: subjectImageView)
        middleView.addConstraintsWithFormat("H:|-15-[v0]-15-|", views: button)
        middleView.addConstraintsWithFormat("V:|-15-[v0(30)]-9-[v1(50)]-4-[v2(20)]|", views: vsImageView, subjectImageView, button)
    }
    
    func setHorizantalViewConstraint(_ firstView: UIView, secondView: UIView) {
        view.addConstraintsWithFormat("H:|-5-[v0(100)]-10-[v1(90)]-10-[v2(100)]-5-|", views: firstView, middleView, secondView)
    }
    
    func setChallenger(_ challengerView: UIView) {
        view.addSubview(challengerView)
        view.addConstraintsWithFormat("V:|-4-[v0(140)]-4-|", views: challengerView)
    }
    
    func challengeForTwoPeople(_ whichView:UIView, firstPerson: UIView, secondPerson: UIView) {
        view.addSubview(whichView)
        view.addConstraintsWithFormat("V:|-4-[v0(140)]-4-|", views: whichView)
        
        whichView.addSubview(firstPerson)
        whichView.addConstraintsWithFormat("H:|-5-[v0]-5-|", views: firstPerson)
        whichView.addSubview(secondPerson)
        whichView.addConstraintsWithFormat("H:|-5-[v0]-5-|", views: secondPerson)
        whichView.addConstraintsWithFormat("V:|[v0(69)]-2-[v1(69)]|", views: firstPerson, secondPerson)
    }
    
    func challengeForThreePeople(_ whichView:UIView, firstPerson: UIView, secondPerson: UIView, thirdPerson: UIView) {
        view.addSubview(whichView)
        view.addConstraintsWithFormat("V:|-4-[v0(140)]-4-|", views: whichView)
        
        whichView.addSubview(firstPerson)
        whichView.addSubview(thirdPerson)
        whichView.addConstraintsWithFormat("H:|-5-[v0(44)]-2-[v1(44)]-5-|", views: firstPerson, thirdPerson)
        whichView.addSubview(secondPerson)
        whichView.addConstraintsWithFormat("H:|-5-[v0]-5-|", views: secondPerson)
        whichView.addConstraintsWithFormat("V:|[v0(69)]-2-[v1(69)]|", views: firstPerson, secondPerson)
        whichView.addConstraintsWithFormat("V:|[v0(69)]|", views: thirdPerson)
    }
    
    func challengeForMorePeople(_ whichView:UIView, firstPerson: UIView, secondPerson: UIView, thirdPerson: UIView, morePerson: UIView) {
        view.addSubview(whichView)
        view.addConstraintsWithFormat("V:|-4-[v0(140)]-4-|", views: whichView)
        
        whichView.addSubview(firstPerson)
        whichView.addSubview(thirdPerson)
        whichView.addConstraintsWithFormat("H:|-5-[v0(44)]-2-[v1(44)]-5-|", views: firstPerson, thirdPerson)
        whichView.addSubview(secondPerson)
        whichView.addSubview(morePerson)
        whichView.addConstraintsWithFormat("H:|-5-[v0(44)]-2-[v1(44)]-5-|", views: secondPerson, morePerson)
        whichView.addConstraintsWithFormat("V:|[v0(69)]-2-[v1(69)]|", views: firstPerson, secondPerson)
        whichView.addConstraintsWithFormat("V:|[v0(69)]|", views: thirdPerson)
        whichView.addConstraintsWithFormat("V:[v0(69)]|", views: morePerson)
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
        addSubview(dividerLineView1)
        addSubview(dividerLineView2)
        addSubview(likeButton)
        addSubview(commentButton)
        addSubview(shareButton)
        addSubview(countOfLikeAndCommentLabel)
    }
    
    func shareHorizantalViews() {
        statusImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(FeedCell.animate as (FeedCell) -> () -> ())))
        addConstraintsWithFormat("H:|-8-[v0(30)]-8-[v1][v2]-8-|", views: profileImageView, nameLabel, untilDateLabel)
        addConstraintsWithFormat("H:|-4-[v0]-4-|", views: thinksAboutChallengeView)
        addConstraintsWithFormat("H:|[v0]|", views: view)
        
        middleView.addConstraintsWithFormat("H:|-12-[v0]-8-|", views: vsImageView)
        addConstraintsWithFormat("H:|-5-[v0]-5-|", views: dividerLineView)
        addConstraintsWithFormat("H:|-5-[v0]-5-|", views: dividerLineView1)
        addConstraintsWithFormat("H:|-5-[v0]-5-|", views: dividerLineView2)
        
        addConstraintsWithFormat("H:|-4-[v0(30)]-2-[v1(30)]-2-[v2(30)][v3]-5-|", views: likeButton, commentButton, shareButton, countOfLikeAndCommentLabel)
    }
    
    func shareVerticalViews() {
        addConstraintsWithFormat("V:|-13-[v0]", views: nameLabel)
        addConstraintsWithFormat("V:|-13-[v0]", views: untilDateLabel)
        view.addConstraintsWithFormat("V:|-4-[v0(140)]-4-|", views: middleView)
        
        addConstraintsWithFormat("V:[v0(25)]-4-|", views: commentButton)
        addConstraintsWithFormat("V:[v0(25)]-4-|", views: shareButton)
        addConstraintsWithFormat("V:[v0(25)]-4-|", views: countOfLikeAndCommentLabel)
        
        addConstraintsWithFormat("V:|-8-[v0(30)]-2-[v1(1)]-2-[v2(150)]-2-[v3(1)]-2-[v4]-1-[v5(1)]-4-[v6(25)]-4-|", views: profileImageView, dividerLineView, view, dividerLineView1, thinksAboutChallengeView, dividerLineView2, likeButton)
    }
    
    let countOfLikeAndCommentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 10)
        label.textAlignment = NSTextAlignment.right;
        return label
    }()
    
    let thinksAboutChallengeView: UILabel = {
        let textView = UILabel()
        textView.font = UIFont.boldSystemFont(ofSize: 12)
        textView.textAlignment = NSTextAlignment.left
        textView.textColor = UIColor.white
        textView.lineBreakMode = NSLineBreakMode.byWordWrapping
        textView.backgroundColor = UIColor(red: 51/255, green: 90/255, blue: 149/255, alpha: 1)
        textView.layer.cornerRadius = 2
        textView.layer.masksToBounds = true
        return textView	
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = imageView.frame.size.width / 2
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let statusImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    let vsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.semanticContentAttribute = .forceRightToLeft
        return imageView
    }()
    
    static func labelCreateDef(_ line: Int) -> UILabel {
        let label = UILabel()
        label.numberOfLines = line
        return label
    }
    
    let nameLabel: UILabel = FeedCell.labelCreateDef(1)
    
    static func labelCreate(_ fontSize: CGFloat) -> UILabel {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: fontSize)
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.backgroundColor = UIColor(red: 255/255, green: 90/255, blue: 51/255, alpha: 1)
        label.layer.cornerRadius = 3
        label.layer.masksToBounds = true
        return label
    }
    
    let untilDateLabel: UILabel = FeedCell.labelCreate(14)
    let goalLabel: UILabel = FeedCell.labelCreate(12)
    
    static func lineForDivider() -> UIView {
        let view = UIView()
        // view.backgroundColor = UIColor.red
        view.layer.cornerRadius = 1.5
        view.layer.masksToBounds = true
        view.layer.borderWidth = 0.1
        view.layer.borderColor = UIColor.gray.cgColor
        return view
    }
    
    let dividerLineView: UIView = FeedCell.lineForDivider()
    let dividerLineView1: UIView = FeedCell.lineForDivider()
    let dividerLineView2: UIView = FeedCell.lineForDivider()
    
    static func buttonForTitle(_ title: String, imageName: String) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: UIControlState())
        button.setTitleColor(UIColor.rgb(143, green: 150, blue: 163), for: UIControlState())
        
        button.setImage(UIImage(named: imageName), for: UIControlState())
        button.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0)
        
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        
        return button
    }
    
    let likeButton = FeedCell.buttonForTitle("", imageName: "like")
    let commentButton: UIButton = FeedCell.buttonForTitle("", imageName: "comment")
    let shareButton: UIButton = FeedCell.buttonForTitle("", imageName: "share")
    
    static func buttonForTitleWithBorder(_ title: String, imageName: String) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: UIControlState())
        button.setTitleColor(UIColor.rgb(143, green: 150, blue: 163), for: UIControlState())
        
        button.setImage(UIImage(named: imageName), for: UIControlState())
        button.titleEdgeInsets = UIEdgeInsetsMake(8, 0, 8, 0)
        
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        button.layer.borderColor = UIColor.gray.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 3.0
        button.clipsToBounds = true
        
        return button
    }
    
    let joinButton = FeedCell.buttonForTitleWithBorder("Join", imageName: "Join")
    let supportButton = FeedCell.buttonForTitleWithBorder("Support", imageName: "Support")
    
    static func imageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 4.0
        imageView.layer.masksToBounds = true
        return imageView
    }
    
    let challengerImageView: UIImageView = FeedCell.imageView()
    let secondChallengerImageView: UIImageView = FeedCell.imageView()
    let firstPeopleImageView: UIImageView = FeedCell.imageView()
    let secondPeopleImageView: UIImageView = FeedCell.imageView()
    let thirdPeopleImageView: UIImageView = FeedCell.imageView()
    let morePeopleImageView: UIImageView = FeedCell.imageView()
    let firstChlrPeopleImageView: UIImageView = FeedCell.imageView()
    let secondChlrPeopleImageView: UIImageView = FeedCell.imageView()
    let thirdChlrPeopleImageView: UIImageView = FeedCell.imageView()
    let moreChlrPeopleImageView: UIImageView = FeedCell.imageView()
    
    static func imageViewFit() -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 4.0
        imageView.layer.masksToBounds = true
        return imageView
    }
    
    let worldImageView: UIImageView = FeedCell.imageViewFit()
    let subjectImageView: UIImageView = FeedCell.imageViewFit()
    
    static func viewFunc() -> UIView {
        let view = UIView()
        view.backgroundColor=UIColor.white
        return view
    }
    
    let middleView: UIView = FeedCell.viewFunc()
    let peopleView: UIView = FeedCell.viewFunc()
    let chlrPeopleView: UIView = FeedCell.viewFunc()
    let view: UIView = FeedCell.viewFunc()
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



