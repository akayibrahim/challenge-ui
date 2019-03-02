	//
//  CustomTabBarController.swift
//  facebookfeed2
//
//  Created by Brian Voong on 2/27/16.
//  Copyright © 2016 letsbuildthatapp. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        
        let feedController = FeedController(collectionViewLayout: UICollectionViewFlowLayout())
        let navigationController = UINavigationController(rootViewController: feedController)
        navigationController.title = "Home"
        navigationController.tabBarItem.image = UIImage(named: "news_feed_icon")
        // navigationController.hidesBarsOnSwipe = true
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let searchController = TrendsController(collectionViewLayout: layout)
        let secondNavigationController = UINavigationController(rootViewController: searchController)
        secondNavigationController.title = "Trends"
        secondNavigationController.tabBarItem.image = UIImage(named: "search")
        // secondNavigationController.isNavigationBarHidden = true
        
        let addChallengeController = AddChallengeController()
        let addNavigationController = UINavigationController(rootViewController: addChallengeController)
        addNavigationController.title = "Add"
        addNavigationController.tabBarItem.image = UIImage(named: "add_icon")
        
        let activiiesController = ActivitiesController()
        let notifyNavController = UINavigationController(rootViewController: activiiesController)
        notifyNavController.title = "Activity"
        notifyNavController.tabBarItem.image = UIImage(named: "activity")
        
        let selfChallengeController = FeedController(collectionViewLayout: UICollectionViewFlowLayout())
        let profileNavController = UINavigationController(rootViewController: selfChallengeController)
        profileNavController.title = "Profile"
        profileNavController.tabBarItem.image = UIImage(named: "requests_icon")
        
        viewControllers = [navigationController, secondNavigationController, addNavigationController, notifyNavController, profileNavController] //, moreNavController]
        
        let tabBarTitleOffset = UIOffsetMake(0,50)
        for controller in (viewControllers)! {
            controller.tabBarItem.titlePositionAdjustment = tabBarTitleOffset
            controller.title = ""
            controller.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
        }
        
        tabBar.isTranslucent = false
        
        let topBorder = CALayer()
        topBorder.frame = CGRect(x: 0, y: 0, width: 1000, height: 0.5)
        topBorder.backgroundColor = UIColor.rgb(229, green: 231, blue: 235).cgColor
        
        tabBar.layer.addSublayer(topBorder)
        tabBar.clipsToBounds = true
    }
    
    func removeTabbarItemsText() {
        if let items = self.tabBarController?.tabBar.items {
            for item in items {
                item.title = ""
                item.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
            }
        }
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let fromView: UIView = tabBarController.selectedViewController!.view
        let toView  : UIView = viewController.view
        if fromView == toView {
            if tabBarController.selectedIndex == chanllengeIndex {
                let controllers = tabBarController.viewControllers
                let navC = controllers![0] as! UINavigationController
                let feedC = navC.viewController(class: FeedController.self)
                // feedC?.reloadChlPage()
                if feedC?.posts.count != 0 {
                    let firstChlRow = IndexPath(item: 0, section: 0)
                    feedC?.collectionView?.scrollToItem(at: firstChlRow, at: .top, animated: false)
                }
                return true
            } else if tabBarController.selectedIndex == profileIndex {
                let controllers = tabBarController.viewControllers
                let navC = controllers![profileIndex] as! UINavigationController
                let feedC = navC.viewController(class: FeedController.self)
                // feedC?.reloadSelfPage()
                if feedC?.posts.count != 0 {
                    let firstChlRow = IndexPath(item: 0, section: 0)
                    feedC?.collectionView?.scrollToItem(at: firstChlRow, at: .top, animated: false)
                }
                return true
            } else if tabBarController.selectedIndex == trendsIndex {
                let controllers = tabBarController.viewControllers
                let navC = controllers![trendsIndex] as! UINavigationController
                let feedC = navC.viewController(class: TrendsController.self)
                // feedC?.reloadSelfPage()
                if feedC?.trendRequest.count != 0 {
                    let firstChlRow = IndexPath(item: 0, section: 0)
                    feedC?.collectionView?.scrollToItem(at: firstChlRow, at: .top, animated: false)
                }
                return true
            } else if tabBarController.selectedIndex == activityIndex {
                let controllers = tabBarController.viewControllers
                let navC = controllers![activityIndex] as! UINavigationController
                let feedC = navC.viewController(class: ActivitiesController.self)
                // feedC?.reloadSelfPage()
                if feedC?.activities.count != 0 {
                    let firstChlRow = IndexPath(item: 0, section: 0)
                    feedC?.tableView?.scrollToRow(at: firstChlRow, at: .top, animated: false)
                }
                return true
            }
            return false
        } else {
            let controllers = tabBarController.viewControllers
            let navC = controllers![addChallengeIndex] as! UINavigationController
            if viewController == navC {
                let feedC = navC.viewController(class: AddChallengeController.self)
                let proofCell = feedC?.getCell(path: proofIndexPath)
                if proofCell?.proofImageView.image == nil {
                    feedC?.imagePickerForProofUpload()
                }
                return true
            }
        }
        
        UIView.transition(from: fromView, to: toView, duration: 0.3, options: UIViewAnimationOptions.transitionCrossDissolve) { (finished:Bool) in
            
        }
        return true
    }
    
    @objc func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        /*
        if (tabBarController.selectedIndex == 0 && chlScrollMoveDown) || (tabBarController.selectedIndex == profileIndex && prflScrollMoveDown) {
            if let status = UIApplication.shared.value(forKey: "statusBar") as? UIView {
                status.backgroundColor = navAndTabColor
            }
            self.navigationController?.setNavigationBarHidden(true, animated: true)
        } else {
            if let status = UIApplication.shared.value(forKey: "statusBar") as? UIView {
                status.backgroundColor = nil
            }
            self.navigationController?.setNavigationBarHidden(false, animated: true)
        }
        if let status = UIApplication.shared.value(forKey: "statusBar") as? UIView {
            if (tabBarController.selectedIndex == 2 || tabBarController.selectedIndex == 3) {
                status.backgroundColor = nil
            } else {
                status.backgroundColor = navAndTabColor
            }
        }
        self.navigationController?.setNavigationBarHidden(true, animated: true)
     */
        if let status = UIApplication.shared.value(forKey: "statusBar") as? UIView {
            status.backgroundColor = nil
        }
        let controllers = tabBarController.viewControllers
        let navFeed = controllers![chlIndex] as! UINavigationController
        navFeed.setNavigationBarHidden(false, animated: false)
        let navAct = controllers![activityIndex] as! UINavigationController
        navAct.setNavigationBarHidden(false, animated: false)
        let navProfile = controllers![profileIndex] as! UINavigationController
        navProfile.setNavigationBarHidden(false, animated: false)
    }
}
