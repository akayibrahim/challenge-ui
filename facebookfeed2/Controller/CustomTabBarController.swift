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
        navigationController.hidesBarsOnSwipe = true
        
        let friendRequestsController = FriendRequestsController()
        let secondNavigationController = UINavigationController(rootViewController: friendRequestsController)
        secondNavigationController.title = "Friends"
        secondNavigationController.tabBarItem.image = UIImage(named: "requests_icon")
        // secondNavigationController.isNavigationBarHidden = true
        
        let addChallengeController = AddChallengeController()
        let messengerNavigationController = UINavigationController(rootViewController: addChallengeController)
        messengerNavigationController.title = "Add"
        messengerNavigationController.tabBarItem.image = UIImage(named: "add_icon")
        
        let selfChallengeController = FeedController(collectionViewLayout: UICollectionViewFlowLayout())
        let notificationsNavController = UINavigationController(rootViewController: selfChallengeController)
        notificationsNavController.title = "Self's"
        notificationsNavController.tabBarItem.image = UIImage(named: "selfs")
        
        let otherController = OtherController()
        let moreNavController = UINavigationController(rootViewController: otherController)
        moreNavController.title = ""
        moreNavController.tabBarItem.image = UIImage(named: "more_icon")
        
        viewControllers = [navigationController, secondNavigationController, messengerNavigationController, notificationsNavController, moreNavController]
        
        tabBar.isTranslucent = false
        
        let topBorder = CALayer()
        topBorder.frame = CGRect(x: 0, y: 0, width: 1000, height: 0.5)
        topBorder.backgroundColor = UIColor.rgb(229, green: 231, blue: 235).cgColor
        
        tabBar.layer.addSublayer(topBorder)
        tabBar.clipsToBounds = true
        
    }
}
