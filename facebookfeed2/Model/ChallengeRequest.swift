//
//  Post.swift
//  facebookfeed2
//
//  Created by iakay on 5.03.2018.
//  Copyright © 2018 challenge. All rights reserved.
//

import UIKit

class ChallengeRequest: SafeJsonObject {
    @objc var name: String?
    @objc var surname: String?
    @objc var challengeId : String?
    @objc var facebookID : String?
    @objc var type: String?
    @objc var subject: String?
}
