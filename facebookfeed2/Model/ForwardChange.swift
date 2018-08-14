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
        aCoder.encode(homeWinner, forKey: "homeWinner")
        aCoder.encode(awayWinner, forKey: "awayWinner")
        aCoder.encode(homeScore, forKey: "homeScore")
        aCoder.encode(awayScore, forKey: "awayScore")
        aCoder.encode(goal, forKey: "goal")
        aCoder.encode(result, forKey: "result")
    }
    
    @objc init(index: IndexPath, forwardScreen: String) {
        self.index = index
        self.forwardScreen = forwardScreen
    }
    
    @objc init(index: IndexPath, forwardScreen: String, viewCommentsCount: Int) {
        self.index = index
        self.forwardScreen = forwardScreen
        self.viewCommentsCount = viewCommentsCount
    }
    
    @objc init(index: IndexPath, forwardScreen: String, viewProofsCount: Int, joined: Bool, proved: Bool) {
        self.index = index
        self.forwardScreen = forwardScreen
        self.viewProofsCount = viewProofsCount
        self.joined = joined
        self.proved = proved
    }
    
    @objc init(index: IndexPath, forwardScreen: String, homeWinner: Bool, goal: String, result: String) {
        self.index = index
        self.forwardScreen = forwardScreen        
        self.homeWinner = homeWinner
        self.goal = goal
        self.result = result
    }
    
    @objc init(index: IndexPath, forwardScreen: String, homeWinner: Bool, awayWinner: Bool, homeScore: String, awayScore: String) {
        self.index = index
        self.forwardScreen = forwardScreen
        self.homeWinner = homeWinner
        self.awayWinner = awayWinner
        self.homeScore = homeScore
        self.awayScore = awayScore        
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
        homeWinner = aDecoder.decodeObject(forKey: "homeWinner") as? Bool
        awayWinner = aDecoder.decodeObject(forKey: "awayWinner") as? Bool
        homeScore = aDecoder.decodeObject(forKey: "homeScore") as? String
        awayScore = aDecoder.decodeObject(forKey: "awayScore") as? String
        goal = aDecoder.decodeObject(forKey: "goal") as? String
        result = aDecoder.decodeObject(forKey: "result") as? String        
    }
    
    @objc var forwardScreen: String?
    var viewCommentsCount: Int?
    var viewProofsCount: Int?
    var joined: Bool?
    var proved: Bool?
    @objc var firstTeamScore: String?
    @objc var secondTeamScore: String?
    @objc var index: IndexPath?
    var homeWinner: Bool?
    var awayWinner: Bool?
    @objc var homeScore: String?
    @objc var awayScore: String?
    @objc var goal: String?
    @objc var result: String?
}
