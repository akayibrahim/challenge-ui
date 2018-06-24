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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Update Progress"
        self.view.backgroundColor = UIColor.white
        let constraintOfY = screenWidth * 1.2 / 5
        let constraintOfYForSecondText = (screenWidth * 1.2 / 5) + globalHeight + 5
        if result {
            navigationItem.title = "Reult"
            view.addSubview(resultText)
            resultText.frame = CGRect(x: 0, y: constraintOfY, width: view.frame.width, height: globalHeight)
        } else if score {
            navigationItem.title = "Scores"
            view.addSubview(homeScoreText)
            homeScoreText.frame = CGRect(x: 0, y: constraintOfY, width: view.frame.width, height: globalHeight)
            homeScoreText.placeholder = " Enter home score..."
            
            view.addSubview(awayScoreText)
            awayScoreText.frame = CGRect(x: 0, y: constraintOfYForSecondText, width: view.frame.width, height: globalHeight)
            awayScoreText.placeholder = " Enter away score..."
        } else if updateProgress {
            if challengeType == SELF {
                view.addSubview(isDone)
                view.addSubview(resultText)
                resultText.frame = CGRect(x: 0, y: constraintOfY, width: view.frame.width, height: globalHeight)
                
                isDone.frame = CGRect(x: 0, y: constraintOfY + (screenWidth * 0.8 / 5), width: view.frame.width / 5, height: globalHeight)
            } else if challengeType == PRIVATE {
                view.addSubview(homeScoreText)
                homeScoreText.frame = CGRect(x: 0, y: constraintOfY, width: view.frame.width, height: globalHeight)
                homeScoreText.placeholder = " Enter home score..."
                
                view.addSubview(awayScoreText)
                awayScoreText.frame = CGRect(x: 0, y: constraintOfYForSecondText, width: view.frame.width, height: globalHeight)
                awayScoreText.placeholder = " Enter away score..."
                
                // isDone.frame = CGRect(x: 0, y: constraintOfYForSecondText + (screenWidth * 0.8 / 5), width: view.frame.width / 5, height: globalHeight)
            }
        }
        navigationItem.rightBarButtonItem = self.editButtonItem
        let rightButton = UIBarButtonItem(title: "Save", style: UIBarButtonItemStyle.done, target: self, action: #selector(self.done))
        rightButton.tintColor = UIColor.white
        navigationItem.rightBarButtonItem = rightButton
        
        self.hideKeyboardWhenTappedAround()
    }
    
    func done() {
        if updateProgress {
            var url : String?
            if challengeType == SELF {
                url = updateProgressOrDoneForSelfURL  + "?challengeId=" + challengeId! + "&result=" + resultText.text! + "&done=" + (isDone.isOn ? "true" : "false")
            } else if challengeType == PRIVATE {
                url = updateResultsOfVersusURL  + "?challengeId=" + challengeId! + "&firstTeamScore=" + homeScoreText.text! + "&secondTeamScore=" + awayScoreText.text!
            }
            updateProgres(url: url!)
        }
        if let controller = navigationController?.viewController(class: AddChallengeController.self) {
            let addViewContent = controller.tableView.cellForRow(at: addViewIndexPath) as! TableViewCellContent
            if result {
                let resultContent = controller.tableView.cellForRow(at: resultIndexPath) as! TableViewCellContent
                resultContent.labelOtherSide.text = resultText.text
                addViewContent.addChallenge.score.text = "\(resultText.text!)"
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
    
    let resultText: UITextField = UpdateProgressController.textField()
    let homeScoreText: UITextField = UpdateProgressController.textField()
    let awayScoreText: UITextField = UpdateProgressController.textField()
    
    static func textField() -> UITextField {
        let textField = UITextField()
        textField.placeholder = " Enter result..."
        textField.layer.borderColor = UIColor (red:204.0/255.0, green:204.0/255.0, blue:204.0/255.0, alpha:1.0).cgColor;
        textField.layer.borderWidth = 1.0;
        textField.layer.cornerRadius = 5.0;
        textField.layer.backgroundColor = UIColor.white.cgColor
        return textField
    }
    
    var isDone: UISwitch = UISwitch(frame:CGRect(x: 150, y: 300, width: 0, height: 0))
}
