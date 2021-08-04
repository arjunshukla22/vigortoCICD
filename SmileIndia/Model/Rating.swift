//
//  Rating.swift
//  SmileIndia
//
//  Created by Na on 23/07/19.
//  Copyright © 2019 Na. All rights reserved.
//

import Foundation
final class Rating: NSObject, Decodable {
    var imageURL: URL? {
        guard let urlString = ImageName else { return nil }
        return URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
    }
    let TotalVotes: Int?
    let Address1, Address2, City, ProviderName, Email, RegistrationNo, Gender, TellAboutYourSelf,  AlternateImageName, Degree, HospitalName, ImageName, OtherDegree, Practice, AvarageRating, PhoneNo : String?
}

extension Rating: Parceable {
    
    static func parseObject(dictionary: [String : AnyObject]) -> Rating? {
        let data = try? JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
        guard data != nil else {
            debugPrint("unable to parse: Rating")
            return nil
        }
        do {
            let decoder = JSONDecoder()
            let user = try decoder.decode(Rating.self, from: data!)
            return user
        }
        catch {
            print("unable to decode model: Rating")
            return nil
        }
    }
}
