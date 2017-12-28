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
    var statusText: String?
    var statusImageName: String?
    var numLikes: NSNumber?
    var numComments: NSNumber?
    var chlDate: String?
    var untilDate: String?
    var type: String?
    var challengerImageName: String?
    var vsImageName : String?
    var worldImageName: String?
    var joinButton: String?
    var subjectImageName: String?
    var subject: String?
    var secondChallengerImageName: String?
    var firstPeopleImage: String?
    var secondPeopleImage: String?
    var thirdPeopleImage: String?
    var morePeopleImage:String?
    var firstChlrPeopleImage: String?
    var secondChlrPeopleImage: String?
    var thirdChlrPeopleImage: String?
    var moreChlrPeopleImage:String?
    
    var location: Location?
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "location" {
            location = Location()
            location?.setValuesForKeys(value as! [String: AnyObject])
        } else {
            super.setValue(value, forKey: key)
        }
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

class Location: NSObject {
    var city: String?
    var state: String?
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
        
//        let postMark = Post()
//        postMark.name = "Mark Zuckerberg"
//        postMark.location = Location()
//        postMark.location?.city = "San Francisco"
//        postMark.location?.state = "CA"
//        postMark.profileImageName = "zuckprofile"
//        postMark.statusText = "By giving people the power to share, we're making the world more transparent."
//        postMark.statusImageName = "zuckdog"
//        postMark.numLikes = 400
//        postMark.numComments = 123
//        
//        let postSteve = Post()
//        postSteve.name = "Steve Jobs"
//        postSteve.location = Location()
//        postSteve.location?.city = "Cupertino"
//        postSteve.location?.state = "CA"
//        postSteve.profileImageName = "steve_profile"
//        postSteve.statusText = "Design is not just what it looks like and feels like. Design is how it works.\n\n" +
//            "Being the richest man in the cemetery doesn't matter to me. Going to bed at night saying we've done something wonderful, that's what matters to me.\n\n" +
//        "Sometimes when you innovate, you make mistakes. It is best to admit them quickly, and get on with improving your other innovations."
//        postSteve.statusImageName = "steve_status"
//        postSteve.numLikes = 1000
//        postSteve.numComments = 55
//        
//        let postGandhi = Post()
//        postGandhi.name = "Mahatma Gandhi"
//        postGandhi.location = Location()
//        postGandhi.location?.city = "Porbandar"
//        postGandhi.location?.state = "India"
//        postGandhi.profileImageName = "gandhi_profile"
//        postGandhi.statusText = "Live as if you were to die tomorrow; learn as if you were to live forever.\n" +
//            "The weak can never forgive. Forgiveness is the attribute of the strong.\n" +
//        "Happiness is when what you think, what you say, and what you do are in harmony."
//        postGandhi.statusImageName = "gandhi_status"
//        postGandhi.numLikes = 333
//        postGandhi.numComments = 22
//
//        
//        posts.append(postMark)
//        posts.append(postSteve)
//        posts.append(postGandhi)
        
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
        
        if let statusText = posts[indexPath.item].statusText {
            
            let rect = NSString(string: statusText).boundingRect(with: CGSize(width: view.frame.width, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14)], context: nil)
            
            let knownHeight: CGFloat = 8 + 36 + 4 + 4 + 100 + 8 + 15 + 1.5 + 44
            
            return CGSize(width: view.frame.width, height: rect.height + knownHeight + 24)
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
                if type == "self" {
                    setupViewsSelf()
                }
                if type == "versus" {
                    setupViewsVersus("4")
                }
                if type == "join" {
                    setupViewsJoin("4")
                }
            }
            
            
            if let name = post?.name {
            
                // let attributedText = NSMutableAttributedString(string: "\(name) has challenge", attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14)])
                
                let attributedText = NSMutableAttributedString(string: "\(name)", attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14)])
                
                if let city = post?.location?.city, let state = post?.location?.state {
                    attributedText.append(NSAttributedString(string: "\n 1 hr - \(city), \(state)  •  ", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 8), NSForegroundColorAttributeName:
                        UIColor.rgb(155, green: 161, blue: 161)]))
                    
                    let paragraphStyle = NSMutableParagraphStyle()
                    paragraphStyle.lineSpacing = 4
                    
                    attributedText.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSMakeRange(0, attributedText.string.characters.count))
                    
                    let attachment = NSTextAttachment()
                    attachment.image = UIImage(named: "globe_small")
                    attachment.bounds = CGRect(x: 0, y: -2, width: 12, height: 12)
                    attributedText.append(NSAttributedString(attachment: attachment))
                    
                    
                }
                /**
                if let chlDate = post?.chlDate, let untilDate = post?.untilDate {
                    attributedText.append(NSAttributedString(string: "\nBetween \(chlDate) - \(untilDate)", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 10), NSForegroundColorAttributeName:
                        UIColor.rgb(155, green: 161, blue: 161)]))
                    
                    let paragraphStyle = NSMutableParagraphStyle()
                    paragraphStyle.lineSpacing = 4
                    
                    attributedText.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSMakeRange(0, attributedText.string.characters.count))
                    
                }*/
                
                nameLabel.attributedText = attributedText
                
            }
            
            if let statusText = post?.statusText {
                statusTextView.text = statusText
            }
            
            if let profileImagename = post?.profileImageName {
                profileImageView.image = UIImage(named: profileImagename)
            }
            
            if let challengerImageName = post?.challengerImageName {
                challengerImageView.image = UIImage(named: challengerImageName)
            }
            
            if let worldImageName = post?.worldImageName {
                worldImageView.image = UIImage(named: worldImageName)
            }
            
            if let untilDate = post?.untilDate {
                untilDateLabel.text = "UNTIL \(untilDate)"
            }
            
            if let vsImageName = post?.vsImageName {
                vsImageView.image = UIImage(named: vsImageName)
            }
            
            if let subjectImageName = post?.subjectImageName {
                subjectImageView.image = UIImage(named: subjectImageName)
            }
            
            if let statusImageName = post?.statusImageName {
                statusImageView.image = UIImage(named: statusImageName)
            }
            
            if let numLikes = post?.numLikes {
                likesLabel.text = "+\(numLikes)"
            }
            
            if let numComments = post?.numComments {
                commentsLabel.text = "+\(numComments)"
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
            
            if let morePeopleImage = post?.morePeopleImage {
                morePeopleImageView.image = UIImage(named: morePeopleImage)
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
            
            if let moreChlrPeopleImage = post?.moreChlrPeopleImage {
                moreChlrPeopleImageView.image = UIImage(named: moreChlrPeopleImage)
            }
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
        addSubview(joinButton)
        shareHorizantalViews()
        addConstraintsWithFormat("H:|-135-[v0]-135-|", views: joinButton)
        addConstraintsWithFormat("V:|-8-[v0(36)]-4-[v1]-4-[v2(100)]-2-[v3]-8-[v4(15)][v5(0.4)][v6(44)]|", views: profileImageView, statusTextView, view, untilDateLabel, joinButton,  dividerLineView, likeView)
        shareVerticalViews()
        firstChallenger()
        middleView.addSubview(subjectImageView)
        middleView.addConstraintsWithFormat("H:|-8-[v0]-8-|", views: subjectImageView)
        middleView.addConstraintsWithFormat("V:|-10-[v0(25)]-5-[v1(40)]-10-|", views: vsImageView, subjectImageView)
        
        if peopleCount == "0" {
            challengeToWorld()
        } else if peopleCount == "1" {
            // it is versus actuallly, so for one people it can not be join chl
        } else if peopleCount == "2" {
            challengeToTwoPeople()
            view.addConstraintsWithFormat("H:|-12-[v0(75)]-30-[v1(75)]-30-[v2(90)]-12-|", views: challengerImageView, middleView, peopleView)
        } else if peopleCount == "3" {
            challengeToThreePeople()
            view.addConstraintsWithFormat("H:|-12-[v0(75)]-30-[v1(75)]-30-[v2(90)]-12-|", views: challengerImageView, middleView, peopleView)
        } else if peopleCount == "4" {
            challengeToMorePeople()
            view.addConstraintsWithFormat("H:|-12-[v0(75)]-30-[v1(75)]-30-[v2(90)]-12-|", views: challengerImageView, middleView, peopleView)
        }
    }
    
    func setupViewsSelf() {
        shareAddViews()
        shareHorizantalViews()
        addConstraintsWithFormat("V:|-8-[v0(36)]-4-[v1]-4-[v2(100)]-2-[v3]-8-[v4(0.4)][v5(44)]|", views: profileImageView, statusTextView, view, untilDateLabel, dividerLineView, likeView)
        shareVerticalViews()
        firstChallenger()
        middleView.addSubview(goalLabel);
        middleView.addSubview(goalValueLabel);
        middleView.addConstraintsWithFormat("V:|-10-[v0(25)]-20-[v1][v2]-15-|", views: vsImageView, goalLabel, goalValueLabel)
        middleView.addConstraintsWithFormat("H:|-12-[v0]-8-|", views: goalLabel)
        middleView.addConstraintsWithFormat("H:|-12-[v0]-8-|", views: goalValueLabel)

        
        subjectImageView.contentMode = .scaleAspectFill
        view.addSubview(subjectImageView)
        view.addConstraintsWithFormat("H:|-12-[v0(75)]-30-[v1(75)]-30-[v2(75)]-12-|", views: challengerImageView, middleView, subjectImageView)
        view.addConstraintsWithFormat("V:|-10-[v0(100)]", views: subjectImageView)
    }
    
    func setupViewsVersus(_ peopleCount: String) {
        shareAddViews()
        shareHorizantalViews()
        addConstraintsWithFormat("V:|-8-[v0(36)]-4-[v1]-4-[v2(100)]-2-[v3]-8-[v4(0.4)][v5(44)]|", views: profileImageView, statusTextView, view, untilDateLabel, dividerLineView, likeView)
        shareVerticalViews()
        
        middleView.addSubview(subjectImageView)
        middleView.addConstraintsWithFormat("H:|-8-[v0]-8-|", views: subjectImageView)
        middleView.addConstraintsWithFormat("V:|-10-[v0(25)]-5-[v1(40)]-10-|", views: vsImageView, subjectImageView)
        
        if peopleCount == "1" {
            firstChallenger()
            secondChallenger()
            view.addConstraintsWithFormat("H:|-12-[v0(75)]-30-[v1(75)]-30-[v2(75)]-12-|", views: challengerImageView, middleView, secondChallengerImageView)
        } else if peopleCount == "2" {
            challengeFromTwoPeople()
            challengeToTwoPeople()
            view.addConstraintsWithFormat("H:|-12-[v0(75)]-30-[v1(75)]-30-[v2(75)]-12-|", views: chlrPeopleView, middleView, peopleView)
        } else if peopleCount == "3" {
            challengeFromThreePeople()
            challengeToThreePeople()
            view.addConstraintsWithFormat("H:|-12-[v0(90)]-15-[v1(75)]-30-[v2(90)]-12-|", views: chlrPeopleView, middleView, peopleView)
        } else if peopleCount == "4" {
            challengeFromMorePeople()
            challengeToMorePeople()
            view.addConstraintsWithFormat("H:|-12-[v0(90)]-15-[v1(75)]-30-[v2(90)]-12-|", views: chlrPeopleView, middleView, peopleView)
        }
    }
    
    func secondChallenger() {
        view.addSubview(secondChallengerImageView)
        view.addConstraintsWithFormat("V:|-10-[v0(100)]", views: secondChallengerImageView)
    }
    
    func firstChallenger() {
        view.addSubview(challengerImageView)
        view.addConstraintsWithFormat("V:|-10-[v0(100)]", views: challengerImageView)
    }
    
    func challengeToWorld() {
        view.addSubview(worldImageView)
        view.addConstraintsWithFormat("H:|-12-[v0(75)]-30-[v1(75)]-30-[v2(90)]-12-|", views: challengerImageView, middleView, worldImageView)
        view.addConstraintsWithFormat("V:|-10-[v0(100)]", views: worldImageView)
    }
    
    func challengeToTwoPeople() {
        view.addSubview(peopleView)
        view.addConstraintsWithFormat("V:|-10-[v0(100)]", views: peopleView)
        
        peopleView.addSubview(firstPeopleImageView)
        peopleView.addConstraintsWithFormat("H:|-10-[v0]-10-|", views: firstPeopleImageView)
        peopleView.addSubview(secondPeopleImageView)
        peopleView.addConstraintsWithFormat("H:|-10-[v0]-10-|", views: secondPeopleImageView)
        peopleView.addConstraintsWithFormat("V:|-5-[v0(43)]-5-[v1(43)]-5-|", views: firstPeopleImageView, secondPeopleImageView)
    }
    
    func challengeToThreePeople() {
        view.addSubview(peopleView)
        view.addConstraintsWithFormat("V:|-10-[v0(100)]", views: peopleView)
        
        peopleView.addSubview(firstPeopleImageView)
        peopleView.addSubview(thirdPeopleImageView)
        peopleView.addConstraintsWithFormat("H:|-10-[v0(32)]-2-[v1(32)]-10-|", views: firstPeopleImageView, thirdPeopleImageView)
        peopleView.addSubview(secondPeopleImageView)
        peopleView.addConstraintsWithFormat("H:|-10-[v0]-10-|", views: secondPeopleImageView)
        peopleView.addConstraintsWithFormat("V:|-5-[v0(43)]-5-[v1(43)]-5-|", views: firstPeopleImageView, secondPeopleImageView)
        peopleView.addConstraintsWithFormat("V:|-5-[v0(43)]|", views: thirdPeopleImageView)
    }
    
    func challengeToMorePeople() {
        view.addSubview(peopleView)
        view.addConstraintsWithFormat("V:|-10-[v0(100)]", views: peopleView)
        
        peopleView.addSubview(firstPeopleImageView)
        peopleView.addSubview(thirdPeopleImageView)
        peopleView.addConstraintsWithFormat("H:|-10-[v0(32)]-2-[v1(32)]-10-|", views: firstPeopleImageView, thirdPeopleImageView)
        peopleView.addSubview(secondPeopleImageView)
        peopleView.addSubview(morePeopleImageView)
        peopleView.addConstraintsWithFormat("H:|-10-[v0(32)]-2-[v1(32)]-10-|", views: secondPeopleImageView, morePeopleImageView)
        peopleView.addConstraintsWithFormat("V:|-5-[v0(43)]-5-[v1(43)]-5-|", views: firstPeopleImageView, secondPeopleImageView)
        peopleView.addConstraintsWithFormat("V:|-5-[v0(43)]|", views: thirdPeopleImageView)
        peopleView.addConstraintsWithFormat("V:[v0(43)]-5-|", views: morePeopleImageView)
    }
    
    func challengeFromTwoPeople() {
        view.addSubview(chlrPeopleView)
        view.addConstraintsWithFormat("V:|-10-[v0(100)]", views: chlrPeopleView)
        
        chlrPeopleView.addSubview(firstChlrPeopleImageView)
        chlrPeopleView.addConstraintsWithFormat("H:|-10-[v0]-10-|", views: firstChlrPeopleImageView)
        chlrPeopleView.addSubview(secondChlrPeopleImageView)
        chlrPeopleView.addConstraintsWithFormat("H:|-10-[v0]-10-|", views: secondChlrPeopleImageView)
        chlrPeopleView.addConstraintsWithFormat("V:|-5-[v0(43)]-5-[v1(43)]-5-|", views: firstChlrPeopleImageView, secondChlrPeopleImageView)
    }
    
    func challengeFromThreePeople() {
        view.addSubview(chlrPeopleView)
        view.addConstraintsWithFormat("V:|-10-[v0(100)]", views: chlrPeopleView)
        
        chlrPeopleView.addSubview(firstChlrPeopleImageView)
        chlrPeopleView.addSubview(thirdChlrPeopleImageView)
        chlrPeopleView.addConstraintsWithFormat("H:|-10-[v0(32)]-2-[v1(32)]-10-|", views: firstChlrPeopleImageView, thirdChlrPeopleImageView)
        chlrPeopleView.addSubview(secondChlrPeopleImageView)
        chlrPeopleView.addConstraintsWithFormat("H:|-10-[v0]-10-|", views: secondChlrPeopleImageView)
        chlrPeopleView.addConstraintsWithFormat("V:|-5-[v0(43)]-5-[v1(43)]-5-|", views: firstChlrPeopleImageView, secondChlrPeopleImageView)
        chlrPeopleView.addConstraintsWithFormat("V:|-5-[v0(43)]|", views: thirdChlrPeopleImageView)
    }
    
    func challengeFromMorePeople() {
        view.addSubview(chlrPeopleView)
        view.addConstraintsWithFormat("V:|-10-[v0(100)]", views: chlrPeopleView)
        
        chlrPeopleView.addSubview(firstChlrPeopleImageView)
        chlrPeopleView.addSubview(thirdChlrPeopleImageView)
        chlrPeopleView.addConstraintsWithFormat("H:|-10-[v0(32)]-2-[v1(32)]-10-|", views: firstChlrPeopleImageView, thirdChlrPeopleImageView)
        chlrPeopleView.addSubview(secondChlrPeopleImageView)
        chlrPeopleView.addSubview(moreChlrPeopleImageView)
        chlrPeopleView.addConstraintsWithFormat("H:|-10-[v0(32)]-2-[v1(32)]-10-|", views: secondChlrPeopleImageView, moreChlrPeopleImageView)
        chlrPeopleView.addConstraintsWithFormat("V:|-5-[v0(43)]-5-[v1(43)]-5-|", views: firstChlrPeopleImageView, secondChlrPeopleImageView)
        chlrPeopleView.addConstraintsWithFormat("V:|-5-[v0(43)]|", views: thirdChlrPeopleImageView)
        chlrPeopleView.addConstraintsWithFormat("V:[v0(43)]-5-|", views: moreChlrPeopleImageView)
    }
    
    func shareAddViews() {
        backgroundColor = UIColor.white

        addSubview(nameLabel)
        addSubview(profileImageView)
        addSubview(statusTextView)
        addSubview(view)
        
        view.addSubview(middleView)
        
        middleView.addSubview(vsImageView)
        
        addSubview(untilDateLabel)
        addSubview(dividerLineView)
        
        addSubview(likeView)
        addSubview(commentView)
        addSubview(shareButton)
        
        likeView.addSubview(likeButton)
        likeView.addSubview(likesLabel)
        
        commentView.addSubview(commentButton)
        commentView.addSubview(commentsLabel)
    }
    
    func shareHorizantalViews() {
        statusImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(FeedCell.animate as (FeedCell) -> () -> ())))
        addConstraintsWithFormat("H:|-8-[v0(44)]-8-[v1]|", views: profileImageView, nameLabel)
        addConstraintsWithFormat("H:|-4-[v0]-4-|", views: statusTextView)
        addConstraintsWithFormat("H:|-4-[v0]-4-|", views: view)
        
        middleView.addConstraintsWithFormat("H:|-12-[v0]-8-|", views: vsImageView)
        addConstraintsWithFormat("H:|-4-[v0]-4-|", views: untilDateLabel)
        addConstraintsWithFormat("H:|-12-[v0]-12-|", views: dividerLineView)
        
        likeView.addConstraintsWithFormat("H:|[v0]|", views: likeButton)
        likeView.addConstraintsWithFormat("H:|-24-[v0]|", views: likesLabel)
        commentView.addConstraintsWithFormat("H:|[v0]|", views: commentButton)
        commentView.addConstraintsWithFormat("H:|-13-[v0]|", views: commentsLabel)
        
        addConstraintsWithFormat("H:|[v0(v2)][v1(v2)][v2]|", views: likeView, commentView, shareButton)
    }
    
    func shareVerticalViews() {
        addConstraintsWithFormat("V:|-8-[v0]", views: nameLabel)
        view.addConstraintsWithFormat("V:|-10-[v0(100)]", views: middleView)
        
        likeView.addConstraintsWithFormat("V:|[v0]|", views: likeButton)
        likeView.addConstraintsWithFormat("V:|-5-[v0]-15-|", views: likesLabel)
        commentView.addConstraintsWithFormat("V:|[v0]|", views: commentButton)
        commentView.addConstraintsWithFormat("V:|-5-[v0]-24-|", views: commentsLabel)
        
        addConstraintsWithFormat("V:[v0(44)]|", views: commentView)
        addConstraintsWithFormat("V:[v0(44)]|", views: shareButton)
        
    }
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        return label
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let statusTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.isScrollEnabled = false
        return textView
    }()
    
    let statusImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    let likesLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 5)
        label.textColor = UIColor.black
        return label
    }()
    
    let commentsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 5)
        label.textColor = UIColor.black
        return label
    }()
    
    let dividerLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(226, green: 228, blue: 232)
        return view
    }()
    
    let likeButton = FeedCell.buttonForTitle("Like", imageName: "like")
    let commentButton: UIButton = FeedCell.buttonForTitle("Comment", imageName: "comment")
    let shareButton: UIButton = FeedCell.buttonForTitle("Share", imageName: "share")
    
    static func buttonForTitle(_ title: String, imageName: String) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: UIControlState())
        button.setTitleColor(UIColor.rgb(143, green: 150, blue: 163), for: UIControlState())
        
        button.setImage(UIImage(named: imageName), for: UIControlState())
        button.titleEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 0)
        
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        
        return button
    }
    
    static func buttonForTitleWithBorder(_ title: String, imageName: String) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: UIControlState())
        button.setTitleColor(UIColor.rgb(143, green: 150, blue: 163), for: UIControlState())
        
        button.setImage(UIImage(named: imageName), for: UIControlState())
        button.titleEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 0)
        
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        button.layer.borderColor = UIColor.gray.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5.0
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
    
    let view: UIView = {
        let view = UIView()
        //view.backgroundColor=UIColor.gray
        return view
    }()
    
    let middleView: UIView = {
        let view = UIView()
        view.backgroundColor=UIColor.white
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
    
    let likeView: UIView = {
        let view = UIView()
        view.backgroundColor=UIColor.white
        return view
    }()
    
    let commentView: UIView = {
        let view = UIView()
        view.backgroundColor=UIColor.white
        return view
    }()
    
    let untilDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 10)
        label.textAlignment = .center
        label.textColor = UIColor.gray
        // label.backgroundColor=UIColor.red
        return label
    }()
    
    let goalLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 7)
        label.textAlignment = .center
        label.textColor = UIColor.black
        // label.backgroundColor=UIColor.red
        return label
    }()
    
    let goalValueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = .center
        label.textColor = UIColor.red
        label.shadowColor = UIColor.black
        // label.backgroundColor=UIColor.red
        return label
    }()
    
    let joinButton = FeedCell.buttonForTitleWithBorder("Join", imageName: "Join")
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



