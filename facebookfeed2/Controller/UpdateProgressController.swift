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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Update Progress"
        self.view.backgroundColor = UIColor.white
        if result {
            view.addSubview(resultText)
            resultText.frame = CGRect(x: 0, y: screenWidth * 1.2 / 5, width: view.frame.width, height: globalHeight)
        } else if score {
            view.addSubview(homeScoreText)
            homeScoreText.frame = CGRect(x: 0, y: screenWidth * 1.2 / 5, width: view.frame.width, height: globalHeight)
            homeScoreText.placeholder = " Home Score..."
            
            view.addSubview(awayScoreText)
            awayScoreText.frame = CGRect(x: 0, y: (screenWidth * 1.2 / 5) + globalHeight + 5, width: view.frame.width, height: globalHeight)
            awayScoreText.placeholder = " Away Score..."
        }
        navigationItem.rightBarButtonItem = self.editButtonItem
        let rightButton = UIBarButtonItem(title: "Save", style: UIBarButtonItemStyle.done, target: self, action: #selector(self.done))
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
            controller.updateScoreAndResult()
        }
        navigationController?.popViewController(animated: true)
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
}
