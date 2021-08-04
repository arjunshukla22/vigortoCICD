//
//  BusinessHour.swift
//  SmileIndia
//
//  Created by Na on 17/02/19.
//  Copyright © 2019 Na. All rights reserved.
//

import Foundation

final class BusinessHour: NSObject, Decodable {
    
    let MorningStart, MorningEnd, EveningStart, EveningEnd : [List]?
}

extension BusinessHour: Parceable {
    
    static func parseObject(dictionary: [String : AnyObject]) -> BusinessHour? {
        let data = try? JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
        guard data != nil else {
            debugPrint("unable to parse: BusinessHour")
            return nil
        }
        do {
            let decoder = JSONDecoder()
            let user = try decoder.decode(BusinessHour.self, from: data!)
            return user
        }
        catch {
            print("unable to decode model: BusinessHour")
            return nil
        }
    }
}

