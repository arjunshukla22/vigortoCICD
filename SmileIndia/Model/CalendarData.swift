//
//  CalendarData.swift
//  SmileIndia
//
//  Created by Arjun  on 28/04/20.
//  Copyright © 2020 Na. All rights reserved.
//

import Foundation
final class CalendarData: NSObject, Decodable{

    let MorningTimeSlots : [MorningTimeSlots]?
    let EveningTimeSlots : [EveningTimeSlots]?
    let IsAnyHalfClosedFull:Bool?

}
extension CalendarData: Parceable{
    
    static func parseObject(dictionary: [String : AnyObject]) -> CalendarData? {
        let data = try? JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
        guard data != nil else {
            debugPrint("unable to parse: DoctorData")
            return nil
        }
        do {
            let decoder = JSONDecoder()
            let user = try decoder.decode(CalendarData.self, from: data!)
            return user
        }
        catch {
            print("unable to decode model: Doctor")
            return nil
        }
    }
}
final class MorningTimeSlots: NSObject, Codable {
    let Time: String?
    let IsClosedDate:Int?
    let IsAvailable:Bool?
}
extension MorningTimeSlots: Parceable{
    
    static func parseObject(dictionary: [String : AnyObject]) -> MorningTimeSlots? {
        let data = try? JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
        guard data != nil else {
            debugPrint("unable to parse: DoctorAddressTimmingList")
            return nil
        }
        do {
            let decoder = JSONDecoder()
            let user = try decoder.decode(MorningTimeSlots.self, from: data!)
            return user
        }
        catch {
            print("unable to decode model: DoctorAddressTimmingList")
            return nil
        }
    }
}


final class EveningTimeSlots: NSObject, Codable {
    let Time: String?
    let IsClosedDate:Int?
    let IsAvailable:Bool?
}
extension EveningTimeSlots: Parceable{
    
    static func parseObject(dictionary: [String : AnyObject]) -> EveningTimeSlots? {
        let data = try? JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
        guard data != nil else {
            debugPrint("unable to parse: DoctorAddressTimmingList")
            return nil
        }
        do {
            let decoder = JSONDecoder()
            let user = try decoder.decode(EveningTimeSlots.self, from: data!)
            return user
        }
        catch {
            print("unable to decode model: DoctorAddressTimmingList")
            return nil
        }
    }
}
