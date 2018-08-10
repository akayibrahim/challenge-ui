//
//  ImageService.swift
//  facebookfeed2
//
//  Created by iakay on 2.03.2018.
//  Copyright © 2018 challenge. All rights reserved.
//

import UIKit
import Alamofire

class VideoService {
    
    static let cache = NSCache<NSString, NSURL>()
    
    static func downloadVideo(withURL url:URL, completion: @escaping (_ video:URL?)->()) {
        let urls = url.absoluteString.split(separator: "?")
        let tempUrl = FileManager.default.temporaryDirectory.appendingPathComponent("\(urls[1]).mov")
        if FileManager.default.fileExists(atPath: tempUrl.path) {
            DispatchQueue.main.async {
                completion(tempUrl)
            }
        } else {
            let destination: DownloadRequest.DownloadFileDestination = { _, _ in return (tempUrl, [.removePreviousFile, .createIntermediateDirectories]) }
            Alamofire.download(url, to: destination).responseData { (response) in
                print(tempUrl)
                switch response.result {
                case .failure( _):
                    break;
                case .success( _):
                    cache.setObject(tempUrl as NSURL, forKey: url.absoluteString as NSString)
                    DispatchQueue.main.async {
                        completion(tempUrl)
                    }
                    break;
                }
                
            }
        }
    }
    
    static func getVideo(withURL url:URL, completion: @escaping (_ video:URL?)->()) {
        if let image = cache.object(forKey: url.absoluteString as NSString) {
            DispatchQueue.main.async {
                completion(image as URL)
            }
        } else {
            DispatchQueue.global(qos: .background).async {
                downloadVideo(withURL: url, completion: completion)
            }
        }
    }
}
