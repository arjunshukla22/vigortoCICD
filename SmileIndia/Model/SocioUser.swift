//
//  SocioUser.swift
//  SmileIndia
//
//  Created by Sakshi Gothi on 04/05/21.
//  Copyright © 2021 Na. All rights reserved.
//

import Foundation

final class SocioData: NSObject, Decodable{
    var imageURL: URL? {
        guard let urlString = ImageName else { return nil }
        return URL(string: urlString)
    }
    var profileImageURL: URL? {
        guard let urlString = ProfileImage else { return nil }
        return URL(string: urlString)
    }
    
    let Status,SpecifierId : Int?
    let resend : Bool?
    let Customerid : Int?
    let Address1,Address2,CityName,ProviderName,Practice,HospitalName,StateName,ImageName,ProfileImage,TellAboutYourSelf,ProviderId: String?
  
}
extension SocioData: Parceable{
    
    static func parseObject(dictionary: [String : AnyObject]) -> SocioData? {
        let data = try? JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
        guard data != nil else {
            debugPrint("unable to parse: DoctorData")
            return nil
        }
        do {
            let decoder = JSONDecoder()
            let user = try decoder.decode(SocioData.self, from: data!)
            return user
        }
        catch {
            print("unable to decode model: Doctor")
            return nil
        }
    }
}

