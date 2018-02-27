//
//  OtherController.swift
//  facebookfeed2
//
//  Created by iakay on 20.02.2018.
//  Copyright © 2018 challenge. All rights reserved.
//

import UIKit

class OtherController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let screenSize = UIScreen.main.bounds
        let otherView = OtherView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height))
        otherView.backgroundColor = UIColor.lightGray
        self.view.addSubview(otherView)
        navigationItem.title = "Profiles & Settings"
    }
    
}

