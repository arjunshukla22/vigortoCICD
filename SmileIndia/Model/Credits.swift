//
//  Credits.swift
//  SmileIndia
//
//  Created by Arjun  on 10/08/20.
//  Copyright © 2020 Na. All rights reserved.
//

import Foundation

final class Credits: NSObject, Decodable{
    
    let CreditHistory : [CreditHistory]?
    let TotalCredits : Int?
}
extension Credits: Parceable{
    
    static func parseObject(dictionary: [String : AnyObject]) -> Credits? {
        let data = try? JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
        guard data != nil else {
            debugPrint("unable to parse: DoctorData")
            return nil
        }
        do {
            let decoder = JSONDecoder()
            let user = try decoder.decode(Credits.self, from: data!)
            return user
        }
        catch {
            print("unable to decode model: Doctor")
            return nil
        }
    }
}




final class CreditHistory: NSObject, Codable {
    let AppointmentId,Id,Amount,ActionBy,SrNo : Int?
    let Reason,ReasonDescription,Date: String?

}
extension CreditHistory: Parceable{
    
    static func parseObject(dictionary: [String : AnyObject]) -> CreditHistory? {
        let data = try? JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
        guard data != nil else {
            debugPrint("unable to parse: DoctorAddressTimmingList")
            return nil
        }
        do {
            let decoder = JSONDecoder()
            let user = try decoder.decode(CreditHistory.self, from: data!)
            return user
        }
        catch {
            print("unable to decode model: DoctorAddressTimmingList")
            return nil
        }
    }
}
