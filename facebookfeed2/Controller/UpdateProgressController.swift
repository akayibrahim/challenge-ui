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
    var customSubject : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Update Progress"
        self.view.backgroundColor = UIColor.white
        let middleOfScreenWidth = (screenWidth * 2.5 / 5) - (view.frame.width * 1 / 5)
        if result {
            view.addSubview(resultText)
            resultText.frame = CGRect(x: middleOfScreenWidth, y: screenWidth * 1 / 5, width: view.frame.width * 2 / 5, height: globalHeight)
        } else if score {
            view.addSubview(homeScoreText)
            homeScoreText.frame = CGRect(x: middleOfScreenWidth, y: screenWidth * 1 / 5, width: view.frame.width * 2 / 5, height: globalHeight)
            homeScoreText.placeholder = " Home Score..."
            
            view.addSubview(awayScoreText)
            awayScoreText.frame = CGRect(x: middleOfScreenWidth, y: screenWidth * 2 / 5, width: view.frame.width * 2 / 5, height: globalHeight)
            awayScoreText.placeholder = " Away Score..."
        } else if customSubject {
            let customMiddleOfScreenWidth = (screenWidth * 2.5 / 5) - (view.frame.width * 2 / 5)
            navigationItem.title = "Custom Subject"
            view.addSubview(customeSubjectText)
            customeSubjectText.frame = CGRect(x: customMiddleOfScreenWidth, y: screenWidth * 1 / 5, width: view.frame.width * 4 / 5, height: globalHeight)
            customeSubjectText.placeholder = " Enter subject..."
            customeSubjectText.autocapitalizationType = .allCharacters
        }
        navigationItem.rightBarButtonItem = self.editButtonItem
        let rightButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(self.done))
        rightButton.tintColor = UIColor.white
        navigationItem.rightBarButtonItem = rightButton
        
        self.hideKeyboardWhenTappedAround()
    }
    
    func done() {
        if let controller = navigationController?.viewController(class: AddChallengeController.self) {
            if result {
                let resultContent = controller.tableView.cellForRow(at: resultIndexPath) as! TableViewCellContent
                resultContent.labelOtherSide.text = resultText.text
            } else if score {
                let scoreContent = controller.tableView.cellForRow(at: scoreIndexPath) as! TableViewCellContent
                scoreContent.labelOtherSide.text = "\(homeScoreText.text!) - \(awayScoreText.text!)"
            }
        }
        if let controller = navigationController?.viewController(class: SelectionTableViewController.self) {
            if customSubject {
                controller.updateAndPopViewController(subjectName: customeSubjectText.text!)
            }
        }
        navigationController?.popViewController(animated: true)
    }
    
    let customeSubjectText: UITextField = UpdateProgressController.textField()
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
}
