//
//  ReviewDetailsModel.swift
//  SmileIndia
//
//  Created by Arjun  on 06/05/21.
//  Copyright © 2021 Na. All rights reserved.
//

import Foundation

final class ReviewDetailsModel: NSObject, Decodable {
    
    let doctorEmail, reviwerName, review: String?
    let reply: String?
    let apptID, displayOrder: Int?
    let isPublic: Bool?
    let createdOn, updatedOn, starRating: String?
    let id: Int?
    
    enum CodingKeys: String, CodingKey {
        case doctorEmail = "DoctorEmail"
        case reviwerName = "ReviwerName"
        case review = "Review"
        case reply = "Reply"
        case apptID = "ApptId"
        case displayOrder = "DisplayOrder"
        case isPublic = "IsPublic"
        case createdOn = "CreatedOn"
        case updatedOn = "UpdatedOn"
        case starRating = "StarRating"
        case id = "Id"
    }
}
extension ReviewDetailsModel: Parceable {
    
    static func parseObject(dictionary: [String : AnyObject]) -> ReviewDetailsModel? {
        
        let data = try? JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
        guard data != nil else {
            debugPrint("unable to parse: ReviewDetailsModel")
            return nil
        }
        do {
            let decoder = JSONDecoder()
            let user = try decoder.decode(ReviewDetailsModel.self, from: data!)
            return user
        }
        catch {
            print("unable to decode model: ReviewDetailsModel")
            return nil
        }
    }
}

