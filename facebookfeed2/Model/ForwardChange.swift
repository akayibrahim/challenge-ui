//
//  ForwardChange.swift
//  facebookfeed2
//
//  Created by iakay on 30.07.2018.
//  Copyright © 2018 challenge. All rights reserved.
//

import Foundation

class ForwardChange: NSObject, NSCoding {
    func encode(with aCoder: NSCoder) {
        aCoder.encode(challengeId, forKey: "challengeId")
        aCoder.encode(forwardScreen, forKey: "forwardScreen")
        aCoder.encode(viewCommentsCount, forKey: "viewCommentsCount")
        aCoder.encode(viewProofsCount, forKey: "viewProofsCount")
        aCoder.encode(joined, forKey: "joined")
        aCoder.encode(proved, forKey: "proved")
        aCoder.encode(firstTeamScore, forKey: "firstTeamScore")
        aCoder.encode(secondTeamScore, forKey: "secondTeamScore")
        aCoder.encode(proofed, forKey: "proofed")
        aCoder.encode(index, forKey: "index")
    }
    
    init(challengeId: String, forwardScreen: String) {
        self.challengeId = challengeId
        self.forwardScreen = forwardScreen
    }
    
    required init?(coder aDecoder: NSCoder) {
        challengeId = aDecoder.decodeObject(forKey: "challengeId") as? String
        forwardScreen = aDecoder.decodeObject(forKey: "forwardScreen") as? String
        viewCommentsCount = aDecoder.decodeObject(forKey: "viewCommentsCount") as? Int
        viewProofsCount = aDecoder.decodeObject(forKey: "viewProofsCount") as? Int
        joined = aDecoder.decodeObject(forKey: "joined") as? Bool
        proved = aDecoder.decodeObject(forKey: "proved") as? Bool
        firstTeamScore = aDecoder.decodeObject(forKey: "firstTeamScore") as? String
        secondTeamScore = aDecoder.decodeObject(forKey: "secondTeamScore") as? String
        proofed = aDecoder.decodeObject(forKey: "proofed") as? Bool
        index = aDecoder.decodeObject(forKey: "index") as? IndexPath
    }
    
    var challengeId: String?
    var forwardScreen: String?
    var viewCommentsCount: Int?
    var viewProofsCount: Int?
    var joined: Bool?
    var proved: Bool?
    var firstTeamScore: String?
    var secondTeamScore: String?
    var proofed: Bool?
    var index: IndexPath?
}
