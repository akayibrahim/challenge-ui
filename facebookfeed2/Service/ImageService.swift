//
//  ImageService.swift
//  facebookfeed2
//
//  Created by iakay on 2.03.2018.
//  Copyright © 2018 challenge. All rights reserved.
//

import UIKit

class ImageService {
    
    static let cache = NSCache<NSString, UIImage>()
    
    static func downloadImage(withURL url:URL, completion: @escaping (_ image:UIImage?)->()) {
        let dataTask = URLSession.shared.dataTask(with: url) { data, responseURL, error in
            var downloadedImage:UIImage?
            if let data = data {
                downloadedImage = UIImage(data: data)
            }
            if downloadedImage != nil {
                cache.setObject(downloadedImage!, forKey: url.absoluteString as NSString)
            }
            DispatchQueue.main.async {
                completion(downloadedImage)
            }
        }
        dataTask.resume()
    }
    
    static func cacheImage(withURL url:URL) {
        DispatchQueue.global(qos: .background).async {
            if cache.object(forKey: url.absoluteString as NSString) == nil {            
                let dataTask = URLSession.shared.dataTask(with: url) { data, responseURL, error in
                    var downloadedImage:UIImage?
                    if let data = data {
                        downloadedImage = UIImage(data: data)
                    }
                    if downloadedImage != nil {
                        cache.setObject(downloadedImage!, forKey: url.absoluteString as NSString)
                    }
                }
                dataTask.resume()
            }
        }
    }
    
    static func cache(withURL url:URL, image: UIImage) {
        if cache.object(forKey: url.absoluteString as NSString) == nil {
            cache.setObject(image, forKey: url.absoluteString as NSString)
        }
    }
    
    static func fromCache(withURL url:URL) -> UIImage {
        return cache.object(forKey: url.absoluteString as NSString)!
    }
    
    static func cached(withURL url:URL) -> Bool {
        if cache.object(forKey: url.absoluteString as NSString) != nil {
            return true
        }
        return false
    }
    
    static func getImage(withURL url:URL, completion: @escaping (_ image:UIImage?)->()) {
        if let image = cache.object(forKey: url.absoluteString as NSString) {
            DispatchQueue.main.async {
                completion(image)
            }
        } else {
            DispatchQueue.global(qos: .background).async {
                downloadImage(withURL: url, completion: completion)
            }
        }
    }
}
