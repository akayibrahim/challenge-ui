//
//  SelectionTableViewController.swift
//  facebookfeed2
//
//  Created by iakay on 27.03.2018.
//  Copyright © 2018 challenge. All rights reserved.
//

import UIKit

class UpdateProgressController : UIViewController {
    var result : Bool = false
    var score : Bool = false
    var updateProgress : Bool = false
    var challengeId : String?
    var challengeType : String?
    var goal: String?
    var homeScore: String?
    var awayScore: String?
    var doneSwitch: Bool = false
    var checkedImg = UIImage(named: "checked")
    var unCheckedImg = UIImage(named: "unchecked")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Update Progress"
        self.view.backgroundColor = pagesBackColor
        let constraintOfY = screenHeight * 1.6 / 5
        // let constraintOfYForSecondText = (screenWidth * 1.2 / 5) + globalHeight + 5
        
        homeWin.image = unCheckedImg
        view.addSubview(homeWin)
        homeWin.frame = CGRect(x: challengeType == SELF || result ? (view.frame.width * 1.2 / 3) - 10 : 0 + 10, y: screenHeight * 0.8 / 5,
                               width: challengeType == SELF || result ? view.frame.width * 0.8 / 3 : view.frame.width / 3, height: screenWidth * 1 / 6)
        
        awayWin.image = unCheckedImg
        view.addSubview(awayWin)
        awayWin.frame = CGRect(x: (view.frame.width * 2 / 3) - 10, y: screenHeight * 0.8 / 5, width: view.frame.width / 3, height: screenWidth * 1 / 6)
        
        if doneSwitch || updateProgress {
            let tapGestureRecognizerHome = UITapGestureRecognizer(target: self, action: #selector(homeWinIt(tapGestureRecognizer:)))
            homeWin.isUserInteractionEnabled = true
            homeWin.addGestureRecognizer(tapGestureRecognizerHome)
            
            
            let tapGestureRecognizerAway = UITapGestureRecognizer(target: self, action: #selector(awayWinIt(tapGestureRecognizer:)))
            awayWin.isUserInteractionEnabled = true
            awayWin.addGestureRecognizer(tapGestureRecognizerAway)
        }
        view.addSubview(homeScoreLabel)
        homeScoreLabel.frame = CGRect(x: 0 + 10, y: screenHeight * 1.3 / 5, width: view.frame.width / 3, height: globalHeight)
        homeScoreLabel.textColor = navAndTabColor
        
        view.addSubview(homeScoreText)
        homeScoreText.frame = CGRect(x: 0 + 10, y: constraintOfY, width: view.frame.width / 3, height: globalHeight)
        homeScoreText.placeholder = "Enter"
        awayScoreText.placeholder = "Enter"
        
        view.addSubview(awayScoreLabel)
        awayScoreLabel.frame = CGRect(x: (view.frame.width * 2 / 3) - 10, y: screenHeight * 1.3 / 5, width: view.frame.width / 3, height: globalHeight)
        awayScoreLabel.textColor = navAndTabColor
        
        view.addSubview(awayScoreText)
        awayScoreText.frame = CGRect(x: (view.frame.width * 2 / 3) - 10, y: constraintOfY, width: view.frame.width / 3, height: globalHeight)
        
        vsImageView.image = UIImage(named: "vs")
        view.addSubview(vsImageView)
        vsImageView.frame = CGRect(x: (view.frame.width * 1.2 / 3) - 10, y: screenHeight * 0.8 / 5, width: view.frame.width * 0.8 / 3,
                                   height: screenWidth * 1 / 6)
        
        view.addSubview(optionalLabel)
        optionalLabel.frame = CGRect(x: (view.frame.width * 1.2 / 3) - 10, y: screenHeight * 1.45 / 5, width: view.frame.width * 0.8 / 3, height: globalHeight)
        optionalLabel.textColor = navAndTabColor
        optionalLabel.text = "(Optional)"
        
        view.addSubview(middleLabel)
        middleLabel.frame = CGRect(x: (view.frame.width * 1.2 / 3) - 10, y: constraintOfY, width: view.frame.width * 0.8 / 3, height: globalHeight)
        middleLabel.textColor = navAndTabColor
        middleLabel.text = "-"
        
        if updateProgress {
            /*
            view.addSubview(backView)
            backView.backgroundColor = UIColor.white
            backView.frame = CGRect(x: 0, y: screenWidth * 4.5 / 5, width: view.frame.width, height: globalHeight)
            
            view.addSubview(doneLabel)
            doneLabel.frame = CGRect(x: (view.frame.width * 1.9 / 3) - 10, y: screenWidth * 4.5 / 5, width: view.frame.width / 5, height: globalHeight)
            doneLabel.textColor = navAndTabColor
            doneLabel.text = "Finish"
            
            view.addSubview(isDone)
            isDone.backgroundColor = UIColor.white
            isDone.frame = CGRect(x: (view.frame.width * 2.5 / 3) - 10, y: screenWidth * 4.6 / 5, width: view.frame.width / 5, height: globalHeight)
            */
            if challengeType == SELF {
                homeScoreLabel.text = "Result"
                awayScoreLabel.text = "Goal"                
                awayScoreText.text = goal
                vsImageView.alpha = 0
                awayWin.alpha = 0
                middleLabel.text = "of"
                view.addSubview(succeedLabel)
                succeedLabel.frame = CGRect(x: (view.frame.width * 1.2 / 3) - 10, y: screenHeight * 0.6 / 5, width: view.frame.width * 0.8 / 3, height: globalHeight)
                succeedLabel.textColor = navAndTabColor
                succeedLabel.text = "Succeed?"
            } else if challengeType == PRIVATE {
                homeScoreLabel.text = "Home"
                awayScoreLabel.text = "Away"
                awayScoreText.text = awayScore != "-1" ? awayScore : ""
            }
            homeScoreText.text = homeScore != "-1" ? homeScore : ""
        } else {
            if result {
                navigationItem.title = "Result"
                homeScoreLabel.text = "Result"
                homeScoreText.text = doneSwitch ? "" : "-"
                homeScoreText.isEnabled = doneSwitch ? true : false
                homeScoreText.alpha = !doneSwitch ? 0.3 : 1
                awayScoreLabel.text = "Goal"
                vsImageView.alpha = 0
                awayWin.alpha = 0
                middleLabel.text = "of"
                view.addSubview(succeedLabel)
                succeedLabel.frame = CGRect(x: (view.frame.width * 1.2 / 3) - 10, y: screenHeight * 0.6 / 5, width: view.frame.width * 0.8 / 3, height: globalHeight)
                succeedLabel.textColor = navAndTabColor
                succeedLabel.text = "Succeed?"
                succeedLabel.alpha = !doneSwitch ? 0.3 : 1
                homeWin.alpha = !doneSwitch ? 0.3 : 1
            } else if score {
                navigationItem.title = "Scores"
                homeScoreLabel.text = "Home"
                awayScoreLabel.text = "Away"
            }
        }
        navigationItem.rightBarButtonItem = self.editButtonItem
        rightButton = UIBarButtonItem(title: "Save", style: UIBarButtonItemStyle.done, target: self, action: #selector(self.done))
        rightButtonFinished = UIBarButtonItem(title: "Finish", style: UIBarButtonItemStyle.done, target: self, action: #selector(self.finish))
        rightButton.tintColor = UIColor.white
        rightButtonFinished.tintColor = UIColor.white
        navigationItem.rightBarButtonItem = rightButton
        
        self.hideKeyboardWhenTappedAround()
        homeScoreText.keyboardType = .numberPad
        awayScoreText.keyboardType = .numberPad
    }
    
    var rightButton: UIBarButtonItem!
    var rightButtonFinished: UIBarButtonItem!
    
    func homeWinIt(tapGestureRecognizer: UITapGestureRecognizer) {
        if awayWin.image == checkedImg {
           awayWin.image = unCheckedImg
        }
        if homeWin.image == checkedImg {
            homeWin.image = unCheckedImg
            if updateProgress {
                navigationItem.rightBarButtonItem = rightButton
            }
        } else {
            homeWin.image = checkedImg
            if updateProgress {
                navigationItem.rightBarButtonItem = rightButtonFinished
            }
        }
    }
    
    func awayWinIt(tapGestureRecognizer: UITapGestureRecognizer) {
        if homeWin.image == checkedImg {
            homeWin.image = unCheckedImg
        }
        if awayWin.image == checkedImg {
            awayWin.image = unCheckedImg
            if updateProgress {
                navigationItem.rightBarButtonItem = rightButton
            }
        } else {
            awayWin.image = checkedImg
            if updateProgress {
                navigationItem.rightBarButtonItem = rightButtonFinished
            }
        }
    }
    
    func finish() {
        done(done: true)
    }
    
    func isWin(_ img: UIImageView) -> Bool {
        return img.image == checkedImg ? true : false
    }
    
    func done(done: Bool) {
        if updateProgress {
            var url : String?
            let firstTeamScore: Int = homeScoreText.text != "" ? Int(homeScoreText.text!)! : -1
            let secondTeamScore: Int = awayScoreText.text != "" ? Int(awayScoreText.text!)! : -1
            if challengeType == SELF {
                if done && !isWin(homeWin) {
                    self.popupAlert(message: "Succeed?", willDelay: false)
                    return
                }
                if secondTeamScore != secondTeamScore && isWin(homeWin) {
                    self.popupAlert(message: "Result and succeed is incompatible!", willDelay: false)
                    return
                }
                url = updateProgressOrDoneForSelfURL  + "?challengeId=\(challengeId!)&homeWin=\(isWin(homeWin))&result=\(firstTeamScore)&goal=\(secondTeamScore)&done=\(isWin(homeWin))"
            } else if challengeType == PRIVATE {
                if done && (!isWin(homeWin) && !isWin(awayWin)) {
                    self.popupAlert(message: "Select winner?", willDelay: false)
                    return
                }
                if (firstTeamScore > secondTeamScore && !isWin(homeWin) && isWin(awayWin)) ||
                    (firstTeamScore < secondTeamScore && isWin(homeWin) && !isWin(awayWin)) {
                    self.popupAlert(message: "Score and winner is incompatible!", willDelay: false)
                    return
                }
                url = updateResultsOfVersusURL  + "?challengeId=\(challengeId!)&homeWin=\(isWin(homeWin))&awayWin=\(isWin(awayWin))&firstTeamScore=\(firstTeamScore)&secondTeamScore=\(secondTeamScore)&done=\((isWin(homeWin) || isWin(awayWin) ? "true" : "false"))"
            }
            updateProgres(url: url!)
        }
        if let controller = navigationController?.viewController(class: AddChallengeController.self) {
            let addViewContent = controller.tableView.cellForRow(at: addViewIndexPath) as! TableViewCellContent
            if result {
                let resultContent = controller.tableView.cellForRow(at: resultIndexPath) as! TableViewCellContent
                resultContent.firstTeamScore = homeScoreText.text != "" ? Int(homeScoreText.text!) : -1
                resultContent.secondTeamScore = awayScoreText.text != "" ? Int(awayScoreText.text!) : -1
                if resultContent.firstTeamScore == resultContent.secondTeamScore {
                    homeWin.image = checkedImg
                }
                if doneSwitch {
                    resultContent.homeWin = homeWin.image == checkedImg ? true : false
                    navigationItem.rightBarButtonItem = rightButtonFinished
                }
                if doneSwitch && resultContent.firstTeamScore != nil && resultContent.secondTeamScore != nil {
                    if resultContent.firstTeamScore != resultContent.secondTeamScore && resultContent.homeWin {
                        self.popupAlert(message: "Result and succeed is incompatible!", willDelay: false)
                        return
                    }
                }
                if doneSwitch {
                    if homeScoreText.text != "" || awayScoreText.text != "" {
                        resultContent.labelOtherSide.text = "\(resultContent.homeWin ? "(Succeed)" : "")\(homeScoreText.text!) - \(awayScoreText.text!)"
                    } else {
                        resultContent.labelOtherSide.text = "\(resultContent.homeWin ? "(Succeed)" : "")"
                    }
                } else {
                    resultContent.labelOtherSide.text = "\(awayScoreText.text!)"
                }
                
                addViewContent.addChallenge.score.text = "\(homeScoreText.text!)"
                controller.updateScoreAndResult(indexPath: resultIndexPath)
            } else if score {
                let scoreContent = controller.tableView.cellForRow(at: scoreIndexPath) as! TableViewCellContent
                scoreContent.firstTeamScore = homeScoreText.text != "" ? Int(homeScoreText.text!) : -1
                scoreContent.secondTeamScore = awayScoreText.text != "" ? Int(awayScoreText.text!) : -1
                if doneSwitch {
                    scoreContent.homeWin = homeWin.image == checkedImg ? true : false
                    scoreContent.awayWin = awayWin.image == checkedImg ? true : false
                }
                if scoreContent.firstTeamScore != scoreContent.secondTeamScore && !scoreContent.homeWin && !scoreContent.awayWin {
                    self.popupAlert(message: "Select winner!!", willDelay: false)
                    return
                }
                if scoreContent.firstTeamScore != nil && scoreContent.secondTeamScore != nil {
                    if (scoreContent.firstTeamScore > scoreContent.secondTeamScore && !scoreContent.homeWin && scoreContent.awayWin) ||
                        (scoreContent.firstTeamScore < scoreContent.secondTeamScore && scoreContent.homeWin && !scoreContent.awayWin) {
                        self.popupAlert(message: "Score and winner is incompatible!", willDelay: false)
                        return
                    }
                }
                if scoreContent.firstTeamScore != -1 && scoreContent.secondTeamScore != -1 {
                    scoreContent.labelOtherSide.text = "\(!scoreContent.homeWin && !scoreContent.awayWin && scoreContent.firstTeamScore == scoreContent.secondTeamScore ? "(Draw) " : "")\(scoreContent.homeWin ? "(Winner) " : "")\(homeScoreText.text!) - \(awayScoreText.text!)\(scoreContent.awayWin ? " (Winner)" : "")"
                } else if !scoreContent.homeWin && !scoreContent.awayWin {
                    scoreContent.labelOtherSide.text = "Draw."
                } else {
                    scoreContent.labelOtherSide.text = "\(scoreContent.homeWin ? "Home" : "")\(scoreContent.awayWin ? "Away" : "") is winner."
                }
                addViewContent.addChallenge.score.text = "\(homeScoreText.text!)\(scoreForPrivate)\(awayScoreText.text!)"
                controller.updateScoreAndResult(indexPath: scoreIndexPath)
            }
        }
        navigationController?.popViewController(animated: true)
    }
    
    func updateProgres(url: String) {
        URLSession.shared.dataTask(with: NSURL(string: url)! as URL, completionHandler: { (data, response, error) -> Void in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                print(responseJSON)
                if responseJSON["message"] != nil {
                    self.popupAlert(message: responseJSON["message"] as! String, willDelay: false)
                }
            }
            DispatchQueue.main.async {
                self.popupAlert(message: "Challenge Updated!", willDelay: true)
            }
        }).resume()
    }
    
    let backView: UIView = FeedCell.viewFunc()
    
    static func imageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.semanticContentAttribute = .forceRightToLeft
        return imageView
    }
    
    let vsImageView: UIImageView = UpdateProgressController.imageView()
    let homeWin: UIImageView = UpdateProgressController.imageView()
    let awayWin: UIImageView = UpdateProgressController.imageView()
    
    let homeScoreText: UITextField = UpdateProgressController.textField()
    let awayScoreText: UITextField = UpdateProgressController.textField()
    
    static func label(_ fontSize: CGFloat) -> UILabel {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: fontSize)
        label.textAlignment = .center
        label.textColor = UIColor.darkGray
        return label
    }
    
    let homeScoreLabel: UILabel = FeedCell.label(15)
    let awayScoreLabel: UILabel = FeedCell.label(15)
    let doneLabel: UILabel = FeedCell.label(15)
    let middleLabel: UILabel = FeedCell.label(25)
    let optionalLabel: UILabel = FeedCell.label(10)
    let succeedLabel: UILabel = FeedCell.label(15)
    
    static func textField() -> UITextField {
        let textField = UITextField()
        textField.placeholder = " Enter result..."
        textField.layer.borderColor = UIColor (red:204.0/255.0, green:204.0/255.0, blue:204.0/255.0, alpha:1.0).cgColor;
        textField.layer.borderWidth = 1.0;
        textField.layer.cornerRadius = 5.0;
        textField.layer.backgroundColor = UIColor.white.cgColor
        textField.textAlignment = .center;
        return textField
    }
    
    var isDone: UISwitch = UISwitch(frame:CGRect(x: 150, y: 300, width: 0, height: 0))
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return textView.text.count + (text.count - range.length) <= 3
    }
}
