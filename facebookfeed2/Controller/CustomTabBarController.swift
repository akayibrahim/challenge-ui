	//
//  CustomTabBarController.swift
//  facebookfeed2
//
//  Created by Brian Voong on 2/27/16.
//  Copyright © 2016 letsbuildthatapp. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let feedController = FeedController(collectionViewLayout: UICollectionViewFlowLayout())
        let navigationController = UINavigationController(rootViewController: feedController)
        navigationController.title = "Challenges"
        navigationController.tabBarItem.image = UIImage(named: "news_feed_icon")
        // navigationController.hidesBarsOnSwipe = true
        /*
        let statusFrame = CGRect(x: 0.0, y: 0, width: self.view.bounds.size.width, height: UIApplication.shared.statusBarFrame.size.height)
        let statusBar = UIView(frame: statusFrame)
        statusBar.backgroundColor = navigationColor
        navigationController.view.addSubview(statusBar)
        */
        let searchController = PageViewController()
        let secondNavigationController = UINavigationController(rootViewController: searchController)
        secondNavigationController.title = "Search"
        secondNavigationController.tabBarItem.image = UIImage(named: "search")
        // secondNavigationController.isNavigationBarHidden = true
        
        let addChallengeController = AddChallengeController()
        let messengerNavigationController = UINavigationController(rootViewController: addChallengeController)
        messengerNavigationController.title = "Add"
        messengerNavigationController.tabBarItem.image = UIImage(named: "add_icon")
        
        let selfChallengeController = FeedController(collectionViewLayout: UICollectionViewFlowLayout())
        let notificationsNavController = UINavigationController(rootViewController: selfChallengeController)
        notificationsNavController.title = "Profile"
        notificationsNavController.tabBarItem.image = UIImage(named: "requests_icon")
        /*
        let otherController = OtherController()
        let moreNavController = UINavigationController(rootViewController: otherController)
        moreNavController.title = ""
        moreNavController.tabBarItem.image = UIImage(named: "more_icon")
        */
        viewControllers = [navigationController, secondNavigationController, messengerNavigationController, notificationsNavController] //, moreNavController]
        
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
            return false
        }
        
        UIView.transition(from: fromView, to: toView, duration: 0.3, options: UIViewAnimationOptions.transitionCrossDissolve) { (finished:Bool) in
            
        }
        return true
    }
}
