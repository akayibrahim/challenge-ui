//
//  ImageService.swift
//  facebookfeed2
//
//  Created by iakay on 2.03.2018.
//  Copyright © 2018 challenge. All rights reserved.
//

import UIKit

class ServiceLocator {
    static func getChallengesFromDummy(jsonFileName : String) -> [Post] {
        var posts = [Post]()
        if let path = Bundle.main.path(forResource: jsonFileName, ofType: "json") {
            do {
                let data = try(Data(contentsOf: URL(fileURLWithPath: path), options: NSData.ReadingOptions.mappedIfSafe))
                let jsonDictionary = try(JSONSerialization.jsonObject(with: data, options: .mutableContainers)) as? [String: Any]
                if let postsArray = jsonDictionary?["posts"] as? [[String: AnyObject]] {
                    for postDictionary in postsArray {
                        posts.append(mappingOfPost(postDictionary: postDictionary))
                    }
                }
            } catch let err {
                print(err)
            }
        }
        return posts
    }
    
    static func getOwnChallengesFromDummy(jsonFileName : String, done : Bool) -> [Post] {
        var posts = [Post]()
        if let path = Bundle.main.path(forResource: jsonFileName, ofType: "json") {
            do {
                let data = try(Data(contentsOf: URL(fileURLWithPath: path), options: NSData.ReadingOptions.mappedIfSafe))
                let jsonDictionary = try(JSONSerialization.jsonObject(with: data, options: .mutableContainers)) as? [String: Any]
                if let postsArray = jsonDictionary?["posts"] as? [[String: AnyObject]] {
                    for postDictionary in postsArray {
                        let post = mappingOfPost(postDictionary: postDictionary)
                        if post.done == done {
                            posts.append(post)
                        }
                    }
                }
            } catch let err {
                print(err)
            }
        }
        return posts
    }
    
    static func mappingOfPost(postDictionary : [String : AnyObject]) -> Post {
        let post = Post()
        post.versusAttendanceList = [VersusAttendance]()
        if let verAttenLis = postDictionary["versusAttendanceList"] as? [[String: AnyObject]] {
            for versus in verAttenLis {
                let versusAtten = VersusAttendance(data: versus)
                post.versusAttendanceList.append(versusAtten)
            }
        }
        post.joinAttendanceList = [JoinAttendance]()
        if let joinAttenLis = postDictionary["joinAttendanceList"] as? [[String: AnyObject]] {
            for join in joinAttenLis {
                let joinAtten = JoinAttendance(data: join)
                post.joinAttendanceList.append(joinAtten)
            }
        }
        post.setValuesForKeys(postDictionary)
        post.done = postDictionary["done"] as? Bool
        post.isComeFromSelf = postDictionary["comeFromSelf"] as? Bool
        post.supportFirstTeam = postDictionary["supportFirstTeam"] as? Bool
        post.supportSecondTeam = postDictionary["supportSecondTeam"] as? Bool
        post.proofed = postDictionary["proofed"] as? Bool
        return post
    }
}
