//
//  ErrorResult.swift
//  XRentY
//
//  Created by user on 26/06/18.
//  Copyright © 2018 user. All rights reserved.
//

import Foundation

enum ErrorResult: Error {
    
    case network(string: String)
    case parser(string: String)
    case custom(string: String)
    case cancel
    
    var message: String {
        switch self {
        case .network(let string):
            return string
        case .parser(let string):
            return string
        case .custom(let string):
            return string
        case .cancel:
            return ""
        }
    }
}
