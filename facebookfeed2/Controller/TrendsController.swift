//
//  OtherControllers.swift
//  facebookfeed2
//
//  Created by Brian Voong on 2/27/16.
//  Copyright © 2016 letsbuildthatapp. All rights reserved.
//

import UIKit

class TrendsController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    let searchBar = UISearchBar()
    var trendRequest = [TrendRequest]()
    let cellId = "cellId"
    var refreshControl : UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor =  UIColor.rgb(229, green: 231, blue: 235)
        searchBar.placeholder = "Search"
        searchBar.delegate = self
        searchBar.autocapitalizationType = UITextAutocapitalizationType.allCharacters
        
        self.navigationItem.titleView = searchBar
        collectionView!.register(TrendRequestCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.backgroundColor = UIColor(white: 0.95, alpha: 1)
        collectionView?.alwaysBounceVertical = true
        collectionView?.showsVerticalScrollIndicator = false

        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.onRefesh), for: UIControlEvents.valueChanged)
        collectionView?.addSubview(refreshControl)
        
        loadTrends()
        
        self.hideKeyboardWhenTappedAround()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBarCancelButton()
        onRefesh()
    }
    
    func searchBarCancelButton() {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked( _ searchBar: UISearchBar) {
        if dummyServiceCall == false {
            fetchTrendChallenges(key: searchBar.text!)
            return
        } else {
            searchDummy()
            return
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
    }
    
    func searchDummy() {
        if let path = Bundle.main.path(forResource: "trend_request_1", ofType: "json") {
            do {
                let data = try(Data(contentsOf: URL(fileURLWithPath: path), options: NSData.ReadingOptions.mappedIfSafe))
                let jsonDictionary = try(JSONSerialization.jsonObject(with: data, options: .mutableContainers)) as? [String: Any]
                if let postsArray = jsonDictionary?["posts"] as? [[String: AnyObject]] {
                    self.trendRequest = [TrendRequest]()
                    for postDictionary in postsArray {
                        let trendReq = TrendRequest()
                        trendReq.setValuesForKeys(postDictionary)
                        self.trendRequest.append(trendReq)
                    }
                }
            } catch let err {
                print(err)
            }
        }
        self.collectionView?.reloadData()
        searchBar.resignFirstResponder()
    }
    
    func onRefesh() {
        self.loadTrends()
        self.collectionView?.reloadData()
        refreshControl.endRefreshing()
    }
    
    func loadTrends() {
        if dummyServiceCall == false {
            fetchTrendChallenges(key: "")
            return
        } else {
            self.trendRequest = ServiceLocator.getTrendChallengesFromDummy(jsonFileName: "trend_request")
            return
        }
    }
    
    func fetchTrendChallenges(key: String) {
        let urlStr = getTrendChallengesURL + memberID + "&subjectSearchKey=" + key
        let urlStrWithPerm = urlStr.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        let url = NSURL(string: urlStrWithPerm!)!
        URLSession.shared.dataTask(with: url as URL, completionHandler: { (data, response, error) -> Void in
            if error == nil && data != nil {
                do {
                    if let postsArray = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [[String: AnyObject]] {
                        self.trendRequest = [TrendRequest]()
                        for postDictionary in postsArray {
                            let trend = TrendRequest()
                            trend.setValuesForKeys(postDictionary)
                            self.trendRequest.append(trend)
                        }
                    }
                } catch let err {
                    print(err)
                }
            }
            DispatchQueue.main.async {
                self.collectionView?.reloadData()
            }
        }).resume()
    }
    
    var downImage: UIImage?
    func downloadImage(requestImageView: UIImageView, challengeId: String) {
        getTrendImage(imageView: requestImageView, challengeId: challengeId)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width, height: self.view.frame.width * 1.3 / 2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! TrendRequestCell
        cell.trendRequest = trendRequest[indexPath.row]
        downloadImage(requestImageView: cell.requestImageView, challengeId: trendRequest[indexPath.row].challengeId!)
        return cell
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        openExplorer(challengeId: trendRequest[indexPath.row].challengeId!)
    }
    
    func openExplorer(challengeId: String) {
        let challengeController = FeedController(collectionViewLayout: UICollectionViewFlowLayout())
        challengeController.navigationItem.title = "Explorer"
        challengeController.hidesBottomBarWhenPushed = true
        challengeController.challengIdForTrendAndExplorer = challengeId
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.pushViewController(challengeController, animated: true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return trendRequest.count
    }
    
    var lastContentOffSet : CGFloat = 0
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (scrollView.contentOffset.y >= 0 && self.lastContentOffSet < scrollView.contentOffset.y) || (scrollView.contentOffset.y > 0 && scrollView.isAtBottom) {
            // move down
            if let status = UIApplication.shared.value(forKey: "statusBar") as? UIView {
                status.backgroundColor = navAndTabColor
            }
            self.navigationController?.setNavigationBarHidden(true, animated: true)
        } else {
            // move up
            if let status = UIApplication.shared.value(forKey: "statusBar") as? UIView {
                status.backgroundColor = nil
            }
            self.navigationController?.setNavigationBarHidden(false, animated: true)
        }
        self.lastContentOffSet = scrollView.contentOffset.y
    }
}
