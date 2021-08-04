//
//  CommentModel.swift
//  SmileIndia
//
//  Created by Arjun  on 07/04/21.
//  Copyright © 2021 Na. All rights reserved.
//

import Foundation

final class CommentModel: NSObject, Decodable {
    let customerID: Int?
    let commentText: String?
    let isApproved: Bool?
    let storeID, blogPostID: Int?
    let deleted: Bool?
    let createdOnUTC: String?
    let isApp: Bool?
    let loginKey: String?
    let commentPageIndex: Int?
    let profileImage: String?
    let username: String?
    let commentTimeAgo: String?
    let commentRepliesCount, id, commentID: Int?
    let commentRepliesList: [CommentModel]?

    enum CodingKeys: String, CodingKey {
        case customerID = "CustomerId"
        case commentText = "CommentText"
        case isApproved = "IsApproved"
        case storeID = "StoreId"
        case blogPostID = "BlogPostId"
        case deleted = "Deleted"
        case createdOnUTC = "CreatedOnUtc"
        case isApp = "IsApp"
        case loginKey = "LoginKey"
        case commentPageIndex = "CommentPageIndex"
        case profileImage = "ProfileImage"
        case username = "Username"
        case commentTimeAgo = "CommentTimeAgo"
        case commentRepliesCount = "CommentRepliesCount"
        case id = "Id"
        case commentID = "CommentId"
        case commentRepliesList = "CommentRepliesList"
    }
}


extension CommentModel: Parceable {
    
    static func parseObject(dictionary: [String : AnyObject]) -> CommentModel? {
        let data = try? JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
        guard data != nil else {
            debugPrint("unable to parse: CustomerInfo")
            return nil
        }
        do {
            let decoder = JSONDecoder()
            let user = try decoder.decode(CommentModel.self, from: data!)
            return user
        }
        catch {
            print("unable to decode model: CustomerInfo")
            return nil
        }
    }
}
