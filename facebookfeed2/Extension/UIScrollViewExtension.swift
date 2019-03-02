//
//  UIFontExtension.swift
//  facebookfeed2
//
//  Created by iakay on 11.05.2018.
//  Copyright © 2018 challenge. All rights reserved.
//

import UIKit

extension UIScrollView {
    
    @objc var isAtTop: Bool {
        return contentOffset.y <= verticalOffsetForTop
    }
    
    @objc var isAtBottom: Bool {
        return contentOffset.y >= verticalOffsetForBottom
    }
    
    @objc var verticalOffsetForTop: CGFloat {
        let topInset = contentInset.top
        return -topInset
    }
    
    @objc var verticalOffsetForBottom: CGFloat {
        let scrollViewHeight = bounds.height
        let scrollContentSizeHeight = contentSize.height
        let bottomInset = contentInset.bottom
        let scrollViewBottomOffset = scrollContentSizeHeight + bottomInset - scrollViewHeight
        return scrollViewBottomOffset
    }
    
    func statusBarVisibility(_ navBarHidden: Bool) {
        if navBarHidden {
            if let status = UIApplication.shared.value(forKey: "statusBar") as? UIView {
                status.backgroundColor = statusBarColor
            }
        } else {
            if let status = UIApplication.shared.value(forKey: "statusBar") as? UIView {
                status.backgroundColor = nil
            }
        }
    }
}
