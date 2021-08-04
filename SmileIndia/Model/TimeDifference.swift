//
//  TimeDifference.swift
//  SmileIndia
//
//  Created by Arjun  on 08/12/20.
//  Copyright © 2020 Na. All rights reserved.
//

import Foundation

final class TimeDifference: NSObject, Decodable {
    let Hours, Minutes, Seconds : Int?
    let TotalSeconds : Float?
}

extension TimeDifference: Parceable {
    
    static func parseObject(dictionary: [String : AnyObject]) -> TimeDifference? {
        let data = try? JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
        guard data != nil else {
            debugPrint("unable to parse: TimeDifference")
            return nil
        }
        do {
            let decoder = JSONDecoder()
            let user = try decoder.decode(TimeDifference.self, from: data!)
            return user
        }
        catch {
            print("unable to decode model: TimeDifference")
            return nil
        }
    }
}
