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
    var firstPeopleImage: String?
    var secondPeopleImage: String?
    var thirdPeopleImage: String?
    var firstChlrPeopleImage: String?
    var secondChlrPeopleImage: String?
    var thirdChlrPeopleImage: String?
    var done : String?
    var countOfJoins : NSNumber?
    var firstTeamCount : String?
    var secondTeamCount : String?
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
            let rect = NSString(string: thinksAboutChallenge).boundingRect(with: CGSize(width: view.frame.width, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 12)], context: nil)
            let screenSize = UIScreen.main.bounds
            let knownHeight: CGFloat = (screenSize.width / 10) + (screenSize.width / 2) + (screenSize.width / 12) + (screenSize.width / 8)
            
            return CGSize(width: view.frame.width, height: rect.height + knownHeight)
        }
        
        return CGSize(width: view.frame.width, height: 200)
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
            if let type = post?.type, let firstTeamCount = post?.firstTeamCount,  let secondTeamCount = post?.secondTeamCount {
                setupViews(firstTeamCount, secondTeamCount: secondTeamCount, type: type)
            } else {
                let type = post?.type
                print(type)
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
    
    func setupViews(_ firstTeamCount: String, secondTeamCount: String, type: String) {
        backgroundColor = UIColor.white
        let contentGuide = self.readableContentGuide
        addGeneralSubViews()
        generateTopView(contentGuide)
        
        addTopAnchor(dividerLineView, anchor: profileImageView.bottomAnchor, constant: 2)
        addLeadingAnchor(dividerLineView, anchor: contentGuide.leadingAnchor, constant: 0)
        addTrailingAnchor(dividerLineView, anchor: contentGuide.trailingAnchor, constant: 0)
        dividerLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        generateMiddleTopView(contentGuide, firstTeamCount: firstTeamCount, secondTeamCount: secondTeamCount, type: type)
        
        generateMiddleBottomView(contentGuide)
        
        addTopAnchor(dividerLineView2, anchor: thinksAboutChallengeView.bottomAnchor, constant: 2)
        addLeadingAnchor(dividerLineView2, anchor: contentGuide.leadingAnchor, constant: 0)
        addTrailingAnchor(dividerLineView2, anchor: contentGuide.trailingAnchor, constant: 4)
        dividerLineView2.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        generateBottomView(contentGuide)
    }
    
    func generateTopView(_ contentGuide: UILayoutGuide) {
        let topMiddleLeftGuide = UILayoutGuide()
        addLayoutGuide(topMiddleLeftGuide)
        
        addTopAnchor(profileImageView, anchor: contentGuide.topAnchor, constant: 0)
        addLeadingAnchor(profileImageView, anchor: contentGuide.leadingAnchor, constant: 0)
        addWidthAnchor(profileImageView, multiplier: 1/10)
        addHeightAnchor(profileImageView, multiplier: 1/10)
        
        topMiddleLeftGuide.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 8.0).isActive = true
        
        addTopAnchor(nameLabel, anchor: profileImageView.topAnchor, constant: 8)
        addLeadingAnchor(nameLabel, anchor: topMiddleLeftGuide.trailingAnchor, constant: 0)
        
        addTopAnchor(untilDateLabel, anchor: profileImageView.topAnchor, constant: 8)
        addTrailingAnchor(untilDateLabel, anchor: contentGuide.trailingAnchor, constant: 0)
    }
    
    func generateMiddleTopView(_ contentGuide: UILayoutGuide, firstTeamCount: String, secondTeamCount: String, type: String) {
        let centerMiddleLeftGuide = UILayoutGuide()
        let centerMiddleRightGuide = UILayoutGuide()
        let middleTopGuide = UILayoutGuide()
        let middleCenterGuide = UILayoutGuide()
        let middleBottomGuide = UILayoutGuide()
        addLayoutGuide(centerMiddleLeftGuide)
        addLayoutGuide(centerMiddleRightGuide)
        addLayoutGuide(middleTopGuide)
        addLayoutGuide(middleCenterGuide)
        addLayoutGuide(middleBottomGuide)
        
        let screenSize = UIScreen.main.bounds
        
        middleTopGuide.heightAnchor.constraint(equalToConstant: screenSize.width * 1/18).isActive = true
        middleCenterGuide.heightAnchor.constraint(equalToConstant: screenSize.width * 1/18).isActive = true
        middleBottomGuide.heightAnchor.constraint(equalToConstant: screenSize.width * 1/18).isActive = true
    
        generateFirstTeam(contentGuide, centerMiddleLeftGuide: centerMiddleLeftGuide, firstTeamCount: firstTeamCount);
        
        middleTopGuide.topAnchor.constraint(equalTo: dividerLineView.bottomAnchor, constant: 2).isActive = true
        addTopAnchor(vsImageView, anchor: middleTopGuide.bottomAnchor, constant: 0)
        addLeadingAnchor(vsImageView, anchor: centerMiddleLeftGuide.trailingAnchor, constant: 0)
        addTrailingAnchor(vsImageView, anchor: centerMiddleRightGuide.leadingAnchor, constant: 0)
        addHeightAnchor(vsImageView, multiplier: 1/6)
        middleCenterGuide.topAnchor.constraint(equalTo: vsImageView.bottomAnchor).isActive = true
        
        if type != "SELF" {
            addTopAnchor(subjectImageView, anchor: middleCenterGuide.bottomAnchor, constant: 0)
            addLeadingAnchor(subjectImageView, anchor: centerMiddleLeftGuide.trailingAnchor, constant: 10)
            addTrailingAnchor(subjectImageView, anchor: centerMiddleRightGuide.leadingAnchor, constant: -10)
            addHeightAnchor(subjectImageView, multiplier: 1/6)
            subjectImageView.contentMode = .scaleAspectFill
        } else {
        }
        // TODO
        middleBottomGuide.topAnchor.constraint(equalTo: subjectImageView.bottomAnchor).isActive = true
        
        addTopAnchor(dividerLineView1, anchor: middleBottomGuide.bottomAnchor, constant: 2)
        addLeadingAnchor(dividerLineView1, anchor: contentGuide.leadingAnchor, constant: 0)
        addTrailingAnchor(dividerLineView1, anchor: contentGuide.trailingAnchor, constant: 4)
        dividerLineView1.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        generateSecondTeam(contentGuide, centerMiddleRightGuide: centerMiddleRightGuide,secondTeamCount: secondTeamCount, type: type)
    }
    
    func generateFirstTeam(_ contentGuide: UILayoutGuide, centerMiddleLeftGuide: UILayoutGuide, firstTeamCount: String) {
        if firstTeamCount == "1" {
            addTopAnchor(firstChlrPeopleImageView, anchor: dividerLineView.bottomAnchor, constant: 2)
            addLeadingAnchor(firstChlrPeopleImageView, anchor: contentGuide.leadingAnchor, constant: 2)
            addTrailingAnchor(firstChlrPeopleImageView, anchor: centerMiddleLeftGuide.leadingAnchor, constant: 0)
            addWidthAnchor(firstChlrPeopleImageView, multiplier: 1/3)
            addHeightAnchor(firstChlrPeopleImageView, multiplier: 1/2)
            centerMiddleLeftGuide.leadingAnchor.constraint(equalTo: firstChlrPeopleImageView.trailingAnchor).isActive = true
        } else if firstTeamCount == "2" {
            addTopAnchor(firstChlrPeopleImageView, anchor: dividerLineView.bottomAnchor, constant: 2)
            addLeadingAnchor(firstChlrPeopleImageView, anchor: contentGuide.leadingAnchor, constant: 2)
            addTrailingAnchor(firstChlrPeopleImageView, anchor: centerMiddleLeftGuide.leadingAnchor, constant: 0)
            addWidthAnchor(firstChlrPeopleImageView, multiplier: 1/3)
            addHeightAnchor(firstChlrPeopleImageView, multiplier: 0.95/4)
            addBottomAnchor(secondChlrPeopleImageView, anchor: dividerLineView1.topAnchor, constant: -2)
            addLeadingAnchor(secondChlrPeopleImageView, anchor: contentGuide.leadingAnchor, constant: 2)
            addTrailingAnchor(secondChlrPeopleImageView, anchor: centerMiddleLeftGuide.leadingAnchor, constant: 0)
            addWidthAnchor(secondChlrPeopleImageView, multiplier: 1/3)
            addHeightAnchor(secondChlrPeopleImageView, multiplier: 0.95/4)
            centerMiddleLeftGuide.leadingAnchor.constraint(equalTo: firstChlrPeopleImageView.trailingAnchor).isActive = true
        } else if firstTeamCount == "3" {
            addTopAnchor(firstChlrPeopleImageView, anchor: dividerLineView.bottomAnchor, constant: 2)
            addLeadingAnchor(firstChlrPeopleImageView, anchor: contentGuide.leadingAnchor, constant: 2)
            addWidthAnchor(firstChlrPeopleImageView, multiplier: 0.95/6)
            addHeightAnchor(firstChlrPeopleImageView, multiplier: 0.95/4)
            addTopAnchor(secondChlrPeopleImageView, anchor: dividerLineView.bottomAnchor, constant: 2)
            addTrailingAnchor(secondChlrPeopleImageView, anchor: centerMiddleLeftGuide.leadingAnchor, constant: 0)
            addWidthAnchor(secondChlrPeopleImageView, multiplier: 0.95/6)
            addHeightAnchor(secondChlrPeopleImageView, multiplier: 0.95/4)
            addBottomAnchor(thirdChlrPeopleImageView, anchor: dividerLineView1.topAnchor, constant: -2)
            addLeadingAnchor(thirdChlrPeopleImageView, anchor: contentGuide.leadingAnchor, constant: 2)
            addTrailingAnchor(thirdChlrPeopleImageView, anchor: centerMiddleLeftGuide.leadingAnchor, constant: 0)
            addWidthAnchor(thirdChlrPeopleImageView, multiplier: 1/3)
            addHeightAnchor(thirdChlrPeopleImageView, multiplier: 0.95/4)
            centerMiddleLeftGuide.leadingAnchor.constraint(equalTo: thirdChlrPeopleImageView.trailingAnchor).isActive = true
        } else if firstTeamCount == "4" {
            let screenSize = UIScreen.main.bounds
            leftMiddleTopWidth.widthAnchor.constraint(equalToConstant: screenSize.width * 0.05/6)
            leftMiddleBottomWidth.widthAnchor.constraint(equalToConstant: screenSize.width * 0.05/6)
            addTopAnchor(firstChlrPeopleImageView, anchor: dividerLineView.bottomAnchor, constant: 2)
            addLeadingAnchor(firstChlrPeopleImageView, anchor: contentGuide.leadingAnchor, constant: 2)
            addTrailingAnchor(firstChlrPeopleImageView, anchor: leftMiddleTopWidth.leadingAnchor, constant: 0)
            addWidthAnchor(firstChlrPeopleImageView, multiplier: 0.95/6)
            addHeightAnchor(firstChlrPeopleImageView, multiplier: 0.95/4)
            leftMiddleTopWidth.trailingAnchor.constraint(equalTo: secondChlrPeopleImageView.leadingAnchor)
            addTopAnchor(secondChlrPeopleImageView, anchor: dividerLineView.bottomAnchor, constant: 2)
            addTrailingAnchor(secondChlrPeopleImageView, anchor: centerMiddleLeftGuide.leadingAnchor, constant: 0)
            addLeadingAnchor(secondChlrPeopleImageView, anchor: leftMiddleTopWidth.trailingAnchor, constant: 2)
            addWidthAnchor(secondChlrPeopleImageView, multiplier: 0.95/6)
            addHeightAnchor(secondChlrPeopleImageView, multiplier: 0.95/4)
            addBottomAnchor(thirdChlrPeopleImageView, anchor: dividerLineView1.topAnchor, constant: -2)
            addLeadingAnchor(thirdChlrPeopleImageView, anchor: contentGuide.leadingAnchor, constant: 2)
            addTrailingAnchor(thirdChlrPeopleImageView, anchor: leftMiddleBottomWidth.leadingAnchor, constant: 0)
            addWidthAnchor(thirdChlrPeopleImageView, multiplier: 0.95/6)
            addHeightAnchor(thirdChlrPeopleImageView, multiplier: 0.95/4)
            leftMiddleBottomWidth.trailingAnchor.constraint(equalTo: moreChlrPeopleImageView.leadingAnchor)
            addBottomAnchor(moreChlrPeopleImageView, anchor: dividerLineView1.topAnchor, constant: -2)
            addLeadingAnchor(moreChlrPeopleImageView, anchor: leftMiddleBottomWidth.trailingAnchor, constant: 2)
            addTrailingAnchor(moreChlrPeopleImageView, anchor: centerMiddleLeftGuide.leadingAnchor, constant: 0)
            addWidthAnchor(moreChlrPeopleImageView, multiplier: 0.95/6)
            addHeightAnchor(moreChlrPeopleImageView, multiplier: 0.95/4)
            centerMiddleLeftGuide.leadingAnchor.constraint(equalTo: secondChlrPeopleImageView.trailingAnchor).isActive = true
        }
    }
    
    func generateSecondTeam(_ contentGuide: UILayoutGuide, centerMiddleRightGuide: UILayoutGuide, secondTeamCount: String, type: String) {
        if secondTeamCount == "0" {
            if type == "SELF" {
                addLeadingAnchor(subjectImageView, anchor: centerMiddleRightGuide.trailingAnchor, constant: 0)
                addTrailingAnchor(subjectImageView, anchor: contentGuide.trailingAnchor, constant: 0)
                addWidthAnchor(subjectImageView, multiplier: 1/3)
                addHeightAnchor(subjectImageView, multiplier: 1/2)
                subjectImageView.centerYAnchor.constraint(equalTo: firstChlrPeopleImageView.centerYAnchor).isActive = true
                centerMiddleRightGuide.trailingAnchor.constraint(equalTo: subjectImageView.leadingAnchor).isActive = true
            } else if type == "PUBLIC" {
                addLeadingAnchor(worldImageView, anchor: centerMiddleRightGuide.trailingAnchor, constant: 0)
                addTrailingAnchor(worldImageView, anchor: contentGuide.trailingAnchor, constant: 0)
                addWidthAnchor(worldImageView, multiplier: 1/3)
                addHeightAnchor(worldImageView, multiplier: 1/2)
                worldImageView.centerYAnchor.constraint(equalTo: firstChlrPeopleImageView.centerYAnchor).isActive = true
                centerMiddleRightGuide.trailingAnchor.constraint(equalTo: worldImageView.leadingAnchor).isActive = true
            }
        } else if secondTeamCount == "1" {
            addTopAnchor(firstPeopleImageView, anchor: dividerLineView.bottomAnchor, constant: 2)
            addLeadingAnchor(firstPeopleImageView, anchor: centerMiddleRightGuide.trailingAnchor, constant: 2)
            addTrailingAnchor(firstPeopleImageView, anchor: contentGuide.trailingAnchor, constant: 0)
            addWidthAnchor(firstPeopleImageView, multiplier: 1/3)
            addHeightAnchor(firstPeopleImageView, multiplier: 1/2)
            centerMiddleRightGuide.trailingAnchor.constraint(equalTo: firstPeopleImageView.leadingAnchor).isActive = true
        } else if secondTeamCount == "2" {
            addTopAnchor(firstPeopleImageView, anchor: dividerLineView.bottomAnchor, constant: 2)
            addLeadingAnchor(firstPeopleImageView, anchor: centerMiddleRightGuide.trailingAnchor, constant: 2)
            addTrailingAnchor(firstPeopleImageView, anchor: contentGuide.trailingAnchor, constant: 0)
            addWidthAnchor(firstPeopleImageView, multiplier: 1/3)
            addHeightAnchor(firstPeopleImageView, multiplier: 0.95/4)
            addBottomAnchor(secondPeopleImageView, anchor: dividerLineView1.topAnchor, constant: -2)
            addLeadingAnchor(secondPeopleImageView, anchor: centerMiddleRightGuide.trailingAnchor, constant: 2)
            addTrailingAnchor(secondPeopleImageView, anchor: contentGuide.trailingAnchor, constant: 0)
            addWidthAnchor(secondPeopleImageView, multiplier: 1/3)
            addHeightAnchor(secondPeopleImageView, multiplier: 0.95/4)
            centerMiddleRightGuide.trailingAnchor.constraint(equalTo: firstPeopleImageView.leadingAnchor).isActive = true
         } else if secondTeamCount == "3" {
            addTopAnchor(firstPeopleImageView, anchor: dividerLineView.bottomAnchor, constant: 2)
            addLeadingAnchor(firstPeopleImageView, anchor: centerMiddleRightGuide.trailingAnchor, constant: 2)
            addWidthAnchor(firstPeopleImageView, multiplier: 0.95/6)
            addHeightAnchor(firstPeopleImageView, multiplier: 0.95/4)
            addTopAnchor(secondPeopleImageView, anchor: dividerLineView.bottomAnchor, constant: 2)
            addTrailingAnchor(secondPeopleImageView, anchor: contentGuide.trailingAnchor, constant: 0)
            addWidthAnchor(secondPeopleImageView, multiplier: 0.95/6)
            addHeightAnchor(secondPeopleImageView, multiplier: 0.95/4)
            addBottomAnchor(thirdPeopleImageView, anchor: dividerLineView1.topAnchor, constant: -2)
            addLeadingAnchor(thirdPeopleImageView, anchor: centerMiddleRightGuide.trailingAnchor, constant: 2)
            addTrailingAnchor(thirdPeopleImageView, anchor: contentGuide.trailingAnchor, constant: 0)
            addWidthAnchor(thirdPeopleImageView, multiplier: 1/3)
            addHeightAnchor(thirdPeopleImageView, multiplier: 0.95/4)
            centerMiddleRightGuide.trailingAnchor.constraint(equalTo: thirdPeopleImageView.leadingAnchor).isActive = true
         } else if secondTeamCount == "4" {
            let screenSize = UIScreen.main.bounds
            rightMiddleTopWidth.widthAnchor.constraint(equalToConstant: screenSize.width * 0.05/6)
            rightMiddleBottomWidth.widthAnchor.constraint(equalToConstant: screenSize.width * 0.05/6)
            addTopAnchor(firstPeopleImageView, anchor: dividerLineView.bottomAnchor, constant: 2)
            addLeadingAnchor(firstPeopleImageView, anchor: centerMiddleRightGuide.trailingAnchor, constant: 2)
            addTrailingAnchor(firstPeopleImageView, anchor: rightMiddleTopWidth.leadingAnchor, constant: 0)
            addWidthAnchor(firstPeopleImageView, multiplier: 0.95/6)
            addHeightAnchor(firstPeopleImageView, multiplier: 0.95/4)
            rightMiddleTopWidth.trailingAnchor.constraint(equalTo: secondPeopleImageView.leadingAnchor)
            addTopAnchor(secondPeopleImageView, anchor: dividerLineView.bottomAnchor, constant: 2)
            addLeadingAnchor(secondPeopleImageView, anchor: rightMiddleTopWidth.trailingAnchor, constant: 2)
            addTrailingAnchor(secondPeopleImageView, anchor: contentGuide.trailingAnchor, constant: 0)
            addWidthAnchor(secondPeopleImageView, multiplier: 0.95/6)
            addHeightAnchor(secondPeopleImageView, multiplier: 0.95/4)
            addBottomAnchor(thirdPeopleImageView, anchor: dividerLineView1.topAnchor, constant: -2)
            addLeadingAnchor(thirdPeopleImageView, anchor: centerMiddleRightGuide.trailingAnchor, constant: 2)
            addTrailingAnchor(thirdPeopleImageView, anchor: rightMiddleBottomWidth.leadingAnchor, constant: 0)
            addWidthAnchor(thirdPeopleImageView, multiplier: 0.95/6)
            addHeightAnchor(thirdPeopleImageView, multiplier: 0.95/4)
            rightMiddleBottomWidth.trailingAnchor.constraint(equalTo: morePeopleImageView.leadingAnchor)
            addBottomAnchor(morePeopleImageView, anchor: dividerLineView1.topAnchor, constant: -2)
            addLeadingAnchor(morePeopleImageView, anchor: rightMiddleBottomWidth.trailingAnchor, constant: 2)
            addTrailingAnchor(morePeopleImageView, anchor: contentGuide.trailingAnchor, constant: 0)
            addWidthAnchor(morePeopleImageView, multiplier: 0.95/6)
            addHeightAnchor(morePeopleImageView, multiplier: 0.95/4)
            centerMiddleRightGuide.trailingAnchor.constraint(equalTo: firstPeopleImageView.leadingAnchor).isActive = true
        }
    }
    
    func generateMiddleBottomView(_ contentGuide: UILayoutGuide) {
        addTopAnchor(thinksAboutChallengeView, anchor: dividerLineView1.bottomAnchor, constant: 2)
        addLeadingAnchor(thinksAboutChallengeView, anchor: contentGuide.leadingAnchor, constant: 0)
        addTrailingAnchor(thinksAboutChallengeView, anchor: contentGuide.trailingAnchor, constant: 4)
    }
    
    func generateBottomView(_ contentGuide: UILayoutGuide) {
        let bottomMiddleLeftGuide = UILayoutGuide()
        let bottomMiddleRightGuide = UILayoutGuide()
        addLayoutGuide(bottomMiddleLeftGuide)
        addLayoutGuide(bottomMiddleRightGuide)
        
        addTopAnchor(likeButton, anchor: dividerLineView2.bottomAnchor, constant: 2)
        addLeadingAnchor(likeButton, anchor: contentGuide.leadingAnchor, constant: 0)
        addWidthAnchor(likeButton, multiplier: 1/12)
        addHeightAnchor(likeButton, multiplier: 1/12)
        bottomMiddleLeftGuide.leadingAnchor.constraint(equalTo: likeButton.trailingAnchor, constant: 8.0).isActive = true
        
        addTopAnchor(commentButton, anchor: dividerLineView2.bottomAnchor, constant: 2)
        addLeadingAnchor(commentButton, anchor: bottomMiddleLeftGuide.leadingAnchor, constant: 2)
        addWidthAnchor(commentButton, multiplier: 1/12)
        addHeightAnchor(commentButton, multiplier: 1/12)
        bottomMiddleRightGuide.leadingAnchor.constraint(equalTo: commentButton.trailingAnchor, constant: 8.0).isActive = true
        
        addTopAnchor(shareButton, anchor: dividerLineView2.bottomAnchor, constant: 0)
        addLeadingAnchor(shareButton, anchor: bottomMiddleRightGuide.leadingAnchor, constant: 0)
        addWidthAnchor(shareButton, multiplier: 1/12)
        addHeightAnchor(shareButton, multiplier: 1/12)
        
        addTopAnchor(countOfLikeAndCommentLabel, anchor: dividerLineView2.bottomAnchor, constant: 10)
        addTrailingAnchor(countOfLikeAndCommentLabel, anchor: contentGuide.trailingAnchor, constant: 0)
    }
    
    func addGeneralSubViews() {
        addSubview(profileImageView)
        addSubview(nameLabel)
        addSubview(untilDateLabel)
        addSubview(vsImageView)
        addSubview(subjectImageView)
        addSubview(dividerLineView)
        addSubview(likeButton)
        addSubview(commentButton)
        addSubview(shareButton)
        addSubview(countOfLikeAndCommentLabel)
        addSubview(dividerLineView1)
        addSubview(thinksAboutChallengeView)
        addSubview(dividerLineView2)
        addSubview(firstChlrPeopleImageView)
        addSubview(secondChlrPeopleImageView)
        addSubview(thirdChlrPeopleImageView)
        addSubview(moreChlrPeopleImageView)
        addSubview(firstPeopleImageView)
        addSubview(secondPeopleImageView)
        addSubview(thirdPeopleImageView)
        addSubview(morePeopleImageView)
        addSubview(worldImageView)
        addLayoutGuide(middleHeight)
        addLayoutGuide(leftMiddleTopWidth)
        addLayoutGuide(leftMiddleBottomWidth)
        addLayoutGuide(rightMiddleTopWidth)
        addLayoutGuide(rightMiddleBottomWidth)
    }
    
    let middleHeight = UILayoutGuide()
    let leftMiddleTopWidth = UILayoutGuide()
    let leftMiddleBottomWidth = UILayoutGuide()
    let rightMiddleTopWidth = UILayoutGuide()
    let rightMiddleBottomWidth = UILayoutGuide()
    
    let countOfLikeAndCommentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 10)
        label.textAlignment = NSTextAlignment.right;
        return label
    }()
    
    let thinksAboutChallengeView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.boldSystemFont(ofSize: 12)
        textView.textAlignment = NSTextAlignment.left
        textView.textColor = UIColor.white
        textView.backgroundColor = UIColor(red: 51/255, green: 90/255, blue: 149/255, alpha: 1)
        textView.layer.cornerRadius = 2
        textView.layer.masksToBounds = true
        textView.isScrollEnabled = false
        textView.isEditable = false
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
    
    let untilDateLabel: UILabel = FeedCell.labelCreate(12)
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
    
    func addTopAnchor(_ view: UIView, anchor: NSLayoutAnchor<NSLayoutYAxisAnchor>, constant: CGFloat) {
        view.topAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
        view.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func addBottomAnchor(_ view: UIView, anchor: NSLayoutAnchor<NSLayoutYAxisAnchor>, constant: CGFloat) {
        view.bottomAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
        view.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func addLeadingAnchor(_ view: UIView, anchor: NSLayoutAnchor<NSLayoutXAxisAnchor>, constant: CGFloat) {
        view.leadingAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
        view.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func addTrailingAnchor(_ view: UIView, anchor: NSLayoutAnchor<NSLayoutXAxisAnchor>, constant: CGFloat) {
        view.trailingAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
        view.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func addWidthAnchor(_ view: UIView, multiplier: CGFloat) {
        let screenSize = UIScreen.main.bounds
        view.widthAnchor.constraint(equalToConstant: screenSize.width * multiplier).isActive = true
    }
    
    func addHeightAnchor(_ view: UIView, multiplier: CGFloat) {
        let screenSize = UIScreen.main.bounds
        view.heightAnchor.constraint(equalToConstant: screenSize.width * multiplier).isActive = true
    }
}

extension UIFont {
    
    /**
     Will return the best approximated font size which will fit in the bounds.
     If no font with name `fontName` could be found, nil is returned.
     */
    static func bestFitFontSize(for text: String, in bounds: CGRect, fontName: String) -> CGFloat? {
        var maxFontSize: CGFloat = 32.0 // UIKit best renders with factors of 2
        guard let maxFont = UIFont(name: fontName, size: maxFontSize) else {
            return nil
        }
        
        let textWidth = text.width(withConstraintedHeight: bounds.height, font: maxFont)
        let textHeight = text.height(withConstrainedWidth: bounds.width, font: maxFont)
        
        // Determine the font scaling factor that should allow the string to fit in the given rect
        let scalingFactor = min(bounds.width / textWidth, bounds.height / textHeight)
        
        // Adjust font size
        maxFontSize *= scalingFactor
        
        return floor(maxFontSize)
    }
    
}

fileprivate extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func width(withConstraintedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        
        return ceil(boundingBox.width)
    }
}

extension UILabel {
    /// Will auto resize the contained text to a font size which fits the frames bounds
    /// Uses the pre-set font to dynamicly determine the proper sizing
    func fitTextToBounds() {
        guard let text = text, let currentFont = font else { return }
        
        if let dynamicFontSize = UIFont.bestFitFontSize(for: text, in: bounds, fontName: currentFont.fontName) {
            font = UIFont(name: currentFont.fontName, size: dynamicFontSize)
        }
    }
    
}
