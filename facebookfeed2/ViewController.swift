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
    var done : String?
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let samplePost = Post()
//        samplePost.performSelector(Selector("setName:"), withObject: "my name")
        if let path = Bundle.main.path(forResource: "all_posts", ofType: "json") {
            do {
                // Asynchronous Http call to your api url, using NSURLSession:
                // http://ip.jsontest.com
                // http://localhost:8080/getChallenges?memberId=5a7b0afe9d1adf3bc631c133
                /*URLSession.shared.dataTask(with: NSURL(string: "http://ip.jsontest.com")! as URL, completionHandler: { (data, response, error) -> Void in
                    // Check if data was received successfully
                    if error == nil && data != nil {
                        do {
                            // Convert NSData to Dictionary where keys are of type String, and values are of any type
                            let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [String:Any]
                            // Access specific key with value of type String
                            //let str = json!["key"] as! String
                            print(json)
                        } catch {
                            // Something went wrong
                        }
                    }
                }).resume()
                */
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
        feedCell.prepareForReuse()
        feedCell.post = posts[indexPath.item]
        feedCell.feedController = self
        return feedCell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenSize = UIScreen.main.bounds
        let knownHeight: CGFloat = (screenSize.width / 2) + (screenSize.width / 15) + (screenSize.width * 1.3/18) + 25

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

class FeedCell: UICollectionViewCell {
    
    var feedController: FeedController?
    
    func animate() {
        feedController?.animateImageView(statusImageView)
    }
    
    func setImage(name: String?, imageView: UIImageView) {
        if let peopleImage = name {
            imageView.image = UIImage(named: peopleImage)
        }
    }
    
    override func prepareForReuse() {
        // Remove any state in this cell that may be left over from its previous use.
        self.firstOneChlrPeopleImageView.image = UIImage()
        self.firstTwoChlrPeopleImageView.image = UIImage()
        self.secondTwoChlrPeopleImageView.image = UIImage()
        self.firstThreeChlrPeopleImageView.image = UIImage()
        self.secondThreeChlrPeopleImageView.image = UIImage()
        self.thirdThreeChlrPeopleImageView.image = UIImage()
        self.firstFourChlrPeopleImageView.image = UIImage()
        self.secondFourChlrPeopleImageView.image = UIImage()
        self.thirdFourChlrPeopleImageView.image = UIImage()
        self.moreFourChlrPeopleImageView.image = UIImage()
        self.firstOnePeopleImageView.image = UIImage()
        self.firstTwoPeopleImageView.image = UIImage()
        self.secondTwoPeopleImageView.image = UIImage()
        self.firstThreePeopleImageView.image = UIImage()
        self.secondThreePeopleImageView.image = UIImage()
        self.thirdThreePeopleImageView.image = UIImage()
        self.firstFourPeopleImageView.image = UIImage()
        self.secondFourPeopleImageView.image = UIImage()
        self.thirdFourPeopleImageView.image = UIImage()
        self.moreFourPeopleImageView.image = UIImage()
        self.vsImageView.image = UIImage()
        self.subjectImageView.image = UIImage()
        self.thinksAboutChallengeView.text = nil
        self.view.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        super.prepareForReuse()
    }
    
    var post: Post? {
        didSet {
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
            if let countOfComments = post?.countOfComments, let countOfLike = post?.countOfLike {
                countOfLikeAndCommentLabel.text = "\(countOfLike) Likes \(countOfComments) Comments "
            }
            if post?.type == "PUBLIC" {
                if let countOfJoins = post?.countOfJoins {
                    countOfLikeAndCommentLabel.text?.append(" \(countOfJoins) Joins ")
                }
                if let subject = post?.subject {
                    subjectImageView.image = UIImage(named: subject)
                }
                var firstPImg: Bool = false;
                var secondPImg: Bool = false;
                var thirdPImg: Bool = false;
                if post?.secondTeamCount == "0" {
                    setImage(name: "worldImage", imageView: firstOnePeopleImageView)
                    firstOnePeopleImageView.contentMode = .scaleAspectFit
                }
                for join in (post?.joinAttendanceList)! {
                    if (join.challenger == false) {
                        if !firstPImg {
                            if post?.secondTeamCount == "1" {
                                setImage(name: join.FacebookID, imageView: firstOnePeopleImageView)
                            } else if post?.secondTeamCount == "2" {
                                setImage(name: join.FacebookID, imageView: firstTwoPeopleImageView)
                            } else if post?.secondTeamCount == "3" {
                                setImage(name: join.FacebookID, imageView: firstThreePeopleImageView)
                            } else if post?.secondTeamCount == "4" {
                                setImage(name: join.FacebookID, imageView: firstFourPeopleImageView)
                            }
                            firstPImg = true
                        } else if !secondPImg {
                            if post?.secondTeamCount == "2" {
                                setImage(name: join.FacebookID, imageView: secondTwoPeopleImageView)
                            } else if post?.secondTeamCount == "3" {
                                setImage(name: join.FacebookID, imageView: secondThreePeopleImageView)
                            } else if post?.secondTeamCount == "4" {
                                setImage(name: join.FacebookID, imageView: secondFourPeopleImageView)
                            }
                            secondPImg = true
                        } else if !thirdPImg {
                            if post?.secondTeamCount == "3" {
                                setImage(name: join.FacebookID, imageView: thirdThreePeopleImageView)
                            } else if post?.secondTeamCount == "4" {
                                setImage(name: join.FacebookID, imageView: thirdFourPeopleImageView)
                            }
                            thirdPImg = true
                        }
                    } else if (join.challenger == true) {
                        setImage(name: join.FacebookID, imageView: firstOneChlrPeopleImageView)
                    }
                }
            } else if post?.type == "PRIVATE" {
                if let subject = post?.subject {
                    subjectImageView.image = UIImage(named: subject)
                }
                var firstImg: Bool = false;
                var secondImg: Bool = false;
                var thirdImg: Bool = false;
                var firstChlrImg: Bool = false;
                var secondChlrImg: Bool = false;
                var thirdChlrImg: Bool = false;
                
                for versus in (post?.versusAttendanceList)! {
                    if(versus.firstTeamMember == true) {
                        if !firstChlrImg {
                            if post?.secondTeamCount == "1" {
                                setImage(name: versus.FacebookID, imageView: firstOneChlrPeopleImageView)
                            } else if post?.secondTeamCount == "2" {
                                setImage(name: versus.FacebookID, imageView: firstTwoChlrPeopleImageView)
                            } else if post?.secondTeamCount == "3" {
                                setImage(name: versus.FacebookID, imageView: firstThreeChlrPeopleImageView)
                            } else if post?.secondTeamCount == "4" {
                                setImage(name: versus.FacebookID, imageView: firstFourChlrPeopleImageView)
                            }
                            firstChlrImg = true
                        } else if !secondChlrImg {
                            if post?.secondTeamCount == "2" {
                                setImage(name: versus.FacebookID, imageView: secondTwoChlrPeopleImageView)
                            } else if post?.secondTeamCount == "3" {
                                setImage(name: versus.FacebookID, imageView: secondThreeChlrPeopleImageView)
                            } else if post?.secondTeamCount == "4" {
                                setImage(name: versus.FacebookID, imageView: secondFourChlrPeopleImageView)
                            }
                            secondChlrImg = true
                        } else if !thirdChlrImg {
                            if post?.secondTeamCount == "3" {
                                setImage(name: versus.FacebookID, imageView: thirdThreeChlrPeopleImageView)
                            } else if post?.secondTeamCount == "4" {
                                setImage(name: versus.FacebookID, imageView: thirdFourChlrPeopleImageView)
                            }
                            thirdChlrImg = true
                        }
                    } else if (versus.secondTeamMember == true){
                        if !firstImg {
                            if post?.secondTeamCount == "1" {
                                setImage(name: versus.FacebookID, imageView: firstOnePeopleImageView)
                            } else if post?.secondTeamCount == "2" {
                                setImage(name: versus.FacebookID, imageView: firstTwoPeopleImageView)
                            } else if post?.secondTeamCount == "3" {
                                setImage(name: versus.FacebookID, imageView: firstThreePeopleImageView)
                            } else if post?.secondTeamCount == "4" {
                                setImage(name: versus.FacebookID, imageView: firstFourPeopleImageView)
                            }
                            firstImg = true
                        } else if !secondImg {
                            if post?.secondTeamCount == "2" {
                                setImage(name: versus.FacebookID, imageView: secondTwoPeopleImageView)
                            } else if post?.secondTeamCount == "3" {
                                setImage(name: versus.FacebookID, imageView: secondThreePeopleImageView)
                            } else if post?.secondTeamCount == "4" {
                                setImage(name: versus.FacebookID, imageView: secondFourPeopleImageView)
                            }
                            secondImg = true
                        } else if !thirdImg {
                            if post?.secondTeamCount == "3" {
                                setImage(name: versus.FacebookID, imageView: thirdThreePeopleImageView)
                            } else if post?.secondTeamCount == "4" {
                                setImage(name: versus.FacebookID, imageView: thirdFourPeopleImageView)
                            }
                            thirdImg = true
                        }
                    }
                }
            } else if post?.type == "SELF" {
                setImage(name: post?.challengerFBId, imageView: firstOneChlrPeopleImageView)
                if let subject = post?.subject {
                    setImage(name: subject, imageView: firstOnePeopleImageView)
                    firstOnePeopleImageView.contentMode = .scaleAspectFill
                }
                
            }
            if let untilDate = post?.untilDate {
                untilDateLabel.text = "\(untilDate)"
            }
            vsImageView.image = UIImage(named: "vs")
            if post?.secondTeamCount == "4" {
                moreFourPeopleImageView.image = UIImage(named: "more_icon")
                moreFourPeopleImageView.contentMode = .scaleAspectFit
            }
            if post?.firstTeamCount == "4" {
                moreFourChlrPeopleImageView.image = UIImage(named: "more_icon")
                moreFourChlrPeopleImageView.contentMode = .scaleAspectFit
            }
            goalLabel.text = "GOAL: 10"
            likeLabel.text = "Like"
            if let type = post?.type, let firstTeamCount = post?.firstTeamCount,  let secondTeamCount = post?.secondTeamCount {
                setupViews(firstTeamCount, secondTeamCount: secondTeamCount, type: type)
            } else {
                let type = post?.type
                print(type)
            }
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
        //generateTopView(contentGuide)
        
        addTopAnchor(dividerLineView, anchor: contentGuide.topAnchor, constant: 0)
        addLeadingAnchor(dividerLineView, anchor: contentGuide.leadingAnchor, constant: 0)
        addTrailingAnchor(dividerLineView, anchor: contentGuide.trailingAnchor, constant: 0)
        dividerLineView.heightAnchor.constraint(equalToConstant: 0).isActive = true
        
        generateMiddleTopView(contentGuide, firstTeamCount: firstTeamCount, secondTeamCount: secondTeamCount, type: type)
        
        generateMiddleBottomView(contentGuide)
        
        if(!thinksAboutChallengeView.text.isEmpty) {
            addTopAnchor(thinksAboutChallengeView, anchor: dividerLineView1.bottomAnchor, constant: 1)
            addLeadingAnchor(thinksAboutChallengeView, anchor: contentGuide.leadingAnchor, constant: 0)
            addTrailingAnchor(thinksAboutChallengeView, anchor: contentGuide.trailingAnchor, constant: 4)
        
            addTopAnchor(dividerLineView2, anchor: thinksAboutChallengeView.bottomAnchor, constant: 0)
            addLeadingAnchor(dividerLineView2, anchor: contentGuide.leadingAnchor, constant: 0)
            addTrailingAnchor(dividerLineView2, anchor: contentGuide.trailingAnchor, constant: 4)
            dividerLineView2.heightAnchor.constraint(equalToConstant: 1).isActive = true
            
            addTopAnchor(likeButtonWithThink, anchor: dividerLineView2.bottomAnchor, constant: 5)
            addTrailingAnchor(likeButtonWithThink, anchor: commentButtonWithThink.leadingAnchor, constant: -70)
            addWidthAnchor(likeButtonWithThink, multiplier: 1/15)
            addHeightAnchor(likeButtonWithThink, multiplier: 1/15)
            
            addTopAnchor(commentButtonWithThink, anchor: dividerLineView2.bottomAnchor, constant: 5)
            commentButtonWithThink.centerXAnchor.constraint(equalTo: contentGuide.centerXAnchor).isActive = true
            addWidthAnchor(commentButtonWithThink, multiplier: 1/15)
            addHeightAnchor(commentButtonWithThink, multiplier: 1/15)
            
            addTopAnchor(shareButtonWithThink, anchor: dividerLineView2.bottomAnchor, constant: 5)
            addLeadingAnchor(shareButtonWithThink, anchor: commentButtonWithThink.trailingAnchor, constant: 70)
            addWidthAnchor(shareButtonWithThink, multiplier: 1/15)
            addHeightAnchor(shareButtonWithThink, multiplier: 1/15)
        } else {
            addTopAnchor(likeButton, anchor: dividerLineView1.bottomAnchor, constant: 5)
            addTrailingAnchor(likeButton, anchor: commentButton.leadingAnchor, constant: -70)
            addWidthAnchor(likeButton, multiplier: 1/15)
            addHeightAnchor(likeButton, multiplier: 1/15)
            
            addTopAnchor(commentButton, anchor: dividerLineView1.bottomAnchor, constant: 5)
            commentButton.centerXAnchor.constraint(equalTo: contentGuide.centerXAnchor).isActive = true
            addWidthAnchor(commentButton, multiplier: 1/15)
            addHeightAnchor(commentButton, multiplier: 1/15)
            
            addTopAnchor(shareButton, anchor: dividerLineView1.bottomAnchor, constant: 5)
            addLeadingAnchor(shareButton, anchor: commentButton.trailingAnchor, constant: 70)
            addWidthAnchor(shareButton, multiplier: 1/15)
            addHeightAnchor(shareButton, multiplier: 1/15)
        }
        
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
        let middleTopGuide = UILayoutGuide()
        let middleCenterGuide = UILayoutGuide()
        let middleBottomGuide = UILayoutGuide()
        addLayoutGuide(middleTopGuide)
        addLayoutGuide(middleCenterGuide)
        addLayoutGuide(middleBottomGuide)
        
        let screenSize = UIScreen.main.bounds
        let contentGuide = self.readableContentGuide
        
        middleTopGuide.heightAnchor.constraint(equalToConstant: 0).isActive = true
        middleCenterGuide.heightAnchor.constraint(equalToConstant: screenSize.width * 0.5/18).isActive = true
    
        generateFirstTeam(contentGuide, firstTeamCount: firstTeamCount);
        
        middleTopGuide.topAnchor.constraint(equalTo: dividerLineView.bottomAnchor, constant: 1).isActive = true
        addTopAnchor(vsImageView, anchor: middleTopGuide.bottomAnchor, constant: 0)
        vsImageView.centerXAnchor.constraint(equalTo: contentGuide.centerXAnchor).isActive = true
        addHeightAnchor(vsImageView, multiplier: 1/6)
        middleCenterGuide.topAnchor.constraint(equalTo: vsImageView.bottomAnchor).isActive = true
        
        if type != "SELF" {
            middleBottomGuide.heightAnchor.constraint(equalToConstant: screenSize.width * 1.5/18).isActive = true
            addTopAnchor(subjectImageView, anchor: middleCenterGuide.bottomAnchor, constant: 0)
            subjectImageView.centerXAnchor.constraint(equalTo: contentGuide.centerXAnchor).isActive = true
            addHeightAnchor(subjectImageView, multiplier: 1/6)
            addWidthAnchor(subjectImageView, multiplier: 0.7/3)
            subjectImageView.contentMode = .scaleAspectFill
            middleBottomGuide.topAnchor.constraint(equalTo: subjectImageView.bottomAnchor).isActive = true
            addTopAnchor(untilDateLabel, anchor: middleBottomGuide.bottomAnchor, constant: 0)
            addWidthAnchor(untilDateLabel, multiplier: 0.7/3)
            untilDateLabel.centerXAnchor.constraint(equalTo: contentGuide.centerXAnchor).isActive = true
            addHeightAnchor(untilDateLabel, multiplier: 1/18)
        } else {
            middleBottomGuide.heightAnchor.constraint(equalToConstant: screenSize.width * 4.5/18).isActive = true
            middleBottomGuide.topAnchor.constraint(equalTo: middleCenterGuide.bottomAnchor).isActive = true
            addTopAnchor(untilDateLabel, anchor: middleBottomGuide.bottomAnchor, constant: 0)
            addWidthAnchor(untilDateLabel, multiplier: 0.7/3)
            untilDateLabel.centerXAnchor.constraint(equalTo: contentGuide.centerXAnchor).isActive = true
            addHeightAnchor(untilDateLabel, multiplier: 1/18)
        }

        addTopAnchor(joinButton, anchor: untilDateLabel.bottomAnchor, constant: 5)
        joinButton.centerXAnchor.constraint(equalTo: contentGuide.centerXAnchor).isActive = true
        joinButton.heightAnchor.constraint(equalToConstant: screenSize.width * 1.3/18).isActive = true
        joinButton.widthAnchor.constraint(equalToConstant: screenSize.width * 1/3).isActive = true

        addTopAnchor(dividerLineView1, anchor: joinButton.bottomAnchor, constant: 1)
        addLeadingAnchor(dividerLineView1, anchor: contentGuide.leadingAnchor, constant: 1)
        addTrailingAnchor(dividerLineView1, anchor: contentGuide.trailingAnchor, constant: 1)
        dividerLineView1.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        generateSecondTeam(contentGuide, secondTeamCount: secondTeamCount, type: type)
    }
    
    var widthOfImage: CGFloat = 1/3
    var heightOfFullImage: CGFloat = 1/2
    var heightOfHalfImage: CGFloat = 0.975/4
    var widthOfQuarterImage: CGFloat = 0.975/6
    var heightOfMiddle: CGFloat = 0.05/4
    var widthOfMiddle: CGFloat = 0.05/6
    func generateFirstTeam(_ contentGuide: UILayoutGuide, firstTeamCount: String) {
        let screenSize = UIScreen.main.bounds
        middleHeight.heightAnchor.constraint(equalToConstant: screenSize.width * heightOfMiddle).isActive = true
        if firstTeamCount == "1" {
            addTopAnchor(firstOneChlrPeopleImageView, anchor: dividerLineView.bottomAnchor, constant: 2)
            addLeadingAnchor(firstOneChlrPeopleImageView, anchor: contentGuide.leadingAnchor, constant: 2)
            addWidthAnchor(firstOneChlrPeopleImageView, multiplier: widthOfImage)
            addHeightAnchor(firstOneChlrPeopleImageView, multiplier: heightOfFullImage)
        } else if firstTeamCount == "2" {
            addTopAnchor(firstTwoChlrPeopleImageView, anchor: dividerLineView.bottomAnchor, constant: 2)
            addLeadingAnchor(firstTwoChlrPeopleImageView, anchor: contentGuide.leadingAnchor, constant: 2)
            addBottomAnchor(firstTwoChlrPeopleImageView, anchor: middleHeight.topAnchor, constant: 0)
            addWidthAnchor(firstTwoChlrPeopleImageView, multiplier: widthOfImage)
            addHeightAnchor(firstTwoChlrPeopleImageView, multiplier: heightOfHalfImage)
            middleHeight.topAnchor.constraint(equalTo: firstTwoChlrPeopleImageView.bottomAnchor)
            addTopAnchor(secondTwoChlrPeopleImageView, anchor: middleHeight.bottomAnchor, constant: -2)
            addLeadingAnchor(secondTwoChlrPeopleImageView, anchor: contentGuide.leadingAnchor, constant: 2)
            addWidthAnchor(secondTwoChlrPeopleImageView, multiplier: widthOfImage)
            addHeightAnchor(secondTwoChlrPeopleImageView, multiplier: heightOfHalfImage)
        } else if firstTeamCount == "3" {
            let screenSize = UIScreen.main.bounds
            leftMiddleTopWidth.widthAnchor.constraint(equalToConstant: screenSize.width * widthOfMiddle)
            addTopAnchor(firstThreeChlrPeopleImageView, anchor: dividerLineView.bottomAnchor, constant: 2)
            addLeadingAnchor(firstThreeChlrPeopleImageView, anchor: contentGuide.leadingAnchor, constant: 2)
            addTrailingAnchor(firstThreeChlrPeopleImageView, anchor: leftMiddleTopWidth.leadingAnchor, constant: 0)
            addBottomAnchor(firstThreeChlrPeopleImageView, anchor: middleHeight.topAnchor, constant: 0)
            addWidthAnchor(firstThreeChlrPeopleImageView, multiplier: widthOfQuarterImage)
            addHeightAnchor(firstThreeChlrPeopleImageView, multiplier: heightOfHalfImage)
            leftMiddleTopWidth.trailingAnchor.constraint(equalTo: secondThreeChlrPeopleImageView.leadingAnchor)
            addTopAnchor(secondThreeChlrPeopleImageView, anchor: dividerLineView.bottomAnchor, constant: 2)
            addLeadingAnchor(secondThreeChlrPeopleImageView, anchor: leftMiddleTopWidth.trailingAnchor, constant: 2)
            addWidthAnchor(secondThreeChlrPeopleImageView, multiplier: widthOfQuarterImage)
            addHeightAnchor(secondThreeChlrPeopleImageView, multiplier: heightOfHalfImage)
            middleHeight.topAnchor.constraint(equalTo: firstThreeChlrPeopleImageView.bottomAnchor)
            addTopAnchor(thirdThreeChlrPeopleImageView, anchor: middleHeight.bottomAnchor, constant: -2)
            addLeadingAnchor(thirdThreeChlrPeopleImageView, anchor: contentGuide.leadingAnchor, constant: 2)
            addWidthAnchor(thirdThreeChlrPeopleImageView, multiplier: widthOfImage)
            addHeightAnchor(thirdThreeChlrPeopleImageView, multiplier: heightOfHalfImage)
        } else if firstTeamCount == "4" {
            let screenSize = UIScreen.main.bounds
            leftMiddleTopWidth.widthAnchor.constraint(equalToConstant: screenSize.width * widthOfMiddle)
            leftMiddleBottomWidth.widthAnchor.constraint(equalToConstant: screenSize.width * widthOfMiddle)
            addTopAnchor(firstFourChlrPeopleImageView, anchor: dividerLineView.bottomAnchor, constant: 2)
            addLeadingAnchor(firstFourChlrPeopleImageView, anchor: contentGuide.leadingAnchor, constant: 2)
            addTrailingAnchor(firstFourChlrPeopleImageView, anchor: leftMiddleTopWidth.leadingAnchor, constant: 0)
            addBottomAnchor(firstFourChlrPeopleImageView, anchor: middleHeight.topAnchor, constant: 0)
            addWidthAnchor(firstFourChlrPeopleImageView, multiplier: widthOfQuarterImage)
            addHeightAnchor(firstFourChlrPeopleImageView, multiplier: heightOfHalfImage)
            leftMiddleTopWidth.trailingAnchor.constraint(equalTo: secondFourChlrPeopleImageView.leadingAnchor)
            addTopAnchor(secondFourChlrPeopleImageView, anchor: dividerLineView.bottomAnchor, constant: 2)
            addLeadingAnchor(secondFourChlrPeopleImageView, anchor: leftMiddleTopWidth.trailingAnchor, constant: 2)
            addWidthAnchor(secondFourChlrPeopleImageView, multiplier: widthOfQuarterImage)
            addHeightAnchor(secondFourChlrPeopleImageView, multiplier: heightOfHalfImage)
            middleHeight.topAnchor.constraint(equalTo: firstFourChlrPeopleImageView.bottomAnchor)
            addTopAnchor(thirdFourChlrPeopleImageView, anchor: middleHeight.bottomAnchor, constant: -2)
            addLeadingAnchor(thirdFourChlrPeopleImageView, anchor: contentGuide.leadingAnchor, constant: 2)
            addTrailingAnchor(thirdFourChlrPeopleImageView, anchor: leftMiddleBottomWidth.leadingAnchor, constant: 0)
            addWidthAnchor(thirdFourChlrPeopleImageView, multiplier: widthOfQuarterImage)
            addHeightAnchor(thirdFourChlrPeopleImageView, multiplier: heightOfHalfImage)
            leftMiddleBottomWidth.trailingAnchor.constraint(equalTo: moreFourChlrPeopleImageView.leadingAnchor)
            addBottomAnchor(moreFourChlrPeopleImageView, anchor: thirdFourChlrPeopleImageView.bottomAnchor, constant: -2)
            addLeadingAnchor(moreFourChlrPeopleImageView, anchor: leftMiddleBottomWidth.trailingAnchor, constant: 2)
            addWidthAnchor(moreFourChlrPeopleImageView, multiplier: widthOfQuarterImage)
            addHeightAnchor(moreFourChlrPeopleImageView, multiplier: heightOfHalfImage)
        }
    }
    
    func generateSecondTeam(_ contentGuide: UILayoutGuide, secondTeamCount: String, type: String) {
        let screenSize = UIScreen.main.bounds
        middleHeight.heightAnchor.constraint(equalToConstant: screenSize.width * heightOfMiddle).isActive = true
        if (secondTeamCount == "0" || secondTeamCount == "1") {
            addTopAnchor(firstOnePeopleImageView, anchor: dividerLineView.bottomAnchor, constant: 2)
            addTrailingAnchor(firstOnePeopleImageView, anchor: contentGuide.trailingAnchor, constant: 0)
            addWidthAnchor(firstOnePeopleImageView, multiplier: widthOfImage)
            addHeightAnchor(firstOnePeopleImageView, multiplier: heightOfFullImage)
        } else if secondTeamCount == "2" {
            addTopAnchor(firstTwoPeopleImageView, anchor: dividerLineView.bottomAnchor, constant: 2)
            addTrailingAnchor(firstTwoPeopleImageView, anchor: contentGuide.trailingAnchor, constant: 0)
            addBottomAnchor(firstTwoPeopleImageView, anchor: middleHeight.topAnchor, constant: 0)
            addWidthAnchor(firstTwoPeopleImageView, multiplier: widthOfImage)
            addHeightAnchor(firstTwoPeopleImageView, multiplier: heightOfHalfImage)
            middleHeight.topAnchor.constraint(equalTo: firstTwoPeopleImageView.bottomAnchor)
            addTopAnchor(secondTwoPeopleImageView, anchor: middleHeight.bottomAnchor, constant: -2)
            addTrailingAnchor(secondTwoPeopleImageView, anchor: contentGuide.trailingAnchor, constant: 0)
            addWidthAnchor(secondTwoPeopleImageView, multiplier: widthOfImage)
            addHeightAnchor(secondTwoPeopleImageView, multiplier: heightOfHalfImage)
         } else if secondTeamCount == "3" {
            rightMiddleBottomWidth.widthAnchor.constraint(equalToConstant: screenSize.width * widthOfMiddle)
            addTopAnchor(firstThreePeopleImageView, anchor: dividerLineView.bottomAnchor, constant: 2)
            addTrailingAnchor(firstThreePeopleImageView, anchor: rightMiddleTopWidth.leadingAnchor, constant: 0)
            addWidthAnchor(firstThreePeopleImageView, multiplier: widthOfQuarterImage)
            addHeightAnchor(firstThreePeopleImageView, multiplier: heightOfHalfImage)
            addBottomAnchor(firstThreePeopleImageView, anchor: middleHeight.topAnchor, constant: 0)
            rightMiddleTopWidth.trailingAnchor.constraint(equalTo: secondThreePeopleImageView.leadingAnchor)
            addTopAnchor(secondThreePeopleImageView, anchor: dividerLineView.bottomAnchor, constant: 2)
            addLeadingAnchor(secondThreePeopleImageView, anchor: rightMiddleTopWidth.trailingAnchor, constant: 2)
            addTrailingAnchor(secondThreePeopleImageView, anchor: contentGuide.trailingAnchor, constant: 0)
            addWidthAnchor(secondThreePeopleImageView, multiplier: widthOfQuarterImage)
            addHeightAnchor(secondThreePeopleImageView, multiplier: heightOfHalfImage)
            middleHeight.topAnchor.constraint(equalTo: firstThreePeopleImageView.bottomAnchor)
            addTopAnchor(thirdThreePeopleImageView, anchor: middleHeight.bottomAnchor, constant: -2)
            addTrailingAnchor(thirdThreePeopleImageView, anchor: contentGuide.trailingAnchor, constant: 0)
            addWidthAnchor(thirdThreePeopleImageView, multiplier: widthOfImage)
            addHeightAnchor(thirdThreePeopleImageView, multiplier: heightOfHalfImage)
         } else if secondTeamCount == "4" {
            rightMiddleBottomWidth.widthAnchor.constraint(equalToConstant: screenSize.width * widthOfMiddle)
            addTopAnchor(firstFourPeopleImageView, anchor: dividerLineView.bottomAnchor, constant: 2)
            addTrailingAnchor(firstFourPeopleImageView, anchor: rightMiddleTopWidth.leadingAnchor, constant: 0)
            addBottomAnchor(firstFourPeopleImageView, anchor: middleHeight.topAnchor, constant: 0)
            addWidthAnchor(firstFourPeopleImageView, multiplier: widthOfQuarterImage)
            addHeightAnchor(firstFourPeopleImageView, multiplier: heightOfHalfImage)
            rightMiddleTopWidth.trailingAnchor.constraint(equalTo: secondFourPeopleImageView.leadingAnchor)
            addTopAnchor(secondFourPeopleImageView, anchor: dividerLineView.bottomAnchor, constant: 2)
            addLeadingAnchor(secondFourPeopleImageView, anchor: rightMiddleTopWidth.trailingAnchor, constant: 2)
            addTrailingAnchor(secondFourPeopleImageView, anchor: contentGuide.trailingAnchor, constant: 0)
            addWidthAnchor(secondFourPeopleImageView, multiplier: widthOfQuarterImage)
            addHeightAnchor(secondFourPeopleImageView, multiplier: heightOfHalfImage)
            middleHeight.topAnchor.constraint(equalTo: firstFourPeopleImageView.bottomAnchor)
            addTopAnchor(thirdFourPeopleImageView, anchor: middleHeight.bottomAnchor, constant: 0)
            addTrailingAnchor(thirdFourPeopleImageView, anchor: rightMiddleBottomWidth.leadingAnchor, constant: 0)
            addWidthAnchor(thirdFourPeopleImageView, multiplier: widthOfQuarterImage)
            addHeightAnchor(thirdFourPeopleImageView, multiplier: heightOfHalfImage)
            rightMiddleBottomWidth.trailingAnchor.constraint(equalTo: moreFourPeopleImageView.leadingAnchor)
            addBottomAnchor(moreFourPeopleImageView, anchor: thirdFourPeopleImageView.bottomAnchor, constant: -2)
            addLeadingAnchor(moreFourPeopleImageView, anchor: rightMiddleBottomWidth.trailingAnchor, constant: 2)
            addTrailingAnchor(moreFourPeopleImageView, anchor: contentGuide.trailingAnchor, constant: 0)
            addWidthAnchor(moreFourPeopleImageView, multiplier: widthOfQuarterImage)
            addHeightAnchor(moreFourPeopleImageView, multiplier: heightOfHalfImage)
        }
    }
    
    func generateMiddleBottomView(_ contentGuide: UILayoutGuide) {
        
    }
    
    func generateBottomView(_ contentGuide: UILayoutGuide) {
        
        
        //addTopAnchor(countOfLikeAndCommentLabel, anchor: dividerLineView2.bottomAnchor, constant: 10)
        //addTrailingAnchor(countOfLikeAndCommentLabel, anchor: contentGuide.trailingAnchor, constant: 0)
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
        addSubview(likeButtonWithThink)
        addSubview(commentButtonWithThink)
        addSubview(shareButtonWithThink)
        addSubview(countOfLikeAndCommentLabel)
        addSubview(dividerLineView1)
        addSubview(thinksAboutChallengeView)
        addSubview(dividerLineView2)
        addLayoutGuide(middleHeight)
        addLayoutGuide(leftMiddleTopWidth)
        addLayoutGuide(leftMiddleBottomWidth)
        addLayoutGuide(rightMiddleTopWidth)
        addLayoutGuide(rightMiddleBottomWidth)
        addSubview(joinButton)
        addSubview(firstOneChlrPeopleImageView)
        addSubview(firstTwoChlrPeopleImageView)
        addSubview(secondTwoChlrPeopleImageView)
        addSubview(firstThreeChlrPeopleImageView)
        addSubview(secondThreeChlrPeopleImageView)
        addSubview(thirdThreeChlrPeopleImageView)
        addSubview(firstFourChlrPeopleImageView)
        addSubview(secondFourChlrPeopleImageView)
        addSubview(thirdFourChlrPeopleImageView)
        addSubview(moreFourChlrPeopleImageView)
        addSubview(firstOnePeopleImageView)
        addSubview(firstTwoPeopleImageView)
        addSubview(secondTwoPeopleImageView)
        addSubview(firstThreePeopleImageView)
        addSubview(secondThreePeopleImageView)
        addSubview(thirdThreePeopleImageView)
        addSubview(firstFourPeopleImageView)
        addSubview(secondFourPeopleImageView)
        addSubview(thirdFourPeopleImageView)
        addSubview(moreFourPeopleImageView)
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
    
    let untilDateLabel: UILabel = FeedCell.labelCreate(9)
    let goalLabel: UILabel = FeedCell.labelCreate(12)
    
    static func label(_ fontSize: CGFloat) -> UILabel {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: fontSize)
        label.textAlignment = .center
        label.textColor = UIColor.white
        return label
    }
    
    let likeLabel: UILabel = FeedCell.label(8)
    
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
        button.semanticContentAttribute = .forceRightToLeft
        button.setTitle(title, for: UIControlState())
        button.setTitleColor(UIColor.rgb(143, green: 150, blue: 163), for: UIControlState())
        
        button.setImage(UIImage(named: imageName), for: UIControlState())
        button.titleEdgeInsets = UIEdgeInsetsMake(8, 0, 8, 0)

        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)        
        return button
    }
    
    let likeButton = FeedCell.buttonForTitle("Like", imageName: "like")
    let commentButton: UIButton = FeedCell.buttonForTitle("Comment", imageName: "comment")
    let shareButton: UIButton = FeedCell.buttonForTitle("Share", imageName: "share")
    let likeButtonWithThink = FeedCell.buttonForTitle("Like", imageName: "like")
    let commentButtonWithThink: UIButton = FeedCell.buttonForTitle("Comment", imageName: "comment")
    let shareButtonWithThink: UIButton = FeedCell.buttonForTitle("Share", imageName: "share")
    
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
    
    let firstOnePeopleImageView: UIImageView = FeedCell.imageView()
    let firstTwoPeopleImageView: UIImageView = FeedCell.imageView()
    let secondTwoPeopleImageView: UIImageView = FeedCell.imageView()
    let firstThreePeopleImageView: UIImageView = FeedCell.imageView()
    let secondThreePeopleImageView: UIImageView = FeedCell.imageView()
    let thirdThreePeopleImageView: UIImageView = FeedCell.imageView()
    let firstFourPeopleImageView: UIImageView = FeedCell.imageView()
    let secondFourPeopleImageView: UIImageView = FeedCell.imageView()
    let thirdFourPeopleImageView: UIImageView = FeedCell.imageView()
    let moreFourPeopleImageView: UIImageView = FeedCell.imageView()
    let firstOneChlrPeopleImageView: UIImageView = FeedCell.imageView()
    let firstTwoChlrPeopleImageView: UIImageView = FeedCell.imageView()
    let secondTwoChlrPeopleImageView: UIImageView = FeedCell.imageView()
    let firstThreeChlrPeopleImageView: UIImageView = FeedCell.imageView()
    let secondThreeChlrPeopleImageView: UIImageView = FeedCell.imageView()
    let thirdThreeChlrPeopleImageView: UIImageView = FeedCell.imageView()
    let firstFourChlrPeopleImageView: UIImageView = FeedCell.imageView()
    let secondFourChlrPeopleImageView: UIImageView = FeedCell.imageView()
    let thirdFourChlrPeopleImageView: UIImageView = FeedCell.imageView()
    let moreFourChlrPeopleImageView: UIImageView = FeedCell.imageView()
    
    static func imageViewFit() -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 4.0
        imageView.layer.masksToBounds = true
        return imageView
    }
    
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
