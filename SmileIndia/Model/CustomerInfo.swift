//
//  CustomerInfo.swift
//  SmileIndia
//
//  Created by Arjun  on 01/03/21.
//  Copyright © 2021 Na. All rights reserved.
//

import Foundation

final class CustomerInfo: NSObject, Decodable {
    let CustomerGuid, FirstName,LastName,Email,Username : String?
    let Id : Int?
    let IsDefaulter : Bool?
}

extension CustomerInfo: Parceable {
    
    static func parseObject(dictionary: [String : AnyObject]) -> CustomerInfo? {
        let data = try? JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
        guard data != nil else {
            debugPrint("unable to parse: CustomerInfo")
            return nil
        }
        do {
            let decoder = JSONDecoder()
            let user = try decoder.decode(CustomerInfo.self, from: data!)
            return user
        }
        catch {
            print("unable to decode model: CustomerInfo")
            return nil
        }
    }
}


