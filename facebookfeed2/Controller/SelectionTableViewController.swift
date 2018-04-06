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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // self.view.backgroundColor = UIColor.lightGray
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
                let selectAlert: UIAlertView = UIAlertView(title: "Alert", message: "You have to select at least one person!",
                                                           delegate: self as? UIAlertViewDelegate, cancelButtonTitle: "Ok")
                selectAlert.show()
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
            controller.updateCell(result: selItems, popIndexPath: popIndexPath)
        }
        navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if popIndexPath.row == 2 {
            if let controller = navigationController?.viewController(class: AddChallengeController.self) {
                var selItems = [SelectedItems]()
                let selItem = SelectedItems()
                selItems.append(selItem)
                selItem.name = items[indexPath.row].name                
                controller.updateCell(result: selItems, popIndexPath: popIndexPath)
            }
            navigationController?.popViewController(animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath as IndexPath)
        cell.textLabel?.text = items[indexPath.row].name
        return cell
    }
}

extension UINavigationController {
    func viewController<T: UIViewController>(class: T.Type) -> T? {
        return viewControllers.filter({$0 is T}).first as? T
    }
}
