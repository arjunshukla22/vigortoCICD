//
//  PrescriptionTemplates.swift
//  SmileIndia
//
//  Created by Arjun  on 13/05/20.
//  Copyright © 2020 Na. All rights reserved.
//

import Foundation

final class PrescriptionTemplates: NSObject, Decodable {
   
    let Title,Body: String?
    let CustomerId,Id: Int?
}

extension PrescriptionTemplates: Parceable {
    
    static func parseObject(dictionary: [String : AnyObject]) -> PrescriptionTemplates? {
        let data = try? JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
        guard data != nil else {
            debugPrint("unable to parse: user")
            return nil
        }
        do {
            let decoder = JSONDecoder()
            let prescriptionTemplates = try decoder.decode(PrescriptionTemplates.self, from: data!)
            return prescriptionTemplates
        }
        catch {
            print("unable to decode model: user")
            return nil
        }
    }
}
