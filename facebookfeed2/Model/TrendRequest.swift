//
//  Post.swift
//  facebookfeed2
//
//  Created by iakay on 5.03.2018.
//  Copyright © 2018 challenge. All rights reserved.
//

import UIKit

class TrendRequest: SafeJsonObject {
    var name: String?
    var challengeId : String?
    var proof : String?
    var prooferFbID : String?
    var subject : String?
    var challengerId : String?
    var provedWithImage: Bool?
}
