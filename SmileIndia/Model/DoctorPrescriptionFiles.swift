//
//  DoctorPrescriptionFiles.swift
//  SmileIndia
//
//  Created by Arjun  on 16/06/20.
//  Copyright © 2020 Na. All rights reserved.
//

import Foundation

final class DoctorPrescriptionFiles: NSObject, Decodable {
   
    let FileName, UniqueFileName, FilePath : String?
    let Id,AppointmentId, AddedBy, AddedFor: Int?
}

extension DoctorPrescriptionFiles: Parceable {
    
    static func parseObject(dictionary: [String : AnyObject]) -> DoctorPrescriptionFiles? {
        let data = try? JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
        guard data != nil else {
            debugPrint("unable to parse: user")
            return nil
        }
        do {
            let decoder = JSONDecoder()
            let user = try decoder.decode(DoctorPrescriptionFiles.self, from: data!)
            return user
        }
        catch {
            print("unable to decode model: user")
            return nil
        }
    }
}
