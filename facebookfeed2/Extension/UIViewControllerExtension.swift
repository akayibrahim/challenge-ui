//
//  UIFontExtension.swift
//  facebookfeed2
//
//  Created by iakay on 11.05.2018.
//  Copyright © 2018 challenge. All rights reserved.
//

import UIKit

extension UICollectionView {
    public func isRowCompletelyVisible(_ indexPath: IndexPath) -> Bool {
        let rect = self.collectionViewLayout.layoutAttributesForItem(at: indexPath)?.frame
        let completelyVisible = self.bounds.contains(rect!)
        return completelyVisible
    }
}

extension UIViewController
{
    @objc func setImage(fbID: String?, imageView: UIImageView) {
        if let peoplefbID = fbID {
            let url = URL(string: "https://graph.facebook.com/\(peoplefbID)/picture?type=large&return_ssl_resources=1")
            imageView.load(url: url!)            
        }
    }
    
    @objc func getTrendImage(challengeId: String, challengerId: String, completion: @escaping (_ image:UIImage?)->()) {
        if dummyServiceCall == false {
            let url = URL(string: downloadImageURL + "?challengeId=\(challengeId)&memberId=\(challengerId)")
            if let urlOfImage = url {                
                ImageService.getImage(withURL: urlOfImage) { image in
                    if image != nil {
                        DispatchQueue.main.async {
                            completion(image)
                        }
                    }
                }
            }
        }
    }
    
    @objc func getVideo(challengeId: String, challengerId: String, completion: @escaping (_ video:URL?)->()) {
        if dummyServiceCall == false {
            let url = URL(string: downloadVideoURL + "?challengeId=\(challengeId)&memberId=\(challengerId)")
            if let urlOfImage = url {
                VideoService.getVideo(withURL: urlOfImage, completion: { (videoData) in
                    if let video = videoData {
                        DispatchQueue.main.async {
                            completion(video as URL)
                        }
                    }
                })
            }
        } else {
            // self.setImage(name: unknownImage, imageView: imageView)
        }
    }
    
    @objc func getProofImageByObjectId(imageView: UIImageView, objectId: String, completion: @escaping (_ image:UIImage?)->()) {
        let url = URL(string: downloadProofImageByObjectIdURL + "?objectId=\(objectId)")
        if let urlOfImage = url {
            ImageService.getImage(withURL: urlOfImage) { image in
                if image != nil {
                    DispatchQueue.main.async {
                        completion(image)
                    }
                }
            }
        }
    }
    
    @objc func setImage(name: String?, imageView: UIImageView) {
        if let peopleImage = name {
            imageView.image = UIImage(named: peopleImage)
        }
    }
    
    @objc func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UITableViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func popupAlert(message: String, willDelay: Bool) {
        DispatchQueue.main.async {
            let selectAlert: UIAlertController = UIAlertController(title: nil, message: message, preferredStyle: UIAlertControllerStyle.alert)
            if !willDelay {
                selectAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            }
            self.present(selectAlert, animated: true, completion: nil)
            if willDelay {
                let when = DispatchTime.now() + 1
                DispatchQueue.main.asyncAfter(deadline: when){
                    // your code with delay
                    selectAlert.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
}

extension UIViewController: UITextViewDelegate {
    public func textViewDidChange(_ textView: UITextView) {
        let size = CGSize(width: textView.frame.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        textView.constraints.forEach{ (constraint) in
            if constraint.firstAttribute == .height {
                constraint.constant = estimatedSize.height                
            }
        }
    }
}
