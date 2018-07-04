//
//  AddChallengeController.swift
//  facebookfeed2
//
//  Created by iakay on 20.02.2018.
//  Copyright © 2018 challenge. All rights reserved.
//

import UIKit

var chlIndex : Int = 0
var typeIndex : Int = 1
var subjectIndex : Int = 2
var homeIndex : Int = 3
var awayIndex : Int = 4
var deadlineIndex : Int = 5
var calIndex : Int = 6
var visibilityIndex : Int = 7
var doneIndex : Int = 8
var scoreIndex : Int = 9
var resultIndex : Int = 10
var proofIndex : Int = 11
var commentIndex : Int = 12
let addViewIndexPath = IndexPath(item: chlIndex, section: 0)
let segControlIndexPath = IndexPath(item: typeIndex, section: 0)
let subjectIndexPath = IndexPath(item: subjectIndex, section: 0)
let leftSideIndex = IndexPath(item: homeIndex, section: 0)
let rightSideIndex = IndexPath(item: awayIndex, section: 0)
let deadlineIndexPath = IndexPath(item: deadlineIndex, section: 0)
let calenddarIndexPath = IndexPath(item: calIndex, section: 0)
let visibilityIndexPath = IndexPath(item: visibilityIndex, section: 0)
let doneIndexPath = IndexPath(item: doneIndex, section: 0)
let scoreIndexPath = IndexPath(item: scoreIndex, section: 0)
let resultIndexPath = IndexPath(item: resultIndex, section: 0)
let proofIndexPath = IndexPath(item: proofIndex, section: 0)
let commentIndexPath = IndexPath(item: commentIndex, section: 0)

class AddChallengeController: UITableViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
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
    var addChallengeIns = [AddChallenge]()
    var firstPage : Bool = true
    var rightButton : UIBarButtonItem?
    var cancelButton : UIBarButtonItem?
    var nextButton : UIBarButtonItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createAddChallengeInstance()
        navigationItem.title = "Add Challenge"
        tableView.register(TableViewCellContent.self, forCellReuseIdentifier: cellId)
        tableView.tableFooterView = UIView()
        self.view.backgroundColor =  UIColor.rgb(229, green: 231, blue: 235)
        rightButton = UIBarButtonItem(title: "Share", style: UIBarButtonItemStyle.plain, target: self, action: #selector(addChallenge))
        cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(cancel))
        nextButton = UIBarButtonItem(title: "Next", style: UIBarButtonItemStyle.plain, target: self, action: #selector(nextPage))
        navigationItem.rightBarButtonItem = nextButton
        rightButton?.tintColor = UIColor.white
        tableView?.showsVerticalScrollIndicator = false
        
        if dummyServiceCall == false {
            fetchData(url: getSubjectsURL, type: "SUBJECT")
            fetchData(url: getSelfSubjectsURL, type: "SELF_SUBJECT")
            fetchData(url: getFollowingListURL + memberID, type: "FRIENDS")
        } else {
            self.subjects = ServiceLocator.getSubjectFromDummy(jsonFileName: "subject")
            self.self_subjects = ServiceLocator.getSubjectFromDummy(jsonFileName: "self_subject")
            self.friends = ServiceLocator.getFriendsFromDummy(jsonFileName: "friends")
        }
        self.hideKeyboardWhenTappedAround()
    }
    
    func nextPage() {
        let commentCell = tableView.cellForRow(at: commentIndexPath) as! TableViewCommentCellContent
        let addViewCell = getCell(path: addViewIndexPath)
        /*
        if commentCell.commentView.text == "Comment" {
            popupAlert(message: "Comment cannot be empty.", willDelay: false)
            return
        }
         */
        if addViewCell.addChallenge.subjectLabel.text == selectText {
            popupAlert(message: "Subject cannot be empty.", willDelay: false)
            return
        }
        navigationItem.setRightBarButton(rightButton, animated: true)
        navigationItem.leftBarButtonItem = cancelButton
        enableDisableCells(disable: false)
    }
    
    func cancel() {
        navigationItem.setRightBarButton(nextButton, animated: true)
        navigationItem.leftBarButtonItem = nil
        enableDisableCells(disable: true)
    }
    
    func getType() -> String {
        let typeCell = getCell(path: segControlIndexPath)
        var type: String = ""
        if typeCell.mySegControl.selectedSegmentIndex == 0 {
            type = PRIVATE
        } else if typeCell.mySegControl.selectedSegmentIndex == 1 {
            type = PUBLIC
        } else if typeCell.mySegControl.selectedSegmentIndex == 2 {
            type = SELF
        } else if typeCell.mySegControl.selectedSegmentIndex == 3 {
            type = PUBLIC
        }
        return type
    }
    
    func isSelf() -> Bool {
        return getType() == SELF
    }
    
    func isPublic() -> Bool {
        return getType() == PUBLIC
    }
    
    func isPrivate() -> Bool {
        return getType() == PRIVATE
    }
    
    func isToWorld() -> Bool {
        let typeCell = getCell(path: segControlIndexPath)
        return typeCell.mySegControl.selectedSegmentIndex == 3
    }
    
    func enableDisableCells(disable: Bool) {
        let doneCell = getCell(path: doneIndexPath)
        switchType = disable
        tableView.reloadRows(at: [segControlIndexPath], with: .fade)
        switchSubject = disable
        tableView.reloadRows(at: [subjectIndexPath], with: .fade)
        switchDone = disable
        tableView.reloadRows(at: [doneIndexPath], with: .fade)
        switchComment = disable
        tableView.reloadRows(at: [commentIndexPath], with: .fade)
        if !isToWorld() {
            switchProofCell = !disable
            tableView.reloadRows(at: [visibilityIndexPath], with: .fade)
        }
        if isPrivate() {
            switchLeftPeopleCell = !disable
            tableView.reloadRows(at: [leftSideIndex], with: .fade)
        }
        if isPrivate() || (isPublic() && !isToWorld()) {
            switchRightPeopleCell = !disable
            tableView.reloadRows(at: [rightSideIndex], with: .fade)
        }
        if isPublic() {
            switchProof = !disable
            tableView.reloadRows(at: [proofIndexPath], with: .fade)
        }
        if !doneCell.isDone.isOn {
            switchDeadline = !disable
            tableView.reloadRows(at: [deadlineIndexPath], with: .fade)
        } else {
            if isPrivate() {
                switchScore = !disable
                tableView.reloadRows(at: [scoreIndexPath], with: .fade)
            }
            if isSelf() {
                switchResult = !disable
                tableView.reloadRows(at: [resultIndexPath], with: .fade)
            }
        }
    }
    
    func isDone() -> Bool {
        let doneCell = getCell(path: doneIndexPath)
        return doneCell.isDone.isOn
    }
    
    func fetchData(url: String, type: String) {
        if type == "FRIENDS" {
            self.friends = [Friends]()
        } else {
            self.subjects = [Subject]()
            self.self_subjects = [Subject]()
        }
        URLSession.shared.dataTask(with: NSURL(string: url)! as URL, completionHandler: { (data, response, error) -> Void in
            if error == nil && data != nil {
                do {
                    if let postsArray = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [[String: AnyObject]] {
                        for postDictionary in postsArray {
                            if type == "SUBJECT" {
                                let subject = Subject()
                                subject.setValuesForKeys(postDictionary)
                                self.subjects.append(subject)
                            } else if type == "SELF_SUBJECT" {
                                let subject = Subject()
                                subject.setValuesForKeys(postDictionary)
                                self.self_subjects.append(subject)
                            } else if type == "FRIENDS" {
                                let friend = Friends()
                                friend.setValuesForKeys(postDictionary)
                                self.friends.append(friend)
                            }
                        }
                    }
                } catch let err {
                    print(err)
                }
            }
        }).resume()
    }
    
    func createAddChallenge(labelText : String, resultText : String, resultId : Int, resultBool : Bool, labelAtt : NSMutableAttributedString) -> AddChallenge {
        let addChl = AddChallenge()
        addChl.labelText = labelText
        addChl.resultText = resultText
        addChl.resultId = resultId
        addChl.resultBool = resultBool
        addChl.labelAtt = labelAtt
        return addChl
    }
    
    func getDateAsFormatted(date : Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy HH:mm"
        let formattedDate = formatter.string(from: date)
        return formattedDate
    }
    
    func createAddChallengeInstance() {
        addChallengeIns = [AddChallenge]()
        addChallengeIns.append(createAddChallenge(labelText: "", resultText : "", resultId: -1, resultBool: false, labelAtt: greaterThan))
        addChallengeIns.append(createAddChallenge(labelText: "Type", resultText : "", resultId: 0, resultBool: false, labelAtt: greaterThan))
        addChallengeIns.append(createAddChallenge(labelText: "Subject", resultText : selectText, resultId: -1, resultBool: false, labelAtt: greaterThan))
        addChallengeIns.append(createAddChallenge(labelText: "Home", resultText : selectText, resultId: -1, resultBool: false, labelAtt: greaterThan))
        addChallengeIns.append(createAddChallenge(labelText: "Away", resultText : selectText, resultId: -1, resultBool: false, labelAtt: greaterThan))
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date())
        addChallengeIns.append(createAddChallenge(labelText: "Deadline", resultText : getDateAsFormatted(date: tomorrow!), resultId: -1, resultBool: false, labelAtt: greaterThan))
        addChallengeIns.append(createAddChallenge(labelText: "", resultText : "", resultId: -1, resultBool: false, labelAtt: greaterThan))
        addChallengeIns.append(createAddChallenge(labelText: "Visibility", resultText : "", resultId: 0, resultBool: false, labelAtt: greaterThan))
        addChallengeIns.append(createAddChallenge(labelText: "Done", resultText : "", resultId: -1, resultBool: false, labelAtt: greaterThan))
        addChallengeIns.append(createAddChallenge(labelText: "Score", resultText : "", resultId: -1, resultBool: false, labelAtt: greaterThan))
        addChallengeIns.append(createAddChallenge(labelText: "Result", resultText : "", resultId: -1, resultBool: false, labelAtt: greaterThan))
        addChallengeIns.append(createAddChallenge(labelText: "Proof", resultText : "", resultId: -1, resultBool: false, labelAtt: greaterThan))
        addChallengeIns.append(createAddChallenge(labelText: "Comment", resultText : "Comment", resultId: -1, resultBool: false, labelAtt: greaterThan))
    }
    
    func getCell(path: IndexPath) -> TableViewCellContent {
        return tableView.cellForRow(at: path) as! TableViewCellContent
    }
    
    func addChallenge() {
        let commentCell = tableView.cellForRow(at: commentIndexPath) as! TableViewCommentCellContent
        let addViewCell = getCell(path: addViewIndexPath)
        let deadlineCell = getCell(path: deadlineIndexPath)
        let doneCell = getCell(path: doneIndexPath)
        let visibilityCell = getCell(path: visibilityIndexPath)
        let resultCell = getCell(path: resultIndexPath)
        let scoreCell = getCell(path: scoreIndexPath)
        let proofCell = getCell(path: proofIndexPath)
        
        let type = isPublic() ? PUBLIC : (isSelf() ? SELF : PRIVATE)
        if ((!isToWorld() && isPublic()) || isPrivate()) && rightSide.count == 0 {
            popupAlert(message: "Away cannot be empty.", willDelay: false)
            return
        }
        if isPublic() && proofCell.proofImageView.image == nil {
            popupAlert(message: "Proof cannot be empty.", willDelay: false)
            return
        }
        
        var json: [String: Any] = ["challengerId": memberID,
                                   "name": memberName,
                                   "challengerFBId": memberFbID,
                                   "thinksAboutChallenge": commentCell.commentView.text == "Comment" ? nil : commentCell.commentView.text!,
                                   "subject": addViewCell.addChallenge.subjectLabel.text!,
                                   "untilDate": deadlineCell.labelOtherSide.text!,
                                   "done": doneCell.isDone.isOn
        ]
        json["firstTeamCount"] = !isPrivate() ? "1" : leftSide.count
        json["secondTeamCount"] = rightSide.count
        json["type"] = type
        
        if isPublic() {
            var joinAttendanceList: [[String: Any]] = []
            for attendace in rightSide {
                let joinAttendance: [String: Any] = ["memberId": attendace.id, "facebookID": attendace.fbId, "join": false, "proofed": false, "challenger": false]
                joinAttendanceList.append(joinAttendance)
            }
            json["proofed"] = true
            json["joinAttendanceList"] = rightSide.count == 0 ? nil : joinAttendanceList as Any
        }
        if isSelf() {
            json["visibility"] = visibilityCell.visibilitySegControlForSelf.selectedSegmentIndex
            json["goal"] = "10" // TODO
            if doneCell.isDone.isOn {
                json["result"] = resultCell.labelOtherSide
            } else {
                json["result"] = "-1"
            }
        }
        if isPrivate() {
            var versusAttendanceList: [[String: Any]] = []
            for attendace in leftSide {
                let versusAttendance: [String: Any] = ["memberId": attendace.id, "facebookID": attendace.fbId, "accept" : false, "firstTeamMember" : true, "secondTeamMember" : false]
                versusAttendanceList.append(versusAttendance)
            }
            for attendace in rightSide {
                let versusAttendance: [String: Any] = ["memberId": attendace.id, "facebookID": attendace.fbId, "accept" : false, "firstTeamMember" : false, "secondTeamMember" : true]
                versusAttendanceList.append(versusAttendance)
            }
            json["versusAttendanceList"] = versusAttendanceList as Any
            json["visibility"] = visibilityCell.visibilitySegControl.selectedSegmentIndex
            if doneCell.isDone.isOn {
                json["score"] = scoreCell.labelOtherSide
            } else {
                json["score"] = "-1"
            }
            
        }
        // PRIVATE firstTeamScore - secondTeamScore    ???
        // GENERAL chlDate - untilDateStr - comeFromSelf - supportFirstTeam - supportSecondTeam - firstTeamSupportCount - secondTeamSupportCount - countOfProofs - insertTime - status - countOfComments
        let url = URL(string: isPublic() ? addJoinChallengeURL : (isPrivate() ? addVersusChallengeURL : addSelfChallengeURL))!
        let request = ServiceLocator.prepareRequest(url: url, json: json)
        
        URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    DispatchQueue.main.async {
                        let result = NSString(data: data, encoding: String.Encoding.ascii.rawValue)!
                        self.addMedia(result: result, image: proofCell.proofImageView.image!)
                    }
                } else {
                    let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
                    if let responseJSON = responseJSON as? [String: Any] {
                        print(responseJSON)
                        if responseJSON["message"] != nil {
                            self.popupAlert(message: responseJSON["message"] as! String, willDelay: false)
                        }
                    }
                }
            }
        }).resume()
    }
    
    func addMedia(result: NSString, image: UIImage) {
        let parameters = ["challengeId": result as String, "memberId": memberID as String]
        let urlOfUpload = URL(string: uploadImageURL)!
        let requestOfUpload = ServiceLocator.prepareRequestForMedia(url: urlOfUpload, parameters: parameters, image: image)
        
        URLSession.shared.dataTask(with: requestOfUpload, completionHandler: { (data, response, error) -> Void in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    DispatchQueue.main.async {
                        self.createAddChallengeInstance()
                        self.tableView.reloadData()
                        self.cancel()
                    }
                    self.popupAlert(message: "Your challange ready!", willDelay: true)
                } else {
                    let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
                    if let responseJSON = responseJSON as? [String: Any] {
                        print(responseJSON)
                        if responseJSON["message"] != nil {
                            self.popupAlert(message: responseJSON["message"] as! String, willDelay: false)
                            return
                        }
                    }
                }
            }
        }).resume()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let segControlContent = getCell(path: segControlIndexPath)
        if indexPath == subjectIndexPath {
            let selectionTable = SelectionTableViewController()
            var selItems = [SelectedItems]()
            
            if isPublic() || isPrivate() {
                for subj in self.subjects {
                    let selItem = SelectedItems()
                    selItem.name = subj.name
                    selItems.append(selItem)
                }
            } else {
                for subj in self.self_subjects {
                    let selItem = SelectedItems()
                    selItem.name = subj.name
                    selItems.append(selItem)
                }
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
                selItem.name = "\(fri.name!) \(fri.surname!)"
                selItem.id = fri.id
                selItem.fbId = fri.facebookID
                selItems.append(selItem)
            }
            if !isPublic() || indexPath.row == 3 {
                selectionTable.items = selItems
            } else {
                selectionTable.items = selItems
            }
            if !isPublic() {
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
            let addViewContent = getCell(path: addViewIndexPath)
            if !firstPage {
                if (!isDone()) {
                    addViewContent.addChallenge.untilDateLabel.text = "LAST \(getDayBetweenDates(isSelect: true)) DAYS"
                    self.tableView?.scrollToRow(at: resultIndexPath, at: UITableViewScrollPosition.bottom, animated: true)
                } else {
                    addViewContent.addChallenge.untilDateLabel.isHidden = true
                    addViewContent.addChallenge.finishFlag.isHidden = false
                }
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
        } else if indexPath == proofIndexPath {
            imagePickerForProofUpload()
        }
    }
    
    let imagePickerController = UIImagePickerController()
    func imagePickerForProofUpload() {
        imagePickerController.delegate = self
        imagePickerController.sourceType = UIImagePickerControllerSourceType.savedPhotosAlbum
        imagePickerController.allowsEditing = false
        self.present(imagePickerController, animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            let proofCell = self.getCell(path: proofIndexPath)
            proofCell.proofImageView.image = pickedImage
            proofCell.proofImageView.alpha = 1
        }
        dismiss(animated: true, completion: nil)
    }
    
    func getDayBetweenDates(isSelect : Bool) -> Int {
        let cellContent = getCell(path: calenddarIndexPath)
        let cCellContent = getCell(path: deadlineIndexPath)
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
        addChallengeIns[deadlineIndex].resultText = getDateAsFormatted(date: cellContent.datePicker.date)
        return daysBetween
    }
    
    func getHeight(switchOfCell: Bool) -> CGFloat {
        if switchOfCell {
            return tableRowHeightHeight
        } else {
            return zeroHeight
        }
    }
    
    var switchType : Bool = true;
    var switchDateP : Bool = false;
    var switchDeadline : Bool = false;
    var switchProofCell : Bool = false;
    var switchLeftPeopleCell : Bool = false;
    var switchRightPeopleCell : Bool = false;
    var switchDone : Bool = true;
    var switchScore : Bool = false;
    var switchResult : Bool = false;
    var switchProof : Bool = false;
    var switchSubject : Bool = true;
    var switchComment : Bool = true;
    var zeroHeight : CGFloat = 0
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath == leftSideIndex {
            return getHeight(switchOfCell: switchLeftPeopleCell)
        } else if indexPath == segControlIndexPath {
            return getHeight(switchOfCell: switchType)
        } else if indexPath == subjectIndexPath {
            return getHeight(switchOfCell: switchSubject)
        } else if indexPath == commentIndexPath {
            return getHeight(switchOfCell: switchComment)
        } else if indexPath == rightSideIndex {
            return getHeight(switchOfCell: switchRightPeopleCell)
        } else if indexPath == deadlineIndexPath {
            return getHeight(switchOfCell: switchDeadline)
        } else if indexPath == visibilityIndexPath {
            return getHeight(switchOfCell: switchProofCell)
        } else if indexPath == doneIndexPath {
            return getHeight(switchOfCell: switchDone)
        } else if indexPath == scoreIndexPath {
            return getHeight(switchOfCell: switchScore)
        } else if indexPath == resultIndexPath {
            return getHeight(switchOfCell: switchResult)
        } else if indexPath == proofIndexPath {
            return getHeight(switchOfCell: switchProof)
        } else if indexPath == calenddarIndexPath {
            if switchDateP {
                return 180
            } else {
                return zeroHeight
            }
        } else if indexPath == addViewIndexPath {
            return (screenSize.width * chlViewHeight) + (tableRowHeightHeight / 2)
        } else {
            return tableRowHeightHeight
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 13
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let frameOfCell : CGRect = CGRect(x: 0, y: 0, width: self.view.frame.width, height: tableRowHeightHeight)        
        let cell = TableViewCellContent(frame: frameOfCell, cellRow: indexPath.row, typeIndex: addChallengeIns[typeIndex].resultId!)
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        if indexPath == segControlIndexPath {
            cell.label.text = addChallengeIns[typeIndex].labelText
            cell.mySegControl.selectedSegmentIndex = addChallengeIns[typeIndex].resultId!
            cell.mySegControl.addTarget(self, action: #selector(self.segControlChange), for: UIControlEvents.valueChanged)
            cell.isHidden = !switchType
        } else if indexPath == subjectIndexPath {
            cell.label.text = addChallengeIns[subjectIndex].labelText
            cell.labelOtherSide.text = addChallengeIns[subjectIndex].resultText
            cell.isHidden = !switchSubject
        } else if indexPath == leftSideIndex {
            cell.label.text = addChallengeIns[homeIndex].labelText
            cell.labelOtherSide.text = addChallengeIns[homeIndex].resultText
            cell.isHidden = !switchLeftPeopleCell
        } else if indexPath == rightSideIndex {
            cell.label.text = addChallengeIns[awayIndex].labelText
            cell.labelOtherSide.text = addChallengeIns[awayIndex].resultText
            cell.isHidden = !switchRightPeopleCell
        } else if indexPath == deadlineIndexPath {
            cell.label.text = addChallengeIns[deadlineIndex].labelText
            cell.labelOtherSide.text = addChallengeIns[deadlineIndex].resultText
            cell.isHidden = !switchDeadline
        } else if indexPath == calenddarIndexPath {
            cell.isHidden = !switchDateP
        } else if indexPath == visibilityIndexPath {
            cell.label.text = addChallengeIns[visibilityIndex].labelText
            // cell.visibilitySegControl.selectedSegmentIndex = addChallengeIns[visibilityIndex].resultId!
            cell.isHidden = !switchProofCell
        } else if indexPath == doneIndexPath {
            cell.label.text = addChallengeIns[doneIndex].labelText
            cell.isHidden = !switchDone
            cell.isDone.setOn(addChallengeIns[doneIndex].resultBool!, animated: false)
            cell.isDone.addTarget(self, action: #selector(self.doneSwitch), for: UIControlEvents.valueChanged)
        } else if indexPath == scoreIndexPath {
            cell.label.text = addChallengeIns[scoreIndex].labelText
            cell.isHidden = !switchScore
            cell.labelOtherSide.attributedText = addChallengeIns[scoreIndex].labelAtt
        } else if indexPath == resultIndexPath {
            cell.label.text = addChallengeIns[resultIndex].labelText
            cell.isHidden = !switchResult
            cell.labelOtherSide.attributedText = addChallengeIns[resultIndex].labelAtt
        } else if indexPath == proofIndexPath {
            cell.label.text = addChallengeIns[proofIndex].labelText
            cell.isHidden = !switchProof
            cell.labelOtherSide.attributedText = addChallengeIns[proofIndex].labelAtt
        } else if indexPath == commentIndexPath {
            let frameOfCellComment : CGRect = CGRect(x: 0, y: 0, width: self.view.frame.width, height: tableRowHeightHeight)
            let cellComment = TableViewCommentCellContent(frame: frameOfCellComment, cellRow: indexPath.row, typeIndex: addChallengeIns[typeIndex].resultId!)
            cellComment.label.text = addChallengeIns[commentIndex].labelText
            cellComment.selectionStyle = UITableViewCellSelectionStyle.none
            cellComment.commentView.text = addChallengeIns[commentIndex].resultText
            cellComment.isHidden = !switchComment
            return cellComment
        }
        return cell
    }
    
    func doneSwitch() {
        let addViewContent = getCell(path: addViewIndexPath)
        let doneSwitch = getCell(path: doneIndexPath)
        if (doneSwitch.isDone.isOn) {
            addViewContent.addChallenge.untilDateLabel.isHidden = true
            addViewContent.addChallenge.finishFlag.isHidden = false
            addViewContent.addChallenge.clapping.isHidden = false
            addViewContent.addChallenge.score.isHidden = false
            if isSelf() {
                addViewContent.addChallenge.score.text = "-"
            } else if isPrivate() {
                addViewContent.addChallenge.score.text = "-\(scoreForPrivate)-"
            }
        } else {
            addViewContent.addChallenge.untilDateLabel.isHidden = false
            addViewContent.addChallenge.finishFlag.isHidden = true
            addViewContent.addChallenge.clapping.isHidden = true
            addViewContent.addChallenge.score.isHidden = true
            addViewContent.addChallenge.untilDateLabel.text = "Deadline"
        }
        tableView.reloadRows(at: [deadlineIndexPath], with: .fade)
        tableView.reloadRows(at: [scoreIndexPath], with: .fade)
        tableView.reloadRows(at: [resultIndexPath], with: .fade)
        addChallengeIns[doneIndex].resultBool = doneSwitch.isDone.isOn
    }
    
    func updateCell(result : [SelectedItems], popIndexPath : IndexPath) {
        let cellContent = getCell(path: popIndexPath)
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
        addChallengeIns[popIndexPath.row].resultText = itemsResult.trim()        
        let addViewContent = getCell(path: addViewIndexPath)
        let subjectContent = getCell(path: subjectIndexPath)
        if popIndexPath != subjectIndexPath {
            segControlChange(isNotAction : true, popIndexPath : popIndexPath)
        } else {
            addViewContent.addChallenge.subjectLabel.text = subjectContent.labelOtherSide.text
            if isSelf() {
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
        createAddChallengeInstance()
        let addViewContent = getCell(path: addViewIndexPath)
        let segControlContent = getCell(path: segControlIndexPath)
        var selItems = [SelectedItems]()
        let selItem = SelectedItems()
        selItem.name = "unknown"
        selItems.append(selItem)
        addChallengeIns[typeIndex].resultId = segControlContent.mySegControl.selectedSegmentIndex
        var doneContent : TableViewCellContent!
        if !isNotAction {
            if firstPage {
                switchDone = true
                if isPublic() {
                    switchDone = false
                }
            }
            tableView.reloadRows(at: [calenddarIndexPath], with: .fade)
            doneContent = getCell(path: doneIndexPath)
            doneContent.isDone.setOn(false, animated: false)
            tableView.reloadRows(at: [addViewIndexPath], with: .fade)
            prepareViewForSelection(result: selItems, popIndexPath: popIndexPath, reset: true)
            tableView.reloadRows(at: [subjectIndexPath], with: .fade)
            tableView.reloadRows(at: [leftSideIndex], with: .fade)
            tableView.reloadRows(at: [rightSideIndex], with: .fade)
            tableView.reloadRows(at: [deadlineIndexPath], with: .fade)
            tableView.reloadRows(at: [visibilityIndexPath], with: .fade)
            tableView.reloadRows(at: [doneIndexPath], with: .fade)
            tableView.reloadRows(at: [scoreIndexPath], with: .fade)
            tableView.reloadRows(at: [resultIndexPath], with: .fade)
            tableView.reloadRows(at: [proofIndexPath], with: .fade)
            tableView.reloadRows(at: [commentIndexPath], with: .fade)
            leftSide.removeAll()
            rightSide.removeAll()            
        } else if popIndexPath == leftSideIndex || popIndexPath == rightSideIndex || (popIndexPath == subjectIndexPath && isSelf()) {
            tableView.reloadRows(at: [addViewIndexPath], with: .fade)
        }
    }
    
    func prepareViewForSelection(result : [SelectedItems], popIndexPath : IndexPath, reset : Bool) {
        let isLeftSide = popIndexPath == leftSideIndex
        let isRightSide = popIndexPath == rightSideIndex        
        if isPublic() {
            if reset {
                setChlrPeopleImages(result : result, reset: !reset)
            }
            setPeopleImages(result : result, reset: false)
        } else if isPrivate() || isSelf() {
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
        let addViewContent = getCell(path: addViewIndexPath)
        let subjectContent = getCell(path: subjectIndexPath)
        addViewContent.addChallenge.subjectLabel.text = subjectContent.labelOtherSide.text
        if !firstPage {
            if (!isDone()) {
                addViewContent.addChallenge.untilDateLabel.text = "LAST \(getDayBetweenDates(isSelect: false)) DAYS"
            } else {
                addViewContent.addChallenge.untilDateLabel.isHidden = true
                addViewContent.addChallenge.finishFlag.isHidden = false
            }
        }
        addViewContent.addChallenge.generateSecondTeam(count: result.count)
        if result.count == 1 {
            setImage(fbID: result[0].fbId, imageView: addViewContent.addChallenge.firstOnePeopleImageView, reset: reset)
            if isToWorld() {
                setImage(name: worldImage, imageView: addViewContent.addChallenge.firstOnePeopleImageView)
                addViewContent.addChallenge.firstOnePeopleImageView.contentMode = .scaleAspectFit
            }
        } else if result.count == 2 {
            setImage(fbID: result[0].fbId, imageView: addViewContent.addChallenge.firstTwoPeopleImageView, reset: reset)
            setImage(fbID: result[1].fbId, imageView: addViewContent.addChallenge.secondTwoPeopleImageView, reset: reset)
        } else if result.count == 3 {
            setImage(fbID: result[0].fbId, imageView: addViewContent.addChallenge.firstThreePeopleImageView, reset: reset)
            setImage(fbID: result[1].fbId, imageView: addViewContent.addChallenge.secondThreePeopleImageView, reset: reset)
            setImage(fbID: result[2].fbId, imageView: addViewContent.addChallenge.thirdThreePeopleImageView, reset: reset)
        } else {
            setImage(fbID: result[0].fbId, imageView: addViewContent.addChallenge.firstFourPeopleImageView, reset: reset)
            setImage(fbID: result[1].fbId, imageView: addViewContent.addChallenge.secondFourPeopleImageView, reset: reset)
            setImage(fbID: result[2].fbId, imageView: addViewContent.addChallenge.thirdFourPeopleImageView, reset: reset)
            setImage(name: "more_icon", imageView: addViewContent.addChallenge.moreFourPeopleImageView)
        }
    }
    
    func setChlrPeopleImages(result : [SelectedItems], reset : Bool) {
        let addViewIndexPath = IndexPath(item: 0, section: 0)
        let addViewContent = getCell(path: addViewIndexPath)
        addViewContent.addChallenge.generateFirstTeam(count: result.count)
        if result.count == 1 {
            setImage(fbID: result[0].fbId, imageView: addViewContent.addChallenge.firstOneChlrPeopleImageView, reset: reset)
        } else if result.count == 2 {
            setImage(fbID: result[0].fbId, imageView: addViewContent.addChallenge.firstTwoChlrPeopleImageView, reset: reset)
            setImage(fbID: result[1].fbId, imageView: addViewContent.addChallenge.secondTwoChlrPeopleImageView, reset: reset)
        } else if result.count == 3 {
            setImage(fbID: result[0].fbId, imageView: addViewContent.addChallenge.firstThreeChlrPeopleImageView, reset: reset)
            setImage(fbID: result[1].fbId, imageView: addViewContent.addChallenge.secondThreeChlrPeopleImageView, reset: reset)
            setImage(fbID: result[2].fbId, imageView: addViewContent.addChallenge.thirdThreeChlrPeopleImageView, reset: reset)
        } else {
            setImage(fbID: result[0].fbId, imageView: addViewContent.addChallenge.firstFourChlrPeopleImageView, reset: reset)
            setImage(fbID: result[1].fbId, imageView: addViewContent.addChallenge.secondFourChlrPeopleImageView, reset: reset)
            setImage(fbID: result[2].fbId, imageView: addViewContent.addChallenge.thirdFourChlrPeopleImageView, reset: reset)
            setImage(name: "more_icon", imageView: addViewContent.addChallenge.moreFourChlrPeopleImageView)
        }
    }
    
    func updateScoreAndResult(indexPath: IndexPath) {
        if indexPath == scoreIndexPath {
            let scoreContent = getCell(path: scoreIndexPath)
            addChallengeIns[scoreIndex].labelAtt = NSMutableAttributedString(string: scoreContent.labelOtherSide.text!, attributes: [NSFontAttributeName: UIFont(name: "EuphemiaUCAS", size: 18)!])
        }
        if indexPath == resultIndexPath {
            let resultContent = getCell(path: resultIndexPath)
            addChallengeIns[resultIndex].labelAtt = NSMutableAttributedString(string: resultContent.labelOtherSide.text!, attributes: [NSFontAttributeName: UIFont(name: "EuphemiaUCAS", size: 18)!])
        }
    }
}
