//
//  FamilyMember.swift
//  SmileIndia
//
//  Created by Na on 20/05/19.
//  Copyright © 2019 Na. All rights reserved.
//

import Foundation
final class FamilyMember: NSObject, Decodable {
    let  FamilyMemberList : [FamilyMembers]?
}

extension FamilyMember: Parceable {
    
    static func parseObject(dictionary: [String : AnyObject]) -> FamilyMember? {
        let data = try? JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
        guard data != nil else {
            debugPrint("unable to parse: FamilyMember")
            return nil
        }
        do {
            let decoder = JSONDecoder()
            let user = try decoder.decode(FamilyMember.self, from: data!)
            return user
        }
        catch {
            print("unable to decode model: FamilyMember")
            return nil
        }
    }
}
final class FamilyMembers: NSObject, Decodable {
    let DOB, FamilyMemberFirstName, FamilyMemberLastName,  FamilyMemberRelationShip, Gender: String?
}

extension FamilyMembers: Parceable {
    
    static func parseObject(dictionary: [String : AnyObject]) -> FamilyMembers? {
        let data = try? JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
        guard data != nil else {
            debugPrint("unable to parse: FamilyMembers")
            return nil
        }
        do {
            let decoder = JSONDecoder()
            let user = try decoder.decode(FamilyMembers.self, from: data!)
            return user
        }
        catch {
            print("unable to decode model: FamilyMembers")
            return nil
        }
    }
}
