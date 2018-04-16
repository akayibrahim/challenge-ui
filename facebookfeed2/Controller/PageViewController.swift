//
//  OtherControllers.swift
//  facebookfeed2
//
//  Created by Brian Voong on 2/27/16.
//  Copyright © 2016 letsbuildthatapp. All rights reserved.
//

import UIKit

class PageViewController: UITableViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    let searchBar = UISearchBar()
    let buttonBar = UIView()
    let pageView = UIViewController()
    let segmentedControl = UISegmentedControl()
    var pages = [UIViewController]()
    // let pageControl = UIPageControl()
    let pageViewController = UIPageViewController(transitionStyle: UIPageViewControllerTransitionStyle.scroll, navigationOrientation: UIPageViewControllerNavigationOrientation.horizontal)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor =  UIColor.rgb(229, green: 231, blue: 235)
        tableView.tableFooterView = UIView()
        searchBar.placeholder = "Search"
        self.navigationItem.titleView = searchBar
        
        segmentedControl.insertSegment(withTitle: "Trends", at: 0, animated: true)
        segmentedControl.insertSegment(withTitle: "Follow Requests", at: 1, animated: true)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(segmentedControl)
        segmentedControl.topAnchor.constraint(equalTo: view.topAnchor, constant: searchBar.frame.height).isActive = true
        segmentedControl.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        segmentedControl.heightAnchor.constraint(equalToConstant: 30).isActive = true
        segmentedControl.backgroundColor = .clear
        segmentedControl.tintColor = .clear
        segmentedControl.addTarget(self, action: #selector(self.segControlChange), for: UIControlEvents.valueChanged)

        let attr = NSDictionary(object: UIFont(name: "DINCondensed-Bold", size: 18)!, forKey: NSFontAttributeName as NSCopying)
        segmentedControl.setTitleTextAttributes(attr as [NSObject : AnyObject], for: .normal)
        segmentedControl.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.lightGray]  as [NSObject : AnyObject], for: .normal)
        segmentedControl.setTitleTextAttributes(attr as [NSObject : AnyObject], for: .selected)
        segmentedControl.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.orange]  as [NSObject : AnyObject], for: .selected)
        
        buttonBar.translatesAutoresizingMaskIntoConstraints = false
        buttonBar.backgroundColor = UIColor.orange
        view.addSubview(buttonBar)
        buttonBar.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor).isActive = true
        buttonBar.heightAnchor.constraint(equalToConstant: 5).isActive = true
        buttonBar.widthAnchor.constraint(equalTo: segmentedControl.widthAnchor, multiplier: 1 / CGFloat(segmentedControl.numberOfSegments)).isActive = true
        
        pageView.view.translatesAutoresizingMaskIntoConstraints = false
        pageView.view.backgroundColor = UIColor.white
        view.addSubview(pageView.view)
        pageView.view.topAnchor.constraint(equalTo: buttonBar.bottomAnchor).isActive = true
        pageView.view.heightAnchor.constraint(equalToConstant: view.frame.height - (searchBar.frame.height + buttonBar.frame.height + (self.tabBarController?.tabBar.frame.height)!)).isActive = true
        pageView.view.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        pageViewController.dataSource = self
        pageViewController.delegate = self
        let initialPage = 0
        
        let selfChallengeController = FeedController(collectionViewLayout: UICollectionViewFlowLayout())
        let followController = FollowRequestController()
        self.pages.append(selfChallengeController)
        self.pages.append(followController)
        pageViewController.setViewControllers([pages[initialPage]], direction: .forward, animated: true, completion: nil)
        pageView.view.addSubview(pageViewController.view)
        pageViewController.view.topAnchor.constraint(equalTo: pageView.view.topAnchor).isActive = true
        pageViewController.view.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
 
        pageViewController.didMove(toParentViewController: pageView)

        /*
        self.pageControl.frame = CGRect()
        self.pageControl.currentPageIndicatorTintColor = UIColor.black
        self.pageControl.pageIndicatorTintColor = UIColor.lightGray
        self.pageControl.numberOfPages = self.pages.count
        self.pageControl.currentPage = initialPage
        self.view.addSubview(self.pageControl)
        
        self.pageControl.translatesAutoresizingMaskIntoConstraints = false
        self.pageControl.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -5).isActive = true
        self.pageControl.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -20).isActive = true
        self.pageControl.heightAnchor.constraint(equalToConstant: 20).isActive = true
        self.pageControl.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        */
    }
    
    func segControlChange(isComeFromOutside: Bool) {
        UIView.animate(withDuration: 0.1) {
            self.buttonBar.frame.origin.x = (self.segmentedControl.frame.width / CGFloat(self.segmentedControl.numberOfSegments)) * CGFloat(self.segmentedControl.selectedSegmentIndex)
        }
        if !isComeFromOutside {
            if segmentedControl.selectedSegmentIndex == 1 {
                pageViewController.setViewControllers([pages[segmentedControl.selectedSegmentIndex] as! UIViewController], direction: .forward, animated: true, completion: nil)
            } else {
                pageViewController.setViewControllers([pages[segmentedControl.selectedSegmentIndex] as! UIViewController], direction: .reverse, animated: true, completion: nil)
            }
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let viewControllerIndex = self.pages.index(of: viewController) {
            if viewControllerIndex == 0 {
                // wrap to last page in array
                segmentedControl.selectedSegmentIndex = 0
                segControlChange(isComeFromOutside: true)
                // return self.pages.last
            } else if viewControllerIndex == 1 {
                // go to previous page in array
                segmentedControl.selectedSegmentIndex = 0
                segControlChange(isComeFromOutside: true)
                return self.pages[viewControllerIndex - 1]
            }
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let viewControllerIndex = self.pages.index(of: viewController) {
            if viewControllerIndex == 0 { // < self.pages.count - 1 {
                // go to next page in array
                segmentedControl.selectedSegmentIndex = 1
                segControlChange(isComeFromOutside: true)
                return self.pages[viewControllerIndex + 1]
            } else if viewControllerIndex == 1 {
                // wrap to first page in array
                segmentedControl.selectedSegmentIndex = 1
                segControlChange(isComeFromOutside: true)
                // return self.pages.first
            }
        }
        return nil
    }
}
