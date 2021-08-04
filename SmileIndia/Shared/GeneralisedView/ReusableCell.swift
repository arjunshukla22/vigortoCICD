//
//  ReusableCell.swift
//  HandstandV2
//
//  Created by user on 03/01/19.
//  Copyright © 2019 Navjot Sharma. All rights reserved.
//

import Foundation
import UIKit

protocol ReusableCell {
    static var identifier: String { get }
    static var nib: UINib { get }
}

extension ReusableCell where Self: UITableViewCell {
    static var identifier: String {
        return String(describing: self)
    }
    
    static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
}

extension ReusableCell where Self: UICollectionViewCell {
    static var identifier: String {
        return String(describing: self)
    }
    
    static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
}
