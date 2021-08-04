//
//  CommentDeleteModel.swift
//  SmileIndia
//
//  Created by Arjun  on 16/04/21.
//  Copyright © 2021 Na. All rights reserved.
//

import Foundation

// MARK: - Result
final class CommentDeleteModel: NSObject, Decodable {
    let totalComment: Int?
    let isCustomerCommented: Bool?
    let blogPostID: Int?

    enum CodingKeys: String, CodingKey {
        case totalComment = "TotalComment"
        case isCustomerCommented = "IsCustomerCommented"
        case blogPostID = "BlogPostId"
    }
}


extension CommentDeleteModel: Parceable {
    
    static func parseObject(dictionary: [String : AnyObject]) -> CommentDeleteModel? {
        let data = try? JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
        guard data != nil else {
            debugPrint("unable to parse: CommentDeleteModel")
            return nil
        }
        do {
            let decoder = JSONDecoder()
            let user = try decoder.decode(CommentDeleteModel.self, from: data!)
            return user
        }
        catch {
            print("unable to decode model: CommentDeleteModel")
            return nil
        }
    }
}
