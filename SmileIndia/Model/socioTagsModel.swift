//
//  socioTagsModel.swift
//  SmileIndia
//
//  Created by Sakshi Gothi on 23/02/21.
//  Copyright © 2021 Na. All rights reserved.
//

import Foundation

final class socioTagsModel: NSObject, Decodable {
    let Id,name: String?
}

extension socioTagsModel: Parceable {
    
    static func parseObject(dictionary: [String : AnyObject]) ->  socioTagsModel? {
        print(dictionary)
        let data = try? JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
        
        guard data != nil else {
            debugPrint("unable to parse: SocioTags")
            return nil
        }
        do {
            let decoder = JSONDecoder()
            let user = try decoder.decode( socioTagsModel.self, from: data!)
            return user
        }
        catch {
            print("unable to decode model: SocioTags")
            return nil
        }
    }
}

