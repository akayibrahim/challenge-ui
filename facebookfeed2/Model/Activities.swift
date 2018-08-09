//
//  Post.swift
//  facebookfeed2
//
//  Created by iakay on 5.03.2018.
//  Copyright © 2018 challenge. All rights reserved.
//

import UIKit

class Activities: SafeJsonObject {
    @objc var name: String?
    @objc var content : String?
    @objc var facebookID : String?    
    @objc var challengeId: String?
    @objc var fromMemberId: String?
    @objc var toMemberId: String?
    @objc var type: String?
    @objc var activityTableId: String?
    @objc var mediaObjectId: String?
}
