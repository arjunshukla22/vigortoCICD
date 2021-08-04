//
//  DrPrescription.swift
//  SmileIndia
//
//  Created by Arjun  on 16/06/20.
//  Copyright © 2020 Na. All rights reserved.
//

import Foundation

final class DrPrescription: NSObject, Decodable {
   
    let  PrescriptionText, MultipleEmail, PrescriptionBody : String?
    let AppointmentId,AddedBy,AddedFor,Id: Int?
}

extension DrPrescription: Parceable {
    
    static func parseObject(dictionary: [String : AnyObject]) -> DrPrescription? {
        let data = try? JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
        guard data != nil else {
            debugPrint("unable to parse: user")
            return nil
        }
        do {
            let decoder = JSONDecoder()
            let user = try decoder.decode(DrPrescription.self, from: data!)
            return user
        }
        catch {
            print("unable to decode model: user")
            return nil
        }
    }
}
