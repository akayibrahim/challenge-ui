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
        navigationController.title = "Feeds"
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
        
        tabBar.isTranslucent = false
        
        let topBorder = CALayer()
        topBorder.frame = CGRect(x: 0, y: 0, width: 1000, height: 0.5)
        topBorder.backgroundColor = UIColor.rgb(229, green: 231, blue: 235).cgColor
        
        tabBar.layer.addSublayer(topBorder)
        tabBar.clipsToBounds = true        
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let fromView: UIView = tabBarController.selectedViewController!.view
        let toView  : UIView = viewController.view
        if fromView == toView {
            if tabBarController.selectedIndex == chanllengeIndex {
                let controllers = tabBarController.viewControllers
                let navC = controllers![0] as! UINavigationController
                let feedC = navC.viewController(class: FeedController.self)
                feedC?.onRefesh()
                return true
            }
            return false
        }
        
        UIView.transition(from: fromView, to: toView, duration: 0.3, options: UIViewAnimationOptions.transitionCrossDissolve) { (finished:Bool) in
            
        }
        return true
    }
    
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        
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
        }*/
        if let status = UIApplication.shared.value(forKey: "statusBar") as? UIView {
            status.backgroundColor = navAndTabColor
        }
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
}
