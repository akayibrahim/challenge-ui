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
        self.firstOnePeopleImageView.gestureRecognizers?.removeAll()
        self.firstTwoPeopleImageView.image = UIImage()
        self.secondTwoPeopleImageView.image = UIImage()
        self.firstThreePeopleImageView.image = UIImage()
        self.secondThreePeopleImageView.image = UIImage()
        self.thirdThreePeopleImageView.image = UIImage()
        self.firstFourPeopleImageView.image = UIImage()
        self.secondFourPeopleImageView.image = UIImage()
        self.thirdFourPeopleImageView.image = UIImage()
        self.moreFourPeopleImageView.image = UIImage()
        self.firstOneChlrPeopleImageView.removeFromSuperview()
        self.firstTwoChlrPeopleImageView.removeFromSuperview()
        self.secondTwoChlrPeopleImageView.removeFromSuperview()
        self.firstThreeChlrPeopleImageView.removeFromSuperview()
        self.secondThreeChlrPeopleImageView.removeFromSuperview()
        self.thirdThreeChlrPeopleImageView.removeFromSuperview()
        self.firstFourChlrPeopleImageView.removeFromSuperview()
        self.secondFourChlrPeopleImageView.removeFromSuperview()
        self.thirdFourChlrPeopleImageView.removeFromSuperview()
        self.moreFourChlrPeopleImageView.removeFromSuperview()
        self.firstOnePeopleImageView.removeFromSuperview()
        self.firstTwoPeopleImageView.removeFromSuperview()
        self.secondTwoPeopleImageView.removeFromSuperview()
        self.firstThreePeopleImageView.removeFromSuperview()
        self.secondThreePeopleImageView.removeFromSuperview()
        self.thirdThreePeopleImageView.removeFromSuperview()
        self.firstFourPeopleImageView.removeFromSuperview()
        self.secondFourPeopleImageView.removeFromSuperview()
        self.thirdFourPeopleImageView.removeFromSuperview()
        self.moreFourPeopleImageView.removeFromSuperview()
        self.vsImageView.image = UIImage()
        self.subjectImageView.image = UIImage()
        self.thinksAboutChallengeView.text = nil
        self.goalLabel.removeFromSuperview()
        self.joinButton.removeFromSuperview()
        self.supportButtonMatch.removeFromSuperview()
        self.supportButton.removeFromSuperview()
        self.subjectLabel.removeFromSuperview()
        self.countOfLikeAndCommentLabel.removeFromSuperview()
        self.mySegControl.removeFromSuperview()
        self.supportLabel.removeFromSuperview()
        self.supportTextLabel.removeFromSuperview()
        self.supportMatchLabel.removeFromSuperview()
        self.viewComments.removeFromSuperview()
        self.viewProofs.removeFromSuperview()
        self.addComments.removeFromSuperview()
        self.addProofs.removeFromSuperview()
        self.joinToChl.removeFromSuperview()
        self.joinToChl.canJoin = false
        self.insertTime.removeFromSuperview()
        self.visibilityLabel.removeFromSuperview()
        self.nameAndStatusLabel.removeFromSuperview()
        self.challengerImageView.image = UIImage()
        self.challengerImageView.removeFromSuperview()
        self.updateProgress.removeFromSuperview()
        self.updateRefreshLabel.removeFromSuperview()
        self.untilDateLabel.removeFromSuperview()
        self.finishFlag.image = UIImage()
        self.scoreHome.removeFromSuperview()
        self.scoreAway.removeFromSuperview()
        self.scoreText.removeFromSuperview()
        self.proofText.removeFromSuperview()
        self.clapping.removeFromSuperview()
        self.clappingHome.removeFromSuperview()
        self.proofedMediaView.image = UIImage()
        self.proofedMediaView.gestureRecognizers?.removeAll()
        self.proofedMediaView.removeFromSuperview()
        self.proofedVideoView.clearConstraints()
        self.proofedVideoView.removeFromSuperview()
        self.multiplierSign.removeFromSuperview()
        self.volumeUpImageView.removeFromSuperview()
        self.volumeDownImageView.removeFromSuperview()
        self.others.removeFromSuperview()
        self.activeLabel.removeFromSuperview()
        self.profileImageView.removeFromSuperview()
        self.proofButton.removeFromSuperview()
        self.resultText.removeFromSuperview()
        self.homeScoreText.removeFromSuperview()
        self.awayScoreText.removeFromSuperview()
        self.homeWinBase.removeFromSuperview()
        self.awayWinBase.removeFromSuperview()        
        // self.avPlayerLayer.removeFromSuperlayer()        
        self.timesUpFlag.image = UIImage()
        self.proofedVideoView.player?.replaceCurrentItem(with: nil)
        self.view.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        self.nameCorner.removeFromSuperview()
        self.countLabel.removeFromSuperview()
        self.beAChallenger.removeFromSuperview()
        super.prepareForReuse()
    }
    
    @objc var post: Post? {
        didSet {
            prepareForReuse()
            if let name = post?.name { //}, let status = post?.status {
                let attributedText = NSMutableAttributedString(string: "\(name.trim())", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 15)])
                /*
                let statusArr: [String] = status.components(separatedBy: " ")
                let challengeType = "\(statusArr[statusArr.count - 2]) \(statusArr[statusArr.count - 1])"
                let statusOfChallenge = status.replace(target: " \(challengeType)", withString: "")
                let statusText = NSMutableAttributedString(string: " \(statusOfChallenge)", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 13)])
                let challengeText = NSMutableAttributedString(string: " \("\(statusArr[statusArr.count - 2].capitalizingFirstLetter()) \(statusArr[statusArr.count - 1].capitalizingFirstLetter())").", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 13)])
                let range = ("\(challengeType) " as NSString).range(of: "\(challengeType) ")
                challengeText.addAttribute(NSAttributedStringKey.foregroundColor, value: post?.type == PUBLIC ? navAndTabColor : ( post?.type == PRIVATE ? UIColor.rgb(0, green: 153, blue: 153) : UIColor.rgb(0, green: 0, blue: 153) ) , range: range)
                statusText.append(challengeText)
                attributedText.append(statusText)
                 */
                nameAndStatusLabel.attributedText = attributedText
            }
            if let thinksAboutChallenge = post?.thinksAboutChallenge { //, let name = post?.name {
                //let commentAtt = NSMutableAttributedString(string: "\(name): ", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 12)])
                let nameAtt = NSMutableAttributedString(string: "\(thinksAboutChallenge)", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 13)])
                //commentAtt.append(nameAtt)
                thinksAboutChallengeView.attributedText = nameAtt
            }
            setImage(fbID: memberFbID, imageView: profileImageView)
            if let countOfComments = post?.countOfComments {
                //viewComments.setTitle("View all \(countOfComments) comment(s)", for: UIControlState())
                viewComments.count = Int(truncating: countOfComments)
                //addComments.count = Int(truncating: countOfComments)
            }
            if let countOfProofs = post?.countOfProofs {
                //viewProofs.setTitle("View all \(countOfProofs) proof(s)", for: UIControlState())
                viewProofs.count = Int(truncating: countOfProofs)
                addProofs.count = Int(truncating: countOfProofs)
                //updateProgress.count = Int(truncating: countOfProofs)
            }
            if let insertTimeText = post?.insertTime {
                insertTime.text = insertTimeText
            }
            if let countOfComments = post?.countOfComments, let countOfProofs = post?.countOfProofs, let firstTeamSupportCount = post?.firstTeamSupportCount {
                countLabel.text = "\(firstTeamSupportCount) Supports • \(countOfComments) Comments • \(countOfProofs) Proofs"
                countLabel.font = UIFont.systemFont(ofSize: 12)
                countLabel.textAlignment = .left
            }
            if let visibilityText = post?.visibility {
                visibilityLabel.text = "\(visibilityText == 1 ? "EVERYONE" : (visibilityText == 2 ? "FRIENDS" : "MEMBERS"))"
            }
            setImage(fbID: post?.challengerFBId, imageView: challengerImageView)
            firstOnePeopleImageView.contentMode = .scaleAspectFill
            firstOnePeopleImageView.memberId = nil
            firstTwoPeopleImageView.memberId = nil
            secondTwoPeopleImageView.memberId = nil
            firstThreePeopleImageView.memberId = nil
            secondThreePeopleImageView.memberId = nil
            thirdThreePeopleImageView.memberId = nil
            firstFourPeopleImageView.memberId = nil
            secondFourPeopleImageView.memberId = nil
            thirdFourPeopleImageView.memberId = nil
            moreFourPeopleImageView.memberId = nil
            firstOneChlrPeopleImageView.memberId = nil
            firstTwoChlrPeopleImageView.memberId = nil
            secondTwoChlrPeopleImageView.memberId = nil
            firstThreeChlrPeopleImageView.memberId = nil
            secondThreeChlrPeopleImageView.memberId = nil
            thirdThreeChlrPeopleImageView.memberId = nil
            firstFourChlrPeopleImageView.memberId = nil
            secondFourChlrPeopleImageView.memberId = nil
            thirdFourChlrPeopleImageView.memberId = nil
            moreFourChlrPeopleImageView.memberId = nil
            var onlyOneChlr = false
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
                    firstOnePeopleImageView.memberId = post?.challengerId
                }
                setImage(fbID: post?.challengerFBId, imageView: firstOneChlrPeopleImageView)
                firstOneChlrPeopleImageView.memberId = post?.challengerId
                let imageName = (post?.done)! ? "unknown-complete" : unknown
                setImage(name: imageName, imageView: firstFourPeopleImageView)
                setImage(name: imageName, imageView: secondFourPeopleImageView)
                setImage(name: imageName, imageView: thirdFourPeopleImageView)
                for join in (post?.joinAttendanceList)! {
                    if (join.FacebookID != post?.challengerFBId) {
                        if !firstPImg {
                            if post?.secondTeamCount == "1" {
                                setImage(fbID: join.FacebookID, imageView: firstOnePeopleImageView)
                                firstOnePeopleImageView.memberId = join.memberId
                            } else if post?.secondTeamCount == "2" {
                                setImage(fbID: join.FacebookID, imageView: firstTwoPeopleImageView)
                                firstTwoPeopleImageView.memberId = join.memberId
                            } else if post?.secondTeamCount == "3" {
                                setImage(fbID: join.FacebookID, imageView: firstThreePeopleImageView)
                                firstThreePeopleImageView.memberId = join.memberId
                            } else if post?.secondTeamCount == "4" {
                                setImage(fbID: join.FacebookID, imageView: firstFourPeopleImageView)
                                firstFourPeopleImageView.memberId = join.memberId
                            }
                            firstPImg = true
                        } else if !secondPImg {
                            if post?.secondTeamCount == "2" {
                                setImage(fbID: join.FacebookID, imageView: secondTwoPeopleImageView)
                                secondTwoPeopleImageView.memberId = join.memberId
                            } else if post?.secondTeamCount == "3" {
                                setImage(fbID: join.FacebookID, imageView: secondThreePeopleImageView)
                                secondThreePeopleImageView.memberId = join.memberId
                            } else if post?.secondTeamCount == "4" {
                                setImage(fbID: join.FacebookID, imageView: secondFourPeopleImageView)
                                secondFourPeopleImageView.memberId = join.memberId
                            }
                            secondPImg = true
                        } else if !thirdPImg {
                            if post?.secondTeamCount == "3" {
                                setImage(fbID: join.FacebookID, imageView: thirdThreePeopleImageView)
                                thirdThreePeopleImageView.memberId = join.memberId
                            } else if post?.secondTeamCount == "4" {
                                setImage(fbID: join.FacebookID, imageView: thirdFourPeopleImageView)
                                thirdFourPeopleImageView.memberId = join.memberId
                            }
                            thirdPImg = true
                        }
                    }
                }
                onlyOneChlr = !firstPImg && !secondPImg && !thirdPImg
            } else if post?.type == PRIVATE {
                if let subject = post?.subject {
                    subjectImageView.image = UIImage(named: subject)
                }
                if let done = post?.done, let firstTeamScore = post?.firstTeamScore, let secondTeamScore = post?.secondTeamScore {
                    let firstTeamScoreAtt = NSMutableAttributedString(string: "\(firstTeamScore)", attributes: [NSAttributedStringKey.font: UIFont(name: "Optima-ExtraBlack", size: 24)!])
                    let scoreForPriAtt = NSMutableAttributedString(string: "\(scoreForPrivate)", attributes: [NSAttributedStringKey.font: UIFont(name: "Optima-ExtraBlack", size: 35)!])
                    let secondTeamScoreAtt = NSMutableAttributedString(string: "\(secondTeamScore)", attributes: [NSAttributedStringKey.font: UIFont(name: "Optima-ExtraBlack", size: 24)!])
                    //firstTeamScoreAtt.append(scoreForPriAtt)
                    //firstTeamScoreAtt.append(secondTeamScoreAtt)
                    // scoreText.text = "\(firstTeamScore)\(scoreForPrivate)\(secondTeamScore)"
                    // scoreText.font = UIFont(name: "Optima-ExtraBlack", size: 44)
                    homeScoreText.attributedText = firstTeamScoreAtt
                    scoreText.attributedText = scoreForPriAtt
                    awayScoreText.attributedText = secondTeamScoreAtt
                    if done {
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
                                firstOneChlrPeopleImageView.memberId = versus.memberId
                            } else if post?.secondTeamCount == "2" {
                                setImage(fbID: versus.FacebookID, imageView: firstTwoChlrPeopleImageView)
                                firstTwoChlrPeopleImageView.memberId = versus.memberId
                            } else if post?.secondTeamCount == "3" {
                                setImage(fbID: versus.FacebookID, imageView: firstThreeChlrPeopleImageView)
                                firstThreeChlrPeopleImageView.memberId = versus.memberId
                            } else if post?.secondTeamCount == "4" {
                                setImage(fbID: versus.FacebookID, imageView: firstFourChlrPeopleImageView)
                                firstFourChlrPeopleImageView.memberId = versus.memberId
                            }
                            firstChlrImg = true
                        } else if !secondChlrImg {
                            if post?.secondTeamCount == "2" {
                                setImage(fbID: versus.FacebookID, imageView: secondTwoChlrPeopleImageView)
                                secondTwoChlrPeopleImageView.memberId = versus.memberId
                            } else if post?.secondTeamCount == "3" {
                                setImage(fbID: versus.FacebookID, imageView: secondThreeChlrPeopleImageView)
                                secondThreeChlrPeopleImageView.memberId = versus.memberId
                            } else if post?.secondTeamCount == "4" {
                                setImage(fbID: versus.FacebookID, imageView: secondFourChlrPeopleImageView)
                                secondFourChlrPeopleImageView.memberId = versus.memberId
                            }
                            secondChlrImg = true
                        } else if !thirdChlrImg {
                            if post?.secondTeamCount == "3" {
                                setImage(fbID: versus.FacebookID, imageView: thirdThreeChlrPeopleImageView)
                                thirdThreeChlrPeopleImageView.memberId = versus.memberId
                            } else if post?.secondTeamCount == "4" {
                                setImage(fbID: versus.FacebookID, imageView: thirdFourChlrPeopleImageView)
                                thirdFourChlrPeopleImageView.memberId = versus.memberId
                            }
                            thirdChlrImg = true
                        }
                    } else if (versus.secondTeamMember == true){
                        if !firstImg {
                            if post?.secondTeamCount == "1" {
                                setImage(fbID: versus.FacebookID, imageView: firstOnePeopleImageView)
                                firstOnePeopleImageView.memberId = versus.memberId
                            } else if post?.secondTeamCount == "2" {
                                setImage(fbID: versus.FacebookID, imageView: firstTwoPeopleImageView)
                                firstTwoPeopleImageView.memberId = versus.memberId
                            } else if post?.secondTeamCount == "3" {
                                setImage(fbID: versus.FacebookID, imageView: firstThreePeopleImageView)
                                firstThreePeopleImageView.memberId = versus.memberId
                            } else if post?.secondTeamCount == "4" {
                                setImage(fbID: versus.FacebookID, imageView: firstFourPeopleImageView)
                                firstFourPeopleImageView.memberId = versus.memberId
                            }
                            firstImg = true
                        } else if !secondImg {
                            if post?.secondTeamCount == "2" {
                                setImage(fbID: versus.FacebookID, imageView: secondTwoPeopleImageView)
                                secondTwoPeopleImageView.memberId = versus.memberId
                            } else if post?.secondTeamCount == "3" {
                                setImage(fbID: versus.FacebookID, imageView: secondThreePeopleImageView)
                                secondThreePeopleImageView.memberId = versus.memberId
                            } else if post?.secondTeamCount == "4" {
                                setImage(fbID: versus.FacebookID, imageView: secondFourPeopleImageView)
                                secondFourPeopleImageView.memberId = versus.memberId
                            }
                            secondImg = true
                        } else if !thirdImg {
                            if post?.secondTeamCount == "3" {
                                setImage(fbID: versus.FacebookID, imageView: thirdThreePeopleImageView)
                                thirdThreePeopleImageView.memberId = versus.memberId
                            } else if post?.secondTeamCount == "4" {
                                setImage(fbID: versus.FacebookID, imageView: thirdFourPeopleImageView)
                                thirdFourPeopleImageView.memberId = versus.memberId
                            }
                            thirdImg = true
                        }
                    }
                }
            } else if post?.type == SELF {
                setImage(fbID: post?.challengerFBId, imageView: firstOneChlrPeopleImageView)
                firstOneChlrPeopleImageView.memberId = post?.challengerId
                if let subject = post?.subject {
                    setImage(name: subject.replace(target: " ", withString: "_"), imageView: firstOnePeopleImageView)
                    firstOnePeopleImageView.memberId = post?.challengerId
                    firstOnePeopleImageView.contentMode = .scaleAspectFill
                    firstOnePeopleImageView.setupZoomPanGesture()
                    firstOnePeopleImageView.setupZoomPinchGesture()
                }
                // goalLabel.text = "GOAL: \(goal)"
                if let result = post?.result, let goal = post?.goal {
                    let resultAtt = NSMutableAttributedString(string: "\(result)", attributes: [NSAttributedStringKey.font: UIFont(name: "Optima-ExtraBlack", size: 24)!])
                    let scoreForSelfAtt = NSMutableAttributedString(string: "\(scoreForSelf)", attributes: [NSAttributedStringKey.font: UIFont(name: "Optima-ExtraBlack", size: 30)!])
                    let goalAtt = NSMutableAttributedString(string: "\(goal)", attributes: [NSAttributedStringKey.font: UIFont(name: "Optima-ExtraBlack", size: 24)!])
                    //resultAtt.append(scoreForSelfAtt)
                    //resultAtt.append(goalAtt)
                    //scoreText.text = "\(result)\(scoreForSelf)\(goal)"
                    // scoreText.attributedText = resultAtt
                    homeScoreText.attributedText = resultAtt
                    scoreText.attributedText = scoreForSelfAtt
                    awayScoreText.attributedText = goalAtt
                }
                /*
                scoreHome.text = "10"
                scoreText.text = "\(scoreForPrivate)"
                scoreAway.text = "GOAL 10"
                */
                // if let result = post?.result {}
            }
            if (post?.timesUp)! {
                untilDateLabel.text = "TIME'S UP"
            } else if (post?.done)! && (post?.active)! {
                untilDateLabel.text = "COMPLETED"
            } else if !(post?.done)! && (post?.active)! {
                if let untilDate = post?.untilDateStr {
                    untilDateLabel.text = "\(untilDate)"
                }
            } else if !(post?.active)! {
                if (post?.rejectedByAllAttendance)! {
                    untilDateLabel.text = "REJECTED BY ALL PARTICIPANT"
                } else if (post?.waitForApprove)! {
                    untilDateLabel.text = "WAITING FOR RESULT APPROVE"
                } else if (post?.scoreRejected)! {
                    if let scoreRejectName = post?.scoreRejectName {
                        untilDateLabel.text = "RESULTS REJECTED BY \(scoreRejectName)"
                    }
                } else {
                    untilDateLabel.text = "WAITING FOR PARTICIPANTS"
                }
            }
            untilDateLabel.textAlignment = .left
            untilDateLabel.adjustsFontSizeToFitWidth = true
            vsImageView.image = UIImage(named: "vs")
            if post?.secondTeamCount == "4" {
                moreFourPeopleImageView.image = UIImage(named: more_icon)
                moreFourPeopleImageView.contentMode = .scaleAspectFit
            }
            if post?.firstTeamCount == "4" {
                moreFourChlrPeopleImageView.image = UIImage(named: more_icon)
                moreFourChlrPeopleImageView.contentMode = .scaleAspectFit
            }
            if let subject = post?.subject {
                subjectLabel.text = subject.uppercased() //.contains("CHALLENGE") ? subject : "\(subject) CHALLENGE"
                // subjectLabel.font = UIFont (name: fontMarkerFelt, size: 20)
                subjectLabel.font = UIFont.systemFont(ofSize: 15) //subjectLabel.font.withSize(15)
                subjectLabel.textAlignment = .right
                //subjectLabel.numberOfLines = 2;
                // subjectLabel.textColor = UIColor.gray
                subjectLabel.adjustsFontSizeToFitWidth = true
            }
            if let supportFirstTeam = post?.supportFirstTeam, let supportSecondTeam = post?.supportSecondTeam {
                if let firstTeamSupportCount = post?.firstTeamSupportCount {
                    supportLabel.text = "+\(firstTeamSupportCount.getSuppportCountAsK())"
                    supportLabel.tag = Int(truncating: firstTeamSupportCount)
                    supportLabel.alpha = 1
                    if supportLabel.tag == 0 {
                        //supportLabel.alpha = 0
                        supportLabel.text = "+\(firstTeamSupportCount.getSuppportCountAsK())"
                    }
                }
                if let secondTeamSupportCount = post?.secondTeamSupportCount {
                    supportMatchLabel.text = "+\(secondTeamSupportCount.getSuppportCountAsK())"
                    supportMatchLabel.tag = Int(truncating: secondTeamSupportCount)
                    supportMatchLabel.alpha = 1
                    if supportMatchLabel.tag == 0 {
                        //supportMatchLabel.alpha = 0
                        supportMatchLabel.text = "+\(secondTeamSupportCount.getSuppportCountAsK())"
                    }
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
            // CONSTANTS
            setImage(name: volumeUp, imageView: volumeUpImageView)
            setImage(name: volumeDown, imageView: volumeDownImageView)
            // END CONSTANTS
            
            if let provedWithImage = self.post?.provedWithImage, let id = self.post?.id, let challengerId = self.post?.challengerId,
                let proofedByChallenger = self.post?.proofedByChallenger, let type = self.post?.type {
                if type == PUBLIC && proofedByChallenger {
                    if !provedWithImage {
                        let play = self.post?.firstRow
                        self.proofedVideoView.showDarkLoader()
                        self.proofedVideoView.playerLayer.load(challengeId: id, challengerId: challengerId, play: play!, completion: { () in
                            self.proofedVideoView.removeBluerLoader()
                        })
                    } else {
                        self.proofedMediaView.load(challengeId: id, challengerId: challengerId)
                    }
                }
            }
            
            if let type = self.post?.type, let firstTeamCount = self.post?.firstTeamCount,  let secondTeamCount = self.post?.secondTeamCount,  let isComeFromSelf = self.post?.isComeFromSelf, let isDone = self.post?.done, let proofed = self.post?.proofed, let active = self.post?.active , let proofedByChallenger = self.post?.proofedByChallenger, let canJoin = self.post?.canJoin, let joined = self.post?.joined, let rejectedByAllAttendance = self.post?.rejectedByAllAttendance, let timesUp = self.post?.timesUp, let provedWithImage = self.post?.provedWithImage, let challengerId = post?.challengerId, let wide = post?.wide {
                let firstTeamScore = self.post?.firstTeamScore != nil ? self.post?.firstTeamScore : "-1"
                let secondTeamScore = self.post?.secondTeamScore != nil ? self.post?.secondTeamScore : "-1"
                let result = self.post?.result != nil ? self.post?.result : "-1"
                let goal = self.post?.goal != nil ? self.post?.goal : "-1"
                let homeWin = self.post?.homeWin != nil ? self.post?.homeWin : false
                let awayWin = self.post?.awayWin != nil ? self.post?.awayWin : false
                let waitForApprove = self.post?.waitForApprove != nil ? self.post?.waitForApprove : false
                let scoreRejected = self.post?.scoreRejected != nil ? self.post?.scoreRejected : false
                let scoreRejectName = self.post?.scoreRejectName != nil ? self.post?.scoreRejectName : ""
                self.setupViews(firstTeamCount, secondTeamCount: secondTeamCount, type: type, isComeFromSelf : isComeFromSelf, done: isDone, proofed: proofed, canJoin: canJoin, firstTeamScore: firstTeamScore!, secondTeamScore: secondTeamScore!, active: active, proofedByChallenger: proofedByChallenger, result: result!, goal: goal!, joined: joined, homeWin: homeWin!, awayWin: awayWin!, rejectedByAllAttendance: rejectedByAllAttendance, timesUp: timesUp, provedWithImage: provedWithImage, waitForApprove: waitForApprove!, scoreRejected: scoreRejected!, scoreRejectName: scoreRejectName!, challengerId: challengerId, wide: wide, onlyOneChlr: onlyOneChlr)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }    
    
    @objc func imageEnable(yes: Bool) {
        // proofedVideoView.alpha = yes ? 0 : 1
        volumeUpImageView.alpha = !yes && volume == 1 ? 1 : 0
        volumeDownImageView.alpha = !yes && volume == 0 ? 1 : 0
        // proofedMediaView.alpha = yes ? 1 : 0
    }
    
    @objc let screenSize = UIScreen.main.bounds
    @objc func setupViews(_ firstTeamCount: String, secondTeamCount: String, type: String, isComeFromSelf : Bool, done : Bool, proofed: Bool, canJoin: Bool, firstTeamScore: String, secondTeamScore: String, active: Bool, proofedByChallenger: Bool, result: String, goal: String, joined: Bool, homeWin: Bool, awayWin: Bool, rejectedByAllAttendance: Bool, timesUp: Bool, provedWithImage: Bool, waitForApprove: Bool, scoreRejected: Bool, scoreRejectName: String, challengerId: String, wide: Bool, onlyOneChlr: Bool) {
        backgroundColor = feedBackColor
        let contentGuide = self.readableContentGuide
        addGeneralSubViews()
        generateTopView(contentGuide, isComeFromSelf: isComeFromSelf)
        
        //if !isComeFromSelf {
            addTopAnchor(dividerLineView, anchor: contentGuide.topAnchor, constant: (screenWidth * 1 / 10))
        //} else {
          //  addTopAnchor(dividerLineView, anchor: contentGuide.topAnchor, constant: 0)
        //}
        addLeadingAnchor(dividerLineView, anchor: contentGuide.leadingAnchor, constant: 0)
        addTrailingAnchor(dividerLineView, anchor: contentGuide.trailingAnchor, constant: 0)
        dividerLineView.heightAnchor.constraint(equalToConstant: 0).isActive = true
        
        generateMiddleTopView(contentGuide, firstTeamCount: firstTeamCount, secondTeamCount: secondTeamCount, type: type, isComeFromSelf : isComeFromSelf, done: done, proofed: proofed, firstTeamScore: firstTeamScore, secondTeamScore: secondTeamScore, active: active, result: result, goal: goal, proofedByChallenger: proofedByChallenger, joined: joined, homeWin: homeWin, awayWin: awayWin, rejectedByAllAttendance: rejectedByAllAttendance, timesUp: timesUp, waitForApprove: waitForApprove, scoreRejected: scoreRejected, scoreRejectName: scoreRejectName, onlyOneChlr: onlyOneChlr)
        
        if !isComeFromSelf {
            if type == PUBLIC && proofedByChallenger {
                
                addSubview(thinksAboutChallengeView)
                addTopAnchor(thinksAboutChallengeView, anchor: dividerLineView1.bottomAnchor, constant: 0)
                addLeadingAnchor(thinksAboutChallengeView, anchor: contentGuide.leadingAnchor, constant: screenWidth*0.3/10)
                addTrailingAnchor(thinksAboutChallengeView, anchor: contentGuide.trailingAnchor, constant: -(screenWidth*0.3/10))
                thinksAboutChallengeView.backgroundColor = UIColor(white: 1, alpha: 0)
                let heightOfThinks : CGFloat = thinksAboutChallengeView.text.isEmpty ? -20 : 0
                if !provedWithImage {
                    self.imageEnable(yes: false)
                    self.addSubview(proofedVideoView)
                    //self.addTopAnchor(proofedVideoView, anchor: self.dividerLineView1.bottomAnchor, constant: 0)
                    addTopAnchor(proofedVideoView, anchor: thinksAboutChallengeView.bottomAnchor, constant: heightOfThinks)
                    self.addWidthAnchor(proofedVideoView, multiplier: 1)
                    self.addHeightAnchor(proofedVideoView, multiplier: wide ? heightRatioOfWideMedia : heightRatioOfMedia)
                    proofedVideoView.playerLayer.videoGravity = wide ? videoGravity : videoGravityFill
                    proofedVideoView.layer.masksToBounds = true
                    /*DispatchQueue.main.async {
                     self.proofedVideoView.layer.addSublayer(self.avPlayerLayer)
                     self.avPlayerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
                     // self.avPlayerLayer.repeatCount = 10
                     self.avPlayerLayer.frame = self.proofedVideoView.layer.bounds
                     }*/
                    
                    addSubview(volumeUpImageView)
                    addBottomAnchor(volumeUpImageView, anchor: proofedVideoView.bottomAnchor, constant: -(screenWidth * 0.2 / 10))
                    addLeadingAnchor(volumeUpImageView, anchor: proofedVideoView.leadingAnchor, constant: (screenWidth * 0.2 / 10))
                    addWidthAnchor(volumeUpImageView, multiplier: 0.06)
                    addHeightAnchor(volumeUpImageView, multiplier: 0.06)
                    
                    addSubview(volumeDownImageView)
                    addBottomAnchor(volumeDownImageView, anchor: proofedVideoView.bottomAnchor, constant: -(screenWidth * 0.2 / 10))
                    addLeadingAnchor(volumeDownImageView, anchor: proofedVideoView.leadingAnchor, constant: (screenWidth * 0.2 / 10))
                    addWidthAnchor(volumeDownImageView, multiplier: 0.06)
                    addHeightAnchor(volumeDownImageView, multiplier: 0.06)
                } else {
                    //self.imageEnable(yes: true)
                    addSubview(proofedMediaView)
                    //addTopAnchor(proofedMediaView, anchor: dividerLineView1.bottomAnchor, constant: 0)
                    addTopAnchor(proofedMediaView, anchor: thinksAboutChallengeView.bottomAnchor, constant: heightOfThinks)
                    addWidthAnchor(proofedMediaView, multiplier: 1)
                    addHeightAnchor(proofedMediaView, multiplier: heightRatioOfMedia)
                }
            }
            
            if active {
            }
            
            addSubview(supportButton)
            addBottomAnchor(supportButton, anchor: contentGuide.bottomAnchor, constant: 0)
            addLeadingAnchor(supportButton, anchor: contentGuide.leadingAnchor, constant: screenWidth*0.2/10)
            //addWidthAnchor(supportButton, multiplier: 0.75/3)
            addHeightAnchor(supportButton, multiplier: 0.6/10)
            
            addSubview(viewComments)
            addCenterYAnchor(viewComments, anchor: supportButton.centerYAnchor, constant: 0)
            addCenterXAnchor(viewComments, anchor: contentGuide.centerXAnchor, constant: 0)
            addHeightAnchor(viewComments, multiplier: 0.6/10)
            
            /*
             addSubview(viewComments)
             viewComments.titleLabel?.font = UIFont.systemFont(ofSize: 14)
             addBottomAnchor(viewComments, anchor: contentGuide.bottomAnchor, constant: -(screenSize.width * 1.30 / 10))
             addLeadingAnchor(viewComments, anchor: contentGuide.leadingAnchor, constant: screenSize.width * 0.15/10)
             addHeightAnchor(viewComments, multiplier: 0.7/10)
             viewComments.titleLabel?.adjustsFontSizeToFitWidth = true
             
             addSubview(profileImageView)
             addBottomAnchor(profileImageView, anchor: contentGuide.bottomAnchor, constant: -(screenSize.width * 0.65 / 10))
             addLeadingAnchor(profileImageView, anchor: contentGuide.leadingAnchor, constant: screenSize.width * 0.15/10)
             addWidthAnchor(profileImageView, multiplier: 0.6/10)
             addHeightAnchor(profileImageView, multiplier: 0.6/10)
             
             addSubview(addComments)
             addComments.titleLabel?.font = UIFont.systemFont(ofSize: 14)
             addLeadingAnchor(addComments, anchor: profileImageView.trailingAnchor, constant: screenSize.width * 0.15/10)
             addComments.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor, constant: 0).isActive = true
             addHeightAnchor(addComments, multiplier: 0.7/10)
             */
            if type == PUBLIC {
                addSubview(viewProofs)
                addCenterYAnchor(viewProofs, anchor: supportButton.centerYAnchor, constant: 0)
                addTrailingAnchor(viewProofs, anchor: contentGuide.trailingAnchor, constant: -(screenWidth*0.3/10))
                addHeightAnchor(viewProofs, multiplier: 0.6/10)
                if !done && active && canJoin {
                    /*
                     addSubview(joinButton)
                     addLeadingAnchor(joinButton, anchor: viewProofs.leadingAnchor, constant: -(screenSize.width * 0/10))
                     joinButton.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor).isActive = true
                     addWidthAnchor(joinButton, multiplier: 0.6/10)
                     addHeightAnchor(joinButton, multiplier: 0.6/10)
                     */
                    addSubview(joinToChl)
                    joinToChl.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
                    addBottomAnchor(joinToChl, anchor: contentGuide.bottomAnchor, constant: -(screenSize.width*1.6/10))
                    joinToChl.centerXAnchor.constraint(equalTo: contentGuide.centerXAnchor).isActive = true
                    addHeightAnchor(joinToChl, multiplier: 0.85/10)
                    addWidthAnchor(joinToChl, multiplier: 2.7/3)
                    joinToChl.canJoin = true
                    joinToChl.setTitleColor(UIColor.white, for: .normal)
                    joinToChl.layer.cornerRadius = 6.0
                    joinToChl.layer.borderWidth = 0
                    joinToChl.backgroundColor = navAndTabColor // UIColor(red: 132/255, green: 212/255, blue: 39/255, alpha: 1)
                }
            }
            
            addSubview(countLabel)
            addBottomAnchor(countLabel, anchor: contentGuide.bottomAnchor, constant: -(screenSize.width*0.9/10))
            addLeadingAnchor(countLabel, anchor: contentGuide.leadingAnchor, constant: screenWidth*0.3/10)
            addWidthAnchor(countLabel, multiplier: 2.5/3)
            /*
            if challengerId == memberID {
                addSubview(visibilityLabel)
                addBottomAnchor(visibilityLabel, anchor: contentGuide.bottomAnchor, constant: (screenSize.width * 0/10))
                addTrailingAnchor(visibilityLabel, anchor: contentGuide.trailingAnchor, constant: -(screenSize.width * 0.15/10))
                addHeightAnchor(visibilityLabel, multiplier: 0.6/10)
            }
            */
        } else if isComeFromSelf && (done || proofed || timesUp || joined || !active) {
            addSubview(updateProgress)
            updateProgress.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            addBottomAnchor(updateProgress, anchor: contentGuide.bottomAnchor, constant: 0)
            updateProgress.centerXAnchor.constraint(equalTo: contentGuide.centerXAnchor).isActive = true
            addHeightAnchor(updateProgress, multiplier: 0.85/10)
            addWidthAnchor(updateProgress, multiplier: 2.7/3)
            updateProgress.setTitleColor(UIColor.white, for: .normal)
            updateProgress.layer.cornerRadius = 6.0
            updateProgress.layer.borderWidth = 0
            updateProgress.backgroundColor = blueColor
        }
        if active && !done && joined && !proofed {
            addSubview(addProofs)
            addProofs.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            addBottomAnchor(addProofs, anchor: contentGuide.bottomAnchor, constant: isComeFromSelf ? 0 : -(screenSize.width*1.6/10))
            addProofs.centerXAnchor.constraint(equalTo: contentGuide.centerXAnchor).isActive = true
            addHeightAnchor(addProofs, multiplier: 0.85/10)
            addWidthAnchor(addProofs, multiplier: 2.7/3)
            addProofs.setTitleColor(UIColor.white, for: .normal)
            addProofs.layer.cornerRadius = 6.0
            addProofs.layer.borderWidth = 0
            addProofs.backgroundColor = navAndTabColor // UIColor(red: 132/255, green: 212/255, blue: 39/255, alpha: 1)
        }
    }
    
    @objc func generateTopView(_ contentGuide: UILayoutGuide, isComeFromSelf : Bool) {
        //if !isComeFromSelf {
            /*
            addSubview(challengerImageView)
            addTopAnchor(challengerImageView, anchor: contentGuide.topAnchor, constant: 3)
            addLeadingAnchor(challengerImageView, anchor: contentGuide.leadingAnchor, constant: 2)
            addWidthAnchor(challengerImageView, multiplier: 0.6/10)
            addHeightAnchor(challengerImageView, multiplier: 0.6/10)
            */
            addSubview(nameCorner)
            addTopAnchor(nameCorner, anchor: contentGuide.topAnchor, constant: 0)
            addLeadingAnchor(nameCorner, anchor: contentGuide.leadingAnchor, constant: -(screenWidth*0.3/10))
            addWidthAnchor(nameCorner, multiplier: 0.3/10)
            addHeightAnchor(nameCorner, multiplier: 0.9/10)
            nameCorner.backgroundColor = navAndTabColor
        
            //nameAndStatusLabel.centerYAnchor.constraint(equalTo: nameCorner.centerYAnchor).isActive = true
            addTopAnchor(nameAndStatusLabel, anchor: nameCorner.topAnchor, constant: 0)
            addLeadingAnchor(nameAndStatusLabel, anchor: nameCorner.trailingAnchor, constant: (screenWidth*0.3/10))
            addWidthAnchor(nameAndStatusLabel, multiplier: 0.875/2)
            nameAndStatusLabel.adjustsFontSizeToFitWidth = true
            
            addSubview(untilDateLabel)
            addBottomAnchor(untilDateLabel, anchor: nameCorner.bottomAnchor, constant: 0)
            addLeadingAnchor(untilDateLabel, anchor: nameAndStatusLabel.leadingAnchor, constant: 0)
            addWidthAnchor(untilDateLabel, multiplier: 1.9/3)
        
            addSubview(others)
            //addBottomAnchor(others, anchor: nameCorner.bottomAnchor, constant: 0)
            addCenterYAnchor(others, anchor: nameCorner.centerYAnchor, constant: 0)
            addTrailingAnchor(others, anchor: contentGuide.trailingAnchor, constant: (screenWidth*0.125/10))
            addWidthAnchor(others, multiplier: 0.95/10)
            //addHeightAnchor(others, multiplier: 0.3/10)
        
            addSubview(subjectLabel)
            addTopAnchor(subjectLabel, anchor: nameCorner.topAnchor, constant: 0)
            //subjectLabel.centerXAnchor.constraint(equalTo: vsImageView.centerXAnchor).isActive = true
            addTrailingAnchor(subjectLabel, anchor: contentGuide.trailingAnchor, constant: -(screenWidth*0.3/10))
            addWidthAnchor(subjectLabel, multiplier: 0.875/2)
            //addHeightAnchor(subjectLabel, multiplier: 0.45/4)
            //subjectLabel.textDropShadow()
        
            addSubview(insertTime)
            addTopAnchor(insertTime, anchor: subjectLabel.bottomAnchor, constant: 0)
            addTrailingAnchor(insertTime, anchor: contentGuide.trailingAnchor, constant: -(screenWidth*0.3/10))
            //addHeightAnchor(insertTime, multiplier: 0.6/10)
        
        
        
        //}
    }
    
    @objc func generateMiddleTopView(_ contentGuide: UILayoutGuide, firstTeamCount: String, secondTeamCount: String, type: String, isComeFromSelf : Bool, done: Bool, proofed: Bool, firstTeamScore: String, secondTeamScore: String, active: Bool, result: String, goal: String, proofedByChallenger: Bool, joined: Bool, homeWin: Bool, awayWin: Bool, rejectedByAllAttendance: Bool, timesUp: Bool, waitForApprove: Bool, scoreRejected: Bool, scoreRejectName: String, onlyOneChlr: Bool) {
        let middleTopGuide = UILayoutGuide()
        let middleCenterGuide = UILayoutGuide()
        let middleBottomGuide = UILayoutGuide()
        addLayoutGuide(middleTopGuide)
        addLayoutGuide(middleCenterGuide)
        addLayoutGuide(middleBottomGuide)
        
        let contentGuide = self.readableContentGuide
        
        generateFirstTeam(contentGuide, firstTeamCount: firstTeamCount);
        
        middleTopGuide.heightAnchor.constraint(equalToConstant: screenSize.width * 0).isActive = true
        middleTopGuide.topAnchor.constraint(equalTo: dividerLineView.bottomAnchor, constant: 1).isActive = true
        
        addTopAnchor(vsImageView, anchor: middleTopGuide.bottomAnchor, constant: 0)
        vsImageView.centerXAnchor.constraint(equalTo: contentGuide.centerXAnchor, constant: -(screenWidth*0.625/4)).isActive = true
        addHeightAnchor(vsImageView, multiplier: 0.5/4)
        addWidthAnchor(vsImageView, multiplier: 0.5/4)
        //vsImageView.alpha = 0
        
        if !timesUp {
            if done && active {
                /*addSubview(finishFlag)
                addTopAnchor(finishFlag, anchor: middleTopGuide.topAnchor, constant: -(screenWidth * 0.15 / 6))
                finishFlag.centerXAnchor.constraint(equalTo: contentGuide.centerXAnchor).isActive = true
                addWidthAnchor(finishFlag, multiplier: 2 / 6)
                addHeightAnchor(finishFlag, multiplier: 1 / 6)
                setImage(name: "finishFlag", imageView: finishFlag)
                finishFlag.layer.zPosition = 10
                vsImageView.alpha = 0
                
                addSubview(multiplierSign)
                addBottomAnchor(multiplierSign, anchor: middleTopGuide.bottomAnchor, constant: -(screenWidth * 0.3 / 6))
                multiplierSign.centerXAnchor.constraint(equalTo: contentGuide.centerXAnchor).isActive = true
                addWidthAnchor(multiplierSign, multiplier: 2 / 6)
                addHeightAnchor(multiplierSign, multiplier: 0.5 / 6)
                multiplierSign.alpha = 0 */
            } else {
                /*
                if !active {
                    //vsImageView.alpha = 0
                    
                    if rejectedByAllAttendance {
                        activeLabel.text = "REJECTED BY ALL PARTICIPANT"
                    } else if waitForApprove {
                        activeLabel.text = "WAITING FOR RESULT APPROVE"
                    } else if scoreRejected {
                        activeLabel.text = "RESULTS REJECTED BY \(scoreRejectName)"
                    } else {
                        activeLabel.text = "WAITING FOR PARTICIPANTS"
                    }
                    // activeLabel.font = UIFont (name: fontMarkerFelt, size: 23)
                    activeLabel.font = activeLabel.font.withSize(23)
                    activeLabel.textAlignment = .center
                    activeLabel.numberOfLines = 2;
                    activeLabel.textColor = UIColor.darkGray
                    activeLabel.adjustsFontSizeToFitWidth = true
                    
                    addSubview(activeLabel)
                    addBottomAnchor(activeLabel, anchor: middleTopGuide.bottomAnchor, constant: 0)
                    addWidthAnchor(activeLabel, multiplier: 0.7/3)
                    activeLabel.centerXAnchor.constraint(equalTo: contentGuide.centerXAnchor).isActive = true
                    addHeightAnchor(activeLabel, multiplier: 0.5/6)
                } else {
                    //vsImageView.alpha = 1
                }
                */
            }
            /*
            addSubview(homeScoreText)
            addTopAnchor(homeScoreText, anchor: middleTopGuide.bottomAnchor, constant: (screenWidth * 0.725 / 10))
            homeScoreText.centerXAnchor.constraint(equalTo: contentGuide.centerXAnchor, constant: -(screenSize.width * 0.6 / 10)).isActive = true
            addWidthAnchor(homeScoreText, multiplier: 0.3 / 6)
            addHeightAnchor(homeScoreText, multiplier: 0.3 / 6)
            homeScoreText.backgroundColor = scoreColor
            // scoreText.font = UIFont(name: "Optima-ExtraBlack", size: 44)
            homeScoreText.textColor = UIColor.white
            homeScoreText.textAlignment = .center
            homeScoreText.layer.cornerRadius = 5
            homeScoreText.layer.masksToBounds = true
            // scoreText.addBorders(edges: [.top, .bottom], width: 1)
            homeScoreText.adjustsFontSizeToFitWidth = true
            homeScoreText.baselineAdjustment = .alignCenters
            homeScoreText.alpha = 0
            
            addSubview(scoreText)
            addTopAnchor(scoreText, anchor: middleTopGuide.bottomAnchor, constant: (screenWidth * 0.625 / 10))
            scoreText.centerXAnchor.constraint(equalTo: contentGuide.centerXAnchor, constant: (screenSize.width * 0 / 10)).isActive = true
            addWidthAnchor(scoreText, multiplier: 0.2 / 6)
            addHeightAnchor(scoreText, multiplier: 0.35 / 6)
            // scoreText.backgroundColor = UIColor.white
            // scoreText.font = UIFont(name: "Optima-ExtraBlack", size: 44)
            scoreText.textColor = scoreColor
            // scoreText.layer.cornerRadius = 5
            // scoreText.layer.masksToBounds = true
            // scoreText.addBorders(edges: [.top, .bottom], width: 1)
            scoreText.adjustsFontSizeToFitWidth = true
            scoreText.alpha = 0
            
            addSubview(awayScoreText)
            addTopAnchor(awayScoreText, anchor: middleTopGuide.bottomAnchor, constant: (screenWidth * 0.725 / 10))
            awayScoreText.centerXAnchor.constraint(equalTo: contentGuide.centerXAnchor, constant: (screenSize.width * 0.6 / 10)).isActive = true
            addWidthAnchor(awayScoreText, multiplier: 0.3 / 6)
            addHeightAnchor(awayScoreText, multiplier: 0.3 / 6)
            awayScoreText.backgroundColor = scoreColor
            // scoreText.font = UIFont(name: "Optima-ExtraBlack", size: 44)
            awayScoreText.textColor = UIColor.white
            awayScoreText.layer.cornerRadius = 5
            awayScoreText.layer.masksToBounds = true
            // scoreText.addBorders(edges: [.top, .bottom], width: 1)
            awayScoreText.adjustsFontSizeToFitWidth = true
            awayScoreText.baselineAdjustment = .alignCenters
            awayScoreText.alpha = 0
            
            if done || isComeFromSelf {
                if type == PUBLIC {
                    var proveOrJoin = false
                    if proofedByChallenger || (proofed && isComeFromSelf) {
                        proofText.text = proofedText
                        proveOrJoin = true
                    } else if joined {
                        proofText.text = "JOINED" // TODO
                        proveOrJoin = true
                    }
                    if proveOrJoin {
                        addSubview(proofText)
                        addTopAnchor(proofText, anchor: middleTopGuide.bottomAnchor, constant: (screenWidth * 0.425 / 6))
                        proofText.centerXAnchor.constraint(equalTo: contentGuide.centerXAnchor, constant: (screenSize.width * 0/10)).isActive = true
                        addWidthAnchor(proofText, multiplier: 1.1 / 6)
                        addHeightAnchor(proofText, multiplier: 0.3 / 6)
                        // proofText.font = UIFont(name: "MarkerFelt-Thin", size: 40)
                        proofText.font = proofText.font.withSize(19)
                        proofText.backgroundColor = scoreColor
                        proofText.textColor = UIColor.white
                        proofText.layer.cornerRadius = 5
                        proofText.layer.masksToBounds = true
                        // proofText.addBorders(edges: [.top, .bottom], width: 1)
                        proofText.adjustsFontSizeToFitWidth = true
                    }
                } else if type == PRIVATE && firstTeamScore != "-1" && secondTeamScore != "-1" {
                    homeScoreText.alpha = 1
                    awayScoreText.alpha = 1
                    scoreText.alpha = 1
                } else if type == SELF && result != "-1" {
                    homeScoreText.alpha = 1
                    awayScoreText.alpha = 1
                    scoreText.alpha = 1
                }
                vsImageView.alpha = 0
            }
            */
        } else {
            /*
            addSubview(timesUpFlag)
            addTopAnchor(timesUpFlag, anchor: middleTopGuide.bottomAnchor, constant: -(screenWidth * 0.5 / 6))
            timesUpFlag.centerXAnchor.constraint(equalTo: contentGuide.centerXAnchor).isActive = true
            addWidthAnchor(timesUpFlag, multiplier: 2.5 / 6)
            addHeightAnchor(timesUpFlag, multiplier: 1.25 / 6)
            setImage(name: "multipliersign", imageView: timesUpFlag)
            timesUpFlag.alpha = 1
            */
        }
        
        middleCenterGuide.heightAnchor.constraint(equalToConstant: screenSize.width * 0/18).isActive = true
        middleCenterGuide.topAnchor.constraint(equalTo: vsImageView.bottomAnchor).isActive = true
        
        if active || (!active && waitForApprove) {
            /*
            if !isComeFromSelf {
                addSubview(supportButton)
                addTopAnchor(supportButton, anchor: middleCenterGuide.bottomAnchor, constant: screenSize.width * 0.5/18)
                supportButton.centerXAnchor.constraint(equalTo: contentGuide.centerXAnchor, constant: -(screenSize.width * 0.26/3)).isActive = true
                addWidthAnchor(supportButton, multiplier: 0.3/3)
                addHeightAnchor(supportButton, multiplier: 1.8/18)
                
                addSubview(supportLabel)
                addBottomAnchor(supportLabel, anchor: supportButton.topAnchor, constant: 0)
                addLeadingAnchor(supportLabel, anchor: supportButton.leadingAnchor, constant: -(screenSize.width * 0/18))
                addWidthAnchor(supportLabel, multiplier: 0.3/3)
                addHeightAnchor(supportLabel, multiplier: 1/30)
                
                if type == PRIVATE {
                    addSubview(supportButtonMatch)
                    addTopAnchor(supportButtonMatch, anchor: middleCenterGuide.bottomAnchor, constant: screenSize.width * 0.5/18)
                    supportButtonMatch.centerXAnchor.constraint(equalTo: contentGuide.centerXAnchor, constant: (screenSize.width * 0.27/3)).isActive = true
                    addWidthAnchor(supportButtonMatch, multiplier: 0.3/3)
                    addHeightAnchor(supportButtonMatch, multiplier: 1.8/18)
                    supportButtonMatch.layer.zPosition = 1
                    
                    addSubview(supportMatchLabel)
                    addBottomAnchor(supportMatchLabel, anchor: supportButtonMatch.topAnchor, constant: 0)
                    addTrailingAnchor(supportMatchLabel, anchor: supportButtonMatch.trailingAnchor, constant: (screenSize.width * 0/18))
                    addWidthAnchor(supportMatchLabel, multiplier: 0.3/3)
                    addHeightAnchor(supportMatchLabel, multiplier: 1/30)
                }
            }
             */
            /*
            if !timesUp {
                addSubview(clapping)
                addBottomAnchor(clapping, anchor: awayScoreText.topAnchor, constant: -(screenWidth * 0.07 / 10))
                clapping.centerXAnchor.constraint(equalTo: awayScoreText.centerXAnchor, constant: screenWidth * 0 / 10).isActive = true
                // addTrailingAnchor(clapping, anchor: awayScoreText.trailingAnchor, constant: 0)
                addWidthAnchor(clapping, multiplier: 0.3 / 6)
                addHeightAnchor(clapping, multiplier: 0.3 / 6)
                clapping.alpha = 0
                
                addSubview(clappingHome)
                addBottomAnchor(clappingHome, anchor: homeScoreText.topAnchor, constant: -(screenWidth * 0.07 / 10))
                clappingHome.centerXAnchor.constraint(equalTo: homeScoreText.centerXAnchor, constant: -(screenWidth * 0 / 10)).isActive = true
                // addLeadingAnchor(clappingHome, anchor: homeScoreText.leadingAnchor, constant: 0)
                addWidthAnchor(clappingHome, multiplier: 0.3 / 6)
                addHeightAnchor(clappingHome, multiplier: 0.3 / 6)
                clappingHome.alpha = 0
                
                if type == PUBLIC && (proofedByChallenger || proofed) && isComeFromSelf {
                    clappingHome.alpha = 1
                }
                if done {
                    addSubview(homeWinBase)
                    addTopAnchor(homeWinBase, anchor: middleTopGuide.bottomAnchor, constant: (screenWidth * 0.775 / 10))
                    homeWinBase.centerXAnchor.constraint(equalTo: contentGuide.centerXAnchor, constant: -(screenSize.width * 0.6 / 10)).isActive = true
                    addWidthAnchor(homeWinBase, multiplier: 0.3 / 6)
                    addHeightAnchor(homeWinBase, multiplier: 0.08 / 6)
                    homeWinBase.backgroundColor = scoreColor
                    homeWinBase.layer.cornerRadius = 5
                    homeWinBase.layer.masksToBounds = true
                    homeWinBase.alpha = 0
                    homeWinBase.layer.zPosition = -1
                    
                    addSubview(awayWinBase)
                    addTopAnchor(awayWinBase, anchor: middleTopGuide.bottomAnchor, constant: (screenWidth * 0.775 / 10))
                    awayWinBase.centerXAnchor.constraint(equalTo: contentGuide.centerXAnchor, constant: (screenSize.width * 0.6 / 10)).isActive = true
                    addWidthAnchor(awayWinBase, multiplier: 0.3 / 6)
                    addHeightAnchor(awayWinBase, multiplier: 0.08 / 6)
                    awayWinBase.backgroundColor = scoreColor
                    awayWinBase.layer.cornerRadius = 5
                    awayWinBase.layer.masksToBounds = true
                    awayWinBase.alpha = 0
                    awayWinBase.layer.zPosition = -1
                    
                    if type == PUBLIC {
                        if proofedByChallenger || (proofed && isComeFromSelf) {
                            clappingHome.alpha = 1
                        }
                    } else if type == PRIVATE {
                        if homeWin {
                            clappingHome.alpha = 1
                            clapping.alpha = 0.2
                            homeWinBase.alpha = 1
                            awayWinBase.alpha = 0.2
                        } else if awayWin {
                            clapping.alpha = 1
                            clappingHome.alpha = 0.2
                            awayWinBase.alpha = 1
                            homeWinBase.alpha = 0.2
                        }
                    } else {
                        if homeWin {
                            clappingHome.alpha = 1
                            homeWinBase.alpha = 1
                        }
                    }
                }
            }
            */
        }
        
        middleBottomGuide.heightAnchor.constraint(equalToConstant: screenSize.width * 0).isActive = true
        middleBottomGuide.topAnchor.constraint(equalTo: vsImageView.bottomAnchor, constant: screenWidth * 0).isActive = true
        
        if !isComeFromSelf {
            addTopAnchor(dividerLineView1, anchor: middleBottomGuide.bottomAnchor, constant: (screenWidth * 0/4)) // CGSIZE
            addLeadingAnchor(dividerLineView1, anchor: contentGuide.leadingAnchor, constant: 1)
            addTrailingAnchor(dividerLineView1, anchor: contentGuide.trailingAnchor, constant: 1)
            dividerLineView1.heightAnchor.constraint(equalToConstant: 0).isActive = true
        }
        
        generateSecondTeam(contentGuide, secondTeamCount: secondTeamCount, type: type, onlyOneChlr: onlyOneChlr)
    }
    
    @objc var widthOfImage: CGFloat = 1/4
    @objc var heightOfFullImage: CGFloat = 1/4
    @objc var heightOfHalfImage: CGFloat = 0.5/4
    @objc var widthOfQuarterImage: CGFloat = 0.5/4
    @objc var heightOfMiddle: CGFloat = 0.04/4
    @objc var widthOfMiddle: CGFloat = 0.04/4
    @objc func generateFirstTeam(_ contentGuide: UILayoutGuide, firstTeamCount: String) {
        let screenSize = UIScreen.main.bounds
        middleHeight.heightAnchor.constraint(equalToConstant: screenSize.width * heightOfMiddle).isActive = true
        if firstTeamCount == teamCountOne {
            addSubview(firstOneChlrPeopleImageView)
            addTopAnchor(firstOneChlrPeopleImageView, anchor: dividerLineView.bottomAnchor, constant: 3)
            addLeadingAnchor(firstOneChlrPeopleImageView, anchor: contentGuide.leadingAnchor, constant: (screenWidth*0.3/10))
            addWidthAnchor(firstOneChlrPeopleImageView, multiplier: widthOfImage*4.25/5)
            addHeightAnchor(firstOneChlrPeopleImageView, multiplier: heightOfHalfImage)
        } else if firstTeamCount == teamCountTwo {
            addSubview(firstTwoChlrPeopleImageView)
            addSubview(secondTwoChlrPeopleImageView)
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
            addSubview(firstThreeChlrPeopleImageView)
            addSubview(secondThreeChlrPeopleImageView)
            addSubview(thirdThreeChlrPeopleImageView)
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
            addSubview(firstFourChlrPeopleImageView)
            addSubview(secondFourChlrPeopleImageView)
            addSubview(thirdFourChlrPeopleImageView)
            addSubview(moreFourChlrPeopleImageView)
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
            addBottomAnchor(moreFourChlrPeopleImageView, anchor: thirdFourChlrPeopleImageView.bottomAnchor, constant: 0)
            addLeadingAnchor(moreFourChlrPeopleImageView, anchor: leftMiddleBottomWidth.trailingAnchor, constant: 2)
            addWidthAnchor(moreFourChlrPeopleImageView, multiplier: widthOfQuarterImage)
            addHeightAnchor(moreFourChlrPeopleImageView, multiplier: heightOfHalfImage)
        }
    }
    
    @objc func generateSecondTeam(_ contentGuide: UILayoutGuide, secondTeamCount: String, type: String, onlyOneChlr: Bool) {
        let screenSize = UIScreen.main.bounds
        middleHeight.heightAnchor.constraint(equalToConstant: screenSize.width * heightOfMiddle).isActive = true
        /*
        if (secondTeamCount == teamCountZero || secondTeamCount == teamCountOne) {
            addSubview(firstOnePeopleImageView)
            addTopAnchor(firstOnePeopleImageView, anchor: dividerLineView.bottomAnchor, constant: 2)
            addTrailingAnchor(firstOnePeopleImageView, anchor: contentGuide.trailingAnchor, constant: 0)
            addWidthAnchor(firstOnePeopleImageView, multiplier: widthOfImage)
            addHeightAnchor(firstOnePeopleImageView, multiplier: heightOfFullImage)
        } else if secondTeamCount == teamCountTwo {
            addSubview(firstTwoPeopleImageView)
            addSubview(secondTwoPeopleImageView)
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
            addSubview(firstThreePeopleImageView)
            addSubview(secondThreePeopleImageView)
            addSubview(thirdThreePeopleImageView)
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
        } else if secondTeamCount == teamCountFour {*/
            addSubview(firstFourPeopleImageView)
            /*firstFourPeopleImageView.backgroundColor = UIColor.red
            secondFourPeopleImageView.backgroundColor = UIColor.blue
            thirdFourPeopleImageView.backgroundColor = UIColor.gray*/
            rightMiddleBottomWidth.widthAnchor.constraint(equalToConstant: screenSize.width * widthOfMiddle)
            addTopAnchor(firstFourPeopleImageView, anchor: vsImageView.topAnchor, constant: 0)
            addLeadingAnchor(firstFourPeopleImageView, anchor: vsImageView.trailingAnchor, constant: screenWidth*widthOfMiddle)
            addBottomAnchor(firstFourPeopleImageView, anchor: middleHeight.topAnchor, constant: 0)
            addWidthAnchor(firstFourPeopleImageView, multiplier: widthOfQuarterImage)
            addHeightAnchor(firstFourPeopleImageView, multiplier: heightOfHalfImage)
            if onlyOneChlr {
                addSubview(beAChallenger)
                addCenterYAnchor(beAChallenger, anchor: vsImageView.centerYAnchor, constant: 0)
                addLeadingAnchor(beAChallenger, anchor: firstFourPeopleImageView.trailingAnchor, constant: screenWidth*widthOfMiddle*2)
                addWidthAnchor(beAChallenger, multiplier: widthOfQuarterImage*3)
                beAChallenger.text = "BE THE FIRST\nCHALLENGER"
                beAChallenger.numberOfLines = 2
                beAChallenger.adjustsFontSizeToFitWidth = true
                beAChallenger.textAlignment = .left
            } else {
                addSubview(secondFourPeopleImageView)
                addSubview(thirdFourPeopleImageView)
                addSubview(moreFourPeopleImageView)
                rightMiddleTopWidth.trailingAnchor.constraint(equalTo: secondFourPeopleImageView.leadingAnchor)
                addTopAnchor(secondFourPeopleImageView, anchor: vsImageView.topAnchor, constant: 0)
                addLeadingAnchor(secondFourPeopleImageView, anchor: firstFourPeopleImageView.trailingAnchor, constant: screenWidth*widthOfMiddle)
                //addTrailingAnchor(secondFourPeopleImageView, anchor: contentGuide.trailingAnchor, constant: 0)
                addWidthAnchor(secondFourPeopleImageView, multiplier: widthOfQuarterImage)
                addHeightAnchor(secondFourPeopleImageView, multiplier: heightOfHalfImage)
                middleHeight.topAnchor.constraint(equalTo: firstFourPeopleImageView.bottomAnchor)
                addTopAnchor(thirdFourPeopleImageView, anchor: vsImageView.topAnchor, constant: 0)
                addLeadingAnchor(thirdFourPeopleImageView, anchor: secondFourPeopleImageView.trailingAnchor, constant: screenWidth*widthOfMiddle)
                //addLeadingAnchor(thirdFourPeopleImageView, anchor: rightMiddleTopWidth.trailingAnchor, constant: 2)
                addWidthAnchor(thirdFourPeopleImageView, multiplier: widthOfQuarterImage)
                addHeightAnchor(thirdFourPeopleImageView, multiplier: heightOfHalfImage)
                //rightMiddleBottomWidth.trailingAnchor.constraint(equalTo: moreFourPeopleImageView.leadingAnchor)
                addTopAnchor(moreFourPeopleImageView, anchor: vsImageView.topAnchor, constant: 0)
                // addLeadingAnchor(moreFourPeopleImageView, anchor: thirdFourPeopleImageView.trailingAnchor, constant: 2)
                addLeadingAnchor(moreFourPeopleImageView, anchor: thirdFourPeopleImageView.trailingAnchor, constant: screenWidth*widthOfMiddle)
                addWidthAnchor(moreFourPeopleImageView, multiplier: widthOfQuarterImage)
                addHeightAnchor(moreFourPeopleImageView, multiplier: heightOfHalfImage)
            }
        //}
    }
    
    @objc func addGeneralSubViews() {
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
    }
    
    @objc let middleHeight = UILayoutGuide()
    @objc let leftMiddleTopWidth = UILayoutGuide()
    @objc let leftMiddleBottomWidth = UILayoutGuide()
    @objc let rightMiddleTopWidth = UILayoutGuide()
    @objc let rightMiddleBottomWidth = UILayoutGuide()
    
    @objc let countOfLikeAndCommentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 10)
        label.textAlignment = NSTextAlignment.right;
        label.isOpaque = true
        label.layer.shouldRasterize = true
        label.layer.rasterizationScale = UIScreen.main.scale
        return label
    }()
    
    @objc let thinksAboutChallengeView: UITextView = {
        let textView = UITextView()
        // textView.font = UIFont.systemFont(ofSize: 12)
        textView.textAlignment = NSTextAlignment.left
        textView.textColor = UIColor.black
        // textView.backgroundColor = UIColor(red: 51/255, green: 90/255, blue: 149/255, alpha: 1)
        // textView.layer.cornerRadius = 2
        textView.layer.masksToBounds = true
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.isOpaque = true
        textView.layer.shouldRasterize = true
        textView.layer.rasterizationScale = UIScreen.main.scale
        return textView
    }()
    
    @objc static func circleImageView() -> UIImageView {
        let imageView = UIImageView()
        // imageView.layer.cornerRadius = 15.0
        imageView.roundedImage()
        imageView.clipsToBounds = true
        imageView.isOpaque = true
        imageView.layer.shouldRasterize = true
        imageView.layer.rasterizationScale = UIScreen.main.scale
        imageView.layer.borderWidth = 0.03
        return imageView
    }
    
    @objc static func rectImageView() -> UIImageView {
        let imageView = UIImageView()
        // imageView.layer.cornerRadius = 15.0
        imageView.clipsToBounds = true
        imageView.isOpaque = true
        imageView.layer.shouldRasterize = true
        imageView.layer.rasterizationScale = UIScreen.main.scale
        return imageView
    }
    
    @objc let profileImageView: UIImageView = FeedCell.circleImageView()
    @objc let challengerImageView: UIImageView = FeedCell.circleImageView()
    @objc let volumeUpImageView: UIImageView = FeedCell.rectImageView()
    @objc let volumeDownImageView: UIImageView = FeedCell.rectImageView()
    @objc let nameCorner: UIImageView = FeedCell.rectImageView()
    
    @objc let proofedMediaView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = defaultContentMode
        imageView.layer.cornerRadius = 2.0
        imageView.layer.masksToBounds = true
        imageView.isUserInteractionEnabled = true
        imageView.isOpaque = true
        imageView.layer.shouldRasterize = true
        imageView.layer.rasterizationScale = UIScreen.main.scale
        imageView.layer.borderWidth = 0.03
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.backgroundColor = backColorOfMedia
        return imageView
    }()
    
    @objc let vsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.semanticContentAttribute = .forceRightToLeft
        imageView.isOpaque = true
        imageView.layer.shouldRasterize = true
        imageView.layer.rasterizationScale = UIScreen.main.scale
        return imageView
    }()
    
    @objc static func labelCreateDef(_ line: Int) -> UILabel {
        let label = UILabel()
        label.numberOfLines = line
        label.font = UIFont.boldSystemFont(ofSize: 10)
        label.isOpaque = true
        label.layer.shouldRasterize = true
        label.layer.rasterizationScale = UIScreen.main.scale
        return label
    }
    
    @objc let nameAndStatusLabel: UILabel = FeedCell.labelCreateDef(1)
    
    @objc static func labelCreate(_ fontSize: CGFloat, backColor: UIColor, textColor: UIColor) -> UILabel {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: fontSize)
        label.textAlignment = .center
        label.textColor = textColor
        label.backgroundColor = backColor
        label.layer.cornerRadius = 3
        label.layer.masksToBounds = true
        label.isOpaque = true
        label.layer.shouldRasterize = true
        label.layer.rasterizationScale = UIScreen.main.scale
        return label
    }
    
    @objc let untilDateLabel: UILabel = FeedCell.labelCreate(11, backColor: UIColor(white: 1, alpha: 0), textColor: UIColor.black)
    @objc let activeLabel: UILabel = FeedCell.labelCreate(9, backColor: UIColor.white, textColor: UIColor.white)
    @objc let goalLabel: UILabel = FeedCell.labelCreate(10, backColor: UIColor(white: 1, alpha: 0), textColor: navAndTabColor)
    @objc let subjectLabel: UILabel = FeedCell.labelCreate(12, backColor: UIColor(white: 1, alpha: 0), textColor: UIColor.black)
    @objc let insertTime: UILabel = FeedCell.labelCreate(11, backColor: UIColor(white: 1, alpha: 0), textColor: UIColor.black)
    @objc let visibilityLabel: UILabel = FeedCell.labelCreate(7, backColor: UIColor(white: 1, alpha: 0), textColor: UIColor.lightGray)
    @objc let countLabel: UILabel = FeedCell.labelCreate(9, backColor: UIColor(white: 1, alpha: 0), textColor: UIColor.black)
    @objc let beAChallenger: UILabel = FeedCell.labelCreate(11, backColor: UIColor(white: 1, alpha: 0), textColor: UIColor.black)
    
    @objc static func label(_ fontSize: CGFloat) -> subclasssedUILabel {
        let label = subclasssedUILabel()
        label.font = UIFont.boldSystemFont(ofSize: fontSize)
        label.textAlignment = .center
        label.textColor = UIColor.darkGray
        label.isOpaque = true
        label.layer.shouldRasterize = true
        label.layer.rasterizationScale = UIScreen.main.scale
        return label
    }
    
    @objc let updateRefreshLabel: UILabel = FeedCell.label(5)
    @objc let supportLabel: subclasssedUILabel = FeedCell.label(12)
    @objc let supportTextLabel: UILabel = FeedCell.label(8)
    @objc let supportMatchLabel: subclasssedUILabel = FeedCell.label(12)
    @objc let scoreHome: UILabel = FeedCell.label(14)
    @objc let scoreAway: UILabel = FeedCell.label(14)
    @objc let scoreText: UILabel = FeedCell.label(14)
    @objc let homeScoreText: UILabel = FeedCell.label(12)
    @objc let awayScoreText: UILabel = FeedCell.label(12)
    @objc let homeWinBase: UILabel = FeedCell.label(12)
    @objc let awayWinBase: UILabel = FeedCell.label(12)
    @objc let resultText: UILabel = FeedCell.label(14)
    @objc let proofText: UILabel = FeedCell.label(14)
    
    @objc static func lineForDivider() -> UIView {
        let view = UIView()
        // view.backgroundColor = UIColor.red
        view.layer.cornerRadius = 1.5
        view.layer.masksToBounds = true
        view.layer.borderWidth = 0.1
        view.layer.borderColor = UIColor.gray.cgColor
        view.layer.shouldRasterize = true
        view.layer.rasterizationScale = UIScreen.main.scale
        return view
    }
    
    @objc let dividerLineView: UIView = FeedCell.lineForDivider()
    @objc let dividerLineView1: UIView = FeedCell.lineForDivider()
    @objc let dividerLineView2: UIView = FeedCell.lineForDivider()
    
    @objc static func buttonForImage(_ imageName: String) -> subclasssedUIButton {
        let button = subclasssedUIButton()
        if imageName != "" {
            button.setImage(UIImage(named: imageName), for: UIControlState())
            button.imageView?.contentMode = .scaleAspectFit
            button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0)
        }
        button.isOpaque = true
        button.layer.shouldRasterize = true
        button.layer.rasterizationScale = UIScreen.main.scale
        return button
    }
    
    @objc let others = FeedCell.buttonForImage("challengeprops")
    
    @objc static func buttonForTitle(_ title: String, imageName: String) -> UIButton {
        let button = UIButton()
        // button.semanticContentAttribute = .forceRightToLeft
        button.setTitle(title, for: UIControlState())
        button.setTitleColor(UIColor.rgb(143, green: 150, blue: 163), for: UIControlState())
        
        if imageName != "" {
            button.setImage(UIImage(named: imageName), for: UIControlState())
        }
        button.titleEdgeInsets = UIEdgeInsetsMake(8, 0, 8, 0)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.isOpaque = true
        button.layer.shouldRasterize = true
        button.layer.rasterizationScale = UIScreen.main.scale
        return button
    }
    
    @objc let multiplierSign = FeedCell.buttonForTitle("", imageName: "multipliersign")
    @objc let clapping = FeedCell.buttonForTitle("", imageName: "clap")
    @objc let clappingHome = FeedCell.buttonForTitle("", imageName: "clap")
    
    @objc static func subClasssButtonForTitle(_ title: String, imageName: String) -> subclasssedUIButton {
        let button = subclasssedUIButton()
        // button.semanticContentAttribute = .forceRightToLeft
        button.setTitle(title, for: UIControlState())
        button.setTitleColor(UIColor.black, for: UIControlState())
        if imageName != "" {
            button.setImage(UIImage(named: imageName), for: UIControlState())
            button.imageView?.contentMode = .scaleAspectFit
            button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 2, 0)
        }
        button.titleEdgeInsets = UIEdgeInsetsMake(8, 0, 8, 0)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.isOpaque = true
        button.layer.shouldRasterize = true
        button.layer.rasterizationScale = UIScreen.main.scale
        return button
    }
    @objc let updateProgress = FeedCell.subClasssButtonForTitle("Details", imageName: "")
    @objc let viewComments = FeedCell.subClasssButtonForTitle(viewAllComments, imageName: "comment")
    @objc let viewProofs = FeedCell.subClasssButtonForTitle(viewAllProofs, imageName: "stamp")
    @objc let addComments = FeedCell.subClasssButtonForTitle(addComents, imageName: "")
    @objc let addProofs = FeedCell.subClasssButtonForTitle(addProofsVar, imageName: "")
    @objc let supportButton = FeedCell.subClasssButtonForTitle("Support", imageName: support)
    @objc let supportButtonMatch = FeedCell.subClasssButtonForTitle("", imageName: support)
    @objc let joinButton = FeedCell.subClasssButtonForTitle("", imageName: acceptedBlack)
    @objc let proofButton = FeedCell.subClasssButtonForTitle("", imageName: acceptedRed)
    
    @objc static func buttonForTitleWithBorder(_ title: String, imageName: String) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: UIControlState())
        button.setTitleColor(UIColor.rgb(143, green: 150, blue: 163), for: UIControlState())
        
        if imageName != "" {
            button.setImage(UIImage(named: imageName), for: .normal)
        }
        button.titleEdgeInsets = UIEdgeInsetsMake(8, 0, 8, 0)
        
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.layer.borderColor = UIColor.gray.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 3.0
        button.clipsToBounds = true
        button.isOpaque = true
        button.layer.shouldRasterize = true
        button.layer.rasterizationScale = UIScreen.main.scale
        return button
    }
    
    @objc static func subClassbuttonForTitleWithBorder(_ title: String, imageName: String) -> subclasssedUIButton {
        let button = subclasssedUIButton()
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
        button.isOpaque = true
        button.layer.shouldRasterize = true
        button.layer.rasterizationScale = UIScreen.main.scale
        return button
    }
    
    @objc let joinToChl = FeedCell.subClassbuttonForTitleWithBorder(joinToChlVar, imageName: "")
    
    @objc static func imageView() -> subclasssedUIImageView {
        let imageView = subclasssedUIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 4.0
        imageView.layer.masksToBounds = true
        imageView.isOpaque = true
        //imageView.layer.shouldRasterize = true
        imageView.layer.rasterizationScale = UIScreen.main.scale
        imageView.layer.borderWidth = 0.03
        //imageView.layer.minificationFilter = kCAFilterTrilinear
        return imageView
    }
    
    @objc let firstOnePeopleImageView: subclasssedUIImageView = FeedCell.imageView()
    @objc let firstTwoPeopleImageView: subclasssedUIImageView = FeedCell.imageView()
    @objc let secondTwoPeopleImageView: subclasssedUIImageView = FeedCell.imageView()
    @objc let firstThreePeopleImageView: subclasssedUIImageView = FeedCell.imageView()
    @objc let secondThreePeopleImageView: subclasssedUIImageView = FeedCell.imageView()
    @objc let thirdThreePeopleImageView: subclasssedUIImageView = FeedCell.imageView()
    @objc let firstFourPeopleImageView: subclasssedUIImageView = FeedCell.imageView()
    @objc let secondFourPeopleImageView: subclasssedUIImageView = FeedCell.imageView()
    @objc let thirdFourPeopleImageView: subclasssedUIImageView = FeedCell.imageView()
    @objc let moreFourPeopleImageView: subclasssedUIImageView = FeedCell.imageView()
    @objc let firstOneChlrPeopleImageView: subclasssedUIImageView = FeedCell.imageView()
    @objc let firstTwoChlrPeopleImageView: subclasssedUIImageView = FeedCell.imageView()
    @objc let secondTwoChlrPeopleImageView: subclasssedUIImageView = FeedCell.imageView()
    @objc let firstThreeChlrPeopleImageView: subclasssedUIImageView = FeedCell.imageView()
    @objc let secondThreeChlrPeopleImageView: subclasssedUIImageView = FeedCell.imageView()
    @objc let thirdThreeChlrPeopleImageView: subclasssedUIImageView = FeedCell.imageView()
    @objc let firstFourChlrPeopleImageView: subclasssedUIImageView = FeedCell.imageView()
    @objc let secondFourChlrPeopleImageView: subclasssedUIImageView = FeedCell.imageView()
    @objc let thirdFourChlrPeopleImageView: subclasssedUIImageView = FeedCell.imageView()
    @objc let moreFourChlrPeopleImageView: subclasssedUIImageView = FeedCell.imageView()
    
    @objc static func imageViewFit() -> UIImageView {
        let imageView = UIImageView()
        imageView.autoresizingMask = [.flexibleBottomMargin, .flexibleTopMargin, .flexibleHeight, .flexibleLeftMargin, .flexibleRightMargin, .flexibleWidth]
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 4.0
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
        imageView.isOpaque = true
        imageView.layer.shouldRasterize = true
        imageView.layer.rasterizationScale = UIScreen.main.scale
        return imageView
    }
    
    @objc let subjectImageView: UIImageView = FeedCell.imageViewFit()
    @objc let finishFlag: UIImageView = FeedCell.imageViewFit()
    @objc let timesUpFlag: UIImageView = FeedCell.imageViewFit()
    
    @objc static func viewFunc() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.isOpaque = true
        view.layer.shouldRasterize = true
        view.layer.rasterizationScale = UIScreen.main.scale
        return view
    }
    
    @objc let middleView: UIView = FeedCell.viewFunc()
    @objc let peopleView: UIView = FeedCell.viewFunc()
    @objc let chlrPeopleView: UIView = FeedCell.viewFunc()
    @objc let view: UIView = FeedCell.viewFunc()
    @objc let proofedVideoView: PlayerView = PlayerView()
    
    @objc static func segmentedControl() -> UISegmentedControl {
        let myArray : NSArray = ["", ""]
        let mySegControl : UISegmentedControl = UISegmentedControl(items: myArray as [AnyObject])
        mySegControl.backgroundColor = UIColor.white
        mySegControl.layer.cornerRadius = 5.0
        mySegControl.tintColor = UIColor.black
        // mySegControl.setBackgroundImage(UIImage(named: "hand"), for: UIControlState(), barMetrics: UIBarMetrics.default)
        mySegControl.layer.shouldRasterize = true
        mySegControl.layer.rasterizationScale = UIScreen.main.scale
        return mySegControl
    }
    
    @objc let mySegControl: UISegmentedControl = FeedCell.segmentedControl()
    
    /*@objc lazy var avPlayerLayer: AVPlayerLayer = {
        return AVPlayerLayer()
    }()*/
}

class subclasssedUIButton : UIButton {
    @objc var challengeId: String?
    @objc var type: String?
    @objc var memberId: String?
    @objc var goal: String?
    @objc var homeScore: String?
    @objc var awayScore: String?
    var proofed: Bool?
    var canJoin: Bool?
    var count: Int?
    var index: IndexPath?
}

class subclasssedUILabel : UILabel {
    var index: Int?
}

class subclasssedUIImageView : UIImageView {
    @objc var memberId: String?
    @objc var name: String?
    @objc var fbID: String?
}
