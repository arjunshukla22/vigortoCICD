//
//  TimeZoneModel.swift
//  SmileIndia
//
//  Created by Sakshi Gothi on 16/09/20.
//  Copyright © 2020 Na. All rights reserved.
//

import Foundation

final class TimeZoneModel: NSObject, Decodable {
    let Id,DisplayName: String?
}

extension TimeZoneModel: Parceable {
    
    static func parseObject(dictionary: [String : AnyObject]) -> TimeZoneModel? {
        print(dictionary)
        let data = try? JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
        
        guard data != nil else {
            debugPrint("unable to parse: TimeZone")
            return nil
        }
        do {
            let decoder = JSONDecoder()
            let user = try decoder.decode(TimeZoneModel.self, from: data!)
            return user
        }
        catch {
            print("unable to decode model: TimeZone")
            return nil
        }
    }
}
