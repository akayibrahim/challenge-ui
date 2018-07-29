//
//  InstaUser.swift
//  facebookfeed2
//
//  Created by iakay on 29.07.2018.
//  Copyright © 2018 challenge. All rights reserved.
//

import UIKit

class User {
    
    var id: String?
    var userName: String?
    var fullName: String?
    var profilePicture: String?
    var bio: String?
    var website: String?
    var mediaCount: String?
    var followsCount: Int?
    var followedByCount: Int?
    
    init(userDict:[String:AnyObject]) {
        self.id = userDict["id"] as? String
        self.userName = userDict["username"] as? String
        self.fullName = userDict["full_name"] as? String
        self.profilePicture = userDict["profile_picture"] as? String
        self.bio = userDict["bio"] as? String
        self.website = userDict["website"] as? String
        self.mediaCount = userDict["media"] as? String
        if let countsDict = userDict["counts"] as? [String: AnyObject] {
            self.followsCount = countsDict["follows"] as? Int
            self.followedByCount = countsDict["followed_by"] as? Int
        }
    }    
}
