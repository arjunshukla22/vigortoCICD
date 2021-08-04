//
//  Signature.swift
//  SmileIndia
//
//  Created by Arjun  on 20/05/20.
//  Copyright © 2020 Na. All rights reserved.
//

import Foundation

final class Signature: NSObject, Decodable {
   
    let FileName,FilePath : String?
}

extension Signature: Parceable {
    
    static func parseObject(dictionary: [String : AnyObject]) -> Signature? {
        let data = try? JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
        guard data != nil else {
            debugPrint("unable to parse: user")
            return nil
        }
        do {
            let decoder = JSONDecoder()
            let user = try decoder.decode(Signature.self, from: data!)
            return user
        }
        catch {
            print("unable to decode model: user")
            return nil
        }
    }
}
