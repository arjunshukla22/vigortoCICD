//
//  StringExtension.swift
//  HandstandV2
//
//  Created by user on 21/12/18.
//  Copyright © 2018 Navjot Sharma. All rights reserved.
//

import Foundation
import UIKit

extension String{
    func isValidEmail() -> Bool
    {
        let emailRegEx = "[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self.lowercased())
    }
    
    
    func isValidUpi() -> Bool
    {
        let upiRegEx = "[a-zA-Z0-9.]{2,256}@[a-zA-Z]{3,64}"
        let upiTest = NSPredicate(format:"SELF MATCHES %@", upiRegEx)
        return upiTest.evaluate(with: self.lowercased())
    }
    
    func isValidIfsc() -> Bool
    {
        let ifscRegEx = "^[A-Za-z]{4}0[A-Z0-9a-z]{6}$"
        let ifscTest = NSPredicate(format:"SELF MATCHES %@", ifscRegEx)
        return ifscTest.evaluate(with: self.lowercased())
    }
    
    func isValidAccountNum() -> Bool
    {
        let accnoRegEx = "[0-9]{9,18}"
        let accnoTest = NSPredicate(format:"SELF MATCHES %@", accnoRegEx)
        return accnoTest.evaluate(with: self.lowercased())
    }
    
    func isEmptyString() -> Bool {
        if self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).count > 0  {
            return false
        } else {
            return true
        }
    }
    
        func fromBase64() -> String? {
            guard let data = Data(base64Encoded: self) else {
                return nil
            }
            
            return String(data: data, encoding: .utf8)
        }
        
        func toBase64() -> String {
            return Data(self.utf8).base64EncodedString()
        }
    
    
    func isStringLink() -> Bool {
        let types: NSTextCheckingResult.CheckingType = [.link]
        let detector = try? NSDataDetector(types: types.rawValue)
        guard (detector != nil && self.characters.count > 0) else { return false }
        if detector!.numberOfMatches(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.characters.count)) > 0 {
            return true
        }
        return false
    }
    
    
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {

            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
    
    var isAlphaCharset: Bool {
        return !isEmpty && range(of: "[^a-zA-Z]", options: .regularExpression) == nil
    }
}
