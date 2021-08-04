//
//  MemberFiles.swift
//  SmileIndia
//
//  Created by Arjun  on 18/05/20.
//  Copyright © 2020 Na. All rights reserved.
//

import Foundation

final class MemberFiles: NSObject, Decodable {
   
    let FileName,FilePath,UniqueFileName: String?
    let AddedBy,AddedFor,AppointmentId,Id: Int?
}

extension MemberFiles: Parceable {
    
    static func parseObject(dictionary: [String : AnyObject]) -> MemberFiles? {
        let data = try? JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
        guard data != nil else {
            debugPrint("unable to parse: user")
            return nil
        }
        do {
            let decoder = JSONDecoder()
            let prescriptionTemplates = try decoder.decode(MemberFiles.self, from: data!)
            return prescriptionTemplates
        }
        catch {
            print("unable to decode model: user")
            return nil
        }
    }
}
