//
//  SubscriptionPlans.swift
//  SmileIndia
//
//  Created by Arjun  on 29/06/20.
//  Copyright © 2020 Na. All rights reserved.
//

import Foundation
final class SubscriptionPlans: NSObject, Decodable{

    let FeaturesList : [FeaturesList]?
    let SubscriptionPlansMaster : SubscriptionPlansMaster?
    let PlanDuration : Int?
}
extension SubscriptionPlans: Parceable{
    
    static func parseObject(dictionary: [String : AnyObject]) -> SubscriptionPlans? {
        let data = try? JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
        guard data != nil else {
            debugPrint("unable to parse: SubscriptionPlans")
            return nil
        }
        do {
            let decoder = JSONDecoder()
            let user = try decoder.decode(SubscriptionPlans.self, from: data!)
            return user
        }
        catch {
            print("unable to decode model: SubscriptionPlans")
            return nil
        }
    }
}

final class FeaturesList: NSObject, Codable {
    let Id: Int?
    let FeatureName,FeatureDescripton,FeatureRoute: String?
}

extension FeaturesList: Parceable{
    
        static func parseObject(dictionary: [String : AnyObject]) -> FeaturesList? {
        let data = try? JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
        guard data != nil else {
            debugPrint("unable to parse: DoctorAddressTimmingList")
            return nil
        }
        do {
            let decoder = JSONDecoder()
            let user = try decoder.decode(FeaturesList.self, from: data!)
            return user
        }
        catch {
            print("unable to decode model: DoctorAddressTimmingList")
            return nil
        }
    }
}


//final class SubscriptionPlansMaster: NSObject, Codable {
//    let Id, Duration, Displayorder: Int?
//    let SubscriptionPlanName,Description,Currency,RazorPayPlanId: String?
//    let Cost : Float?
//    
//    let createdDate, updatedTime: String?
//    let excludeTaxCost,freeApts: Int?
//    let isGivenTrial, isDiscountApply, isPlanActive,isDisplayAlways: Bool?
//    
// 
//}

// MARK: - SubscriptionPlansMaster
struct SubscriptionPlansMaster: Codable {
    let subscriptionPlanName, subscriptionPlansMasterDescription, currency: String?
    let duration: Int?
    let createdDate, updatedTime: String?
    let cost, excludeTaxCost: Int?
    let razorPayPlanID: String?
    let displayorder: Int?
    let isGivenTrial, isDiscountApply, isPlanActive: Bool?
    let freeApts: Int?
    let isDisplayAlways: Bool?
    let trialDays, id: Int?

    enum CodingKeys: String, CodingKey {
        case subscriptionPlanName = "SubscriptionPlanName"
        case subscriptionPlansMasterDescription = "Description"
        case currency = "Currency"
        case duration = "Duration"
        case createdDate = "CreatedDate"
        case updatedTime = "UpdatedTime"
        case cost = "Cost"
        case excludeTaxCost = "ExcludeTaxCost"
        case razorPayPlanID = "RazorPayPlanId"
        case displayorder = "Displayorder"
        case isGivenTrial = "IsGivenTrial"
        case isDiscountApply = "IsDiscountApply"
        case isPlanActive = "IsPlanActive"
        case freeApts = "FreeApts"
        case isDisplayAlways = "IsDisplayAlways"
        case trialDays = "TrialDays"
        case id = "Id"
    }
}





extension SubscriptionPlansMaster: Parceable{
    
    static func parseObject(dictionary: [String : AnyObject]) -> SubscriptionPlansMaster? {
        let data = try? JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
        guard data != nil else {
            debugPrint("unable to parse: DoctorAddressTimmingList")
            return nil
        }
        do {
            let decoder = JSONDecoder()
            let user = try decoder.decode(SubscriptionPlansMaster.self, from: data!)
            return user
        }
        catch {
            print("unable to decode model: DoctorAddressTimmingList")
            return nil
        }
    }
}
