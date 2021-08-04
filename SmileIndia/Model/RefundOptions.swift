//
//  RefundOptions.swift
//  SmileIndia
//
//  Created by Arjun  on 07/08/20.
//  Copyright © 2020 Na. All rights reserved.
//

import Foundation

final class RefundOptions: NSObject, Decodable {
    let MoneyRefund, CreditRefund: Bool?
}

extension RefundOptions: Parceable {
    
    static func parseObject(dictionary: [String : AnyObject]) -> RefundOptions? {
        let data = try? JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
        guard data != nil else {
            debugPrint("unable to parse: user")
            return nil
        }
        do {
            let decoder = JSONDecoder()
            let user = try decoder.decode(RefundOptions.self, from: data!)
            return user
        }
        catch {
            print("unable to decode model: user")
            return nil
        }
    }
}
