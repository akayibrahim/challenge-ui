//
//  Post.swift
//  facebookfeed2
//
//  Created by iakay on 5.03.2018.
//  Copyright © 2018 challenge. All rights reserved.
//

import UIKit

struct Media {
    let key: String
    let filename: String
    let data: Data
    let mimeType: String
    
    init?(withImage image: UIImage, forKey key: String) {
        self.key = key
        self.mimeType = "image/jpeg"
        self.filename = "image.jpg"
        
        guard let data = UIImageJPEGRepresentation(image, 0.7) else { return nil }
        self.data = data
    }
    
    init?(url: NSURL, forKey key: String) {
        self.key = key
        self.mimeType = "video/mov"
        self.filename = "video.mov"
        
        // guard let data = NSData.init(contentsOf: url as URL) else { return nil }
        var data: Data?
        let path = url.path
        do { data = try Data(contentsOf: url as URL) } catch {}
        self.data = data!
    }
}
