//
//  SelectionTableViewController.swift
//  facebookfeed2
//
//  Created by iakay on 27.03.2018.
//  Copyright © 2018 challenge. All rights reserved.
//

import UIKit

class SelectionTableViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    let screenSize = UIScreen.main.bounds
    var items = [SelectedItems]()
    var tableTitle : String!
    var tableView : UITableView!
    var popIndexPath : IndexPath!
    var otherSideCount : Int!
    var segmentIndex : Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height), style: UITableViewStyle.plain)
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "LabelCell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        tableView.tableFooterView = UIView()
        self.view.addSubview(tableView)
        navigationItem.title = tableTitle
        if popIndexPath.row == 3 || popIndexPath.row == 4 {
            tableView.allowsMultipleSelection = true
            navigationItem.rightBarButtonItem = self.editButtonItem
            let rightButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(self.showEditing))
            rightButton.tintColor = UIColor.white
            navigationItem.rightBarButtonItem = rightButton
        }
    }
    
    func showEditing() {
        if let controller = navigationController?.viewController(class: AddChallengeController.self) {
            if tableView.indexPathsForSelectedRows == nil {
                let selectAlert: UIAlertController = UIAlertController(title: "Alert", message: "You have to select at least one person!", preferredStyle: UIAlertControllerStyle.alert)
                selectAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(selectAlert, animated: true, completion: nil)
                return
            }
            let indexPath : [IndexPath] = tableView.indexPathsForSelectedRows!
            var selItems = [SelectedItems]()
            for index in indexPath {
                let selItem = SelectedItems()
                selItem.name = items[index.row].name
                selItem.id = items[index.row].id
                selItems.append(selItem)
            }
            if otherSideCount != -1 && otherSideCount != 0 && selItems.count != otherSideCount {
                let selectAlert: UIAlertController = UIAlertController(title: "Alert", message: "You select \(otherSideCount) people at the other side, you have to select same count. So if you you choose different count, you have to select again at the other side.", preferredStyle: UIAlertControllerStyle.alert)
                selectAlert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
                selectAlert.addAction(UIAlertAction(title: "Continue", style: UIAlertActionStyle.default, handler: {
                    action in
                        controller.updateCell(result: selItems, popIndexPath: self.popIndexPath)
                        self.navigationController?.popViewController(animated: true)
                }))
                self.present(selectAlert, animated: true, completion: nil)
                return
            }
            controller.updateCell(result: selItems, popIndexPath: popIndexPath)
        }
        navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if popIndexPath.row == 2 {
            if (indexPath.row == (items.count + 1)) {
                let updateProgress = UpdateProgressController()
                updateProgress.customeSubjectText.becomeFirstResponder()
                updateProgress.customSubject = true
                updateProgress.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(updateProgress, animated: true)
            } else if (indexPath.row == items.count) {
                // nothing
            } else {
                updateAndPopViewController(subjectName: items[indexPath.row].name)
            }
        }
    }
    
    func updateAndPopViewController(subjectName : String) {
        if let controller = navigationController?.viewController(class: AddChallengeController.self) {
            var selItems = [SelectedItems]()
            let selItem = SelectedItems()
            selItem.name = subjectName
            selItems.append(selItem)
            controller.updateCell(result: selItems, popIndexPath: popIndexPath)
        }
        navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if ((popIndexPath.row == 3 || popIndexPath.row == 4) || (popIndexPath.row == 2 && segmentIndex == 1)) {
            return items.count
        } else {
            return items.count + 2
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath as IndexPath)
        if ((popIndexPath.row == 3 || popIndexPath.row == 4) || (popIndexPath.row == 2 && segmentIndex == 1)) {
            cell.textLabel?.text = items[indexPath.row].name
        } else {
            if (indexPath.row == (items.count + 1)) {
                cell.textLabel?.text = customSubjectLabel
            } else if (indexPath.row == items.count) {
                cell.backgroundColor = pagesBackColor
                cell.selectionStyle = UITableViewCellSelectionStyle.none
            } else {
                cell.textLabel?.text = items[indexPath.row].name
            }
        }
        return cell
    }
}
