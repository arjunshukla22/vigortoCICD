//
//  SubscribedPlan.swift
//  SmileIndia
//
//  Created by Arjun  on 01/07/20.
//  Copyright © 2020 Na. All rights reserved.
//

import Foundation

final class SubscribedPlan: NSObject, Decodable {
   
    let StartDate, EndDate, CreatedDate, UpdatedOn,Username, PlanName, SubscriptionLink,RazorPaySubscriptionId : String?
    let SubscriptionTypeId,PurchasedAtPrice,DurationOfPlan,Id: Int?
    let PaymentStatus,SubscriptionStatus: Bool?

}

extension SubscribedPlan: Parceable {
    
    static func parseObject(dictionary: [String : AnyObject]) -> SubscribedPlan? {
        let data = try? JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
        guard data != nil else {
            debugPrint("unable to parse: user")
            return nil
        }
        do {
            let decoder = JSONDecoder()
            let user = try decoder.decode(SubscribedPlan.self, from: data!)
            return user
        }
        catch {
            print("unable to decode model: user")
            return nil
        }
    }
}
