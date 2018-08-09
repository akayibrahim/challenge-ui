//
//  Post.swift
//  facebookfeed2
//
//  Created by iakay on 5.03.2018.
//  Copyright © 2018 challenge. All rights reserved.
//

import UIKit

class Attendance: SafeJsonObject {
    @objc var challengeId: String?
    @objc var memberId: String?
    @objc var supportedMemberId : String?
    @objc var name: String?
    @objc var surname: String?
    @objc var facebookId: String?
    var followed: Bool?
}
