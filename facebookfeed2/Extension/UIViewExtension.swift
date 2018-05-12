//
//  UIFontExtension.swift
//  facebookfeed2
//
//  Created by iakay on 11.05.2018.
//  Copyright © 2018 challenge. All rights reserved.
//

import UIKit

extension UIView {
    func setImage(fbID: String?, imageView: UIImageView) {
        if let peoplefbID = fbID {
            let url = URL(string: "https://graph.facebook.com/\(peoplefbID)/picture?type=large&return_ssl_resources=1")
            ImageService.getImage(withURL: url!) { image in
                if image != nil {
                    imageView.image = image
                } else {
                    self.setImage(name: unknown, imageView: imageView)
                }
            }
            //let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
            // imageView.image = UIImage(data: data!)
            // imageView.image = UIImage(named: peopleImage)
        }
    }
    
    func setImage(name: String?, imageView: UIImageView) {
        if let peopleImage = name {
            imageView.image = UIImage(named: peopleImage)
        }
    }
    
    func addConstraintsWithFormat(_ format: String, views: UIView...) {
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            viewsDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
    }
    
    func addTopAnchor(_ view: UIView, anchor: NSLayoutAnchor<NSLayoutYAxisAnchor>, constant: CGFloat) {
        view.topAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
        view.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func addBottomAnchor(_ view: UIView, anchor: NSLayoutAnchor<NSLayoutYAxisAnchor>, constant: CGFloat) {
        view.bottomAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
        view.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func addLeadingAnchor(_ view: UIView, anchor: NSLayoutAnchor<NSLayoutXAxisAnchor>, constant: CGFloat) {
        view.leadingAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
        view.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func addTrailingAnchor(_ view: UIView, anchor: NSLayoutAnchor<NSLayoutXAxisAnchor>, constant: CGFloat) {
        view.trailingAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
        view.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func addWidthAnchor(_ view: UIView, multiplier: CGFloat) {
        let screenSize = UIScreen.main.bounds
        view.widthAnchor.constraint(equalToConstant: screenSize.width * multiplier).isActive = true
    }
    
    func addHeightAnchor(_ view: UIView, multiplier: CGFloat) {
        let screenSize = UIScreen.main.bounds
        view.heightAnchor.constraint(equalToConstant: screenSize.width * multiplier).isActive = true
    }
}
