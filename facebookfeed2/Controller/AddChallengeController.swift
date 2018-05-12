//
//  AddChallengeController.swift
//  facebookfeed2
//
//  Created by iakay on 20.02.2018.
//  Copyright © 2018 challenge. All rights reserved.
//

import UIKit

let addViewIndexPath = IndexPath(item: 0, section: 0)
let segControlIndexPath = IndexPath(item: 1, section: 0)
let subjectIndexPath = IndexPath(item: 2, section: 0)
let leftSideIndex = IndexPath(item: 3, section: 0)
let rightSideIndex = IndexPath(item: 4, section: 0)
let deadlineIndexPath = IndexPath(item: 5, section: 0)
let calenddarIndexPath = IndexPath(item: 6, section: 0)
let visibilityIndexPath = IndexPath(item: 7, section: 0)
let doneIndexPath = IndexPath(item: 8, section: 0)
let scoreIndexPath = IndexPath(item: 9, section: 0)
let resultIndexPath = IndexPath(item: 10, section: 0)

class AddChallengeController: UITableViewController {    
    let screenSize = UIScreen.main.bounds
    var tableRowHeightHeight: CGFloat = 44
    var chlViewHeight: CGFloat = 17.5/30
    
    var subjects = [Subject]()
    var self_subjects = [Subject]()
    var friends = [Friends]()
    var leftSide = [SelectedItems]()
    var rightSide = [SelectedItems]()
    var deadLine = Int()
    var bottomConstraint: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Add Challenge"
        tableView.register(TableViewCellContent.self, forCellReuseIdentifier: cellId)
        tableView.tableFooterView = UIView()
        self.view.backgroundColor =  UIColor.rgb(229, green: 231, blue: 235)
        let rightButton = UIBarButtonItem(title: "Add", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.addChallenge))
        navigationItem.rightBarButtonItem = rightButton
        rightButton.tintColor = UIColor.white
        tableView?.showsVerticalScrollIndicator = false
        
        if let path = Bundle.main.path(forResource: "subject", ofType: "json") {
            do {
                let data = try(Data(contentsOf: URL(fileURLWithPath: path), options: NSData.ReadingOptions.mappedIfSafe))
                let jsonDictionary = try(JSONSerialization.jsonObject(with: data, options: .mutableContainers)) as? [String: Any]
                if let postsArray = jsonDictionary?["posts"] as? [[String: AnyObject]] {
                    self.subjects = [Subject]()
                    for postDictionary in postsArray {
                        let subject = Subject()
                        subject.setValuesForKeys(postDictionary)
                        self.subjects.append(subject)
                    }
                }
            } catch let err {
                print(err)
            }
        }
        if let path = Bundle.main.path(forResource: "self_subject", ofType: "json") {
            do {
                let data = try(Data(contentsOf: URL(fileURLWithPath: path), options: NSData.ReadingOptions.mappedIfSafe))
                let jsonDictionary = try(JSONSerialization.jsonObject(with: data, options: .mutableContainers)) as? [String: Any]
                if let postsArray = jsonDictionary?["posts"] as? [[String: AnyObject]] {
                    self.self_subjects = [Subject]()
                    for postDictionary in postsArray {
                        let subject = Subject()
                        subject.setValuesForKeys(postDictionary)
                        self.self_subjects.append(subject)
                    }
                }
            } catch let err {
                print(err)
            }
        }
        if let path = Bundle.main.path(forResource: "friends", ofType: "json") {
            do {
                let data = try(Data(contentsOf: URL(fileURLWithPath: path), options: NSData.ReadingOptions.mappedIfSafe))
                let jsonDictionary = try(JSONSerialization.jsonObject(with: data, options: .mutableContainers)) as? [String: Any]
                if let postsArray = jsonDictionary?["posts"] as? [[String: AnyObject]] {
                    self.friends = [Friends]()
                    for postDictionary in postsArray {
                        let friends = Friends()
                        friends.setValuesForKeys(postDictionary)
                        self.friends.append(friends)
                    }
                }
            } catch let err {
                print(err)
            }
        }
        self.hideKeyboardWhenTappedAround()
    }
    
    func addChallenge() {
        let addViewCellContent = tableView.cellForRow(at: addViewIndexPath) as! TableViewCellContent
        let proofContent = tableView.cellForRow(at: visibilityIndexPath) as! TableViewCellContent
        let segControlContent = tableView.cellForRow(at: segControlIndexPath) as! TableViewCellContent
        let selectAlert: UIAlertController = UIAlertController(title: "Alert", message: "\(segControlContent.mySegControl.selectedSegmentIndex) \(addViewCellContent.addChallenge.subjectLabel.text!) \(leftSide) \(rightSide) \(deadLine) \(proofContent.isDone.isOn)", preferredStyle: UIAlertControllerStyle.alert)
        selectAlert.addAction(UIAlertAction(title: "Continue", style: UIAlertActionStyle.default, handler: nil))
        self.present(selectAlert, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let segControlContent = tableView.cellForRow(at: segControlIndexPath) as! TableViewCellContent
        if indexPath == subjectIndexPath {
            let selectionTable = SelectionTableViewController()
            var selItems = [SelectedItems]()
            var subjs = [Subject]()
            if segControlContent.mySegControl.selectedSegmentIndex != 1 {
                subjs = self.subjects
            } else {
                subjs = self.self_subjects
            }
            for subj in subjs {
                let selItem = SelectedItems()
                selItem.name = subj.name
                selItems.append(selItem)
            }
            selectionTable.items = selItems
            selectionTable.tableTitle = "Subjects"
            selectionTable.popIndexPath = indexPath
            selectionTable.segmentIndex = segControlContent.mySegControl.selectedSegmentIndex
            selectionTable.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(selectionTable, animated: true)
        } else if indexPath == leftSideIndex || indexPath == rightSideIndex {
            let selectionTable = SelectionTableViewController()
            var selItems = [SelectedItems]()
            for fri in self.friends {
                let selItem = SelectedItems()
                selItem.name = fri.name
                selItem.id = fri.id
                selItems.append(selItem)
            }
            var selItemsWithoutWorld = [SelectedItems]()
            selItemsWithoutWorld = selItems
            selItemsWithoutWorld.removeLast()
            if segControlContent.mySegControl.selectedSegmentIndex != 0 || indexPath.row == 3 {
                selectionTable.items = selItemsWithoutWorld
            } else {
                selectionTable.items = selItems
            }
            if segControlContent.mySegControl.selectedSegmentIndex != 0 {
                if indexPath == leftSideIndex {
                    selectionTable.otherSideCount = rightSide.count
                } else {
                    selectionTable.otherSideCount = leftSide.count
                }
            } else {
                selectionTable.otherSideCount = -1
            }
            selectionTable.tableTitle = "Friends"
            selectionTable.popIndexPath = indexPath
            selectionTable.segmentIndex = segControlContent.mySegControl.selectedSegmentIndex
            selectionTable.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(selectionTable, animated: true)
        } else if indexPath == deadlineIndexPath {
            let addViewCellContent = tableView.cellForRow(at: addViewIndexPath) as! TableViewCellContent
            if (switchDeadline) {                
                addViewCellContent.addChallenge.untilDateLabel.text = "LAST \(getDayBetweenDates(isSelect: true)) DAYS"
                self.tableView?.scrollToRow(at: resultIndexPath, at: UITableViewScrollPosition.bottom, animated: true)
            } else {
                addViewCellContent.addChallenge.untilDateLabel.text = "Done!"
            }
        } else if indexPath == resultIndexPath {
            let updateProgress = UpdateProgressController()
            updateProgress.result = true
            updateProgress.resultText.becomeFirstResponder()
            updateProgress.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(updateProgress, animated: true)
        } else if indexPath == scoreIndexPath {
            let updateProgress = UpdateProgressController()
            updateProgress.homeScoreText.becomeFirstResponder()
            updateProgress.score = true
            updateProgress.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(updateProgress, animated: true)
            /*
            let alert = UIAlertController(title: "Scores", message: nil, preferredStyle: .alert)
            alert.addTextField {
                (textfield) in
                textfield.placeholder = "Home score..."
                textfield.autocapitalizationType = .allCharacters
            }
            alert.addTextField {
                (textfield) in
                textfield.placeholder = "Away score..."
                textfield.autocapitalizationType = .allCharacters
            }
            alert.addAction(UIAlertAction(title: ok, style: .default, handler: {
                [weak alert] (_) in
                let homeTextField = alert?.textFields![0]
                let awayTextField = alert?.textFields![1]
                let scoreContent = tableView.cellForRow(at: scoreIndexPath) as! TableViewCellContent
                if let homeText = homeTextField?.text, let awayText = awayTextField?.text {
                    scoreContent.labelOtherSide.text = "\(homeText) - \(awayText)"
                }
            }))
            self.present(alert, animated: true, completion: nil)
            */
        }
    }
    
    func getDayBetweenDates(isSelect : Bool) -> Int {
        let cellContent = tableView.cellForRow(at: calenddarIndexPath) as! TableViewCellContent
        let cCellContent = tableView.cellForRow(at: deadlineIndexPath) as! TableViewCellContent
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy HH:mm"
        let formattedDate = formatter.string(from: cellContent.datePicker.date)
        if isSelect {
            cCellContent.labelOtherSide.text = formattedDate
            switchDateP = !switchDateP
            tableView.reloadRows(at: [calenddarIndexPath], with: .fade)
        } else {
            let date = formatter.date(from: cCellContent.labelOtherSide.text!)
            cellContent.datePicker.date = date!
        }
        let daysBetween : Int = Calendar.current.dateComponents([.day], from: Date(), to: cellContent.datePicker.date).day!
        return daysBetween
    }
    
    var switchDateP : Bool = false;
    var switchDeadline : Bool = true;
    var switchProofCell : Bool = false;
    var switchLeftPeopleCell : Bool = false;
    var switchRightPeopleCell : Bool = true;
    var switchDone : Bool = false;
    var switchScore : Bool = false;
    var switchResult : Bool = false;
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath == calenddarIndexPath {
            if switchDateP {
                return 180
            } else {
                return 0
            }
        } else if indexPath == visibilityIndexPath {
            if switchProofCell {
                return tableRowHeightHeight
            } else {
                return 0
            }
        } else if indexPath == leftSideIndex {
            if switchLeftPeopleCell {
                return tableRowHeightHeight
            } else {
                return 0
            }
        } else if indexPath == rightSideIndex {
            if switchRightPeopleCell {
                return tableRowHeightHeight
            } else {
                return 0
            }
        } else if indexPath == scoreIndexPath {
            if switchScore {
                return tableRowHeightHeight
            } else {
                return 0
            }
        } else if indexPath == resultIndexPath {
            if switchResult {
                return tableRowHeightHeight
            } else {
                return 0
            }
        } else if indexPath == deadlineIndexPath {
            if switchDeadline {
                return tableRowHeightHeight
            } else {
                return 0
            }
        } else if indexPath != addViewIndexPath {
            return tableRowHeightHeight
        } else {
            return (screenSize.width * chlViewHeight) + tableRowHeightHeight
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 11
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let frameOfCell : CGRect = CGRect(x: 0, y: 0, width: self.view.frame.width, height: tableRowHeightHeight)
        let cell = TableViewCellContent(frame: frameOfCell, cellRow: indexPath.row)
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        if indexPath == segControlIndexPath {
            cell.label.text = "Type"
            cell.mySegControl.addTarget(self, action: #selector(self.segControlChange), for: UIControlEvents.valueChanged)
        } else if indexPath == subjectIndexPath {
            cell.label.text = "Subject"
            cell.labelOtherSide.text = selectText
        } else if indexPath == leftSideIndex {
            cell.label.text = "Home"
            cell.labelOtherSide.text = selectText
            cell.isHidden = !switchLeftPeopleCell
        } else if indexPath == rightSideIndex {
            cell.label.text = "Away"
            cell.labelOtherSide.text = selectText
            cell.isHidden = !switchRightPeopleCell
        } else if indexPath == deadlineIndexPath {
            cell.label.text = "Deadline"
            let formatter = DateFormatter()
            formatter.dateFormat = "dd-MM-yyyy HH:mm"
            let formattedDate = formatter.string(from: cell.datePicker.date)
            cell.labelOtherSide.text = formattedDate
            cell.isHidden = !switchDeadline
        } else if indexPath == calenddarIndexPath {
            cell.isHidden = !switchDateP
        } else if indexPath == visibilityIndexPath {
            cell.label.text = "Visibility"
            cell.isHidden = !switchProofCell
        } else if indexPath == doneIndexPath {
            cell.label.text = "Done"
            cell.isHidden = !switchDone
            cell.isDone.addTarget(self, action: #selector(self.doneSwitch), for: UIControlEvents.valueChanged)
        } else if indexPath == scoreIndexPath {
            cell.label.text = "Score"
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            cell.isHidden = !switchScore
            cell.labelOtherSide.attributedText = greaterThan
        } else if indexPath == resultIndexPath {
            cell.label.text = "Result"
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            cell.isHidden = !switchResult
            cell.labelOtherSide.attributedText = greaterThan
        }
        return cell
    }
    
    func doneSwitch() {
        let addViewContent = tableView.cellForRow(at: addViewIndexPath) as! TableViewCellContent
        let doneSwitch = tableView.cellForRow(at: doneIndexPath) as! TableViewCellContent
        let segControlContent = tableView.cellForRow(at: segControlIndexPath) as! TableViewCellContent
        if (doneSwitch.isDone.isOn) {
            switchDeadline = false
            addViewContent.addChallenge.untilDateLabel.text = "Done!"
            if segControlContent.mySegControl.selectedSegmentIndex == 1 {
                switchResult = true
            } else if segControlContent.mySegControl.selectedSegmentIndex == 2 {
                switchScore = true
            }
        } else {
            switchDeadline = true
            addViewContent.addChallenge.untilDateLabel.text = "Deadline"
            if segControlContent.mySegControl.selectedSegmentIndex == 1 {
                switchResult = false
            } else if segControlContent.mySegControl.selectedSegmentIndex == 2 {
                switchScore = false
            }
        }
        tableView.reloadRows(at: [deadlineIndexPath], with: .fade)
        tableView.reloadRows(at: [scoreIndexPath], with: .fade)
        tableView.reloadRows(at: [resultIndexPath], with: .fade)
    }
    
    func updateCell(result : [SelectedItems], popIndexPath : IndexPath) {
        let cellContent = tableView.cellForRow(at: popIndexPath) as! TableViewCellContent
        var itemsResult : String = ""
        var itemsCount : Int = 1
        for item in result {
            if itemsCount > 2 {
                itemsResult += " ..."
                break
            }
            itemsResult += item.name + ", "
            itemsCount += 1
        }
        cellContent.labelOtherSide.text = itemsResult.trim()
        let addViewContent = tableView.cellForRow(at: addViewIndexPath) as! TableViewCellContent
        let subjectContent = tableView.cellForRow(at: subjectIndexPath) as! TableViewCellContent
        let segControlContent = tableView.cellForRow(at: segControlIndexPath) as! TableViewCellContent
        if popIndexPath != subjectIndexPath {
            segControlChange(isNotAction : true, popIndexPath : popIndexPath)
        } else {
            addViewContent.addChallenge.subjectLabel.text = subjectContent.labelOtherSide.text
            if segControlContent.mySegControl.selectedSegmentIndex == 1 {
                setImage(name: addViewContent.addChallenge.subjectLabel.text, imageView: addViewContent.addChallenge.firstOnePeopleImageView)
            }
        }
        if popIndexPath == leftSideIndex || popIndexPath == rightSideIndex {
            if popIndexPath == leftSideIndex {
                leftSide = result
                if rightSide.count != leftSide.count {
                    rightSide.removeAll()
                    tableView.reloadRows(at: [rightSideIndex], with: .fade)
                }
            } else if popIndexPath == rightSideIndex {
                rightSide = result
                if rightSide.count != leftSide.count {
                    leftSide.removeAll()
                    tableView.reloadRows(at: [leftSideIndex], with: .fade)
                }
            }
            prepareViewForSelection(result: result, popIndexPath: popIndexPath, reset: false)
        }
    }
    
    func segControlChange(isNotAction : Bool, popIndexPath : IndexPath) {
        let addViewContent = tableView.cellForRow(at: addViewIndexPath) as! TableViewCellContent
        let segControlContent = tableView.cellForRow(at: segControlIndexPath) as! TableViewCellContent
        var selItems = [SelectedItems]()
        let selItem = SelectedItems()
        selItem.name = "unknown"
        selItems.append(selItem)
        addViewContent.addChallenge.firstOnePeopleImageView.contentMode = .scaleAspectFill
        var doneContent : TableViewCellContent!
        if !isNotAction {
            switchProofCell = true
            switchLeftPeopleCell = true
            switchRightPeopleCell = true
            switchDone = true
            switchScore = false
            switchResult = false
            switchDeadline = true
            switchDateP = false
            tableView.reloadRows(at: [calenddarIndexPath], with: .fade)
            doneContent = tableView.cellForRow(at: doneIndexPath) as! TableViewCellContent
            doneContent.isDone.setOn(false, animated: false)
            if segControlContent.mySegControl.selectedSegmentIndex == 0 {
                switchProofCell = false
                switchLeftPeopleCell = false
                switchDone = false
                switchScore = false
                switchResult = false
            } else if segControlContent.mySegControl.selectedSegmentIndex == 1 {
                switchLeftPeopleCell = false
                switchRightPeopleCell = false
                if (doneContent.isDone.isOn) {
                    switchResult = true
                    switchDeadline = false
                }
            } else if segControlContent.mySegControl.selectedSegmentIndex == 2 {
                if (doneContent.isDone.isOn) {
                    switchScore = true
                    switchDeadline = false
                }
            }
            prepareViewForSelection(result: selItems, popIndexPath: popIndexPath, reset: true)
            tableView.reloadRows(at: [addViewIndexPath], with: .fade)
            tableView.reloadRows(at: [subjectIndexPath], with: .fade)
            tableView.reloadRows(at: [leftSideIndex], with: .fade)
            tableView.reloadRows(at: [rightSideIndex], with: .fade)
            tableView.reloadRows(at: [deadlineIndexPath], with: .fade)
            tableView.reloadRows(at: [visibilityIndexPath], with: .fade)
            tableView.reloadRows(at: [doneIndexPath], with: .fade)
            tableView.reloadRows(at: [scoreIndexPath], with: .fade)
            tableView.reloadRows(at: [resultIndexPath], with: .fade)
            leftSide.removeAll()
            rightSide.removeAll()
            if segControlContent.mySegControl.selectedSegmentIndex == 1 {
                let visibilityContent = tableView.cellForRow(at: visibilityIndexPath) as! TableViewCellContent
                visibilityContent.visibilitySegControl.insertSegment(withTitle: justMe, at: 0, animated: true)
            }
        } else if popIndexPath == leftSideIndex || popIndexPath == rightSideIndex || (popIndexPath == subjectIndexPath && segControlContent.mySegControl.selectedSegmentIndex == 1) {
            tableView.reloadRows(at: [addViewIndexPath], with: .fade)
        }
    }
    
    func prepareViewForSelection(result : [SelectedItems], popIndexPath : IndexPath, reset : Bool) {
        let segControlContent = tableView.cellForRow(at: segControlIndexPath) as! TableViewCellContent
        let isLeftSide = popIndexPath == leftSideIndex
        let isRightSide = popIndexPath == rightSideIndex        
        if segControlContent.mySegControl.selectedSegmentIndex == 0 {
            if reset {
                setChlrPeopleImages(result : result, reset: !reset)
            }
            setPeopleImages(result : result, reset: false)
        } else if segControlContent.mySegControl.selectedSegmentIndex == 1 || segControlContent.mySegControl.selectedSegmentIndex == 2 {
            if isLeftSide {
                setChlrPeopleImages(result : result, reset: false)
                if rightSide.count != leftSide.count {
                    setPeopleImages(result : result, reset: true)
                } else {
                    setPeopleImages(result : rightSide, reset: false)
                }
            }
            if isRightSide {
                setPeopleImages(result : result, reset: false)
                if rightSide.count != leftSide.count {
                    setChlrPeopleImages(result : result, reset: true)
                } else {
                    setChlrPeopleImages(result : leftSide, reset: false)
                }
            }
        }
    }
    
    func setPeopleImages(result : [SelectedItems], reset : Bool) {
        let addViewContent = tableView.cellForRow(at: addViewIndexPath) as! TableViewCellContent
        let subjectContent = tableView.cellForRow(at: subjectIndexPath) as! TableViewCellContent
        addViewContent.addChallenge.subjectLabel.text = subjectContent.labelOtherSide.text
        if (switchDeadline) {
            addViewContent.addChallenge.untilDateLabel.text = "LAST \(getDayBetweenDates(isSelect: false)) DAYS"
        } else {
            addViewContent.addChallenge.untilDateLabel.text = "Done!"
        }
        addViewContent.addChallenge.generateSecondTeam(count: result.count)
        if result.count == 1 {
            setImage(fbID: result[0].id, imageView: addViewContent.addChallenge.firstOnePeopleImageView, reset: reset)
            if result[0].name == "To World" {
                setImage(name: result[0].id, imageView: addViewContent.addChallenge.firstOnePeopleImageView)
                addViewContent.addChallenge.firstOnePeopleImageView.contentMode = .scaleAspectFit
            }
        } else if result.count == 2 {
            setImage(fbID: result[0].id, imageView: addViewContent.addChallenge.firstTwoPeopleImageView, reset: reset)
            setImage(fbID: result[1].id, imageView: addViewContent.addChallenge.secondTwoPeopleImageView, reset: reset)
        } else if result.count == 3 {
            setImage(fbID: result[0].id, imageView: addViewContent.addChallenge.firstThreePeopleImageView, reset: reset)
            setImage(fbID: result[1].id, imageView: addViewContent.addChallenge.secondThreePeopleImageView, reset: reset)
            setImage(fbID: result[2].id, imageView: addViewContent.addChallenge.thirdThreePeopleImageView, reset: reset)
        } else {
            setImage(fbID: result[0].id, imageView: addViewContent.addChallenge.firstFourPeopleImageView, reset: reset)
            setImage(fbID: result[1].id, imageView: addViewContent.addChallenge.secondFourPeopleImageView, reset: reset)
            setImage(fbID: result[2].id, imageView: addViewContent.addChallenge.thirdFourPeopleImageView, reset: reset)
            setImage(name: "more_icon", imageView: addViewContent.addChallenge.moreFourPeopleImageView)
        }
    }
    
    func setChlrPeopleImages(result : [SelectedItems], reset : Bool) {
        let addViewIndexPath = IndexPath(item: 0, section: 0)
        let addViewContent = tableView.cellForRow(at: addViewIndexPath) as! TableViewCellContent
        addViewContent.addChallenge.generateFirstTeam(count: result.count)
        if result.count == 1 {
            setImage(fbID: result[0].id, imageView: addViewContent.addChallenge.firstOneChlrPeopleImageView, reset: reset)
        } else if result.count == 2 {
            setImage(fbID: result[0].id, imageView: addViewContent.addChallenge.firstTwoChlrPeopleImageView, reset: reset)
            setImage(fbID: result[1].id, imageView: addViewContent.addChallenge.secondTwoChlrPeopleImageView, reset: reset)
        } else if result.count == 3 {
            setImage(fbID: result[0].id, imageView: addViewContent.addChallenge.firstThreeChlrPeopleImageView, reset: reset)
            setImage(fbID: result[1].id, imageView: addViewContent.addChallenge.secondThreeChlrPeopleImageView, reset: reset)
            setImage(fbID: result[2].id, imageView: addViewContent.addChallenge.thirdThreeChlrPeopleImageView, reset: reset)
        } else {
            setImage(fbID: result[0].id, imageView: addViewContent.addChallenge.firstFourChlrPeopleImageView, reset: reset)
            setImage(fbID: result[1].id, imageView: addViewContent.addChallenge.secondFourChlrPeopleImageView, reset: reset)
            setImage(fbID: result[2].id, imageView: addViewContent.addChallenge.thirdFourChlrPeopleImageView, reset: reset)
            setImage(name: "more_icon", imageView: addViewContent.addChallenge.moreFourChlrPeopleImageView)
        }
    }
}
