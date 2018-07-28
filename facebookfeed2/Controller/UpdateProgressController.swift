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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Update Progress"
        self.view.backgroundColor = pagesBackColor
        let constraintOfY = screenWidth * 2.5 / 5
        // let constraintOfYForSecondText = (screenWidth * 1.2 / 5) + globalHeight + 5
        
        view.addSubview(homeScoreLabel)
        homeScoreLabel.frame = CGRect(x: 0 + 10, y: screenWidth * 2 / 5, width: view.frame.width / 3, height: globalHeight)
        homeScoreLabel.textColor = navAndTabColor
        
        view.addSubview(homeScoreText)
        homeScoreText.frame = CGRect(x: 0 + 10, y: constraintOfY, width: view.frame.width / 3, height: globalHeight)
        homeScoreText.placeholder = "Enter"
        awayScoreText.placeholder = "Enter"
        
        view.addSubview(awayScoreLabel)
        awayScoreLabel.frame = CGRect(x: (view.frame.width * 2 / 3) - 10, y: screenWidth * 2 / 5, width: view.frame.width / 3, height: globalHeight)
        awayScoreLabel.textColor = navAndTabColor
        
        view.addSubview(awayScoreText)
        awayScoreText.frame = CGRect(x: (view.frame.width * 2 / 3) - 10, y: constraintOfY, width: view.frame.width / 3, height: globalHeight)
        
        vsImageView.image = UIImage(named: "vs")
        view.addSubview(vsImageView)
        vsImageView.frame = CGRect(x: (view.frame.width * 1.2 / 3) - 10, y: screenWidth * 2.3 / 5, width: view.frame.width * 0.8 / 3,
                                   height: screenWidth * 1 / 6)
        
        if updateProgress {
            view.addSubview(backView)
            backView.backgroundColor = UIColor.white
            backView.frame = CGRect(x: 0, y: screenWidth * 3.5 / 5, width: view.frame.width, height: globalHeight)
            
            view.addSubview(doneLabel)
            doneLabel.frame = CGRect(x: (view.frame.width * 1.9 / 3) - 10, y: screenWidth * 3.5 / 5, width: view.frame.width / 5, height: globalHeight)
            doneLabel.textColor = navAndTabColor
            doneLabel.text = "Finish"
            
            view.addSubview(isDone)
            isDone.backgroundColor = UIColor.white
            isDone.frame = CGRect(x: (view.frame.width * 2.5 / 3) - 10, y: screenWidth * 3.6 / 5, width: view.frame.width / 5, height: globalHeight)
            
            if challengeType == SELF {
                homeScoreLabel.text = "Result"
                awayScoreLabel.text = "Goal"
                awayScoreText.isEnabled = false
                awayScoreText.text = goal
            } else if challengeType == PRIVATE {
                homeScoreLabel.text = "Home"
                awayScoreLabel.text = "Away"
                awayScoreText.text = awayScore
            }
            homeScoreText.text = homeScore
        } else {
            if result {
                navigationItem.title = "Result"
                homeScoreLabel.text = "Result"
                homeScoreText.text = "?"
                homeScoreText.isEnabled = doneSwitch ? true : false
                awayScoreLabel.text = "Goal"
            } else if score {
                navigationItem.title = "Scores"
                homeScoreLabel.text = "Home"
                awayScoreLabel.text = "Away"
            }
        }
        navigationItem.rightBarButtonItem = self.editButtonItem
        let rightButton = UIBarButtonItem(title: "Save", style: UIBarButtonItemStyle.done, target: self, action: #selector(self.done))
        rightButton.tintColor = UIColor.white
        navigationItem.rightBarButtonItem = rightButton
        
        self.hideKeyboardWhenTappedAround()
        homeScoreText.keyboardType = .numberPad
        awayScoreText.keyboardType = .numberPad
    }
    
    func done() {
        if updateProgress {
            var url : String?
            if challengeType == SELF {
                if isDone.isOn && homeScoreText.text == "" {
                    self.popupAlert(message: "Score is mandotory!", willDelay: false)
                    return
                }
                url = updateProgressOrDoneForSelfURL  + "?challengeId=" + challengeId! + "&result=" + homeScoreText.text! + "&done=" + (isDone.isOn ? "true" : "false")
            } else if challengeType == PRIVATE {
                if isDone.isOn && homeScoreText.text == "" {
                    self.popupAlert(message: "Home score is mandotory!", willDelay: false)
                    return
                }
                if isDone.isOn && awayScoreText.text == "" {
                    self.popupAlert(message: "Away score is mandotory!", willDelay: false)
                    return
                }
                url = updateResultsOfVersusURL  + "?challengeId=" + challengeId! + "&firstTeamScore=" + homeScoreText.text! + "&secondTeamScore=" + awayScoreText.text! + "&done=" + (isDone.isOn ? "true" : "false")
            }
            updateProgres(url: url!)
        }
        if let controller = navigationController?.viewController(class: AddChallengeController.self) {
            let addViewContent = controller.tableView.cellForRow(at: addViewIndexPath) as! TableViewCellContent
            if result {
                let resultContent = controller.tableView.cellForRow(at: resultIndexPath) as! TableViewCellContent
                resultContent.labelOtherSide.text = "\(homeScoreText.text!) - \(awayScoreText.text!)"                
                addViewContent.addChallenge.score.text = "\(homeScoreText.text!)"
                controller.updateScoreAndResult(indexPath: resultIndexPath)
            } else if score {
                let scoreContent = controller.tableView.cellForRow(at: scoreIndexPath) as! TableViewCellContent
                scoreContent.labelOtherSide.text = "\(homeScoreText.text!) - \(awayScoreText.text!)"
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
    
    let vsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.semanticContentAttribute = .forceRightToLeft
        return imageView
    }()
    
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
        return textView.text.count + (text.count - range.length) <= 5
    }
}
