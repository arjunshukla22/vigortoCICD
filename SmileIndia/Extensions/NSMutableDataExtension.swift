//
//  NSMutableDataExtension.swift
//  HandstandV2
//
//  Created by user on 21/01/19.
//  Copyright © 2019 Navjot Sharma. All rights reserved.
//

import Foundation
extension NSMutableData {
    
    func appendString(string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
}
