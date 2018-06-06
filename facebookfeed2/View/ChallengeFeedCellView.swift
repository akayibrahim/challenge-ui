//
//  ChallengeFeedCellView.swift
//  facebookfeed2
//
//  Created by iakay on 26.02.2018.
//  Copyright © 2018 challenge. All rights reserved.
//

import UIKit
import AVKit

class FeedCell: UICollectionViewCell {
    
    var feedController: FeedController?
    
    func animate() {
        feedController?.animateImageView(proofedMediaView)
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
        self.goalLabel.removeFromSuperview()
        self.joinButton.removeFromSuperview()
        self.supportSelfButton.removeFromSuperview()
        self.supportButtonMatch.removeFromSuperview()
        self.supportButton.removeFromSuperview()
        self.subjectLabel.removeFromSuperview()
        self.countOfLikeAndCommentLabel.removeFromSuperview()
        self.mySegControl.removeFromSuperview()
        self.likeLabel.removeFromSuperview()
        self.supportLabel.removeFromSuperview()
        self.supportTextLabel.removeFromSuperview()
        self.supportMatchLabel.removeFromSuperview()
        self.viewComments.removeFromSuperview()
        self.viewProofs.removeFromSuperview()
        self.addComments.removeFromSuperview()
        self.addProofs.removeFromSuperview()
        self.joinToChl.removeFromSuperview()
        self.insertTime.removeFromSuperview()
        self.nameAndStatusLabel.removeFromSuperview()
        self.challengerImageView.image = UIImage()
        self.updateProgress.removeFromSuperview()
        self.updateRefreshLabel.removeFromSuperview()
        self.untilDateLabel.removeFromSuperview()
        self.finishFlag.removeFromSuperview()
        self.scoreHome.removeFromSuperview()
        self.scoreAway.removeFromSuperview()
        self.scoreText.removeFromSuperview()
        self.proofText.removeFromSuperview()
        self.clapping.removeFromSuperview()
        self.clappingHome.removeFromSuperview()
        self.proofedMediaView.image = UIImage()
        self.proofedVideoView.removeFromSuperview()
        self.multiplierSign.removeFromSuperview()
        // self.playerController.player?.replaceCurrentItem(with: nil)
        // self.playerController.view.removeFromSuperview()
        self.view.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        super.prepareForReuse()
    }
    
    var post: Post? {
        didSet {
            var isJoined = false
            if let name = post?.name, let status = post?.status {
                let attributedText = NSMutableAttributedString(string: "\(name)", attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 12)])
                let statusText = NSMutableAttributedString(string: " \(status).", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 12)])
                attributedText.append(statusText)
                nameAndStatusLabel.attributedText = attributedText
            }
            if let thinksAboutChallenge = post?.thinksAboutChallenge, let name = post?.name {
                let commentAtt = NSMutableAttributedString(string: "\(name): ", attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 12)])
                let nameAtt = NSMutableAttributedString(string: "\(thinksAboutChallenge)", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 12)])
                commentAtt.append(nameAtt)
                thinksAboutChallengeView.attributedText = commentAtt
            }
            setImage(fbID: memberID, imageView: profileImageView)
            if let countOfComments = post?.countOfComments {
                viewComments.setTitle("View all \(countOfComments) comments", for: UIControlState())
            }
            if let countOfProofs = post?.countOfProofs {
                viewProofs.setTitle("View all \(countOfProofs) proofs", for: UIControlState())
            }
            if let insertTimeText = post?.insertTime {
                insertTime.text = insertTimeText
            }
            setImage(fbID: post?.challengerFBId, imageView: challengerImageView)
            if post?.type == PUBLIC {
                if let subject = post?.subject {
                    subjectImageView.image = UIImage(named: subject)
                }
                var firstPImg: Bool = false;
                var secondPImg: Bool = false;
                var thirdPImg: Bool = false;
                if post?.secondTeamCount == "0" {
                    setImage(name: worldImage, imageView: firstOnePeopleImageView)
                    firstOnePeopleImageView.contentMode = .scaleAspectFit
                }
                for join in (post?.joinAttendanceList)! {
                    if (join.FacebookID != post?.challengerFBId) {
                        if !firstPImg {
                            if post?.secondTeamCount == "1" {
                                setImage(fbID: join.FacebookID, imageView: firstOnePeopleImageView)
                            } else if post?.secondTeamCount == "2" {
                                setImage(fbID: join.FacebookID, imageView: firstTwoPeopleImageView)
                            } else if post?.secondTeamCount == "3" {
                                setImage(fbID: join.FacebookID, imageView: firstThreePeopleImageView)
                            } else if post?.secondTeamCount == "4" {
                                setImage(fbID: join.FacebookID, imageView: firstFourPeopleImageView)
                            }
                            firstPImg = true
                        } else if !secondPImg {
                            if post?.secondTeamCount == "2" {
                                setImage(fbID: join.FacebookID, imageView: secondTwoPeopleImageView)
                            } else if post?.secondTeamCount == "3" {
                                setImage(fbID: join.FacebookID, imageView: secondThreePeopleImageView)
                            } else if post?.secondTeamCount == "4" {
                                setImage(fbID: join.FacebookID, imageView: secondFourPeopleImageView)
                            }
                            secondPImg = true
                        } else if !thirdPImg {
                            if post?.secondTeamCount == "3" {
                                setImage(fbID: join.FacebookID, imageView: thirdThreePeopleImageView)
                            } else if post?.secondTeamCount == "4" {
                                setImage(fbID: join.FacebookID, imageView: thirdFourPeopleImageView)
                            }
                            thirdPImg = true
                        }
                    }
                    setImage(fbID: post?.challengerFBId, imageView: firstOneChlrPeopleImageView)
                    if memberID == join.memberId {
                        if join.join! {
                            joinButton.setImage(UIImage(named: acceptedRed), for: .normal)
                            isJoined = true
                        } else {
                            joinButton.setImage(UIImage(named: acceptedBlack), for: .normal)
                        }
                    }
                }
            } else if post?.type == PRIVATE {
                if let subject = post?.subject {
                    subjectImageView.image = UIImage(named: subject)
                }
                if let done = post?.done, let firstTeamScore = post?.firstTeamScore, let secondTeamScore = post?.secondTeamScore {
                    if done {
                        scoreText.text = "\(firstTeamScore)\(scoreForPrivate)\(secondTeamScore)"
                        /*
                        scoreHome.text = "\(firstTeamScore)"
                        scoreText.text = "\(scoreForPrivate)"
                        scoreAway.text = "\(secondTeamScore)"
                        */
                    }
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
                                setImage(fbID: versus.FacebookID, imageView: firstOneChlrPeopleImageView)
                            } else if post?.secondTeamCount == "2" {
                                setImage(fbID: versus.FacebookID, imageView: firstTwoChlrPeopleImageView)
                            } else if post?.secondTeamCount == "3" {
                                setImage(fbID: versus.FacebookID, imageView: firstThreeChlrPeopleImageView)
                            } else if post?.secondTeamCount == "4" {
                                setImage(fbID: versus.FacebookID, imageView: firstFourChlrPeopleImageView)
                            }
                            firstChlrImg = true
                        } else if !secondChlrImg {
                            if post?.secondTeamCount == "2" {
                                setImage(fbID: versus.FacebookID, imageView: secondTwoChlrPeopleImageView)
                            } else if post?.secondTeamCount == "3" {
                                setImage(fbID: versus.FacebookID, imageView: secondThreeChlrPeopleImageView)
                            } else if post?.secondTeamCount == "4" {
                                setImage(fbID: versus.FacebookID, imageView: secondFourChlrPeopleImageView)
                            }
                            secondChlrImg = true
                        } else if !thirdChlrImg {
                            if post?.secondTeamCount == "3" {
                                setImage(fbID: versus.FacebookID, imageView: thirdThreeChlrPeopleImageView)
                            } else if post?.secondTeamCount == "4" {
                                setImage(fbID: versus.FacebookID, imageView: thirdFourChlrPeopleImageView)
                            }
                            thirdChlrImg = true
                        }
                    } else if (versus.secondTeamMember == true){
                        if !firstImg {
                            if post?.secondTeamCount == "1" {
                                setImage(fbID: versus.FacebookID, imageView: firstOnePeopleImageView)
                            } else if post?.secondTeamCount == "2" {
                                setImage(fbID: versus.FacebookID, imageView: firstTwoPeopleImageView)
                            } else if post?.secondTeamCount == "3" {
                                setImage(fbID: versus.FacebookID, imageView: firstThreePeopleImageView)
                            } else if post?.secondTeamCount == "4" {
                                setImage(fbID: versus.FacebookID, imageView: firstFourPeopleImageView)
                            }
                            firstImg = true
                        } else if !secondImg {
                            if post?.secondTeamCount == "2" {
                                setImage(fbID: versus.FacebookID, imageView: secondTwoPeopleImageView)
                            } else if post?.secondTeamCount == "3" {
                                setImage(fbID: versus.FacebookID, imageView: secondThreePeopleImageView)
                            } else if post?.secondTeamCount == "4" {
                                setImage(fbID: versus.FacebookID, imageView: secondFourPeopleImageView)
                            }
                            secondImg = true
                        } else if !thirdImg {
                            if post?.secondTeamCount == "3" {
                                setImage(fbID: versus.FacebookID, imageView: thirdThreePeopleImageView)
                            } else if post?.secondTeamCount == "4" {
                                setImage(fbID: versus.FacebookID, imageView: thirdFourPeopleImageView)
                            }
                            thirdImg = true
                        }
                    }
                }
            } else if post?.type == SELF {
                setImage(fbID: post?.challengerFBId, imageView: firstOneChlrPeopleImageView)
                if let subject = post?.subject {
                    setImage(name: subject, imageView: firstOnePeopleImageView)
                    firstOnePeopleImageView.contentMode = .scaleAspectFill
                }
                scoreText.text = "10\(scoreForPrivate)10"
                /*
                scoreHome.text = "10"
                scoreText.text = "\(scoreForPrivate)"
                scoreAway.text = "GOAL 10"
                */
                // if let result = post?.result {}
            }
            /*
            if let countOfLike = post?.countOfLike {
                let countAtt = NSMutableAttributedString(string: "+\(countOfLike)", attributes: nil)
                let supportAtt = NSMutableAttributedString(string: " Likes", attributes: [NSForegroundColorAttributeName: UIColor.red, NSFontAttributeName: UIFont.boldSystemFont(ofSize: 10)])
                countAtt.append(supportAtt)
                likeLabel.attributedText = countAtt
            }
             */
            if let untilDate = post?.untilDateStr {
                untilDateLabel.text = "\(untilDate)"
                untilDateLabel.font = UIFont (name: fontMarkerFelt, size: 24)
                untilDateLabel.textAlignment = .center
                untilDateLabel.numberOfLines = 2;
                untilDateLabel.textColor = UIColor.gray
            }
            vsImageView.image = UIImage(named: "vs")
            if post?.secondTeamCount == "4" {
                moreFourPeopleImageView.image = UIImage(named: more_icon)
                moreFourPeopleImageView.contentMode = .scaleAspectFit
            }
            if post?.firstTeamCount == "4" {
                moreFourChlrPeopleImageView.image = UIImage(named: more_icon)
                moreFourChlrPeopleImageView.contentMode = .scaleAspectFit
            }
            goalLabel.text = "GOAL"
            if let subject = post?.subject {
                subjectLabel.text = subject
                subjectLabel.font = UIFont (name: fontMarkerFelt, size: 20)
                subjectLabel.textAlignment = .center
                subjectLabel.numberOfLines = 2;
                subjectLabel.textColor = UIColor.gray
            }
            /* TODO
            if let amILike = post?.amILike {
                if amILike {
                    supportSelfButton.setImage(UIImage(named: supported), for: .normal)
                } else {
                    supportSelfButton.setImage(UIImage(named: support), for: .normal)
                }
            }
             */
            if let supportFirstTeam = post?.supportFirstTeam, let supportSecondTeam = post?.supportSecondTeam {
                if let firstTeamSupportCount = post?.firstTeamSupportCount {
                    supportLabel.text = "+\(firstTeamSupportCount)"
                }
                if let secondTeamSupportCount = post?.secondTeamSupportCount {
                    supportMatchLabel.text = "+\(secondTeamSupportCount)"
                }
                supportTextLabel.text = supportText
                if supportFirstTeam {
                    supportButton.setImage(UIImage(named: supported), for: .normal)
                } else {
                    supportButton.setImage(UIImage(named: support), for: .normal)
                }
                if supportSecondTeam {
                    supportButtonMatch.setImage(UIImage(named: supported), for: .normal)
                } else {
                    supportButtonMatch.setImage(UIImage(named: support), for: .normal)
                }
            }
            if let type = self.post?.type, let firstTeamCount = self.post?.firstTeamCount,  let secondTeamCount = self.post?.secondTeamCount,  let isComeFromSelf = self.post?.isComeFromSelf, let isDone = self.post?.done,
                let proofed = self.post?.proofed, let firstTeamScore = self.post?.firstTeamScore, let secondTeamScore = self.post?.secondTeamScore {
                self.setupViews(firstTeamCount, secondTeamCount: secondTeamCount, type: type, isComeFromSelf : isComeFromSelf, done: isDone, proofed: proofed, joined: isJoined, firstTeamScore: firstTeamScore, secondTeamScore: secondTeamScore)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let screenSize = UIScreen.main.bounds
    func setupViews(_ firstTeamCount: String, secondTeamCount: String, type: String, isComeFromSelf : Bool, done : Bool, proofed: Bool, joined: Bool, firstTeamScore: String, secondTeamScore: String) {
        backgroundColor = UIColor.white
        let contentGuide = self.readableContentGuide
        addGeneralSubViews()
        generateTopView(contentGuide, isComeFromSelf: isComeFromSelf)
        
        if !isComeFromSelf {
            addTopAnchor(dividerLineView, anchor: contentGuide.topAnchor, constant: (screenWidth * 0.675 / 10))
        } else {
            addTopAnchor(dividerLineView, anchor: contentGuide.topAnchor, constant: 0)
        }
        
        addLeadingAnchor(dividerLineView, anchor: contentGuide.leadingAnchor, constant: 0)
        addTrailingAnchor(dividerLineView, anchor: contentGuide.trailingAnchor, constant: 0)
        dividerLineView.heightAnchor.constraint(equalToConstant: 0).isActive = true
        
        generateMiddleTopView(contentGuide, firstTeamCount: firstTeamCount, secondTeamCount: secondTeamCount, type: type, isComeFromSelf : isComeFromSelf, done: done, proofed: proofed, firstTeamScore: firstTeamScore, secondTeamScore: secondTeamScore)
        
        if !isComeFromSelf {
            if type == PUBLIC && proofed {
                var url : URL
                
                if secondTeamCount == "0" {
                    url = URL(string: "https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4")!;
                } else {
                    url = URL(string: "http://techslides.com/demos/sample-videos/small.mp4")!;
                    
                    addSubview(proofedMediaView)
                    addTopAnchor(proofedMediaView, anchor: dividerLineView1.bottomAnchor, constant: 0)
                    addWidthAnchor(proofedMediaView, multiplier: 1)
                    addHeightAnchor(proofedMediaView, multiplier: 1 / 2)
                    setImage(name: "gandhi", imageView: proofedMediaView)
                    proofedMediaView.alpha = 0
                }
                addSubview(proofedVideoView)
                addTopAnchor(proofedVideoView, anchor: dividerLineView1.bottomAnchor, constant: 0)
                addWidthAnchor(proofedVideoView, multiplier: 1)
                addHeightAnchor(proofedVideoView, multiplier: 1 / 2)
                proofedVideoView.alpha = 1
                
                DispatchQueue.main.async {
                    self.proofedVideoView.layer.addSublayer(self.avPlayerLayer)
                    self.avPlayerLayer.frame = self.proofedVideoView.layer.bounds
                    self.avPlayerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
                    self.proofedVideoView.layer.masksToBounds = true
                }
            }
            
            if(!thinksAboutChallengeView.text.isEmpty) {
                addSubview(thinksAboutChallengeView)
                addBottomAnchor(thinksAboutChallengeView, anchor: contentGuide.bottomAnchor, constant: -(screenSize.width * 1.6 / 10))
                addLeadingAnchor(thinksAboutChallengeView, anchor: contentGuide.leadingAnchor, constant: 0)
                addTrailingAnchor(thinksAboutChallengeView, anchor: contentGuide.trailingAnchor, constant: 4)
                thinksAboutChallengeView.backgroundColor = UIColor(white: 1, alpha: 0)
            }
            
            addSubview(viewComments)
            viewComments.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            addBottomAnchor(viewComments, anchor: contentGuide.bottomAnchor, constant: -(screenSize.width * 1.05 / 10))
            addLeadingAnchor(viewComments, anchor: contentGuide.leadingAnchor, constant: screenSize.width * 0.15/10)
            addHeightAnchor(viewComments, multiplier: 0.7/10)
            
            addBottomAnchor(profileImageView, anchor: contentGuide.bottomAnchor, constant: -(screenSize.width * 0.45 / 10))
            addLeadingAnchor(profileImageView, anchor: contentGuide.leadingAnchor, constant: screenSize.width * 0.15/10)
            addWidthAnchor(profileImageView, multiplier: 0.6/10)
            addHeightAnchor(profileImageView, multiplier: 0.6/10)
            
            addSubview(addComments)
            addComments.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            addLeadingAnchor(addComments, anchor: profileImageView.trailingAnchor, constant: screenSize.width * 0.15/10)
            addComments.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor, constant: 0).isActive = true
            addHeightAnchor(addComments, multiplier: 0.7/10)
            
            if type == PUBLIC {
                addSubview(viewProofs)
                viewProofs.titleLabel?.font = UIFont.systemFont(ofSize: 14)
                addTrailingAnchor(viewProofs, anchor: contentGuide.trailingAnchor, constant: -(screenSize.width * 0.2/10))
                viewProofs.centerYAnchor.constraint(equalTo: viewComments.centerYAnchor, constant: 0).isActive = true
                addHeightAnchor(viewProofs, multiplier: 0.7/10)
                
                if secondTeamCount == "0" && !done {
                    addSubview(joinButton)
                    addLeadingAnchor(joinButton, anchor: viewProofs.leadingAnchor, constant: -(screenSize.width * 0/10))
                    joinButton.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor).isActive = true
                    addWidthAnchor(joinButton, multiplier: 0.6/10)
                    addHeightAnchor(joinButton, multiplier: 0.6/10)
                    
                    if joined {
                        addSubview(addProofs)
                        addProofs.titleLabel?.font = UIFont.systemFont(ofSize: 14)
                        addLeadingAnchor(addProofs, anchor: joinButton.trailingAnchor, constant: (screenSize.width * 0.15/10))
                        addProofs.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor, constant: 0).isActive = true
                        addHeightAnchor(addProofs, multiplier: 0.7/10)
                    } else {
                        addSubview(joinToChl)
                        joinToChl.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
                        addLeadingAnchor(joinToChl, anchor: joinButton.trailingAnchor, constant: (screenSize.width * 0.15/10))
                        joinToChl.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor, constant: 0).isActive = true
                        addHeightAnchor(joinToChl, multiplier: 0.7/10)
                    }
                }
            }
            
            addSubview(insertTime)
            addBottomAnchor(insertTime, anchor: contentGuide.bottomAnchor, constant: (screenSize.width * 0.2/10))
            addLeadingAnchor(insertTime, anchor: contentGuide.leadingAnchor, constant: screenSize.width * 0.15/10)
            addHeightAnchor(insertTime, multiplier: 0.6/10)
        }
    }
    
    func generateTopView(_ contentGuide: UILayoutGuide, isComeFromSelf : Bool) {
        if !isComeFromSelf {
            addSubview(challengerImageView)
            addTopAnchor(challengerImageView, anchor: contentGuide.topAnchor, constant: 0)
            addLeadingAnchor(challengerImageView, anchor: contentGuide.leadingAnchor, constant: 2)
            addWidthAnchor(challengerImageView, multiplier: 0.6/10)
            addHeightAnchor(challengerImageView, multiplier: 0.6/10)
            
            nameAndStatusLabel.centerYAnchor.constraint(equalTo: challengerImageView.centerYAnchor).isActive = true
            addLeadingAnchor(nameAndStatusLabel, anchor: challengerImageView.trailingAnchor, constant: 5)
        }
    }
    
    func generateMiddleTopView(_ contentGuide: UILayoutGuide, firstTeamCount: String, secondTeamCount: String, type: String, isComeFromSelf : Bool, done: Bool, proofed: Bool, firstTeamScore: String, secondTeamScore: String) {
        let middleTopGuide = UILayoutGuide()
        let middleCenterGuide = UILayoutGuide()
        let middleBottomGuide = UILayoutGuide()
        addLayoutGuide(middleTopGuide)
        addLayoutGuide(middleCenterGuide)
        addLayoutGuide(middleBottomGuide)
        
        let contentGuide = self.readableContentGuide
        
        generateFirstTeam(contentGuide, firstTeamCount: firstTeamCount);
        
        middleTopGuide.heightAnchor.constraint(equalToConstant: screenSize.width * 1 / 6).isActive = true
        
        middleTopGuide.topAnchor.constraint(equalTo: dividerLineView.bottomAnchor, constant: 1).isActive = true
        
        if done {
            addSubview(finishFlag)
            addBottomAnchor(finishFlag, anchor: middleTopGuide.bottomAnchor, constant: (screenWidth * 0 / 6))
            finishFlag.centerXAnchor.constraint(equalTo: contentGuide.centerXAnchor).isActive = true
            addWidthAnchor(finishFlag, multiplier: 2 / 6)
            addHeightAnchor(finishFlag, multiplier: 1 / 6)
            finishFlag.alpha = 1
            vsImageView.alpha = 0.75
            
            addSubview(multiplierSign)
            addBottomAnchor(multiplierSign, anchor: middleTopGuide.bottomAnchor, constant: -(screenWidth * 0.3 / 6))
            multiplierSign.centerXAnchor.constraint(equalTo: contentGuide.centerXAnchor).isActive = true
            addWidthAnchor(multiplierSign, multiplier: 2 / 6)
            addHeightAnchor(multiplierSign, multiplier: 0.5 / 6)
            multiplierSign.alpha = 0
            
            /*
            addSubview(scoreHome)
            addTopAnchor(scoreHome, anchor: middleTopGuide.bottomAnchor, constant: (screenWidth * 0.6 / 10))
            scoreHome.centerXAnchor.constraint(equalTo: contentGuide.centerXAnchor, constant: -(screenSize.width * 1.3/10)).isActive = true
            addWidthAnchor(scoreHome, multiplier: 0.5 / 6)
            addHeightAnchor(scoreHome, multiplier: 0.25 / 6)
            scoreHome.backgroundColor = UIColor.white
            scoreHome.textColor = UIColor.black
            scoreHome.layer.cornerRadius = 5
            scoreHome.layer.masksToBounds = true
            scoreHome.layer.borderColor = UIColor.black.cgColor
            scoreHome.layer.borderWidth = 1.0
            scoreHome.font = UIFont.boldSystemFont(ofSize: 14)
            
            addSubview(scoreAway)
            addTopAnchor(scoreAway, anchor: vsImageView.topAnchor, constant: (screenWidth * 0.6 / 10))
            scoreAway.centerXAnchor.constraint(equalTo: contentGuide.centerXAnchor, constant: (screenSize.width * 1.3/10)).isActive = true
            addWidthAnchor(scoreAway, multiplier: 0.5 / 6)
            addHeightAnchor(scoreAway, multiplier: 0.25 / 6)
            scoreAway.backgroundColor = UIColor.white
            scoreAway.textColor = UIColor.black
            scoreAway.layer.cornerRadius = 5
            scoreAway.layer.masksToBounds = true
            scoreAway.layer.borderColor = UIColor.black.cgColor
            scoreAway.layer.borderWidth = 1.0
            scoreAway.font = UIFont.boldSystemFont(ofSize: 14)
            */
            
            addSubview(scoreText)
            addTopAnchor(scoreText, anchor: vsImageView.topAnchor, constant: (screenWidth * 0.6 / 10))
            scoreText.centerXAnchor.constraint(equalTo: contentGuide.centerXAnchor, constant: (screenSize.width * 0/10)).isActive = true
            addWidthAnchor(scoreText, multiplier: 1.7 / 6)
            addHeightAnchor(scoreText, multiplier: 0.25 / 6)
            scoreText.backgroundColor = UIColor.white
            scoreText.textColor = UIColor.black
            scoreText.layer.cornerRadius = 5
            scoreText.layer.masksToBounds = true
            scoreText.addBorders(edges: [.top, .bottom], width: 1)
            
            addSubview(proofText)
            addTopAnchor(proofText, anchor: vsImageView.topAnchor, constant: (screenWidth * 0.6 / 10))
            proofText.centerXAnchor.constraint(equalTo: contentGuide.centerXAnchor, constant: (screenSize.width * 0/10)).isActive = true
            addWidthAnchor(proofText, multiplier: 1.2 / 6)
            addHeightAnchor(proofText, multiplier: 0.25 / 6)
            proofText.backgroundColor = UIColor.white
            proofText.textColor = UIColor.black
            proofText.layer.cornerRadius = 5
            proofText.layer.masksToBounds = true
            proofText.addBorders(edges: [.top, .bottom], width: 1)
            
            if type == PUBLIC {
                // scoreHome.alpha = 0
                // scoreAway.alpha = 0
                scoreText.alpha = 0
                proofText.alpha = 1
                if proofed {
                    proofText.text = proofedText
                } else {
                    proofText.text = "JOINED" // TODO
                    if isComeFromSelf {
                        multiplierSign.alpha = 1 // TODO implement for others
                    }
                }
            } else {
                // scoreHome.alpha = 1
                // scoreAway.alpha = 1
                scoreText.alpha = 1
                proofText.alpha = 0
            }
            if type == SELF {
                addSubview(goalLabel)
                addBottomAnchor(goalLabel, anchor: scoreText.topAnchor, constant: (screenWidth * 0.05 / 10))
                goalLabel.centerXAnchor.constraint(equalTo: contentGuide.centerXAnchor, constant: screenWidth * 1.1 / 10).isActive = true
                addWidthAnchor(goalLabel, multiplier: 0.3 / 3)
                addHeightAnchor(goalLabel, multiplier: 0.1 / 3)
            }
        } else {
            addSubview(untilDateLabel)
            addBottomAnchor(untilDateLabel, anchor: middleTopGuide.bottomAnchor, constant: 0)
            addWidthAnchor(untilDateLabel, multiplier: 0.7/3)
            untilDateLabel.centerXAnchor.constraint(equalTo: contentGuide.centerXAnchor).isActive = true
            addHeightAnchor(untilDateLabel, multiplier: 1/6)
            vsImageView.alpha = 1
        }
        
        addTopAnchor(vsImageView, anchor: middleTopGuide.bottomAnchor, constant: 0)
        vsImageView.centerXAnchor.constraint(equalTo: contentGuide.centerXAnchor).isActive = true
        addHeightAnchor(vsImageView, multiplier: 1/6)
        
        middleCenterGuide.heightAnchor.constraint(equalToConstant: screenSize.width * 0/18).isActive = true
        middleCenterGuide.topAnchor.constraint(equalTo: vsImageView.bottomAnchor).isActive = true
        
        if !isComeFromSelf {
            addSubview(supportButton)
            addTopAnchor(supportButton, anchor: middleCenterGuide.bottomAnchor, constant: screenSize.width * 1.2/18)
            supportButton.centerXAnchor.constraint(equalTo: contentGuide.centerXAnchor, constant: -(screenSize.width * 0.35/3)).isActive = true
            addWidthAnchor(supportButton, multiplier: 0.3/3)
            addHeightAnchor(supportButton, multiplier: 1.8/18)
            
            addSubview(supportLabel)
            addBottomAnchor(supportLabel, anchor: supportButton.topAnchor, constant: 0)
            addTrailingAnchor(supportLabel, anchor: supportButton.trailingAnchor, constant: screenSize.width * 0.4/18)
            addWidthAnchor(supportLabel, multiplier: 0.3/3)
            addHeightAnchor(supportLabel, multiplier: 1/30)
            
            if type != SELF {
                addSubview(supportButtonMatch)
                addTopAnchor(supportButtonMatch, anchor: middleCenterGuide.bottomAnchor, constant: screenSize.width * 1.2/18)
                supportButtonMatch.centerXAnchor.constraint(equalTo: contentGuide.centerXAnchor, constant: (screenSize.width * 0.35/3)).isActive = true
                addWidthAnchor(supportButtonMatch, multiplier: 0.3/3)
                addHeightAnchor(supportButtonMatch, multiplier: 1.8/18)
                
                addSubview(supportMatchLabel)
                addBottomAnchor(supportMatchLabel, anchor: supportButtonMatch.topAnchor, constant: 0)
                addLeadingAnchor(supportMatchLabel, anchor: supportButtonMatch.leadingAnchor, constant: -(screenSize.width * 0.4/18))
                addWidthAnchor(supportMatchLabel, multiplier: 0.3/3)
                addHeightAnchor(supportMatchLabel, multiplier: 1/30)
            }
            /*
             addSubview(supportTextLabel)
             addTopAnchor(supportTextLabel, anchor: supportLabel.bottomAnchor, constant: -(screenSize.width * 0.4/18))
             supportTextLabel.centerXAnchor.constraint(equalTo: contentGuide.centerXAnchor, constant: 0).isActive = true
             addWidthAnchor(supportTextLabel, multiplier: 1/3)
             addHeightAnchor(supportTextLabel, multiplier: 1/15)
             supportTextLabel.textColor = UIColor.red
             else if type == PUBLIC {
             addSubview(joinButton)
             addTopAnchor(joinButton, anchor: middleCenterGuide.bottomAnchor, constant: screenSize.width * 0.5/18)
             joinButton.centerXAnchor.constraint(equalTo: contentGuide.centerXAnchor).isActive = true
             addWidthAnchor(joinButton, multiplier: 0.8/6)
             addHeightAnchor(joinButton, multiplier: 0.8/6)
             } else {
             selfTypeLikeButtonAndLabel(contentGuide, middleCenterGuide: middleCenterGuide)
             }
             */
        }
        
        if done {
            addSubview(clapping)
            addTopAnchor(clapping, anchor: scoreText.bottomAnchor, constant: screenWidth * 0.1 / 10)
            clapping.centerXAnchor.constraint(equalTo: contentGuide.centerXAnchor, constant: screenWidth * 1.2 / 10).isActive = true
            addWidthAnchor(clapping, multiplier: 0.45 / 6)
            addHeightAnchor(clapping, multiplier: 0.45 / 6)
            clapping.alpha = 0
            
            addSubview(clappingHome)
            addTopAnchor(clappingHome, anchor: scoreText.bottomAnchor, constant: screenWidth * 0.1 / 10)
            clappingHome.centerXAnchor.constraint(equalTo: contentGuide.centerXAnchor, constant: -(screenWidth * 1.2 / 10)).isActive = true
            addWidthAnchor(clappingHome, multiplier: 0.45 / 6)
            addHeightAnchor(clappingHome, multiplier: 0.45 / 6)
            clappingHome.alpha = 0
            
            if type == PUBLIC {
                if proofed {
                    clappingHome.alpha = 1
                }
            } else if type == PRIVATE {
                if firstTeamScore > secondTeamScore {
                    clappingHome.alpha = 1
                } else {
                    clapping.alpha = 1
                }
            } else {
                clappingHome.alpha = 1 // TODO
            }
        } else {
             if isComeFromSelf {
                addSubview(updateProgress)
                addBottomAnchor(updateProgress, anchor: middleBottomGuide.topAnchor, constant: -(screenWidth * 0.15 / 6))
                updateProgress.centerXAnchor.constraint(equalTo: contentGuide.centerXAnchor).isActive = true
                addWidthAnchor(updateProgress, multiplier: 1.3 / 6)
                addHeightAnchor(updateProgress, multiplier: 0.6 / 6)
                updateProgress.titleLabel?.numberOfLines = 2
                updateProgress.titleLabel?.textAlignment = .center
                updateProgress.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
                updateProgress.setTitleColor(UIColor.white, for: UIControlState())
                updateProgress.backgroundColor = blueColor
                updateProgress.layer.cornerRadius = 5.0
                updateProgress.clipsToBounds = true
                
                /*
                addSubview(updateRefreshLabel)
                addTopAnchor(updateRefreshLabel, anchor: updateProgress.bottomAnchor, constant: -(screenWidth * 0.5 / 6))
                updateRefreshLabel.centerXAnchor.constraint(equalTo: contentGuide.centerXAnchor).isActive = true
                addWidthAnchor(updateRefreshLabel, multiplier: 1/3)
                addHeightAnchor(updateRefreshLabel, multiplier: 1/15)
                updateRefreshLabel.text = "Update\nProgress"
                updateRefreshLabel.numberOfLines = 2
                 */
            }
        }
        
        middleBottomGuide.heightAnchor.constraint(equalToConstant: screenSize.width * 0).isActive = true
        middleBottomGuide.topAnchor.constraint(equalTo: vsImageView.bottomAnchor, constant: screenSize.width * 1/6).isActive = true
        
        addSubview(subjectLabel)
        addTopAnchor(subjectLabel, anchor: middleBottomGuide.bottomAnchor, constant: 0)
        subjectLabel.centerXAnchor.constraint(equalTo: contentGuide.centerXAnchor).isActive = true
        addHeightAnchor(subjectLabel, multiplier: 1/15)
        if !isComeFromSelf {
            addTopAnchor(dividerLineView1, anchor: middleBottomGuide.bottomAnchor, constant: (screenSize.width * 1/15)) // CGSIZE
            addLeadingAnchor(dividerLineView1, anchor: contentGuide.leadingAnchor, constant: 1)
            addTrailingAnchor(dividerLineView1, anchor: contentGuide.trailingAnchor, constant: 1)
            dividerLineView1.heightAnchor.constraint(equalToConstant: 1).isActive = true
        }
        
        generateSecondTeam(contentGuide, secondTeamCount: secondTeamCount, type: type)
    }
    
    func selfTypeLikeButtonAndLabel(_ contentGuide: UILayoutGuide, middleCenterGuide: UILayoutGuide) {
        addSubview(supportSelfButton)
        addTopAnchor(supportSelfButton, anchor: middleCenterGuide.bottomAnchor, constant: 0)
        supportSelfButton.centerXAnchor.constraint(equalTo: contentGuide.centerXAnchor).isActive = true
        addWidthAnchor(supportSelfButton, multiplier: 0.6/6)
        addHeightAnchor(supportSelfButton, multiplier: 0.6/6)
        
        addSubview(likeLabel)
        addTopAnchor(likeLabel, anchor: supportSelfButton.bottomAnchor, constant: 0)
        likeLabel.centerXAnchor.constraint(equalTo: contentGuide.centerXAnchor).isActive = true
        addWidthAnchor(likeLabel, multiplier: 1/3)
        addHeightAnchor(likeLabel, multiplier: 1/15)
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
        if firstTeamCount == teamCountOne {
            addTopAnchor(firstOneChlrPeopleImageView, anchor: dividerLineView.bottomAnchor, constant: 2)
            addLeadingAnchor(firstOneChlrPeopleImageView, anchor: contentGuide.leadingAnchor, constant: 2)
            addWidthAnchor(firstOneChlrPeopleImageView, multiplier: widthOfImage)
            addHeightAnchor(firstOneChlrPeopleImageView, multiplier: heightOfFullImage)
        } else if firstTeamCount == teamCountTwo {
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
        } else if firstTeamCount == teamCountThree {
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
        } else if firstTeamCount == teamCountFour {
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
        if (secondTeamCount == teamCountZero || secondTeamCount == teamCountOne) {
            addTopAnchor(firstOnePeopleImageView, anchor: dividerLineView.bottomAnchor, constant: 2)
            addTrailingAnchor(firstOnePeopleImageView, anchor: contentGuide.trailingAnchor, constant: 0)
            addWidthAnchor(firstOnePeopleImageView, multiplier: widthOfImage)
            addHeightAnchor(firstOnePeopleImageView, multiplier: heightOfFullImage)
        } else if secondTeamCount == teamCountTwo {
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
        } else if secondTeamCount == teamCountThree {
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
        } else if secondTeamCount == teamCountFour {
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
            addTopAnchor(thirdFourPeopleImageView, anchor: middleHeight.bottomAnchor, constant: -2)
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
    
    func addGeneralSubViews() {
        addSubview(profileImageView)
        addSubview(nameAndStatusLabel)        
        addSubview(vsImageView)
        addSubview(subjectImageView)
        addSubview(dividerLineView)
        addSubview(countOfLikeAndCommentLabel)
        addSubview(dividerLineView1)
        addSubview(thinksAboutChallengeView)
        addSubview(dividerLineView2)
        addLayoutGuide(middleHeight)
        addLayoutGuide(leftMiddleTopWidth)
        addLayoutGuide(leftMiddleBottomWidth)
        addLayoutGuide(rightMiddleTopWidth)
        addLayoutGuide(rightMiddleBottomWidth)
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
        // textView.font = UIFont.systemFont(ofSize: 12)
        textView.textAlignment = NSTextAlignment.left
        textView.textColor = UIColor.black
        // textView.backgroundColor = UIColor(red: 51/255, green: 90/255, blue: 149/255, alpha: 1)
        // textView.layer.cornerRadius = 2
        textView.layer.masksToBounds = true
        textView.isScrollEnabled = false
        textView.isEditable = false
        return textView
    }()
    
    static func circleImageView() -> UIImageView {
        let imageView = UIImageView()
        // imageView.layer.cornerRadius = 15.0
        imageView.roundedImage()
        imageView.clipsToBounds = true
        return imageView
    }
    
    let profileImageView: UIImageView = FeedCell.circleImageView()
    let challengerImageView: UIImageView = FeedCell.circleImageView()
    
    let proofedMediaView: UIImageView = {
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
        label.font = UIFont.boldSystemFont(ofSize: 10)
        return label
    }
    
    let nameAndStatusLabel: UILabel = FeedCell.labelCreateDef(1)
    
    static func labelCreate(_ fontSize: CGFloat, backColor: UIColor, textColor: UIColor) -> UILabel {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: fontSize)
        label.textAlignment = .center
        label.textColor = textColor
        label.backgroundColor = backColor
        label.layer.cornerRadius = 3
        label.layer.masksToBounds = true
        return label
    }
    
    let untilDateLabel: UILabel = FeedCell.labelCreate(9, backColor: UIColor.white, textColor: UIColor.white)
    let goalLabel: UILabel = FeedCell.labelCreate(7, backColor: UIColor(white: 1, alpha: 0), textColor: navAndTabColor)
    let subjectLabel: UILabel = FeedCell.labelCreate(12, backColor: UIColor.white, textColor: UIColor.black)
    let insertTime: UILabel = FeedCell.labelCreate(9, backColor: UIColor(white: 1, alpha: 0), textColor: UIColor.lightGray)
    
    static func label(_ fontSize: CGFloat) -> UILabel {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: fontSize)
        label.textAlignment = .center
        label.textColor = UIColor.darkGray
        return label
    }
    
    let likeLabel: UILabel = FeedCell.label(12)
    let updateRefreshLabel: UILabel = FeedCell.label(5)
    let supportLabel: UILabel = FeedCell.label(12)
    let supportTextLabel: UILabel = FeedCell.label(8)
    let supportMatchLabel: UILabel = FeedCell.label(12)
    let scoreHome: UILabel = FeedCell.label(14)
    let scoreAway: UILabel = FeedCell.label(14)
    let scoreText: UILabel = FeedCell.label(14)
    let proofText: UILabel = FeedCell.label(14)
    
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
        // button.semanticContentAttribute = .forceRightToLeft
        button.setTitle(title, for: UIControlState())
        button.setTitleColor(UIColor.rgb(143, green: 150, blue: 163), for: UIControlState())
        
        if imageName != "" {
            button.setImage(UIImage(named: imageName), for: UIControlState())
        }
        button.titleEdgeInsets = UIEdgeInsetsMake(8, 0, 8, 0)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        return button
    }
    
    let supportSelfButton = FeedCell.buttonForTitle("", imageName: support)
    let joinButton = FeedCell.buttonForTitle("", imageName: acceptedBlack)
    let viewComments = FeedCell.buttonForTitle(viewAllComments, imageName: "")
    let viewProofs = FeedCell.buttonForTitle(viewAllProofs, imageName: "")
    let addComments = FeedCell.buttonForTitle(addComents, imageName: "")
    let addProofs = FeedCell.buttonForTitle(addProofsVar, imageName: "")
    let joinToChl = FeedCell.buttonForTitle(joinToChlVar, imageName: "")
    let supportButton = FeedCell.buttonForTitle("", imageName: support)
    let supportButtonMatch = FeedCell.buttonForTitle("", imageName: support)
    let finishFlag = FeedCell.buttonForTitle("", imageName: "finishFlag")
    let multiplierSign = FeedCell.buttonForTitle("", imageName: "multipliersign")
    let clapping = FeedCell.buttonForTitle("", imageName: "clap")
    let clappingHome = FeedCell.buttonForTitle("", imageName: "clap")
    
    static func subClasssButtonForTitle(_ title: String, imageName: String) -> subclasssedUIButton {
        let button = subclasssedUIButton()
        // button.semanticContentAttribute = .forceRightToLeft
        button.setTitle(title, for: UIControlState())
        button.setTitleColor(UIColor.rgb(143, green: 150, blue: 163), for: UIControlState())
        if imageName != "" {
            button.setImage(UIImage(named: imageName), for: UIControlState())
        }
        button.titleEdgeInsets = UIEdgeInsetsMake(8, 0, 8, 0)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        return button
    }
    let updateProgress = FeedCell.subClasssButtonForTitle("UPDATE\nPROGRESS", imageName: "")
    
    static func buttonForTitleWithBorder(_ title: String, imageName: String) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: UIControlState())
        button.setTitleColor(UIColor.rgb(143, green: 150, blue: 163), for: UIControlState())
        
        if imageName != "" {
            button.setImage(UIImage(named: imageName), for: UIControlState())
        }
        button.titleEdgeInsets = UIEdgeInsetsMake(8, 0, 8, 0)
        
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.layer.borderColor = UIColor.gray.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 3.0
        button.clipsToBounds = true
        
        return button
    }
    
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
    let proofedVideoView: UIView = FeedCell.viewFunc()
    
    static func segmentedControl() -> UISegmentedControl {
        let myArray : NSArray = ["", ""]
        let mySegControl : UISegmentedControl = UISegmentedControl(items: myArray as [AnyObject])
        mySegControl.backgroundColor = UIColor.white
        mySegControl.layer.cornerRadius = 5.0
        mySegControl.tintColor = UIColor.black
        // mySegControl.setBackgroundImage(UIImage(named: "hand"), for: UIControlState(), barMetrics: UIBarMetrics.default)
        return mySegControl
    }
    
    let mySegControl: UISegmentedControl = FeedCell.segmentedControl()
    
    let avPlayerLayer : AVPlayerLayer = AVPlayerLayer.init()
    // let avPlayer : AVPlayer = AVPlayer.init()
}

class subclasssedUIButton : UIButton {
    var challengeId: String?
    var type: String?
}



