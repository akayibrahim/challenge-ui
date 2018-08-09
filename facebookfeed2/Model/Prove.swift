//
//  Post.swift
//  facebookfeed2
//
//  Created by iakay on 5.03.2018.
//  Copyright © 2018 challenge. All rights reserved.
//

import UIKit

class Prove: SafeJsonObject {
    @objc var name: String?
    @objc var fbID: String?
    @objc var proofObjectId: String?
    @objc var challangeId: String?
    @objc var memberId: String?
    var provedWithImage: Bool?
}
