//
//  AddChallengeController.swift
//  facebookfeed2
//
//  Created by iakay on 20.02.2018.
//  Copyright © 2018 challenge. All rights reserved.
//

import UIKit

class AddChallengeController: UITableViewController {
    
    let screenSize = UIScreen.main.bounds
    var tableRowHeightHeight: CGFloat = 44
    var chlViewHeight: CGFloat = 17.5/30
    let addViewIndexPath = IndexPath(item: 0, section: 0)
    let segControlIndexPath = IndexPath(item: 1, section: 0)
    let subjectIndexPath = IndexPath(item: 2, section: 0)
    let leftSideIndex = IndexPath(item: 3, section: 0)
    let rightSideIndex = IndexPath(item: 4, section: 0)
    let deadlineIndexPath = IndexPath(item: 5, section: 0)
    let calenddarIndexPath = IndexPath(item: 6, section: 0)
    let proofIndexPath = IndexPath(item: 7, section: 0)
    var subjects = [Subject]()
    var friends = [Friends]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Add Challenge"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCellAdd")
        tableView.tableFooterView = UIView()
        self.view.backgroundColor =  UIColor.rgb(229, green: 231, blue: 235)
        let rightButton = UIBarButtonItem(title: "Add", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.addChallenge))
        navigationItem.rightBarButtonItem = rightButton
        rightButton.tintColor = UIColor.white
        
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
    }
    
    func addChallenge() {
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 2 {
            let selectionTable = SelectionTableViewController()
            var selItems = [SelectedItems]()
            for subj in self.subjects {
                let selItem = SelectedItems()
                selItem.name = subj.name
                selItems.append(selItem)
            }
            selectionTable.items = selItems
            selectionTable.tableTitle = "Subjects"
            selectionTable.popIndexPath = indexPath
            self.navigationController?.pushViewController(selectionTable, animated: true)
        } else if indexPath.row == 3 || indexPath.row == 4 {
            let selectionTable = SelectionTableViewController()
            var selItems = [SelectedItems]()
            for fri in self.friends {
                let selItem = SelectedItems()
                selItem.name = fri.name
                selItem.id = fri.id
                selItems.append(selItem)
            }
            let segControlContent = tableView.cellForRow(at: segControlIndexPath) as! TableViewCellContent
            var selItemsWithoutWorld = [SelectedItems]()
            selItemsWithoutWorld = selItems
            selItemsWithoutWorld.removeLast()
            if segControlContent.mySegControl.selectedSegmentIndex != 0 || indexPath.row == 3 {
                selectionTable.items = selItemsWithoutWorld
            } else {
                selectionTable.items = selItems
            }
            selectionTable.tableTitle = "Friends"
            selectionTable.popIndexPath = indexPath
            self.navigationController?.pushViewController(selectionTable, animated: true)
        } else if indexPath.row == 5 {
            let cellContent = tableView.cellForRow(at: calenddarIndexPath) as! TableViewCellContent
            let cCellContent = tableView.cellForRow(at: deadlineIndexPath) as! TableViewCellContent
            let addViewCellContent = tableView.cellForRow(at: addViewIndexPath) as! TableViewCellContent
            let formatter = DateFormatter()
            formatter.dateFormat = "dd-MM-yyyy HH:mm"
            let formattedDate = formatter.string(from: cellContent.datePicker.date)
            cCellContent.labelOtherSide.text = formattedDate
            switchDateP = !switchDateP
            tableView.reloadRows(at: [calenddarIndexPath], with: .fade)
            let daysBetween : Int = Calendar.current.dateComponents([.day], from: Date(), to: cellContent.datePicker.date).day!
            addViewCellContent.addChallenge.untilDateLabel.text = "LAST \(daysBetween) DAYS"
            self.tableView?.scrollToRow(at: proofIndexPath, at: UITableViewScrollPosition.bottom, animated: true)
        }
    }
    var switchDateP : Bool = false;
    var switchProofCell : Bool = true;
    var switchLeftPeopleCell : Bool = false;
    var switchRightPeopleCell : Bool = true;
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 6 {
            if switchDateP {
                return 180
            } else {
                return 0
            }
        } else if indexPath.row == 7 {
            if switchProofCell {
                return tableRowHeightHeight
            } else {
                return 0
            }
        } else if indexPath.row == 3 {
            if switchLeftPeopleCell {
                return tableRowHeightHeight
            } else {
                return 0
            }
        } else if indexPath.row == 4 {
            if switchRightPeopleCell {
                return tableRowHeightHeight
            } else {
                return 0
            }
        } else if indexPath.row != 0 {
            return tableRowHeightHeight
        } else {
            return (screenSize.width * chlViewHeight) + tableRowHeightHeight
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // let cell = tableView.dequeueReusableCell(withIdentifier: "MyCellAdd", for: indexPath as IndexPath)
        let frameOfCell : CGRect = CGRect(x: 0, y: 0, width: self.view.frame.width, height: tableRowHeightHeight)
        let cell = TableViewCellContent(frame: frameOfCell, cellRow: indexPath.row)
        if indexPath.row == 0 {
            cell.selectionStyle = UITableViewCellSelectionStyle.none
        } else if indexPath.row == 1 {
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            cell.label.text = "Type"
            cell.mySegControl.addTarget(self, action: #selector(self.segControlChange), for: UIControlEvents.valueChanged)
        } else if indexPath.row == 2 {
            cell.label.text = "Subject"
            cell.labelOtherSide.text = "Select"
        } else if indexPath.row == 3 {
            cell.label.text = "Left Side"
            cell.labelOtherSide.text = "Select"
            cell.isHidden = !switchLeftPeopleCell
        } else if indexPath.row == 4 {
            cell.label.text = "Right Side"
            cell.labelOtherSide.text = "Select"
            cell.isHidden = !switchRightPeopleCell
        } else if indexPath.row == 5 {
            cell.label.text = "Deadline"
            let formatter = DateFormatter()
            formatter.dateFormat = "dd-MM-yyyy HH:mm"
            let formattedDate = formatter.string(from: cell.datePicker.date)
            cell.labelOtherSide.text = formattedDate
        } else if indexPath.row == 6 {
            cell.isHidden = !switchDateP
        } else if indexPath.row == 7 {
            cell.label.text = "Proof?"
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            cell.isHidden = !switchProofCell
        }
        return cell
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
        if popIndexPath.row != 2 {
            segControlChange(isNotAction : true, popIndexPath : popIndexPath)
        }
        if popIndexPath.row == 3 || popIndexPath.row == 4 {
            prepareViewForSelection(result: result, popIndexPath: popIndexPath, reset: false)
        }
    }
    
    func segControlChange(isNotAction : Bool, popIndexPath : IndexPath) {
        let addViewContent = tableView.cellForRow(at: addViewIndexPath) as! TableViewCellContent
        let segControlContent = tableView.cellForRow(at: segControlIndexPath) as! TableViewCellContent
        let subjectContent = tableView.cellForRow(at: subjectIndexPath) as! TableViewCellContent
        let leftSideContent = tableView.cellForRow(at: leftSideIndex) as! TableViewCellContent
        let rightSideContent = tableView.cellForRow(at: rightSideIndex) as! TableViewCellContent
        if subjectContent.labelOtherSide.text != "Select" {
            addViewContent.addChallenge.subjectLabel.text = subjectContent.labelOtherSide.text
        }
        var selItems = [SelectedItems]()
        let selItem = SelectedItems()
        selItem.name = "unknown"
        selItems.append(selItem)
        prepareViewForSelection(result: selItems, popIndexPath: popIndexPath, reset: true)
        switchProofCell = false
        switchLeftPeopleCell = true
        switchRightPeopleCell = true
        addViewContent.addChallenge.firstOnePeopleImageView.contentMode = .scaleAspectFill
        var subjectImage = "unknown"
        if segControlContent.mySegControl.selectedSegmentIndex == 0 {
            switchProofCell = true
            switchLeftPeopleCell = false
        } else if segControlContent.mySegControl.selectedSegmentIndex == 1 {
            if subjectContent.labelOtherSide.text != "Select" {
                subjectImage = subjectContent.labelOtherSide.text!
            }
            switchLeftPeopleCell = false
            switchRightPeopleCell = false
        }
        setImage(name: subjectImage, imageView: addViewContent.addChallenge.firstOnePeopleImageView)
        if !isNotAction {
            tableView.reloadRows(at: [leftSideIndex], with: .fade)
            tableView.reloadRows(at: [rightSideIndex], with: .fade)
            tableView.reloadRows(at: [proofIndexPath], with: .fade)
        } else if popIndexPath.row == 3 || popIndexPath.row == 4 {
            tableView.reloadRows(at: [addViewIndexPath], with: .fade)
        }
    }
    
    func prepareViewForSelection(result : [SelectedItems], popIndexPath : IndexPath, reset : Bool) {
        let segControlContent = tableView.cellForRow(at: segControlIndexPath) as! TableViewCellContent
        if segControlContent.mySegControl.selectedSegmentIndex == 0 {
            if reset {
                setChlrPeopleImages(result : result)
            }
            setPeopleImages(result : result)
        } else if segControlContent.mySegControl.selectedSegmentIndex == 1 {
            setPeopleImages(result : result)
            setChlrPeopleImages(result : result)
        } else if segControlContent.mySegControl.selectedSegmentIndex == 2 {
            setPeopleImages(result : result)
            setChlrPeopleImages(result : result)
        }
    }
    
    func setPeopleImages(result : [SelectedItems]) {
        let addViewIndexPath = IndexPath(item: 0, section: 0)
        let addViewContent = tableView.cellForRow(at: addViewIndexPath) as! TableViewCellContent
        addViewContent.addChallenge.generateSecondTeam(count: result.count)
        if result.count == 1 {
            setImage(name: result[0].id, imageView: addViewContent.addChallenge.firstOnePeopleImageView)
            // setImage(fbID: result[0].id, imageView: addViewContent.addChallenge.firstOnePeopleImageView)
            if result[0].name == "To World" {
                addViewContent.addChallenge.firstOnePeopleImageView.contentMode = .scaleAspectFit
            }
        } else if result.count == 2 {
            setImage(name: result[0].id, imageView: addViewContent.addChallenge.firstTwoPeopleImageView)
            setImage(name: result[1].id, imageView: addViewContent.addChallenge.secondTwoPeopleImageView)
        } else if result.count == 3 {
            setImage(name: result[0].id, imageView: addViewContent.addChallenge.firstThreePeopleImageView)
            setImage(name: result[1].id, imageView: addViewContent.addChallenge.secondThreePeopleImageView)
            setImage(name: result[2].id, imageView: addViewContent.addChallenge.thirdThreePeopleImageView)
        } else {
            setImage(name: result[0].id, imageView: addViewContent.addChallenge.firstFourPeopleImageView)
            setImage(name: result[1].id, imageView: addViewContent.addChallenge.secondFourPeopleImageView)
            setImage(name: result[2].id, imageView: addViewContent.addChallenge.thirdFourPeopleImageView)
            setImage(name: "more_icon", imageView: addViewContent.addChallenge.moreFourPeopleImageView)
        }
    }
    
    func setChlrPeopleImages(result : [SelectedItems]) {
        let addViewIndexPath = IndexPath(item: 0, section: 0)
        let addViewContent = tableView.cellForRow(at: addViewIndexPath) as! TableViewCellContent
        addViewContent.addChallenge.generateFirstTeam(count: result.count)
        if result.count == 1 {
            setImage(name: result[0].id, imageView: addViewContent.addChallenge.firstOneChlrPeopleImageView)
            // setImage(fbID: result[0].id, imageView: addViewContent.addChallenge.firstOneChlrPeopleImageView)
        } else if result.count == 2 {
            setImage(name: result[0].id, imageView: addViewContent.addChallenge.firstTwoChlrPeopleImageView)
            setImage(name: result[1].id, imageView: addViewContent.addChallenge.secondTwoChlrPeopleImageView)
        } else if result.count == 3 {
            setImage(name: result[0].id, imageView: addViewContent.addChallenge.firstThreeChlrPeopleImageView)
            setImage(name: result[1].id, imageView: addViewContent.addChallenge.secondThreeChlrPeopleImageView)
            setImage(name: result[2].id, imageView: addViewContent.addChallenge.thirdThreeChlrPeopleImageView)
        } else {
            setImage(name: result[0].id, imageView: addViewContent.addChallenge.firstFourChlrPeopleImageView)
            setImage(name: result[1].id, imageView: addViewContent.addChallenge.secondFourChlrPeopleImageView)
            setImage(name: result[2].id, imageView: addViewContent.addChallenge.thirdFourChlrPeopleImageView)
            setImage(name: "more_icon", imageView: addViewContent.addChallenge.moreFourChlrPeopleImageView)
        }
    }
    
    func setImage(fbID: String?, imageView: UIImageView) {
        if let peoplefbID = fbID {
            let url = URL(string: "https://graph.facebook.com/\(peoplefbID)/picture?type=large&return_ssl_resources=1")
            ImageService.getImage(withURL: url!) { image in
                imageView.image = image
            }
            //let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
            // imageView.image = UIImage(data: data!)
            // imageView.image = UIImage(named: peopleImage)
        }
    }
    
    func setImage(name: String?, imageView: UIImageView) {
        if let peopleImage = name {
            imageView.image = UIImage(named: peopleImage)
        }
    }
}

extension String
{
    func trim() -> String
    {
        let cs = CharacterSet.init(charactersIn: ", ")
        return self.trimmingCharacters(in: cs)
    }
}
