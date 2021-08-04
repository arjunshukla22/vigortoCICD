//
//  AddFriendModel.swift
//  SmileIndia
//
//  Created by Arjun  on 26/05/21.
//  Copyright © 2021 Na. All rights reserved.
//

import Foundation

// MARK: - Result
final class AddFriendModel: NSObject, Decodable {
    let customerid, friendsID: Int?
    let isfollow: Bool?
    let status: Int?
    let createdOn, updatedOn: String?
    let id: Int?

    enum CodingKeys: String, CodingKey {
        case customerid = "Customerid"
        case friendsID = "FriendsId"
        case isfollow = "Isfollow"
        case status = "Status"
        case createdOn = "CreatedOn"
        case updatedOn = "UpdatedOn"
        case id = "Id"
    }
}



extension AddFriendModel: Parceable {
    
    static func parseObject(dictionary: [String : AnyObject]) -> AddFriendModel? {
        let data = try? JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
        guard data != nil else {
            debugPrint("unable to parse: AddFriendModel")
            return nil
        }
        do {
            let decoder = JSONDecoder()
            let user = try decoder.decode(AddFriendModel.self, from: data!)
            return user
        }
        catch {
            print("unable to decode model: AddFriendModel")
            return nil
        }
    }
}

