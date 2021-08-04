//
//  ListDoctor.swift
//  SmileIndia
//
//  Created by Na on 24/02/19.
//  Copyright © 2019 Na. All rights reserved.
//

import Foundation
final class ListDoctor: NSObject, Decodable{
     let AvailableProviderDetailList : [Doctor]?
    let TotalCount: Int?
}
extension ListDoctor: Parceable{
    
    static func parseObject(dictionary: [String : AnyObject]) -> ListDoctor? {
        let data = try? JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
        guard data != nil else {
            debugPrint("unable to parse: ListDoctor")
            return nil
        }
        do {
            let decoder = JSONDecoder()
            let user = try decoder.decode(ListDoctor.self, from: data!)
            return user
        }
        catch {
            print("unable to decode model: ListDoctor")
            return nil
        }
    }
}
final class Doctor: NSObject, Decodable{
    var imageURL: URL? {
        guard let urlString = ImageName else { return nil }
        return URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
    }
    let Address1 : [Address1]?
    let Address2 : [Address1]?
    let Address1Timming : [AddressTiming]?
    let Address2Timming : [AddressTiming]?
    let CityName, Degree, Email, OtherDegree, Practice,Otherspeciality, ProviderName, RegistrationNo, TellAboutYourSelf, PhoneNo, ImageName,DiscountOffered,EConsultationFee, AvailableTimeZoneMsg,AvailableDayMsg, ProviderID,Experience,SubscriptionTypeId ,TreatmentDiscount,CountryCode : String?
    let CustomerTypeId, Rating, ConsultantFee: Int?
    
    let DiscountOfferedDisplayFor,ConsultantFeeDisplayFor,PlanName : String?
    let Paymentstatus : Bool?

}
extension Doctor: Parceable{
    
    static func parseObject(dictionary: [String : AnyObject]) -> Doctor? {
        let data = try? JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
        
        guard data != nil else {
            
            debugPrint("unable to parse: Doctor")
            return nil
        }
        do {
            let decoder = JSONDecoder()
            let user = try decoder.decode(Doctor.self, from: data!)
            return user
        }
        catch {
            print("unable to decode model: Doctor")
            return nil
        }
    }
}

final class Address1: NSObject, Decodable{
    let Address, CustomerId,HospitalName, Latitude, Longitude, ZipCode, Rating  : String?
    let CityId,Id,StateId ,SubscriptionTypeId  : Int?
    let IsPrimary: Bool?
    let PlanName : String?
    let Paymentstatus : Bool?
}
extension Address1: Parceable{
    
    static func parseObject(dictionary: [String : AnyObject]) -> Address1? {
        let data = try? JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
        guard data != nil else {
            debugPrint("unable to parse: Address")
            return nil
        }
        do {
            let decoder = JSONDecoder()
            let user = try decoder.decode(Address1.self, from: data!)
            return user
        }
        catch {
            print("unable to decode model: Address")
            return nil
        }
    }
}
final class AddressTiming: NSObject, Codable{
    let DayMasters: DayMaster?
    let DoctorAddressId : Int?
    let EveningTimeEnd, EveningTimeStart, MorningTimeEnd, MorningTimeStart: TimeConstraint?
    
    func encode(to encoder: Encoder) throws {
        
    }
    
}
extension AddressTiming: Parceable{
    
    static func parseObject(dictionary: [String : AnyObject]) -> AddressTiming? {
        let data = try? JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
        guard data != nil else {
            debugPrint("unable to parse: AddressTiming")
            return nil
        }
        do {
            let decoder = JSONDecoder()
            let user = try decoder.decode(AddressTiming.self, from: data!)
            return user
        }
        catch {
            print("unable to decode model: AddressTiming")
            return nil
        }
    }
}
final class DayMaster: NSObject, Decodable{
    let Name: String?
}
extension DayMaster: Parceable{
    
    static func parseObject(dictionary: [String : AnyObject]) -> DayMaster? {
        let data = try? JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
        guard data != nil else {
            debugPrint("unable to parse: DayMaster")
            return nil
        }
        do {
            let decoder = JSONDecoder()
            let user = try decoder.decode(DayMaster.self, from: data!)
            return user
        }
        catch {
            print("unable to decode model: DayMaster")
            return nil
        }
    }
}
final class TimeConstraint: NSObject, Decodable{
    let Timing: String?
    let IsClosed: Bool?
}
extension TimeConstraint: Parceable{
    
    static func parseObject(dictionary: [String : AnyObject]) -> TimeConstraint? {
        let data = try? JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
        guard data != nil else {
            debugPrint("unable to parse: TimeConstraint")
            return nil
        }
        do {
            let decoder = JSONDecoder()
            let user = try decoder.decode(TimeConstraint.self, from: data!)
            return user
        }
        catch {
            print("unable to decode model: TimeConstraint")
            return nil
        }
    }
}
