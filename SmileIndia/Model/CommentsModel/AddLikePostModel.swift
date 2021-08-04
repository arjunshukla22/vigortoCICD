//
//  AddLikePostModel.swift
//  SmileIndia
//
//  Created by Arjun  on 15/04/21.
//  Copyright © 2021 Na. All rights reserved.
//

import Foundation


final class AddLikePostModel: NSObject, Decodable {
    let BlogDislikeCount, BlogLikeCount : Int?
}

extension AddLikePostModel: Parceable {
    
    static func parseObject(dictionary: [String : AnyObject]) -> AddLikePostModel? {
        let data = try? JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
        guard data != nil else {
            debugPrint("unable to parse: AddLikePostModel")
            return nil
        }
        do {
            let decoder = JSONDecoder()
            let user = try decoder.decode(AddLikePostModel.self, from: data!)
            return user
        }
        catch {
            print("unable to decode model: AddLikePostModel")
            return nil
        }
    }
}
