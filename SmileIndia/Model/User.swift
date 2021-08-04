//
//  User.swift
//  SmileIndia
//
//  Created by Na on 10/02/19.
//  Copyright © 2019 Na. All rights reserved.
//

import Foundation

final class User: NSObject, Decodable {
   var profileImageURL: URL? {
        guard let urlString = ProfileImage else { return nil }
    return URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
    }
    let username, email, phone, CustomerGuid, CustomerType, token, ProfileImage : String?
    let CustomerId: Int?
    let IscompleteProfile : Bool?
}

extension User: Parceable {
    
    static func parseObject(dictionary: [String : AnyObject]) -> User? {
        let data = try? JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
        guard data != nil else {
            debugPrint("unable to parse: user")
            return nil
        }
        do {
            let decoder = JSONDecoder()
            let user = try decoder.decode(User.self, from: data!)
            return user
        }
        catch {
            print("unable to decode model: user")
            return nil
        }
    }
}
