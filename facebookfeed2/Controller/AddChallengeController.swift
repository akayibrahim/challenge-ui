//
//  AddChallengeController.swift
//  facebookfeed2
//
//  Created by iakay on 20.02.2018.
//  Copyright © 2018 challenge. All rights reserved.
//

import UIKit
import Alamofire
import YPImagePicker

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
        cancelButton = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.plain, target: self, action: #selector(cancel))
        nextButton = UIBarButtonItem(title: "Next", style: UIBarButtonItemStyle.plain, target: self, action: #selector(nextPage))
        navigationItem.rightBarButtonItem = nextButton
        rightButton?.tintColor = UIColor.white
        tableView?.showsVerticalScrollIndicator = false
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        self.hideKeyboardWhenTappedAround()
        self.leftSide.append(getMember())
    }
    
    func nextPage() {
        let subjectCell = getCell(path: subjectIndexPath)
        /*
        if commentCell.commentView.text == "Comment" {
            popupAlert(message: "Comment cannot be empty.", willDelay: false)
            return
        }
         */
        if subjectCell.labelOtherSide.text == selectText {
            popupAlert(message: "Please select subject!", willDelay: false)
            return
        }
        navigationItem.setRightBarButton(rightButton, animated: true)
        navigationItem.leftBarButtonItem = cancelButton
        firstPage = false
        enableDisableCells(disable: false)
        if !isSelf() && !isToWorld() {
            let addViewCell = getCell(path: addViewIndexPath)
            let deadlineCell = getCell(path: deadlineIndexPath)
            let daysBetween = getDayBetweenDates(isSelect: false)
            addViewCell.addChallenge.untilDateLabel.text = "CHALLENGE TIME is \(daysBetween) DAYS"
            deadlineCell.labelOtherSide.text = "\(daysBetween) Days"
            deadlineCell.label.text = "CHALLENGE TIME"
            deadlineCell.label.font = UIFont.systemFont(ofSize: 13)
        }
    }
    
    func cancel() {
        navigationItem.setRightBarButton(nextButton, animated: true)
        navigationItem.leftBarButtonItem = nil
        firstPage = true
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
    
    func closeCalendar() {
        switchDateP = false
        tableView.reloadRows(at: [calenddarIndexPath], with: .fade)
    }
    
    func enableDisableCells(disable: Bool) {
        closeCalendar()
        let doneCell = getCell(path: doneIndexPath)
        let addViewCell = getCell(path: addViewIndexPath)
        let commentCell = tableView.cellForRow(at: commentIndexPath) as! TableViewCommentCellContent
        switchType = disable
        tableView.reloadRows(at: [segControlIndexPath], with: .fade)
        switchSubject = disable
        tableView.reloadRows(at: [subjectIndexPath], with: .fade)
        if firstPage {
            switchDeadline = false
            tableView.reloadRows(at: [deadlineIndexPath], with: .fade)
            switchDone = isPublic() ? false : true
            tableView.reloadRows(at: [doneIndexPath], with: .fade)
            switchResult = false
            tableView.reloadRows(at: [resultIndexPath], with: .fade)
            switchScore = false
            tableView.reloadRows(at: [scoreIndexPath], with: .fade)
        } else {
            switchDone = disable
            tableView.reloadRows(at: [doneIndexPath], with: .fade)
            if !doneCell.isDone.isOn {
                switchDeadline = !disable
                tableView.reloadRows(at: [deadlineIndexPath], with: .fade)
            } else {
                if isPrivate() {
                    switchScore = !disable
                    tableView.reloadRows(at: [scoreIndexPath], with: .fade)
                }
            }
        }
        switchComment = disable
        addChallengeIns[commentIndex].resultText = commentCell.commentView.text
        tableView.reloadRows(at: [commentIndexPath], with: .fade)
        if isSelf() {
            switchResult = !disable
            tableView.reloadRows(at: [resultIndexPath], with: .fade)
        }
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
        if firstPage {
            switchProof = false
            tableView.reloadRows(at: [proofIndexPath], with: .fade)
        } else if !firstPage && isPublic() {
            switchProof = !disable
            tableView.reloadRows(at: [proofIndexPath], with: .fade)
        }
        if !firstPage {
            let daysBetween = getDayBetweenDates(isSelect: false)
            addViewCell.addChallenge.untilDateLabel.text = (!isToWorld() && !isSelf()) ? "CHALLENGE TIME is \(daysBetween) DAYS" : "LAST \(daysBetween) DAYS"
        }
    }
    
    func isDone() -> Bool {
        let doneCell = getCell(path: doneIndexPath)
        return doneCell.isDone.isOn
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
        addChallengeIns.append(createAddChallenge(labelText: "Home", resultText : memberName, resultId: -1, resultBool: false, labelAtt: greaterThan))
        addChallengeIns.append(createAddChallenge(labelText: "Away", resultText : selectText, resultId: -1, resultBool: false, labelAtt: greaterThan))
        let nextWeek = Calendar.current.date(byAdding: .day, value: 7, to: Date())
        addChallengeIns.append(createAddChallenge(labelText: "Deadline", resultText : getDateAsFormatted(date: nextWeek!), resultId: 10079, resultBool: false, labelAtt: greaterThan))
        addChallengeIns.append(createAddChallenge(labelText: "", resultText : "", resultId: -1, resultBool: false, labelAtt: greaterThan))
        addChallengeIns.append(createAddChallenge(labelText: "Visibility", resultText : "", resultId: 0, resultBool: false, labelAtt: greaterThan))
        addChallengeIns.append(createAddChallenge(labelText: "Done", resultText : "", resultId: -1, resultBool: false, labelAtt: greaterThan))
        addChallengeIns.append(createAddChallenge(labelText: "Winner", resultText : "", resultId: -1, resultBool: false, labelAtt: greaterThan))
        addChallengeIns.append(createAddChallenge(labelText: "Goal", resultText : "", resultId: -1, resultBool: false, labelAtt: greaterThan))
        addChallengeIns.append(createAddChallenge(labelText: "Proof", resultText : "", resultId: -1, resultBool: false, labelAtt: greaterThan))
        addChallengeIns.append(createAddChallenge(labelText: "Comment", resultText : "Comment", resultId: -1, resultBool: false, labelAtt: greaterThan))
    }
    
    func getCell(path: IndexPath) -> TableViewCellContent {
        return tableView.cellForRow(at: path) as! TableViewCellContent
    }
    
    func addChallenge() {
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        if switchDateP == true {
            switchDateP = false
            tableView.reloadRows(at: [calenddarIndexPath], with: .fade)
        }
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
        if isImg && isPublic() && proofCell.proofImageView.image == nil {
            popupAlert(message: "Proof cannot be empty.", willDelay: false)
            return
        }
        if isDone() && isSelf() && resultCell.labelOtherSide.attributedText == addChallengeIns[resultIndex].labelAtt {
            popupAlert(message: "Result cannot be empty.", willDelay: false)
            return
        }
        
        var json: [String: Any] = ["challengerId": memberID,
                                   "name": memberName,
                                   "challengerFBId": memberFbID,
                                   "subject": addViewCell.addChallenge.subjectLabel.text!,
                                   "done": doneCell.isDone.isOn
        ]
        if commentCell.commentView.text != "Comment" {
            json["thinksAboutChallenge"] = commentCell.commentView.text!
        }
        json["firstTeamCount"] = !isPrivate() ? "1" : leftSide.count
        json["secondTeamCount"] = rightSide.count
        json["type"] = type
        let index = visibilityCell.visibilitySegControl.selectedSegmentIndex
        json["visibility"] = index == 0 ? 3 : (index == 1 ? 2 : 1)
        
        if doneCell.isDone.isOn == false {
            if !isSelf() && !isToWorld() {
                // let temp = deadlineCell.labelOtherSide.text
                // let daysBetween = temp?.components(separatedBy: " ").dropLast().joined()
                json["challengeTime"] = addChallengeIns[deadlineIndex].resultId
            } else {
                json["untilDate"] = deadlineCell.labelOtherSide.text!
            }
        }
        
        if isPublic() {
            var joinAttendanceList: [[String: Any]] = []
            for attendace in rightSide {
                let joinAttendance: [String: Any] = ["memberId": attendace.id, "facebookID": attendace.fbId, "join": false, "proofed": false, "challenger": false]
                joinAttendanceList.append(joinAttendance)
            }
            json["joinAttendanceList"] = rightSide.count == 0 ? nil : joinAttendanceList as Any
            json["proofed"] = true
        }
        if isSelf() {
            if doneCell.isDone.isOn == true {
                json["result"] = resultCell.firstTeamScore
                json["goal"] = resultCell.secondTeamScore
                json["homeWin"] = resultCell.homeWin
            } else {
                json["result"] = resultCell.firstTeamScore
                json["goal"] = resultCell.secondTeamScore
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
            if doneCell.isDone.isOn == true {
                json["firstTeamScore"] = scoreCell.firstTeamScore
                json["secondTeamScore"] = scoreCell.secondTeamScore
                json["homeWin"] = scoreCell.homeWin
                json["awayWin"] = scoreCell.awayWin
            } else {
                json["firstTeamScore"] = "-1"
                json["secondTeamScore"] = "-1"
            }
            
        }
        // PRIVATE firstTeamScore - secondTeamScore    ???
        // GENERAL chlDate - untilDateStr - comeFromSelf - supportFirstTeam - supportSecondTeam - firstTeamSupportCount - secondTeamSupportCount - countOfProofs - insertTime - status - countOfComments
        let url = URL(string: isPublic() ? addJoinChallengeURL : (isPrivate() ? addVersusChallengeURL : addSelfChallengeURL))!
        var request : URLRequest!
        if isPublic() {
            if isImg {
                // request = ServiceLocator.prepareRequestForMedia(url: url, parameters: json, image: proofCell.proofImageView.image!)
            } else {
                // request = ServiceLocator.prepareRequestForVideo(url: url, parameters: json, videoUrl: videoURL!)
            }
        } else {
            request = ServiceLocator.prepareRequest(url: url, json: json)
        }
        request = ServiceLocator.prepareRequest(url: url, json: json)
        
        URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    DispatchQueue.main.async {
                        if self.isPublic() {
                            let result = NSString(data: data, encoding: String.Encoding.ascii.rawValue)!
                            self.addMedia(result: result)
                        } else {
                            self.clear()
                        }
                    }
                } else {
                    let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
                    if let responseJSON = responseJSON as? [String: Any] {
                        print(responseJSON)
                        if responseJSON["message"] != nil {
                            self.navigationItem.rightBarButtonItem?.isEnabled = true
                            self.popupAlert(message: responseJSON["message"] as! String, willDelay: false)
                        }
                    }
                }
            }
        }).resume()
    }
    
    func clear() {
        DispatchQueue.main.async {
            self.createAddChallengeInstance()
            self.cancel()
            self.tableView.reloadData()
            self.popupAlert(message: "ADDED!", willDelay: true)
            if self.leftSide.count == 0 {
                self.leftSide.append(self.getMember())
            }
            self.navigationController?.tabBarController?.selectedIndex = profileIndex
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        }
    }
    
    func addMedia(result: NSString) {
        let proofCell = getCell(path: proofIndexPath)
        let parameters = ["challengeId": result as String, "memberId": memberID as String]
        let urlOfUpload = URL(string: uploadImageURL)!
        var requestOfUpload: URLRequest?
        if self.isImg {
            requestOfUpload = ServiceLocator.prepareRequestForMedia(url: urlOfUpload, parameters: parameters, image: proofCell.proofImageView.image!)
        } else {
            requestOfUpload = ServiceLocator.prepareRequestForVideo(url: urlOfUpload, parameters: parameters, videoUrl: videoURL!)
        }
        URLSession.shared.dataTask(with: requestOfUpload!, completionHandler: { (data, response, error) -> Void in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    self.clear()
                } else {
                    self.navigationItem.rightBarButtonItem?.isEnabled = true
                    let error = ServiceLocator.getErrorMessage(data: data, chlId: "", sUrl: uploadImageURL, inputs: "challengeId:\(result as String), memberID:\(memberID)")
                    self.popupAlert(message: error, willDelay: false)
                }
            }
        }).resume()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let segControlContent = getCell(path: segControlIndexPath)
        if indexPath == subjectIndexPath {
            let selectionTable = SelectionTableViewController()
            selectionTable.tableTitle = "Subjects"
            selectionTable.popIndexPath = indexPath
            selectionTable.segmentIndex = segControlContent.mySegControl.selectedSegmentIndex
            selectionTable.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(selectionTable, animated: true)
        } else if indexPath == leftSideIndex || indexPath == rightSideIndex {
            let selectionTable = SelectionTableViewController()
            selectionTable.leftSide = leftSide
            selectionTable.rightSide = rightSide
            selectionTable.tableTitle = "Friends"
            selectionTable.popIndexPath = indexPath
            selectionTable.segmentIndex = segControlContent.mySegControl.selectedSegmentIndex
            selectionTable.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(selectionTable, animated: true)
        } else if indexPath == deadlineIndexPath {
            let addViewContent = getCell(path: addViewIndexPath)
            if !firstPage {
                let daysBetween = getDayBetweenDates(isSelect: true)
                addViewContent.addChallenge.untilDateLabel.text = (!isToWorld() && !isSelf()) ? "CHALLENGE TIME is \(daysBetween) DAYS" : "LAST \(daysBetween) DAYS"
            }
        } else if indexPath == resultIndexPath {
            let updateProgress = UpdateProgressController()
            updateProgress.result = true
            updateProgress.doneSwitch = isDone()
            updateProgress.awayScoreText.becomeFirstResponder()
            updateProgress.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(updateProgress, animated: true)
        } else if indexPath == scoreIndexPath {
            let updateProgress = UpdateProgressController()
            updateProgress.doneSwitch = isDone()
            updateProgress.homeScoreText.becomeFirstResponder()
            updateProgress.score = true
            updateProgress.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(updateProgress, animated: true)
        } else if indexPath == proofIndexPath {
            imagePickerForProofUpload()
        }
    }
    
    func getMember() -> SelectedItems {
        let selItem = SelectedItems()
        selItem.name = memberName
        selItem.id = memberID
        selItem.fbId = memberFbID
        selItem.selected = true
        selItem.user = true
        return selItem
    }
    
    let imagePickerController = UIImagePickerController()
    func imagePickerForProofUpload() {
        imagePickerController.delegate = self
        imagePickerController.mediaTypes = ["public.image", "public.movie"]
        let actionsheet = UIAlertController(title: "", message: "Choose a photo source", preferredStyle :.actionSheet)
        actionsheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: {(action: UIAlertAction) in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)  {
                self.imagePickerController.sourceType = UIImagePickerControllerSourceType.camera
                self.imagePickerController.allowsEditing = false
                self.imagePickerController.showsCameraControls = true
                self.imagePickerController.videoMaximumDuration = 20
                self.present(self.imagePickerController, animated: true, completion: nil)
            } else {
                self.popupAlert(message: "Device has not camera.", willDelay: false)
            }
            
        }))
        
        actionsheet.addAction(UIAlertAction(title: "Media Library", style: .default, handler: {(action: UIAlertAction) in            
            let picker = YPImagePicker()
            picker.showsFilters = true
            picker.showsVideo = true
            YPImagePickerConfiguration()
            self.present(picker, animated: true, completion: nil)
            /*self.imagePickerController.sourceType = UIImagePickerControllerSourceType.savedPhotosAlbum
            self.imagePickerController.allowsEditing = false            
            self.present(self.imagePickerController, animated: true, completion: nil)*/
        }))
        
        actionsheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(actionsheet, animated: true, completion: nil)
    }

    var videoURL: NSURL?
    
    var isImg: Bool = true
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            let proofCell = self.getCell(path: proofIndexPath)
            proofCell.proofImageView.image = pickedImage
            proofCell.proofImageView.alpha = 1
            isImg = true
        } else {
            videoURL = info["UIImagePickerControllerMediaURL"] as? NSURL
            isImg = false
            print(videoURL!)
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
            if !isToWorld() && !isSelf() {
                let daysBetween : Int = Calendar.current.dateComponents([.day], from: Date(), to: cellContent.datePicker.date).day!
                cCellContent.labelOtherSide.text = "\(daysBetween) Days"
                let minutesBetween : Int = Calendar.current.dateComponents([.minute], from: Date(), to: cellContent.datePicker.date).minute!
                addChallengeIns[deadlineIndex].resultId = minutesBetween
            } else {
                cCellContent.labelOtherSide.text = formattedDate
            }
            switchDateP = !switchDateP
            tableView.reloadRows(at: [calenddarIndexPath], with: .fade)
            tableView.scrollToRow(at: calenddarIndexPath, at: .bottom, animated: true)
        } else {
            let temp = cCellContent.labelOtherSide.text
            if (temp?.contains("Days"))! {
                let daysBetween = temp?.components(separatedBy: " ").dropLast().joined()
                let nextWeek = Calendar.current.date(byAdding: .day, value: Int(daysBetween!)! + 1, to: Date())
                cellContent.datePicker.date = nextWeek!
            } else {
                let date = formatter.date(from: cCellContent.labelOtherSide.text!)
                cellContent.datePicker.date = date!
            }
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
    var commentCellHeight : CGFloat = 44
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath == leftSideIndex {
            return getHeight(switchOfCell: switchLeftPeopleCell)
        } else if indexPath == segControlIndexPath {
            return getHeight(switchOfCell: switchType)
        } else if indexPath == subjectIndexPath {
            return getHeight(switchOfCell: switchSubject)
        } else if indexPath == commentIndexPath {
            return commentCellHeight
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
                return 224
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
            let nextWeek = Calendar.current.date(byAdding: .day, value: 7, to: Date())
            cell.datePicker.date = nextWeek!
            cell.deadLines.selectedSegmentIndex = 1
            cell.deadLines.addTarget(self, action: #selector(self.deadlinesChanged), for: UIControlEvents.valueChanged)
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
            cellComment.commentView.delegate = self
            return cellComment
        }
        return cell
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        let commentContent = tableView.cellForRow(at: commentIndexPath) as! TableViewCommentCellContent
        if commentContent.commentView.textColor == UIColor.lightGray {
            commentContent.commentView.text = nil
            commentContent.commentView.textColor = UIColor.gray
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        let commentContent = tableView.cellForRow(at: commentIndexPath) as! TableViewCommentCellContent
        if commentContent.commentView.text.isEmpty {
            commentContent.commentView.text = "Comment"
            commentContent.commentView.textColor = UIColor.lightGray
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return textView.text.count + (text.count - range.length) <= commentCharacterLimit
    }
    
    var beforeEstimatedSize = CGSize(width: screenWidth, height: 44)
    override func textViewDidChange(_ textView: UITextView) {
        let commentContent = tableView.cellForRow(at: commentIndexPath) as! TableViewCommentCellContent
        let size = CGSize(width: commentContent.commentView.frame.width, height: .infinity)
        let estimatedSize = commentContent.commentView.sizeThatFits(size)
        commentContent.commentView.constraints.forEach{ (constraint) in
            if constraint.firstAttribute == .height {
                constraint.constant = estimatedSize.height
                commentCellHeight = estimatedSize.height + 10
                if beforeEstimatedSize.height != estimatedSize.height {
                    updateTable()
                }
                tableView.scrollToRow(at: commentIndexPath, at: .bottom, animated: false)
                beforeEstimatedSize = estimatedSize
            }
        }
    }
    
    func updateTable() {
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
    }
    
    func deadlinesChanged() {
        let calendarContent = tableView.cellForRow(at: calenddarIndexPath) as! TableViewCellContent
        let selectedIndex = calendarContent.deadLines.selectedSegmentIndex
        let day : Int = selectedIndex == 0 ? 1 : (selectedIndex == 1 ? 7 : (selectedIndex == 2 ? 30 : 365) )
        calendarContent.datePicker.date = Calendar.current.date(byAdding: .day, value: day, to: Date())!
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
            addChallengeIns[resultIndex].labelText = "Succeed?"
        } else {
            addViewContent.addChallenge.untilDateLabel.isHidden = false
            addViewContent.addChallenge.finishFlag.isHidden = true
            addViewContent.addChallenge.clapping.isHidden = true
            addViewContent.addChallenge.score.isHidden = true
            addViewContent.addChallenge.untilDateLabel.text = "Deadline"
            addChallengeIns[resultIndex].labelText = "Goal"
        }
        tableView.reloadRows(at: [deadlineIndexPath], with: .fade)
        tableView.reloadRows(at: [scoreIndexPath], with: .fade)
        tableView.reloadRows(at: [resultIndexPath], with: .fade)
        addChallengeIns[doneIndex].resultBool = doneSwitch.isDone.isOn
    }
    
    func updateCell(result : [SelectedItems], popIndexPath : IndexPath) {
        closeCalendar()
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
                let imageName = addViewContent.addChallenge.subjectLabel.text?.replacingOccurrences(of: " ", with: "_")
                setImage(name: imageName, imageView: addViewContent.addChallenge.firstOnePeopleImageView)
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
        if subjectContent.labelOtherSide.text != selectText {
            addViewContent.addChallenge.subjectLabel.text = subjectContent.labelOtherSide.text
        }
        if !firstPage {
            if (!isDone()) {
                let daysBetween = getDayBetweenDates(isSelect: false)
                addViewContent.addChallenge.untilDateLabel.text = (!isToWorld() && !isSelf()) ? "CHALLENGE TIME is \(daysBetween) DAYS" : "LAST \(daysBetween) DAYS"
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
