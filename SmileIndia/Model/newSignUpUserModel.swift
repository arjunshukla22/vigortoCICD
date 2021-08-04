//
//  newSignUpUserModel.swift
//  SmileIndia
//
//  Created by Arjun  on 18/06/21.
//  Copyright © 2021 Na. All rights reserved.
//

import Foundation

final class NewDrSignUpUser: NSObject, Decodable {
  
    let token : String?

}

extension NewDrSignUpUser: Parceable {
    
    static func parseObject(dictionary: [String : AnyObject]) -> NewDrSignUpUser? {
        let data = try? JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
        guard data != nil else {
            debugPrint("unable to parse: NewDrSignUpUser")
            return nil
        }
        do {
            let decoder = JSONDecoder()
            let user = try decoder.decode(NewDrSignUpUser.self, from: data!)
            return user
        }
        catch {
            print("unable to decode model: NewDrSignUpUser")
            return nil
        }
    }
}
