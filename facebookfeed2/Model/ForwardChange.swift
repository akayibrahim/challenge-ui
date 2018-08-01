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
        aCoder.encode(forwardScreen, forKey: "forwardScreen")
        aCoder.encode(viewCommentsCount, forKey: "viewCommentsCount")
        aCoder.encode(viewProofsCount, forKey: "viewProofsCount")
        aCoder.encode(joined, forKey: "joined")
        aCoder.encode(proved, forKey: "proved")
        aCoder.encode(firstTeamScore, forKey: "firstTeamScore")
        aCoder.encode(secondTeamScore, forKey: "secondTeamScore")
        aCoder.encode(index, forKey: "index")
    }
    
    init(index: IndexPath, forwardScreen: String) {
        self.index = index
        self.forwardScreen = forwardScreen
    }
    
    init(index: IndexPath, forwardScreen: String, viewCommentsCount: Int) {
        self.index = index
        self.forwardScreen = forwardScreen
        self.viewCommentsCount = viewCommentsCount
    }
    
    init(index: IndexPath, forwardScreen: String, viewProofsCount: Int, joined: Bool, proved: Bool) {
        self.index = index
        self.forwardScreen = forwardScreen
        self.viewProofsCount = viewProofsCount
        self.joined = joined
        self.proved = proved
    }
    
    required init?(coder aDecoder: NSCoder) {
        forwardScreen = aDecoder.decodeObject(forKey: "forwardScreen") as? String
        viewCommentsCount = aDecoder.decodeObject(forKey: "viewCommentsCount") as? Int
        viewProofsCount = aDecoder.decodeObject(forKey: "viewProofsCount") as? Int
        joined = aDecoder.decodeObject(forKey: "joined") as? Bool
        proved = aDecoder.decodeObject(forKey: "proved") as? Bool
        firstTeamScore = aDecoder.decodeObject(forKey: "firstTeamScore") as? String
        secondTeamScore = aDecoder.decodeObject(forKey: "secondTeamScore") as? String
        index = aDecoder.decodeObject(forKey: "index") as? IndexPath
    }
    
    var forwardScreen: String?
    var viewCommentsCount: Int?
    var viewProofsCount: Int?
    var joined: Bool?
    var proved: Bool?
    var firstTeamScore: String?
    var secondTeamScore: String?
    var index: IndexPath?
}
