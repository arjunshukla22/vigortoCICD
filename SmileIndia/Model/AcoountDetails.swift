//
//  AcoountDetails.swift
//  SmileIndia
//
//  Created by Arjun  on 16/04/20.
//  Copyright © 2020 Na. All rights reserved.
//

import Foundation

final class AccountDetails: NSObject, Decodable {
   
    let Name, BankName, AccountNumber,MaskedAccountNumber, CardNumber, AccountType, IFSC, VPA, DateOfBirth,Dob, SSN,TotalAmount : String?
    let Id:Int?
    let IsDefault,Active:Bool?
}

extension AccountDetails: Parceable {
    
    static func parseObject(dictionary: [String : AnyObject]) -> AccountDetails? {
        let data = try? JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
        guard data != nil else {
            debugPrint("unable to parse: user")
            return nil
        }
        do {
            let decoder = JSONDecoder()
            let user = try decoder.decode(AccountDetails.self, from: data!)
            return user
        }
        catch {
            print("unable to decode model: AccountDetails")
            return nil
        }
    }
}
