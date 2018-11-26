//
//  ImageService.swift
//  facebookfeed2
//
//  Created by iakay on 2.03.2018.
//  Copyright © 2018 challenge. All rights reserved.
//

import UIKit
import FBSDKCoreKit

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
    
    static func getTrendChallengesFromDummy(jsonFileName : String) -> [TrendRequest] {
        var trends = [TrendRequest]()
        if let path = Bundle.main.path(forResource: jsonFileName, ofType: "json") {
            do {
                let data = try(Data(contentsOf: URL(fileURLWithPath: path), options: NSData.ReadingOptions.mappedIfSafe))
                let jsonDictionary = try(JSONSerialization.jsonObject(with: data, options: .mutableContainers)) as? [String: Any]
                if let postsArray = jsonDictionary?["posts"] as? [[String: AnyObject]] {
                    for postDictionary in postsArray {
                        let trend = TrendRequest()
                        trend.setValuesForKeys(postDictionary)
                        trends.append(trend)
                    }
                }
            } catch let err {
                print(err)
            }
        }
        return trends
    }
    
    static func getSubjectFromDummy(jsonFileName : String) -> [Subject] {
        var subjects = [Subject]()
        if let path = Bundle.main.path(forResource: jsonFileName, ofType: "json") {
            do {
                let data = try(Data(contentsOf: URL(fileURLWithPath: path), options: NSData.ReadingOptions.mappedIfSafe))
                let jsonDictionary = try(JSONSerialization.jsonObject(with: data, options: .mutableContainers)) as? [String: Any]
                if let postsArray = jsonDictionary?["posts"] as? [[String: AnyObject]] {
                    for postDictionary in postsArray {
                        let subject = Subject()
                        subject.setValuesForKeys(postDictionary)
                        subjects.append(subject)
                    }
                }
            } catch let err {
                print(err)
            }
        }
        return subjects
    }
    
    static func getFriendsFromDummy(jsonFileName : String) -> [Friends] {
        var friends = [Friends]()
        if let path = Bundle.main.path(forResource: jsonFileName, ofType: "json") {
            do {
                let data = try(Data(contentsOf: URL(fileURLWithPath: path), options: NSData.ReadingOptions.mappedIfSafe))
                let jsonDictionary = try(JSONSerialization.jsonObject(with: data, options: .mutableContainers)) as? [String: Any]
                if let postsArray = jsonDictionary?["posts"] as? [[String: AnyObject]] {
                    for postDictionary in postsArray {
                        let friend = Friends()
                        friend.setValuesForKeys(postDictionary)
                        friends.append(friend)
                    }
                }
            } catch let err {
                print(err)
            }
        }
        return friends
    }
    
    static func getCommentFromDummy(jsonFileName : String) -> [Comments] {
        var comments = [Comments]()
        if let path = Bundle.main.path(forResource: jsonFileName, ofType: "json") {
            do {
                let data = try(Data(contentsOf: URL(fileURLWithPath: path), options: NSData.ReadingOptions.mappedIfSafe))
                let jsonDictionary = try(JSONSerialization.jsonObject(with: data, options: .mutableContainers)) as? [String: Any]
                if let postsArray = jsonDictionary?["posts"] as? [[String: AnyObject]] {
                    for postDictionary in postsArray {
                        let comment = Comments()
                        comment.setValuesForKeys(postDictionary)
                        comments.append(comment)
                    }
                }
            } catch let err {
                print(err)
            }
        }
        return comments
    }
    
    static func getProofsFromDummy(jsonFileName : String) -> [Prove] {
        var proofs = [Prove]()
        if let path = Bundle.main.path(forResource: jsonFileName, ofType: "json") {
            do {
                let data = try(Data(contentsOf: URL(fileURLWithPath: path), options: NSData.ReadingOptions.mappedIfSafe))
                let jsonDictionary = try(JSONSerialization.jsonObject(with: data, options: .mutableContainers)) as? [String: Any]
                if let postsArray = jsonDictionary?["posts"] as? [[String: AnyObject]] {
                    for postDictionary in postsArray {
                        let proof = Prove()
                        proof.setValuesForKeys(postDictionary)
                        proofs.append(proof)
                    }
                }
            } catch let err {
                print(err)
            }
        }
        return proofs
    }
    
    static func getSuggestionFriendsFromDummy(jsonFileName : String) -> [SuggestionFriends] {
        var friendRequest = [SuggestionFriends]()
        if let path = Bundle.main.path(forResource: jsonFileName, ofType: "json") {
            do {
                let data = try(Data(contentsOf: URL(fileURLWithPath: path), options: NSData.ReadingOptions.mappedIfSafe))
                let jsonDictionary = try(JSONSerialization.jsonObject(with: data, options: .mutableContainers)) as? [String: Any]
                if let postsArray = jsonDictionary?["posts"] as? [[String: AnyObject]] {
                    for postDictionary in postsArray {
                        let friendReq = SuggestionFriends()
                        friendReq.setValuesForKeys(postDictionary)
                        friendRequest.append(friendReq)
                    }
                }
            } catch let err {
                print(err)
            }
        }
        return friendRequest
    }
    
    static func getChallengeRequestsFromDummy(jsonFileName : String) -> [ChallengeRequest] {
        var challengeRequest = [ChallengeRequest]()
        if let path = Bundle.main.path(forResource: jsonFileName, ofType: "json") {
            do {
                let data = try(Data(contentsOf: URL(fileURLWithPath: path), options: NSData.ReadingOptions.mappedIfSafe))
                let jsonDictionary = try(JSONSerialization.jsonObject(with: data, options: .mutableContainers)) as? [String: Any]
                if let postsArray = jsonDictionary?["posts"] as? [[String: AnyObject]] {
                    for postDictionary in postsArray {
                        let challengeReq = ChallengeRequest()
                        challengeReq.setValuesForKeys(postDictionary)
                        challengeRequest.append(challengeReq)
                    }
                }
            } catch let err {
                print(err)
            }
        }
        return challengeRequest
    }
    
    static func getFollowingsFromDummy(jsonFileName : String) -> [Following] {
        var followings = [Following]()
        if let path = Bundle.main.path(forResource: jsonFileName, ofType: "json") {
            do {
                let data = try(Data(contentsOf: URL(fileURLWithPath: path), options: NSData.ReadingOptions.mappedIfSafe))
                let jsonDictionary = try(JSONSerialization.jsonObject(with: data, options: .mutableContainers)) as? [String: Any]
                if let postsArray = jsonDictionary?["posts"] as? [[String: AnyObject]] {
                    for postDictionary in postsArray {
                        let following = Following()
                        following.setValuesForKeys(postDictionary)
                        followings.append(following)
                    }
                }
            } catch let err {
                print(err)
            }
        }
        return followings
    }
    
    static func getFollowersFromDummy(jsonFileName : String) -> [Followers] {
        var followers = [Followers]()
        if let path = Bundle.main.path(forResource: jsonFileName, ofType: "json") {
            do {
                let data = try(Data(contentsOf: URL(fileURLWithPath: path), options: NSData.ReadingOptions.mappedIfSafe))
                let jsonDictionary = try(JSONSerialization.jsonObject(with: data, options: .mutableContainers)) as? [String: Any]
                if let postsArray = jsonDictionary?["posts"] as? [[String: AnyObject]] {
                    for postDictionary in postsArray {
                        let follower = Followers()
                        follower.setValuesForKeys(postDictionary)
                        followers.append(follower)
                    }
                }
            } catch let err {
                print(err)
            }
        }
        return followers
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
        post.active = postDictionary["active"] as? Bool
        post.proofed = postDictionary["proofed"] as? Bool
        post.canJoin = postDictionary["canJoin"] as? Bool
        post.joined = postDictionary["joined"] as? Bool
        post.proofedByChallenger = postDictionary["proofedByChallenger"] as? Bool
        post.homeWin = postDictionary["homeWin"] as? Bool
        post.awayWin = postDictionary["awayWin"] as? Bool
        post.provedWithImage = postDictionary["provedWithImage"] as? Bool
        post.rejectedByAllAttendance = postDictionary["rejectedByAllAttendance"] as? Bool
        post.timesUp = postDictionary["timesUp"] as? Bool
        post.waitForApprove = postDictionary["waitForApprove"] as? Bool
        post.scoreRejected = postDictionary["scoreRejected"] as? Bool
        return post
    }
    
    static func prepareRequest(url: URL, json: [String: Any]) -> URLRequest {
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        return request
    }
    
    static func prepareRequestForMedia(url: URL, parameters: [String: Any], image: UIImage) -> URLRequest {
        var request = URLRequest(url: url)
        let boundary = "Boundary-\(NSUUID().uuidString)"
        let image = Media(withImage: image, forKey: "file")
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        let dataBody = createDataBody(withParameters: parameters , media: [image!], boundary: boundary)
        request.httpBody = dataBody
        return request
    }
    
    static func prepareRequestForVideo(url: URL, parameters: [String: Any], videoUrl: NSURL) -> URLRequest {
        var request = URLRequest(url: url)
        let boundary = "Boundary-\(NSUUID().uuidString)"
        let video = Media(url: videoUrl, forKey: "file")
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        let dataBody = createDataBody(withParameters: parameters , media: [video!], boundary: boundary)
        request.httpBody = dataBody
        return request
    }
    
    typealias Parameters = [String: Any]
    static func createDataBody(withParameters params: Parameters?, media: [Media]?, boundary: String) -> Data {
        let lineBreak = "\r\n"
        var body = Data()
        if let parameters = params {
            for (key, value) in parameters {
                body.append("--\(boundary + lineBreak)")
                body.append("Content-Disposition: form-data; name=\"\(key)\"\(lineBreak + lineBreak)")
                body.append("\(value)\(lineBreak)")
            }
        }
        if let media = media {
            for photo in media {
                body.append("--\(boundary + lineBreak)")
                body.append("Content-Disposition: form-data; name=\"\(photo.key)\"; filename=\"\(photo.filename)\"\(lineBreak)")
                body.append("Content-Type: \(photo.mimeType + lineBreak + lineBreak)")
                body.append(photo.data)
                body.append(lineBreak)
            }
        }
        body.append("--\(boundary)--\(lineBreak)")
        return body
    }
    
    static func getErrorMessage(data: Data, chlId: String, sUrl: String, inputs: String) -> String {
        return logError(data: data, chlId: chlId, sUrl: sUrl, inputs: inputs)
    }
    
    static func logErrorMessage(data: Data, chlId: String, sUrl: String, inputs: String) {
        let error = logError(data: data, chlId: chlId, sUrl: sUrl, inputs: inputs)
        print(error)
    }
    
    static func logError(data: Data, chlId: String, sUrl: String, inputs: String) -> String {
        var errorMessage: String = ""
        let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
        if let responseJSON = responseJSON as? [String: Any] {
            if responseJSON["message"] != nil {
                errorMessage = (responseJSON["message"] as? String)!
                
                let parameters = ["challengeId": chlId, "memberId": memberID as String, "errorMessage": errorMessage, "serviceURL": sUrl, "inputs": inputs]
                let url = URL(string: errorLogURL)!
                let requestOfUpload = prepareRequest(url: url, json: parameters)
                URLSession.shared.dataTask(with: requestOfUpload, completionHandler: { (data, response, error) -> Void in
                    guard let data = data, error == nil else {
                        print(error?.localizedDescription ?? "No data")
                        return
                    }
                    if let httpResponse = response as? HTTPURLResponse {
                        if httpResponse.statusCode == 200 {
                        } else {
                            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
                            if let responseJSON = responseJSON as? [String: Any] {
                                if responseJSON["message"] != nil {
                                    print((responseJSON["message"] as? String)!)
                                }
                            }
                            return
                        }
                    }
                }).resume()
            }
        }
        return errorMessage
    }
    
    static func getActivitiesFromDummy(jsonFileName : String) -> [Activities] {
        var activities = [Activities]()
        if let path = Bundle.main.path(forResource: jsonFileName, ofType: "json") {
            do {
                let data = try(Data(contentsOf: URL(fileURLWithPath: path), options: NSData.ReadingOptions.mappedIfSafe))
                let jsonDictionary = try(JSONSerialization.jsonObject(with: data, options: .mutableContainers)) as? [String: Any]
                if let postsArray = jsonDictionary?["posts"] as? [[String: AnyObject]] {
                    activities = [Activities]()
                    for postDictionary in postsArray {
                        let activity = Activities()
                        activity.setValuesForKeys(postDictionary)
                        activities.append(activity)
                    }
                }
            } catch let err {
                print(err)
            }
        }
        return activities
    }
    
    @objc static func fetchFacebookFriends() {
        DispatchQueue.global(qos: .background).async {
            let params = ["fields": "id, first_name, last_name, name, email, picture,friends"]
            let graphRequest = FBSDKGraphRequest(graphPath: "me/friends", parameters: params)
            let connection = FBSDKGraphRequestConnection()
            connection.add(graphRequest, completionHandler: { (connection, result, error) -> Void in
                if error == nil {
                    // print(result!)
                    let data = result as! [String : Any]
                    let user_friends = data["data"] as! NSArray
                    print(user_friends.value(forKey: "id"))
                    addFirends(friends: user_friends.value(forKey: "id") as! NSArray)                    
                } else {
                    print("Error Getting Friends \(error!)");
                }
            })
            connection.start()
        }
    }
    
    @objc static func addFirends(friends: NSArray) {
        DispatchQueue.global(qos: .background).async {
            let json: [String: Any] = ["memberId": memberID,
                                       "friendMemberIdList": friends
            ]
            let request : URLRequest! = ServiceLocator.prepareRequest(url: URL(string: followingFriendListURL)!, json: json)
            URLSession.shared.dataTask(with: request).resume()
        }
    }
    
    @objc static let group = DispatchGroup()
    @objc static func getParameterValue(_ key: String) -> String {
        group.enter()
        var value: String = PARAMETER_DEFAULT
        let jsonURL = URL(string: getParameterValueURL + key)!
        jsonURL.get { data, response, error in
            guard
                data != nil
                else {
                    if data != nil {
                        ServiceLocator.logErrorMessage(data: data!, chlId: "", sUrl: getChallengeSizeOfMemberURL, inputs: "memberID=\(memberID)")
                    }
                    return
            }
            value = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)! as String
            self.group.leave()
        }
        let waitResult = self.group.wait(timeout: .now() + 1.5)
        if waitResult == .timedOut {
            return value
        }
        return value
    }
    
    @objc static func isParameterOpen(_ key: String) -> Bool {
        let value = ServiceLocator.getParameterValue(key)
        if value != PARAMETER_DEFAULT { // C: 0, O: 1
            return true
        }
        return false
    }
}
