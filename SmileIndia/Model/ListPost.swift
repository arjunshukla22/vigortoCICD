//
//  ListPost.swift
//  SmileIndia
//
//  Created by Sakshi Gothi on 19/02/21.
//  Copyright © 2021 Na. All rights reserved.
//



import Foundation

final class ListPost: NSObject, Decodable {
  
    
    let Body, Username,CreatedOnUtcString,ProfileImage,SpecialityName,DegreeName,Title,Category,CustomerGuid : String?
    let Id,CustomerLikeStatus,CustomerId,Status,BlogLikeCount,BlogCommentCount:Int?
    let TotalRecords,CustomerTypeId: Int?
    let CategoryArray,CategoryIdArray : [String]
   
    var profileImageURL: URL? {
        guard let urlString = ProfileImage else { return nil }
        return URL(string: urlString)
    }
}

extension ListPost: Parceable {
    
    static func parseObject(dictionary: [String : AnyObject]) -> ListPost? {
        print(dictionary)
        let data = try? JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
        
        guard data != nil else {
            debugPrint("unable to parse: feeds")
            return nil
        }
        do {
            let decoder = JSONDecoder()
            let user = try decoder.decode(ListPost.self, from: data!)
            return user
        }
        catch {
            print("unable to decode model: feeds")
            return nil
        }
    }
}


