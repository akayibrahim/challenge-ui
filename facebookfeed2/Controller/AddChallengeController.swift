//
//  AddChallengeController.swift
//  facebookfeed2
//
//  Created by iakay on 20.02.2018.
//  Copyright © 2018 challenge. All rights reserved.
//

import UIKit
import YPImagePicker

var chlIndex : Int = 0
var typeIndex : Int = 1
var subjectIndex : Int = 4
var homeIndex : Int = 3
var awayIndex : Int = 11
var deadlineIndex : Int = 5
var calIndex : Int = 6
var visibilityIndex : Int = 7
var doneIndex : Int = 8
var scoreIndex : Int = 9
var resultIndex : Int = 10
var proofIndex : Int = 2
var commentIndex : Int = 13
var toPublicIndex : Int = 12
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
let toPublicPath = IndexPath(item: toPublicIndex, section: 0)

class AddChallengeController: UITableViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    @objc let screenSize = UIScreen.main.bounds
    @objc var tableRowHeightHeight: CGFloat = 44
    @objc var chlViewHeight: CGFloat = 1.3/3
    var leftSide = [SelectedItems]()
    var rightSide = [SelectedItems]()
    @objc var deadLine = Int()
    @objc var bottomConstraint: NSLayoutConstraint?
    @objc var addChallengeIns = [AddChallenge]()
    @objc var firstPage : Bool = true
    @objc var rightButton : UIBarButtonItem?
    @objc var cancelButton : UIBarButtonItem?
    @objc var nextButton : UIBarButtonItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createAddChallengeInstance()
        navigationItem.title = "Add Challenge"
        tableView.register(TableViewCellContent.self, forCellReuseIdentifier: "addChlCellId")
        tableView.tableFooterView = UIView()
        self.view.backgroundColor =  UIColor(white: 1, alpha: 1) // UIColor.rgb(229, green: 231, blue: 235)
        rightButton = UIBarButtonItem(title: "Share", style: UIBarButtonItemStyle.plain, target: self, action: #selector(addChallenge))
        cancelButton = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.plain, target: self, action: #selector(cancel))
        nextButton = UIBarButtonItem(title: "Next", style: UIBarButtonItemStyle.plain, target: self, action: #selector(nextPage))
        navigationItem.rightBarButtonItem = rightButton
        rightButton?.tintColor = UIColor.black
        tableView?.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        self.hideKeyboardWhenTappedAround()
        self.leftSide.append(getMember())
        imagePickerForProofUpload()
    }
    
    @objc func nextPage() {
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
        addChallengeIns[subjectIndex].resultText = subjectCell.labelOtherSide.text
        navigationItem.setRightBarButton(rightButton, animated: true)
        navigationItem.leftBarButtonItem = cancelButton
        firstPage = false
        enableDisableCells(disable: false)
        if !isSelf() && !isToWorld() {
            // let addViewCell = getCell(path: addViewIndexPath)
            let deadlineCell = getCell(path: deadlineIndexPath)
            let daysBetween = getDayBetweenDates(isSelect: false)
            deadlineCell.labelOtherSide.text = "\(daysBetween) Days"
            deadlineCell.label.text = "CHALLENGE TIME"
            deadlineCell.label.font = UIFont.systemFont(ofSize: 13)
        }
    }
    
    @objc func cancel() {
        navigationItem.setRightBarButton(nextButton, animated: true)
        navigationItem.leftBarButtonItem = nil
        firstPage = true
        enableDisableCells(disable: true)
    }
    
    @objc func getType() -> String {
        /*
        let typeCell = getCell(path: segControlIndexPath)
        var type: String = ""
        if typeCell.mySegControl.selectedSegmentIndex == 0 {
            type = PUBLIC
        } else if typeCell.mySegControl.selectedSegmentIndex == 1 {
            type = PRIVATE
        } else if typeCell.mySegControl.selectedSegmentIndex == 2 {
            type = SELF
        }
        */
        return PUBLIC
    }
    
    @objc func isSelf() -> Bool {
        return getType() == SELF
    }
    
    @objc func isPublic() -> Bool {
        return getType() == PUBLIC
    }
    
    @objc func isPrivate() -> Bool {
        return getType() == PRIVATE
    }
    
    @objc func isToWorld() -> Bool {
        return isPublic() && addChallengeIns[toPublicIndex].resultId == 1
    }
    
    @objc func closeCalendar() {
        switchDateP = false
        tableView.reloadRows(at: [calenddarIndexPath], with: .fade)
    }
    
    @objc func enableDisableCells(disable: Bool) {
        closeCalendar()
        let doneCell = getCell(path: doneIndexPath)
        // let addViewCell = getCell(path: addViewIndexPath)
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
            switchtoPublic = isPublic() ? true : false
            tableView.reloadRows(at: [toPublicPath], with: .fade)
        } else {
            switchDone = disable
            tableView.reloadRows(at: [doneIndexPath], with: .fade)
            switchtoPublic = false
            tableView.reloadRows(at: [toPublicPath], with: .fade)
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
        switchResult = isSelf() ? !disable : false
        tableView.reloadRows(at: [resultIndexPath], with: .fade)
        switchProofCell = !isToWorld() ? !disable : false
        tableView.reloadRows(at: [visibilityIndexPath], with: .fade)
        switchLeftPeopleCell = isPrivate() ? !disable : false
        tableView.reloadRows(at: [leftSideIndex], with: .fade)
        switchRightPeopleCell = isPrivate() || (isPublic() && !isToWorld()) ? !disable : false
        tableView.reloadRows(at: [rightSideIndex], with: .fade)
        switchProof = !firstPage && isPublic() ? !disable : false
        tableView.reloadRows(at: [proofIndexPath], with: .fade)
        if !firstPage {
            _ = getDayBetweenDates(isSelect: false)
        }
    }
    
    @objc func isDone() -> Bool {
        let doneCell = getCell(path: doneIndexPath)
        return doneCell.isDone.isOn
    }
    
    @objc func createAddChallenge(labelText : String, resultText : String, resultId : Int, resultBool : Bool, labelAtt : NSMutableAttributedString) -> AddChallenge {
        let addChl = AddChallenge()
        addChl.labelText = labelText
        addChl.resultText = resultText
        addChl.resultId = resultId
        addChl.resultBool = resultBool
        addChl.labelAtt = labelAtt
        return addChl
    }
    
    @objc func getDateAsFormatted(date : Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy HH:mm"
        let formattedDate = formatter.string(from: date)
        return formattedDate
    }
    
    @objc func createAddChallengeInstance() {
        addChallengeIns = [AddChallenge]()
        addChallengeIns.append(createAddChallenge(labelText: "", resultText : "", resultId: -1, resultBool: false, labelAtt: greaterThan))
        addChallengeIns.append(createAddChallenge(labelText: "Type", resultText : "", resultId: 0, resultBool: false, labelAtt: greaterThan))
        addChallengeIns.append(createAddChallenge(labelText: "", resultText : "", resultId: -1, resultBool: false, labelAtt: greaterThan)) //Proof
        addChallengeIns.append(createAddChallenge(labelText: "Home", resultText : memberName, resultId: -1, resultBool: false, labelAtt: greaterThan))
        addChallengeIns.append(createAddChallenge(labelText: "Subject", resultText : selectText, resultId: -1, resultBool: false, labelAtt: greaterThan))
        let nextWeek = Calendar.current.date(byAdding: .day, value: 7, to: Date())
        addChallengeIns.append(createAddChallenge(labelText: "Deadline", resultText : getDateAsFormatted(date: nextWeek!), resultId: 10079, resultBool: false, labelAtt: greaterThan))
        addChallengeIns.append(createAddChallenge(labelText: "", resultText : "", resultId: -1, resultBool: false, labelAtt: greaterThan))
        addChallengeIns.append(createAddChallenge(labelText: "Visibility", resultText : "", resultId: 0, resultBool: false, labelAtt: greaterThan))
        addChallengeIns.append(createAddChallenge(labelText: "Done", resultText : "", resultId: -1, resultBool: false, labelAtt: greaterThan))
        addChallengeIns.append(createAddChallenge(labelText: "Winner", resultText : "", resultId: -1, resultBool: false, labelAtt: greaterThan))
        addChallengeIns.append(createAddChallenge(labelText: "Goal", resultText : "", resultId: -1, resultBool: false, labelAtt: greaterThan))
        addChallengeIns.append(createAddChallenge(labelText: "Restrict", resultText : selectText, resultId: 1, resultBool: false, labelAtt: greaterThan))
        addChallengeIns.append(createAddChallenge(labelText: "To", resultText : "", resultId: 1, resultBool: false, labelAtt: greaterThan))
        addChallengeIns.append(createAddChallenge(labelText: "Comment", resultText : "Comment", resultId: -1, resultBool: false, labelAtt: greaterThan))
    }
    
    @objc func getCell(path: IndexPath) -> TableViewCellContent {
        return tableView.cellForRow(at: path) as! TableViewCellContent
    }
    
    @objc func addChallenge() {
        if Util.controlNetwork() {
            return
        }
        if switchDateP == true {
            switchDateP = false
            tableView.reloadRows(at: [calenddarIndexPath], with: .fade)
        }
        let commentCell = tableView.cellForRow(at: commentIndexPath) as! TableViewCommentCellContent
        //let addViewCell = getCell(path: addViewIndexPath)
        let deadlineCell = getCell(path: deadlineIndexPath)
        let doneCell = getCell(path: doneIndexPath)
        //let visibilityCell = getCell(path: visibilityIndexPath)
        let resultCell = getCell(path: resultIndexPath)
        let scoreCell = getCell(path: scoreIndexPath)
        let proofCell = getCell(path: proofIndexPath)
        let subjectCell = getCell(path: subjectIndexPath)
        let toPublicCell = getCell(path: toPublicPath)
        
        if subjectCell.labelOtherSide.text == selectText {
            popupAlert(message: "Please select subject!", willDelay: false)
            return
        }
        let type = isPublic() ? PUBLIC : (isSelf() ? SELF : PRIVATE)
        if ((!isToWorld() && isPublic()) || isPrivate()) && rightSide.count == 0 {
            popupAlert(message: "Away cannot be empty.", willDelay: false)
            return
        }
        if isPublic() && proofCell.proofImageView.image == nil {
            popupAlert(message: "Proof cannot be empty.", willDelay: false)
            return
        }
        if isDone() && isSelf() && resultCell.labelOtherSide.attributedText == addChallengeIns[resultIndex].labelAtt {
            popupAlert(message: "Result cannot be empty.", willDelay: false)
            return
        }
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        self.navigationItem.leftBarButtonItem?.isEnabled = false
        var json: [String: Any] = ["challengerId": memberID,
                                   "name": memberName,
                                   "challengerFBId": memberFbID,
                                   "subject": subjectCell.labelOtherSide.text!,
                                   "done": doneCell.isDone.isOn
        ]
        if commentCell.commentView.text != "Comment" {
            json["thinksAboutChallenge"] = commentCell.commentView.text!
        }
        json["firstTeamCount"] = !isPrivate() ? "1" : leftSide.count
        json["secondTeamCount"] = rightSide.count
        json["type"] = type
        let index = toPublicCell.toPublicControl.selectedSegmentIndex
        json["visibility"] = index == 0 ? 3 : 1 //(index == 1 ? 2 : 1)
        
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
                            self.navigationItem.leftBarButtonItem?.isEnabled = true
                            self.popupAlert(message: responseJSON["message"] as! String, willDelay: false)
                        }
                    }
                }
            }
        }).resume()
    }
    
    @objc func clear() {
        DispatchQueue.main.async {
            self.navigationItem.rightBarButtonItem?.isEnabled = true
            self.navigationItem.leftBarButtonItem?.isEnabled = true
            self.createAddChallengeInstance()
            //self.cancel()
            self.tableView.reloadData()
            //self.popupAlert(message: "ADDED!", willDelay: true)
            if self.leftSide.count == 0 {
                self.leftSide.append(self.getMember())
            }
            reloadProfile = true
            self.navigationController?.tabBarController?.selectedIndex = profileIndex
        }
    }
    
    @objc func addMedia(result: NSString) {
        let proofCell = getCell(path: proofIndexPath)
        let parameters = ["challengeId": result as String, "memberId": memberID as String, "wide": self.isWide as Bool] as [String : Any]
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
                    self.navigationItem.leftBarButtonItem?.isEnabled = true
                    let error = ServiceLocator.getErrorMessage(data: data, chlId: "", sUrl: uploadImageURL, inputs: "challengeId:\(result as String), memberID:\(memberID)")
                    self.popupAlert(message: error, willDelay: false)
                }
            }
        }).resume()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath == subjectIndexPath {
            let segControlContent = getCell(path: segControlIndexPath)
            let selectionTable = SelectionTableViewController()
            selectionTable.tableTitle = "Subjects"
            selectionTable.popIndexPath = indexPath
            selectionTable.segmentIndex = segControlContent.mySegControl.selectedSegmentIndex
            selectionTable.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(selectionTable, animated: true)
        } else if indexPath == leftSideIndex || indexPath == rightSideIndex {
            let segControlContent = getCell(path: segControlIndexPath)
            let selectionTable = SelectionTableViewController()
            selectionTable.leftSide = leftSide
            selectionTable.rightSide = rightSide
            selectionTable.tableTitle = "Friends"
            selectionTable.popIndexPath = indexPath
            selectionTable.segmentIndex = segControlContent.mySegControl.selectedSegmentIndex
            selectionTable.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(selectionTable, animated: true)
        } else if indexPath == deadlineIndexPath {
            // let addViewContent = getCell(path: addViewIndexPath)
            //if !firstPage {
                _ = getDayBetweenDates(isSelect: true)
                switchDateP = !switchDateP
                tableView.reloadRows(at: [calenddarIndexPath], with: .fade)
                tableView.scrollToRow(at: calenddarIndexPath, at: .bottom, animated: true)
            //}
        } else if indexPath == resultIndexPath {
            let updateProgress = UpdateProgressController()
            updateProgress.result = true
            updateProgress.doneSwitch = isDone()
            updateProgress.challengeType = SELF
            updateProgress.awayScoreText.becomeFirstResponder()
            updateProgress.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(updateProgress, animated: true)
        } else if indexPath == scoreIndexPath {
            let updateProgress = UpdateProgressController()
            updateProgress.doneSwitch = isDone()
            updateProgress.challengeType = PRIVATE
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
    
    @objc let imagePickerController = UIImagePickerController()
    @objc func imagePickerForProofUpload() {
        let picker = YPImagePicker(configuration: Util.conficOfYpImagePicker())
        picker.didFinishPicking { [unowned picker] items, cancelled in
            let proofCell = self.getCell(path: proofIndexPath)
            for item in items {
                switch item {
                case .photo(let photo):
                    proofCell.proofImageView.image = photo.modifiedImage
                    proofCell.proofImageView.alpha = 1
                    self.isImg = true
                case .video(let video):
                    self.videoURL = video.url as NSURL
                    proofCell.proofImageView.image = video.thumbnail
                    self.isWide = video.thumbnail.size.width > video.thumbnail.size.height ? true : false
                    proofCell.proofImageView.alpha = 1
                    self.isImg = false
                }
            }
            picker.dismiss(animated: true, completion: nil)
            if cancelled && proofCell.proofImageView.image == nil {
                self.navigationController?.tabBarController?.selectedIndex = chlIndex
            }
        }
        present(picker, animated: true, completion: nil)
        /*
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
            self.imagePickerController.sourceType = UIImagePickerControllerSourceType.savedPhotosAlbum
            self.imagePickerController.allowsEditing = false            
            self.present(self.imagePickerController, animated: true, completion: nil)
        }))
        
        actionsheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(actionsheet, animated: true, completion: nil)
         */
    }

    @objc var videoURL: NSURL?
    @objc var isImg: Bool = true
    @objc var isWide: Bool = false
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
    
    @objc func getDayBetweenDates(isSelect : Bool) -> Int {
        let cellContent = getCell(path: calenddarIndexPath)
        let cCellContent = getCell(path: deadlineIndexPath)
        //let addViewContent = getCell(path: addViewIndexPath)
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy HH:mm"
        let formattedDate = formatter.string(from: cellContent.datePicker.date)
        if isSelect {
            if !isToWorld() && !isSelf() {
                let daysBetween : Int = Calendar.current.dateComponents([.day], from: Date(), to: cellContent.datePicker.date).day!
                let minutesBetween : Int = Calendar.current.dateComponents([.minute], from: Date(), to: cellContent.datePicker.date).minute!
                addChallengeIns[deadlineIndex].resultId = minutesBetween
                cCellContent.labelOtherSide.text = daysBetween != 0 ? "\(daysBetween) Days" : "\(minutesBetween / 60) Hours"
            } else {
                cCellContent.labelOtherSide.text = formattedDate
            }
        } else {
            let temp = cCellContent.labelOtherSide.text
            if (temp?.contains("Days"))! {
                let daysBetween = temp?.components(separatedBy: " ").dropLast().joined()
                let nextWeek = Calendar.current.date(byAdding: .day, value: Int(daysBetween!)! + 1, to: Date())
                cellContent.datePicker.date = nextWeek!
            } else if (temp?.contains("Hours"))! {
                let daysBetween = temp?.components(separatedBy: " ").dropLast().joined()
                let nextWeek = Calendar.current.date(byAdding: .hour, value: Int(daysBetween!)! + 1, to: Date())
                cellContent.datePicker.date = nextWeek!
            } else {
                let date = formatter.date(from: cCellContent.labelOtherSide.text!)
                cellContent.datePicker.date = date!
            }
        }
        let daysBetween : Int = Calendar.current.dateComponents([.day], from: Date(), to: cellContent.datePicker.date).day!
        //let minutesBetween : Int = Calendar.current.dateComponents([.minute], from: Date(), to: cellContent.datePicker.date).minute!
        addChallengeIns[deadlineIndex].resultText = getDateAsFormatted(date: cellContent.datePicker.date)
        //let text = daysBetween != 0 ? "\(daysBetween) Days" : "\(minutesBetween / 60) Hours"
        //addViewContent.addChallenge.untilDateLabel.text = (!isToWorld() && !isSelf()) ? "CHALLENGE TIME is \(text)" : "LAST \(text)"
        return daysBetween
    }
    
    @objc func getHeight(switchOfCell: Bool) -> CGFloat {
        if switchOfCell {
            return tableRowHeightHeight
        } else {
            return zeroHeight
        }
    }
    
    @objc var switchType : Bool = false;
    @objc var switchDateP : Bool = false;
    @objc var switchDeadline : Bool = true;
    @objc var switchProofCell : Bool = false;
    @objc var switchLeftPeopleCell : Bool = false;
    @objc var switchRightPeopleCell : Bool = true;
    @objc var switchDone : Bool = false;
    @objc var switchScore : Bool = false;
    @objc var switchResult : Bool = false;
    @objc var switchProof : Bool = true;
    @objc var switchSubject : Bool = true;
    @objc var switchComment : Bool = true;
    @objc var switchtoPublic : Bool = false;
    @objc var zeroHeight : CGFloat = 0
    @objc var commentCellHeight : CGFloat = 44*2.5
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
            return screenWidth*0.8+screenWidth*0.1/10 //switchProof ? tableRowHeightHeight*3 : 0
            //return getHeight(switchOfCell: switchProof)
        } else if indexPath == toPublicPath {
            return getHeight(switchOfCell: switchtoPublic)
        } else if indexPath == calenddarIndexPath {
            if switchDateP {
                return 224
            } else {
                return zeroHeight
            }
        } else if indexPath == addViewIndexPath {
            return zeroHeight // (screenWidth * chlViewHeight) + (tableRowHeightHeight / 2)
        } else {
            return tableRowHeightHeight
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 14
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
            cell.datePicker.addTarget(self, action: #selector(self.pickedDate), for: UIControlEvents.valueChanged)
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
            //cell.labelOtherSide.attributedText = addChallengeIns[proofIndex].labelAtt
        } else if indexPath == commentIndexPath {
            let frameOfCellComment : CGRect = CGRect(x: 0, y: 0, width: self.view.frame.width, height: tableRowHeightHeight)
            let cellComment = TableViewCommentCellContent(frame: frameOfCellComment, cellRow: indexPath.row, typeIndex: addChallengeIns[typeIndex].resultId!)
            cellComment.label.text = addChallengeIns[commentIndex].labelText
            cellComment.selectionStyle = UITableViewCellSelectionStyle.none
            cellComment.commentView.text = addChallengeIns[commentIndex].resultText
            cellComment.isHidden = !switchComment
            cellComment.commentView.delegate = self
            return cellComment
        } else if indexPath == toPublicPath {
            cell.label.text = addChallengeIns[toPublicIndex].labelText
            cell.isHidden = !switchtoPublic
            cell.toPublicControl.selectedSegmentIndex = addChallengeIns[toPublicIndex].resultId!
            print(cell.toPublicControl.selectedSegmentIndex)
            cell.toPublicControl.addTarget(self, action: #selector(self.toPublicControlChange), for: UIControlEvents.valueChanged)
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
    
    @objc var beforeEstimatedSize = CGSize(width: screenWidth, height: 44)
    override func textViewDidChange(_ textView: UITextView) {
        let commentContent = tableView.cellForRow(at: commentIndexPath) as! TableViewCommentCellContent
        let size = CGSize(width: commentContent.commentView.frame.width, height: .infinity)
        let estimatedSize = commentContent.commentView.sizeThatFits(size)
        commentContent.commentView.constraints.forEach{ (constraint) in
            if constraint.firstAttribute == .height {
                constraint.constant = estimatedSize.height
                commentCellHeight = estimatedSize.height + tableRowHeightHeight*1.6
                if beforeEstimatedSize.height != estimatedSize.height {
                    updateTable()
                }
                addChallengeIns[commentIndex].resultText = commentContent.commentView.text
                tableView.scrollToRow(at: commentIndexPath, at: .bottom, animated: false)
                beforeEstimatedSize = estimatedSize
            }
        }
    }
    
    @objc func updateTable() {
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
    }
    
    @objc func deadlinesChanged() {
        let calendarContent = tableView.cellForRow(at: calenddarIndexPath) as! TableViewCellContent
        let selectedIndex = calendarContent.deadLines.selectedSegmentIndex
        let day : Int = selectedIndex == 0 ? 1 : (selectedIndex == 1 ? 7 : (selectedIndex == 2 ? 30 : 365) )
        calendarContent.datePicker.date = Calendar.current.date(byAdding: .day, value: day, to: Date())!
        _ = getDayBetweenDates(isSelect: true)
    }
    
    @objc func pickedDate() {
        _ = getDayBetweenDates(isSelect: true)
    }
    
    @objc func doneSwitch() {
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
        // let addViewContent = getCell(path: addViewIndexPath)
        //let subjectContent = getCell(path: subjectIndexPath)
        if popIndexPath != subjectIndexPath {
            segControlChange(isNotAction : true, popIndexPath : popIndexPath)
        }/* else {
            addViewContent.addChallenge.subjectLabel.text = subjectContent.labelOtherSide.text
            if isSelf() {
                let imageName = addViewContent.addChallenge.subjectLabel.text?.replacingOccurrences(of: " ", with: "_")
                setImage(name: imageName, imageView: addViewContent.addChallenge.firstOnePeopleImageView)
            }
        }*/
        if popIndexPath == leftSideIndex || popIndexPath == rightSideIndex {
            if popIndexPath == leftSideIndex {
                leftSide = result
                if rightSide.count != leftSide.count {
                    rightSide.removeAll()
                    tableView.reloadRows(at: [rightSideIndex], with: .fade)
                }
            } else if popIndexPath == rightSideIndex {
                rightSide = result
                let toPublicCell = getCell(path: toPublicPath)
                toPublicCell.toPublicControl.selectedSegmentIndex = rightSide.count == 0 ? 1 : 0
                addChallengeIns[toPublicIndex].resultId = rightSide.count == 0 ? 1 : 0
                if rightSide.count != leftSide.count {
                    leftSide.removeAll()
                    tableView.reloadRows(at: [leftSideIndex], with: .fade)
                }
            }
            //prepareViewForSelection(result: result, popIndexPath: popIndexPath, reset: false)
        }
    }
    
    @objc func toPublicControlChange(isNotAction : Bool, popIndexPath : IndexPath) {
        let toPublicControlContent = getCell(path: toPublicPath)
        addChallengeIns[toPublicIndex].resultId = toPublicControlContent.toPublicControl.selectedSegmentIndex
        //prepareViewForSelection(result: getUnknown(), popIndexPath: leftSideIndex, reset: true)
    }
    
    func getUnknown() -> [SelectedItems]{
        var selItems = [SelectedItems]()
        let selItem = SelectedItems()
        selItem.name = "unknown"
        selItems.append(selItem)
        return selItems
    }
    
    @objc func segControlChange(isNotAction : Bool, popIndexPath : IndexPath) {
        let segControlContent = getCell(path: segControlIndexPath)
        var doneContent : TableViewCellContent!
        if !isNotAction {
            createAddChallengeInstance()
            addChallengeIns[typeIndex].resultId = segControlContent.mySegControl.selectedSegmentIndex
            if firstPage {
                switchDone = isPublic() ? false : true
                switchtoPublic = isPublic() ? true : false
                tableView.reloadRows(at: [toPublicPath], with: .fade)
            }
            tableView.reloadRows(at: [calenddarIndexPath], with: .fade)
            doneContent = getCell(path: doneIndexPath)
            doneContent.isDone.setOn(false, animated: false)
            // tableView.reloadRows(at: [addViewIndexPath], with: .fade)
            //prepareViewForSelection(result: getUnknown(), popIndexPath: popIndexPath, reset: true)
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
            // tableView.reloadRows(at: [addViewIndexPath], with: .fade)
        }
    }
    
    func prepareViewForSelection(result : [SelectedItems], popIndexPath : IndexPath, reset : Bool) {
        let isLeftSide = popIndexPath == leftSideIndex
        let isRightSide = popIndexPath == rightSideIndex        
        if isPublic() {
            /* if reset {
                setChlrPeopleImages(result : result, reset: !reset)
            } */
            setPeopleImages(result : result, reset: false)
        } else if isPrivate() || isSelf() {
            if isLeftSide {
                setChlrPeopleImages(result : result, reset: false)
                if rightSide.count != leftSide.count {
                    var resultForReset = [SelectedItems]()
                    for _ in 0...leftSide.count - 1 {
                        let items = SelectedItems()
                        items.fbId = ""
                        items.id = ""
                        items.name = ""
                        resultForReset.append(items)
                    }
                    rightSide = resultForReset
                    setPeopleImages(result : resultForReset, reset: true)
                } else {
                    setPeopleImages(result : rightSide, reset: false)
                }
            }
            if isRightSide {
                setPeopleImages(result : result, reset: false)
                if rightSide.count != leftSide.count {
                    var resultForReset = [SelectedItems]()
                    for _ in 0...rightSide.count - 1 {
                        let items = SelectedItems()
                        items.fbId = ""
                        items.id = ""
                        items.name = ""
                        resultForReset.append(items)
                    }
                    resultForReset[0].fbId = memberFbID
                    resultForReset[0].id = memberID
                    resultForReset[0].name = memberName
                    leftSide = resultForReset
                    setChlrPeopleImages(result : resultForReset, reset: true)
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
                _ = getDayBetweenDates(isSelect: false)
            } else {
                addViewContent.addChallenge.untilDateLabel.isHidden = true
                addViewContent.addChallenge.finishFlag.isHidden = false
            }
        }
        addViewContent.addChallenge.generateSecondTeam(count: result.count)
        if result.count == 1 {
            setImage(fbID: result[0].fbId, imageView: addViewContent.addChallenge.firstOnePeopleImageView, reset: reset)
            addViewContent.addChallenge.firstOnePeopleImageView.contentMode = .scaleAspectFill
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
    
    @objc func updateScoreAndResult(indexPath: IndexPath) {
        if indexPath == scoreIndexPath {
            let scoreContent = getCell(path: scoreIndexPath)
            addChallengeIns[scoreIndex].labelAtt = NSMutableAttributedString(string: scoreContent.labelOtherSide.text!, attributes: [NSAttributedStringKey.font: UIFont(name: "EuphemiaUCAS", size: 18)!])
        }
        if indexPath == resultIndexPath {
            let resultContent = getCell(path: resultIndexPath)
            addChallengeIns[resultIndex].labelAtt = NSMutableAttributedString(string: resultContent.labelOtherSide.text!, attributes: [NSAttributedStringKey.font: UIFont(name: "EuphemiaUCAS", size: 18)!])
        }
    }
}
