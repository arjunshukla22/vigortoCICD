//
//  Result.swift
//  MVVM
//
//  Created by user on 25/06/18.
//  Copyright © 2018 user. All rights reserved.
//

import Foundation

typealias Parameters = [String:Any]

enum Result <T , E: Error> {
    case success(T)
    case failure(E)
}



