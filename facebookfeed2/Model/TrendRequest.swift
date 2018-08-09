//
//  Post.swift
//  facebookfeed2
//
//  Created by iakay on 5.03.2018.
//  Copyright © 2018 challenge. All rights reserved.
//

import UIKit

class TrendRequest: SafeJsonObject {
    @objc var name: String?
    @objc var challengeId : String?
    @objc var proof : String?
    @objc var prooferFbID : String?
    @objc var subject : String?
    @objc var challengerId : String?
    var provedWithImage: Bool?
}
