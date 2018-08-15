//
//  UIFontExtension.swift
//  facebookfeed2
//
//  Created by iakay on 11.05.2018.
//  Copyright © 2018 challenge. All rights reserved.
//

import UIKit

extension UITableViewController
{
    @objc func setImage(fbID: String?, imageView: UIImageView, reset : Bool) {
        if reset && fbID != memberFbID {
            setImage(name: unknown, imageView: imageView)
        } else if let peoplefbID = fbID {            
            let url = URL(string: "https://graph.facebook.com/\(peoplefbID)/picture?type=large&return_ssl_resources=1")
            imageView.load(url: url!)
        }
    }
    
    override func setImage(name: String?, imageView: UIImageView) {
        if let peopleImage = name {
            imageView.image = UIImage(named: peopleImage)
        }
    }    
}

extension UITableView {
    
    public var boundsWithoutInset: CGRect {
        var boundsWithoutInset = bounds
        boundsWithoutInset.origin.y += contentInset.top
        boundsWithoutInset.size.height -= contentInset.top + contentInset.bottom
        return boundsWithoutInset
    }
    
    public func isRowCompletelyVisible(at indexPath: IndexPath) -> Bool {
        let rect = rectForRow(at: indexPath)
        return boundsWithoutInset.contains(rect)
    }
}
