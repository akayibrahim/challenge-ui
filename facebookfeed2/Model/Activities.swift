//
//  Post.swift
//  facebookfeed2
//
//  Created by iakay on 5.03.2018.
//  Copyright © 2018 challenge. All rights reserved.
//

import UIKit

class Activities: SafeJsonObject {
    var name: String?
    var content : String?
    var facebookID : String?    
    var challengeId: String?
    var fromMemberId: String?
    var toMemberId: String?
    var type: String?
    var activityTableId: String?
    var mediaObjectId: String?
}
