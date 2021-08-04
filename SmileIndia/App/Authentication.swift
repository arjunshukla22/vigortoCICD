//
//  Authentication.swift
//  HandstandV2
//
//  Created by user on 31/12/18.
//  Copyright © 2018 Navjot Sharma. All rights reserved.
//

import Foundation

class Authentication: NSObject {
    
    // AppCurrentLang
    class var appLanguage: String? {
        set {
            UserDefaults.standard.setValue(newValue, forKey: "appLanguage")
        } get {
            return UserDefaults.standard.value(forKey: "appLanguage") as? String ?? "en"
        }
    }
    
    // Doctor Name Search
    class var docList: [String]? {
        set {
            UserDefaults.standard.setValue(newValue, forKey: "docList")
        } get {
            return UserDefaults.standard.value(forKey: "docList") as? [String] ?? nil
        }
    }
    
    // token
    class var token: String? {
        set {
            UserDefaults.standard.setValue(newValue, forKey: "token")
        } get {
            return UserDefaults.standard.value(forKey: "token") as? String ?? nil
        }
    }
    
    class var profileComplete: Bool? {
        set {
            UserDefaults.standard.setValue(newValue, forKey: "profileComplete")
        } get {
            return UserDefaults.standard.bool(forKey: "profileComplete")
        }
    }
    
    
    // is user logged in
    class var isUserLoggedIn: Bool? {
        set {
            UserDefaults.standard.setValue(newValue, forKey: "login")
        } get {
            return UserDefaults.standard.bool(forKey: "login")
        }
    }
    // customer name
    class var customerName: String? {
        set {
            UserDefaults.standard.setValue(newValue, forKey: "customerName")
        } get {
            return UserDefaults.standard.value(forKey: "customerName") as? String ?? nil
        }
    }
    
    
    // customer email
    class var customerEmail: String? {
        set {
            UserDefaults.standard.setValue(newValue, forKey: "customerEmail")
        } get {
            return UserDefaults.standard.value(forKey: "customerEmail") as? String ?? nil
        }
    }
    // customer phone
    class var customerPhone: String? {
        set {
            UserDefaults.standard.setValue(newValue, forKey: "customerPhone")
        } get {
            return UserDefaults.standard.value(forKey: "customerPhone") as? String ?? nil
        }
    }
    
    // customer type
    class var customerType: String? {
        set {
            UserDefaults.standard.setValue(newValue, forKey: "customerType")
        } get {
            return UserDefaults.standard.value(forKey: "customerType") as? String ?? nil
        }
    }
    
    // customer id
    class var customerGuid: String? {
        set {
            UserDefaults.standard.setValue(newValue, forKey: "customerGuid")
        } get {
            return UserDefaults.standard.value(forKey: "customerGuid") as? String ?? nil
        }
    }
    
    // customer id
    class var customerId: String? {
        set {
            UserDefaults.standard.setValue(newValue, forKey: "customerId")
        } get {
            return UserDefaults.standard.value(forKey: "customerId") as? String ?? nil
        }
    }
    
    class var ProfileImage: String? {
        set {
            UserDefaults.standard.setValue(newValue, forKey: "ProfileImage")
        } get {
            return UserDefaults.standard.value(forKey: "ProfileImage") as? String ?? nil
        }
    }
    
    // customer device Token
    class var deviceToken: String? {
        set {
            UserDefaults.standard.setValue(newValue, forKey: "device_token")
        } get {
            return UserDefaults.standard.value(forKey: "device_token") as? String ?? ""
        }
    }
    
    // customer device Token
    class var remember: String? {
        set {
            UserDefaults.standard.setValue(newValue, forKey: "remember")
        } get {
            return UserDefaults.standard.value(forKey: "remember") as? String ?? ""
        }
    }
    
    // customer device Password
    class var customerPassword: String? {
        set {
            UserDefaults.standard.setValue(newValue, forKey: "password")
        } get {
            return UserDefaults.standard.value(forKey: "password") as? String ?? ""
        }
    }
    // authenticate user
    class func authenticateUser(_ user: User, _ password: String, _ cId: String,_ remember_me:String,_ proComplete:Bool) {
        token = "\(user.email ?? ""):\(password)".toBase64()
        customerGuid = cId
        customerName = user.username
        customerType = user.CustomerType
        customerEmail = user.email
        customerPhone = user.phone
        customerId = "\(user.CustomerId ?? 0)"
       // isUserLoggedIn = true
        isUserLoggedIn = user.CustomerType == EnumUserType.Doctor ? proComplete : true
        remember = remember_me
        customerPassword = "\(password)"
        profileComplete = proComplete
        
    }
    
    // authenticate user
    class func clearData() {
        isUserLoggedIn = false
        customerType = nil
        token = nil
        customerName = nil
        customerEmail = nil
        customerPhone = nil
        customerGuid = nil
        profileComplete = false
    }
}
