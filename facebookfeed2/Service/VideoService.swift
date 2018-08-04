//
//  ImageService.swift
//  facebookfeed2
//
//  Created by iakay on 2.03.2018.
//  Copyright © 2018 challenge. All rights reserved.
//

import UIKit

class VideoService {
    
    static let cache = NSCache<NSString, NSData>()
    
    static func downloadVideo(withURL url:URL, completion: @escaping (_ video:NSData?)->()) {
        let dataTask = URLSession.shared.dataTask(with: url) { data, responseURL, error in
            var downloadedImage:NSData?
            
            if let data = data {
                let bytes: [Int8] = data.map{Int8(bitPattern: $0)}
                downloadedImage = NSData(bytes: bytes, length: bytes.count)
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
                    var downloadedImage:NSData?
                    if let data = data {
                        let bytes: [Int8] = data.map{Int8(bitPattern: $0)}
                        downloadedImage = NSData(bytes: bytes, length: bytes.count)
                    }
                    if downloadedImage != nil {
                        cache.setObject(downloadedImage!, forKey: url.absoluteString as NSString)
                    }
                }
                dataTask.resume()
            }
        }
    }
    
    static func getVideo(withURL url:URL, completion: @escaping (_ video:NSData?)->()) {
        if let image = cache.object(forKey: url.absoluteString as NSString) {
            completion(image)
        } else {
            // DispatchQueue.global(qos: .background).async {
                downloadVideo(withURL: url, completion: completion)
            // }
        }
    }
}
