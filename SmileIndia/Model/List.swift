//
// List.swift
//  SmileIndia
//
//  Created by user on 13/02/19.
//  Copyright © 2019 Na. All rights reserved.
//

import Foundation

final class List: NSObject, Decodable {
    let  Selected, Disabled : Bool?
    let Group, Text, Value,name  : String?
    let Id,id : Int?
}

extension List: Parceable {
    
    static func parseObject(dictionary: [String : AnyObject]) -> List? {
        let data = try? JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
        guard data != nil else {
            debugPrint("unable to parse: List")
            return nil
        }
        do {
            let decoder = JSONDecoder()
            let user = try decoder.decode(List.self, from: data!)
            return user
        }
        catch {
            print("unable to decode model: List")
            return nil
        }
    }
}
