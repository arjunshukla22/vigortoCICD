//
//  Doctor.swift
//  SmileIndia
//
//  Created by Na on 04/05/19.
//  Copyright © 2019 Na. All rights reserved.
//

import Foundation
final class DoctorData: NSObject, Decodable{
    var imageURL: URL? {
        guard let urlString = ImageName else { return nil }
        return URL(string: urlString)
    }
    var profileImageURL: URL? {
        guard let urlString = ProfileImage else { return nil }
        return URL(string: urlString)
    }
    let DoctorAddressTimmingList : [DoctorAddressTimmingList]?
    let DoctorOtherAddressTimmingList : [DoctorAddressTimmingList]?
    let Email, TellAboutYourSelf, Phone, ImageName, CustomerId, FirstName, HospitalName, LastName, Latitude, Longitude, Mrcode, OtherAddress1, OtherAddress2, OtherHospitalName, OtherDegreeName, OtherLatitude, OtherLongitude, OtherZipCode, ProfileImage, RegNo, TreatmentDiscount, Website, Address1, Address2, DiscountOffered, AlternatePhoneNo, TimeZoneId,NPINo,DAA, ZipCode,Otherspeciality,Experience,EConsultationFee,NPI,CountryCode ,CountryNameCode: String?
    let ConsultationFee, CityId, DegreeId, GenderId, OtherCityId, OtherStatesId, SpecialityId, CountryId, StateId, TitleId, Earnedpoints: Int?
}
extension DoctorData: Parceable{
    
    static func parseObject(dictionary: [String : AnyObject]) -> DoctorData? {
        let data = try? JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
        guard data != nil else {
            debugPrint("unable to parse: DoctorData")
            return nil
        }
        do {
            let decoder = JSONDecoder()
            let user = try decoder.decode(DoctorData.self, from: data!)
            return user
        }
        catch {
            print("unable to decode model: Doctor")
            return nil
        }
    }
}
final class DoctorAddressTimmingList: NSObject, Codable {
    let DayId, EveningTimeEndId, EveningTimeStartId, MorningTimeEndId, MorningTimeStartId: Int?
}
extension DoctorAddressTimmingList: Parceable{
    
    static func parseObject(dictionary: [String : AnyObject]) -> DoctorAddressTimmingList? {
        let data = try? JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
        guard data != nil else {
            debugPrint("unable to parse: DoctorAddressTimmingList")
            return nil
        }
        do {
            let decoder = JSONDecoder()
            let user = try decoder.decode(DoctorAddressTimmingList.self, from: data!)
            return user
        }
        catch {
            print("unable to decode model: DoctorAddressTimmingList")
            return nil
        }
    }
}
