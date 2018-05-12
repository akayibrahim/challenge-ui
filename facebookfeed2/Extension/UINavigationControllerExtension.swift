//
//  UIFontExtension.swift
//  facebookfeed2
//
//  Created by iakay on 11.05.2018.
//  Copyright © 2018 challenge. All rights reserved.
//

import UIKit

extension UINavigationController {
    func viewController<T: UIViewController>(class: T.Type) -> T? {
        return viewControllers.filter({$0 is T}).first as? T
    }
}
