//
//  UserDefaultManager.swift
//  Mr. Steam
//
//  Created by MAc_4 on 11/04/19.
//  Copyright © 2019 MAc_4. All rights reserved.
//

import Foundation
import UIKit


struct UDKeys{
    
    static let doctorList = "DoctorList"
   
}

class UDManager: NSObject{
    
    static let shared = UDManager()
   
   
    private override init() { }
    
    
       

    func clearData() {
        
        UserDefaults.standard.removeObject(forKey: UDKeys.doctorList)
       
    }
  }


extension UserDefaults{
    
    func set<T: Encodable>(encodable: T, forKey key: String) {
        if let data = try? JSONEncoder().encode(encodable) {
            set(data, forKey: key)
        }
    }
    
    func value<T: Decodable>(_ type: T.Type, forKey key: String) -> T? {
        if let data = object(forKey: key) as? Data,
            let value = try? JSONDecoder().decode(type, from: data) {
            return value
        }
        return nil
    }
    
}
