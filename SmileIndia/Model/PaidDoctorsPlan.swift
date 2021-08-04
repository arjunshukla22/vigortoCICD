//
//  PaidDoctorsPlan.swift
//  SmileIndia
//
//  Created by Sakshi on 17/07/20.
//  Copyright © 2020 Na. All rights reserved.
//

import Foundation

final class PaidDoctorsPlan: NSObject, Decodable {
   
    let StartDate, EndDate, CreatedDate, UpdatedOn, Username, PlanName, SubscriptionLink, RazorPaySubscriptionId,ChargedAt, Expire_by : String?
    let SubscriptionTypeId,PurchasedAtPrice,DurationOfPlan,Id,TrialDays: Int?
    let PaymentStatus,SubscriptionStatus ,IsTrial: Bool?

}

extension PaidDoctorsPlan: Parceable {
    
    static func parseObject(dictionary: [String : AnyObject]) -> PaidDoctorsPlan? {
        let data = try? JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
        guard data != nil else {
            debugPrint("unable to parse: user")
            return nil
        }
        do {
            let decoder = JSONDecoder()
            let user = try decoder.decode(PaidDoctorsPlan.self, from: data!)
            return user
        }
        catch {
            print("unable to decode model: user")
            return nil
        }
    }
}
