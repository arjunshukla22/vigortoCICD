//
//  TimeZone.swift
//  SmileIndia
//
//  Created by Sakshi Gothi on 16/09/20.
//  Copyright © 2020 Na. All rights reserved.
//
import Foundation

final class TimeZone: NSObject, Decodable {
    
    let Id,DisplayName: [List]?
}

extension TimeZone: Parceable {
    
    static func parseObject(dictionary: [String : AnyObject]) -> TimeZone? {
        let data = try? JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
        guard data != nil else {
            debugPrint("unable to parse: BusinessHour")
            return nil
        }
        do {
            let decoder = JSONDecoder()
            let user = try decoder.decode(TimeZone.self, from: data!)
            return user
        }
        catch {
            print("unable to decode model: TimeZone")
            return nil
        }
    }
}
