//
//  InsuranceList.swift
//  SmileIndia
//
//  Created by Arjun  on 19/11/20.
//  Copyright © 2020 Na. All rights reserved.
//

import Foundation
final class InsuranceList: NSObject, Decodable{

    let InsurancesPlansList : [InsurancePlansList]?
    let InsuranceProvider: String?
    let Id,selectedPlansCount : Int?
    let IsSelectAll : Bool?

}
extension InsuranceList: Parceable{
    
    static func parseObject(dictionary: [String : AnyObject]) -> InsuranceList? {
        let data = try? JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
        guard data != nil else {
            debugPrint("unable to parse: InsuranceList")
            return nil
        }
        do {
            let decoder = JSONDecoder()
            let user = try decoder.decode(InsuranceList.self, from: data!)
            return user
        }
        catch {
            print("unable to decode model: InsuranceList")
            return nil
        }
    }
}
final class InsurancePlansList: NSObject, Codable {
    let InsurancePlanName : String?
    let InsuranceId,Id : Int?
    let IsAccepted : Bool?
}
extension InsurancePlansList: Parceable{
    
    static func parseObject(dictionary: [String : AnyObject]) -> InsurancePlansList? {
        print(dictionary)


        let data = try? JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
        guard data != nil else {
            debugPrint("unable to parse: InsurancePlansList")
            return nil
        }
        do {
            let decoder = JSONDecoder()
            let user = try decoder.decode(InsurancePlansList.self, from: data!)
            return user
        }
        catch {
            print("unable to decode model: InsurancePlansList")
            return nil
        }
    }
}
