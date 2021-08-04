//
//  TimeCollectionCell.swift
//  SmileIndia
//
//  Created by Na on 09/07/19.
//  Copyright © 2019 Na. All rights reserved.
//

import UIKit

class TimeCollectionCell: UICollectionViewCell, ReusableCell {
    
    @IBOutlet weak var timeLabel: UILabel!
    var select =  Bool() {
        didSet {
            self.backgroundColor = select ? #colorLiteral(red: 0.233, green: 0.816, blue: 0.538, alpha: 1) : #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
            timeLabel.backgroundColor = select ? #colorLiteral(red: 0.233, green: 0.816, blue: 0.538, alpha: 1) : #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
            timeLabel.textColor = select ? .white : .black
            timeLabel.layer.borderColor = select ? UIColor.clear.cgColor : UIColor.gray.cgColor
        }
    }
}
