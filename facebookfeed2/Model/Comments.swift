//
//  Post.swift
//  facebookfeed2
//
//  Created by iakay on 5.03.2018.
//  Copyright © 2018 challenge. All rights reserved.
//

import UIKit

class Comments: SafeJsonObject {
    @objc var name: String?
    @objc var comment : String?
    @objc var fbID : String?
    @objc var challengeId: String?
    @objc var memberId: String?
}
