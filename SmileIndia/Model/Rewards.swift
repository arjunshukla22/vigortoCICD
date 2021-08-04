//
//  Rewards.swift
//  SmileIndia
//
//  Created by Arjun  on 25/03/20.
//  Copyright © 2020 Na. All rights reserved.
//

import Foundation

final class Rewards: NSObject, Decodable{

    let Earnedpoints: Int?
}
extension Rewards: Parceable{
    
    static func parseObject(dictionary: [String : AnyObject]) -> Rewards? {
        let data = try? JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
        guard data != nil else {
            debugPrint("unable to parse: DoctorData")
            return nil
        }
        do {
            let decoder = JSONDecoder()
            let user = try decoder.decode(Rewards.self, from: data!)
            return user
        }
        catch {
            print("unable to decode model: Doctor")
            return nil
        }
    }
}

