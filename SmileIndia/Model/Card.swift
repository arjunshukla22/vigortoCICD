//
//  Card.swift
//  SmileIndia
//
//  Created by Na on 08/05/19.
//  Copyright © 2019 Na. All rights reserved.
//

import Foundation
final class Card: NSObject, Decodable {
    var imageURL: URL? {
        guard let urlString = logo else { return nil }
        return URL(string: urlString)
    }
    let EffectiveDate, EndDate, MemberId, MemberName, SubscriberId, logo, FullName : String?
}

extension Card: Parceable {
    
    static func parseObject(dictionary: [String : AnyObject]) -> Card? {
        let data = try? JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
        guard data != nil else {
            debugPrint("unable to parse: Card")
            return nil
        }
        do {
            let decoder = JSONDecoder()
            let user = try decoder.decode(Card.self, from: data!)
            return user
        }
        catch {
            print("unable to decode model: Card")
            return nil
        }
    }
}
