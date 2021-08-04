//
//  PlanDetailsModel.swift
//  SmileIndia
//
//  Created by Arjun  on 30/06/20.
//  Copyright © 2020 Na. All rights reserved.
//

import Foundation

final class PlanDetailsModel: NSObject, Decodable {
   
    let PlanName, RazorPayPlanId,CreatedOn,EndDate,startdate,DateEnd : String?
    let Amount,Discount,SubcriptionTypeId,Tax,TotalAmount,TotalPlanPrice,SubscriptionDays,TrialDays: Int?
    let IsTrial: Bool?


}

extension PlanDetailsModel: Parceable {
    
    static func parseObject(dictionary: [String : AnyObject]) -> PlanDetailsModel? {
        let data = try? JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
        guard data != nil else {
            debugPrint("unable to parse: user")
            return nil
        }
        do {
            let decoder = JSONDecoder()
            let user = try decoder.decode(PlanDetailsModel.self, from: data!)
            return user
        }
        catch {
            print("unable to decode model: user")
            return nil
        }
    }
}
