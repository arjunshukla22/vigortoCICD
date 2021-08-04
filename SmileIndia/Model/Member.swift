//
//  Member.swift
//  SmileIndia
//
//  Created by Na on 21/05/19.
//  Copyright © 2019 Na. All rights reserved.
//

import Foundation
final class Member: NSObject, Decodable {
    let  CityId, CustomerId, GenderId, StateProvinceId, ZipCode,Earnedpoints,CountryId : Int?
    let Address1, Address2, City, DateOfBirth, Email, FirstName, Gender, LastName, Phone, StateName, TimeZoneId, CountryName,CountryCode ,CountryNameCode: String?
}

extension Member: Parceable {
    
    static func parseObject(dictionary: [String : AnyObject]) -> Member? {
        let data = try? JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
        guard data != nil else {
            debugPrint("unable to parse: Member")
            return nil
        }
        do {
            let decoder = JSONDecoder()
            let user = try decoder.decode(Member.self, from: data!)
            return user
        }
        catch {
            print("unable to decode model: Member")
            return nil
        }
    }
}
